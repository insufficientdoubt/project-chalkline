// Live draw.io infographics: <div class="drawio-live" data-src="drawio/republic.svg"></div>
// Loads a draw.io SVG export into the page itself (not as an <img>), so the boxes can react:
// hover or tap a box and it lifts while everything else fades. Styles: drawio-live.css.
// Make the SVG with scripts/drawio.py (or draw.io's File > Export as > SVG).
// Recall mode, for a summary students rebuild from memory: <div class="drawio-live" data-mode="recall" ...>.
// The end boxes (the ones only one line touches: the details) start blank with a "?"; tap one to show it,
// or use Show all / Hide all. data-hide="id1, id2" names the boxes to blank instead (draw.io's cell ids).
(function () {
  document.querySelectorAll(".drawio-live[data-src]").forEach(function (box) {
    fetch(box.dataset.src).then(r => r.text()).then(function (text) {
      box.innerHTML = text.slice(text.indexOf("<svg"));   // drop the XML header
      const svg = box.querySelector("svg");
      svg.removeAttribute("width"); svg.removeAttribute("height");   // scale to the slide
      // A "box" is any shape with a fill (draw.io gives each shape its own <g data-cell-id>);
      // arrows and plain text labels stay as they are.
      svg.querySelectorAll("g[data-cell-id]").forEach(function (g) {
        const id = g.dataset.cellId;
        if (id === "0" || id === "1") return;
        const shape = g.querySelector(":scope > g > rect, :scope > g > path, :scope > rect, :scope > path");
        if (shape && shape.getAttribute("fill") && shape.getAttribute("fill") !== "none") g.classList.add("live-box");
      });
      if (box.dataset.mode === "recall") recall(box, svg);
      svg.addEventListener("click", function (e) {   // touch screens: tap a box to focus it, tap again to clear
        const g = e.target.closest(".live-box");
        if (g && g.classList.contains("recall")) { g.classList.toggle("shown"); sync(box); e.stopPropagation(); return; }
        svg.querySelectorAll(".live-box.focus").forEach(x => { if (x !== g) x.classList.remove("focus"); });
        if (g) { g.classList.toggle("focus"); e.stopPropagation(); }
      });
    }).catch(function () { box.textContent = "(Couldn't load " + box.dataset.src + ")"; });
  });

  // Recall mode: blank the end boxes (or the ones data-hide names), each with a "?" to tap.
  function recall(box, svg) {
    const NS = "http://www.w3.org/2000/svg";
    let hide;
    if (box.dataset.hide) {
      const ids = box.dataset.hide.split(",").map(function (x) { return x.trim(); });
      hide = Array.from(svg.querySelectorAll(".live-box")).filter(function (g) { return ids.includes(g.dataset.cellId); });
    } else {
      // the lines' two ends: a box touched by one end only is the end of a branch
      const ends = [];
      svg.querySelectorAll("g[data-cell-id] path[fill='none']").forEach(function (p) {
        const n = (p.getAttribute("d") || "").match(/-?[\d.]+/g);
        if (n && n.length >= 4) ends.push([+n[0], +n[1]], [+n[n.length - 2], +n[n.length - 1]]);
      });
      hide = Array.from(svg.querySelectorAll(".live-box")).filter(function (g) {
        const b = g.getBBox();
        return ends.filter(function (e) { return e[0] >= b.x - 3 && e[0] <= b.x + b.width + 3 && e[1] >= b.y - 3 && e[1] <= b.y + b.height + 3; }).length === 1;
      });
    }
    hide.forEach(function (g) {
      const b = g.getBBox(), q = document.createElementNS(NS, "text");
      q.setAttribute("x", b.x + b.width / 2); q.setAttribute("y", b.y + b.height / 2);
      q.setAttribute("class", "recall-q"); q.textContent = "?";
      g.classList.add("recall"); g.appendChild(q);
    });
    if (!hide.length) return;
    const btn = document.createElement("button");
    btn.className = "drawio-recall-btn"; btn.type = "button";
    btn.addEventListener("click", function () {
      const all = box.querySelectorAll(".recall"), open = box.querySelectorAll(".recall.shown").length < all.length;
      all.forEach(function (g) { g.classList.toggle("shown", open); });
      sync(box);
    });
    box.appendChild(btn); sync(box);
  }
  function sync(box) {
    const btn = box.querySelector(".drawio-recall-btn"); if (!btn) return;
    const all = box.querySelectorAll(".recall").length, shown = box.querySelectorAll(".recall.shown").length;
    btn.textContent = shown < all ? "Show all · 全部显示" : "Hide all · 全部隐藏";
  }
})();
