/*
  Live boards: a shared board (a Padlet wall, a whiteboard) on a slide, with the link students open
  and its QR code under it. Click the QR code (or Show QR) for a big one the class can scan.

      ::: {.live-board src="https://padlet.com/embed/abc123" join="https://padlet.com/you/wall-abc123"}
      Add one idea.
      :::

      ::: {.live-board rooms="excalidraw"}      a new Excalidraw room is made for you
      :::

      ::: {.live-board rooms="wbo"}             a new WBO whiteboard, live on the slide
      :::

  src     what the frame shows. Padlet: its embed address (Share › Embed). Leave it out to paste it
          on the slide (Edit link, teacher site only).
  join    the link students open (and the QR code). Leave it out to use src.
  rooms   excalidraw or wbo: the slide makes a fresh room link itself; New room makes another.
  layout  full (the default): the board fills the whole slide, with a small card in the corner (QR code,
          link, buttons); the slide's title, if it has one, sits on top of the board.
          inline: the frame with the join bar under it, for a slide with other things on it.
  height  inline only: the frame's height in pixels (default 430).
  zoom    shows the board smaller, so more of it fits: zoom="0.7" (Padlet's posts are big at full
          size, so a Padlet starts at 0.7; other boards at 1).
  The text inside the div is the line in front of the link ("Add one idea."); default "Join".

  A link pasted with Edit link, or a room made with New room, is kept in this browser for this slide.
  Edit link and New room are on the teacher site only. In the slide PDF the frame becomes a big QR code.

  Excalidraw switches off live sharing when it runs inside a frame (excalidraw.com's own rule), so the
  slide doesn't show a frame for it (that would be a second, private board): it shows the room's QR
  code and an Open button. Open the room in its own tab and show that tab. WBO and Padlet stay live
  inside the frame.
*/
(function () {
  const STORE = "chalkline-live-board:";
  const PRINT = /[?&]print-pdf/.test(location.search);

  function randomBytes(n) { return crypto.getRandomValues(new Uint8Array(n)); }
  function hex(bytes) { return Array.from(bytes, function (b) { return b.toString(16).padStart(2, "0"); }).join(""); }
  function base64url(bytes) {
    return btoa(String.fromCharCode.apply(null, bytes)).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
  }

  // Rooms the slide can make on its own: no account, no copying a share link.
  const ROOMS = {
    // Excalidraw's own room links: #room=<10 random bytes, hex>,<a 128-bit AES key, base64url>.
    // The key stays in the link (after #), so Excalidraw's server never sees the drawings.
    excalidraw: { frame: "https://excalidraw.com/", live: false,
      make: function () { return "https://excalidraw.com/#room=" + hex(randomBytes(10)) + "," + base64url(randomBytes(16)); } },
    // WBO (wbo.ophir.dev, open source): a board is just a name; anyone with the link draws on it.
    wbo: { live: true,
      make: function () { return "https://wbo.ophir.dev/boards/chalkline-" + hex(randomBytes(6)); } },
  };

  function load(key) {
    try { return JSON.parse(localStorage.getItem(STORE + key)) || {}; } catch (e) { return {}; }
  }
  function save(key, value) {
    try {
      if (value) localStorage.setItem(STORE + key, JSON.stringify(value));
      else localStorage.removeItem(STORE + key);
    } catch (e) { /* private window: it lasts until the page closes */ }
  }

  // A pasted link, or a whole embed code (<iframe src="...">): just the address
  function cleanLink(text) {
    text = (text || "").trim();
    const m = text.match(/<iframe[^>]*\ssrc=["']([^"']+)["']/i);
    if (m) text = m[1];
    if (text && !/^[a-z]+:\/\//i.test(text)) text = "https://" + text;
    return text.replace(/&amp;/g, "&");
  }
  function shortLink(url) {
    return url.replace(/^https?:\/\/(www\.)?/, "").replace(/(#room=[^,]{6})[^]*$/, "$1…");
  }

  function qrSvg(url) {
    if (!window.qrcode || !url) return "";
    let qr;
    try {
      qr = window.qrcode(0, "M");
      qr.addData(encodeURI(decodeURI(url)));
      qr.make();
    } catch (e) { return ""; }
    const n = qr.getModuleCount(), q = 4;
    let d = "";
    for (let r = 0; r < n; r++) for (let c = 0; c < n; c++) if (qr.isDark(r, c)) d += "M" + (c + q) + " " + (r + q) + "h1v1h-1z";
    return '<svg viewBox="0 0 ' + (n + 2 * q) + " " + (n + 2 * q) + '" shape-rendering="crispEdges" role="img" aria-label="QR code">' +
      '<rect width="100%" height="100%" fill="#fff"/><path fill="#000" d="' + d + '"/></svg>';
  }

  function el(tag, cls, text) {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text != null) e.textContent = text;
    return e;
  }
  function button(text, title, onclick) {
    const b = el("button", "ui-btn lb-btn", text);
    b.type = "button";
    if (title) b.title = title;
    b.addEventListener("click", onclick);
    return b;
  }

  // The big QR code, over everything (in full screen too). Click or Esc to close.
  let pop = null;
  function closeBig() { if (pop) { pop.remove(); pop = null; } }
  function showBig(url, label) {
    closeBig();
    pop = el("div", "lb-pop");
    pop.setAttribute("role", "dialog");
    pop.setAttribute("aria-label", "QR code to join");
    const card = el("div", "lb-pop-card");
    const code = el("div", "lb-pop-code");
    code.innerHTML = qrSvg(url);
    card.append(el("div", "lb-pop-label", label), code, el("div", "lb-pop-url", shortLink(url)), el("div", "lb-pop-hint", "Click anywhere or press Esc to close"));
    pop.append(card);
    pop.addEventListener("click", closeBig);
    document.body.append(pop);
  }
  window.addEventListener("keydown", function (e) {
    if (pop && e.key === "Escape") { e.stopImmediatePropagation(); e.preventDefault(); closeBig(); }
  }, true);

  function setup(box, index) {
    const a = box.dataset;
    const teacher = a.teacher === "true";
    const room = ROOMS[(a.rooms || "").toLowerCase()];
    const slide = box.closest("section");
    const key = location.pathname + "|" + (slide && slide.id ? slide.id : index);
    const label = box.textContent.trim() || "Join";
    box.textContent = "";
    const full = (a.layout || "full").toLowerCase() !== "inline";
    if (full) { box.classList.add("lb-full"); if (slide) slide.classList.add("lb-full-slide"); }
    if (a.height) box.style.setProperty("--lb-h", parseInt(a.height, 10) + "px");

    let saved = load(key);
    function links() {
      if (room) {
        let join = saved.join || a.join || "";
        // The teacher's browser makes the room; a student's copy of the deck (or the slide PDF) never makes its own
        if (!join && teacher && !PRINT) { join = room.make(); saved = { join: join }; save(key, saved); }
        // Not live in a frame (Excalidraw): no frame, so there's never a second, private board
        return { join: join, frame: room.live ? join : (a.src || "") };
      }
      const frame = saved.src || a.src || "";
      return { join: saved.join || a.join || frame, frame: frame };
    }

    const stage = el("div", "lb-stage");
    const frame = el("iframe", "lb-frame");
    frame.setAttribute("allow", "clipboard-read; clipboard-write; fullscreen");
    frame.setAttribute("allowfullscreen", "");
    const empty = el("div", "lb-empty");
    stage.append(frame, empty);

    const bar = el("div", "lb-bar");
    const mini = el("button", "lb-mini");
    mini.type = "button";
    mini.title = "Show the QR code big";
    const join = el("div", "lb-join");
    const what = el("span", "lb-label", label);
    const link = el("a", "lb-url");
    link.target = "_blank";
    link.rel = "noopener";
    join.append(what, link);
    const actions = el("div", "lb-actions");
    // Fold: the corner card shrinks to a small tab, so the board gets the whole slide. Remembered.
    const fold = el("button", "lb-fold");
    fold.type = "button";
    const FOLD_KEY = "chalkline-live-board:folded";
    function folded() { try { return localStorage.getItem(FOLD_KEY) === "1"; } catch (e) { return false; } }
    function paintFold(on) {
      box.classList.toggle("lb-folded", on);
      fold.title = on ? "Show the QR code and buttons" : "Hide the QR code and buttons";
      fold.setAttribute("aria-label", fold.title);
      fold.setAttribute("aria-expanded", String(!on));
      fold.innerHTML = on
        ? '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4z" fill="none" stroke="currentColor" stroke-width="2"/><path d="M14 14h2v2h-2zM18 18h2v2h-2zM14 18h2M18 14h2" stroke="currentColor" stroke-width="2"/></svg><span>Join</span>'
        : '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 10l5 5 5-5" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>';
    }
    fold.addEventListener("click", function (e) {
      e.stopPropagation();
      const on = !box.classList.contains("lb-folded");
      try { localStorage.setItem(FOLD_KEY, on ? "1" : "0"); } catch (err) { /* private window */ }
      paintFold(on);
    });
    paintFold(full && folded());
    bar.append(mini, join, actions, fold);

    const field = el("input", "ui-field lb-field");
    field.type = "url";
    field.placeholder = room ? "Paste a room link" : "Paste the board's link or its embed code";
    field.hidden = true;
    field.setAttribute("aria-label", "Link for this board");

    box.append(stage, bar, field);

    function paint() {
      const l = links();
      // Frames load when their slide is shown (reveal.js lazy loading): data-src, and src only when
      // this slide is the one on screen.
      if (l.frame && !PRINT) {
        if (frame.getAttribute("data-src") !== l.frame) {
          frame.setAttribute("data-src", l.frame);
          if (frame.getAttribute("src") || (slide && slide.classList.contains("present"))) frame.setAttribute("src", l.frame);
        }
        frame.title = label + ": " + shortLink(l.frame);
      } else {
        frame.removeAttribute("data-src");
        frame.removeAttribute("src");
      }
      const zoom = parseFloat(a.zoom) || (/padlet\.(com|org)/.test(l.frame) ? 0.7 : 1);
      frame.style.setProperty("--lb-zoom", zoom);
      frame.hidden = !l.frame || PRINT;
      empty.hidden = !!l.frame && !PRINT;
      empty.textContent = "";
      empty.classList.remove("lb-open");
      box.classList.toggle("lb-is-open", !l.frame && !!room && !!l.join && !PRINT);
      if (PRINT) {
        empty.classList.add("lb-print");
        if (l.join) {
          const code = el("div", "lb-print-code");
          code.innerHTML = qrSvg(l.join);
          empty.append(code, el("div", "lb-print-url", l.join));
        } else empty.append(el("p", "lb-empty-head", "A live board: its link and QR code are on the slide."));
      } else if (!l.frame && room && l.join) {
        // A room that only shares in its own tab: its QR code, big, and a button to open it
        empty.classList.add("lb-open");
        const code = el("button", "lb-open-code");
        code.type = "button";
        code.title = "Show the QR code big";
        code.innerHTML = qrSvg(l.join);
        code.addEventListener("click", function () { showBig(l.join, label); });
        const go = button("Open the class board ↗", "Open the room in its own tab, and show that tab", function () { window.open(l.join, "_blank", "noopener"); });
        empty.append(el("p", "lb-empty-head", label), code, el("p", "lb-open-url", shortLink(l.join)), go,
          el("p", null, "This board shares only in its own tab: open it there and show that tab."));
      } else if (!l.frame) {
        empty.append(el("p", "lb-empty-head", "No board here yet."));
        if (teacher) {
          empty.append(el("p", null, "Padlet: open your padlet, choose Share, then Embed in your blog or website. Copy the code."),
            el("p", null, "Then click Edit link below and paste it. It's kept in this browser."));
        } else empty.append(el("p", null, "Your teacher will share the link."));
      }
      bar.hidden = !l.join;
      actions.hidden = PRINT;
      mini.innerHTML = qrSvg(l.join);
      link.href = l.join || "#";
      link.textContent = shortLink(l.join || "");
      link.title = l.join;
    }

    mini.addEventListener("click", function () { const l = links(); if (l.join) showBig(l.join, label); });
    actions.append(
      button("Show QR", "A big QR code to scan", function () { const l = links(); if (l.join) showBig(l.join, label); }),
      button("Open ↗", room && !room.live ? "Open the live room in its own tab (Excalidraw shares only there)" : "Open in its own tab",
        function () { const l = links(); if (l.join) window.open(l.join, "_blank", "noopener"); }));
    if (teacher && !PRINT) {
      if (room) {
        let armed = null;
        const fresh = button("New room", "A new, empty room with a new link (the old room stays at its old link)", function () {
          if (!armed) {
            fresh.textContent = "Sure? New room";
            fresh.classList.add("ui-armed");
            armed = setTimeout(function () { armed = null; fresh.textContent = "New room"; fresh.classList.remove("ui-armed"); }, 3000);
            return;
          }
          clearTimeout(armed); armed = null;
          fresh.textContent = "New room"; fresh.classList.remove("ui-armed");
          saved = { join: room.make() }; save(key, saved); paint();
        });
        actions.append(fresh);
      }
      actions.append(button("Edit link", "Paste another link (empty: back to the deck's own link)", function () {
        field.hidden = !field.hidden;
        if (!field.hidden) { field.value = links().join; field.select(); }
      }));
      field.addEventListener("change", function () {
        const url = cleanLink(field.value);
        if (!url) saved = {};
        else if (room) saved = { join: url };
        else saved = { src: url, join: url };
        save(key, saved);
        field.hidden = true;
        paintAll();
      });
      field.addEventListener("keydown", function (e) {
        if (e.key === "Enter") field.blur();
        if (e.key === "Escape") { field.hidden = true; e.stopPropagation(); }
      });
    }
    // No link yet: on the teacher site the bar still shows, for its Edit link button
    function paintAll() {
      paint();
      if (teacher && !PRINT) bar.hidden = false;
      for (const b of actions.querySelectorAll(".lb-needs-link")) b.hidden = !links().join;
    }
    actions.firstChild.classList.add("lb-needs-link");   // Show QR
    actions.children[1].classList.add("lb-needs-link");  // Open
    paintAll();
  }

  function start() {
    document.querySelectorAll(".reveal .live-board").forEach(setup);
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start);
  else start();
})();
