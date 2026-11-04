/*
  Slide size: how this screen shows the slides: the space around them, and their shape (the deck's
  own, or the screen's shape, so there are no empty bands at the sides or top and bottom). Only on
  this screen; the deck files don't change. The setting applies in every deck, with the tool closed too.
  Saved as "slide": { margin: 0 to 0.3, wide: true to fill the screen }.
*/
(function () {
  const T = window.ChalklineToolbox;
  const DECK = window.Reveal ? Reveal.getConfig() : {};
  const SIZE = { margin: DECK.margin == null ? 0.04 : DECK.margin, width: DECK.width || 960, height: DECK.height || 700 };
  function setting() { return T.load("slide", { margin: SIZE.margin, wide: false }); }
  // The screen's shape: a wider screen adds width, a taller one adds height, never less than the deck
  // has, so nothing new can overflow. A deck that already has the screen's shape gains nothing.
  function filled() {
    const screen = window.innerWidth / Math.max(1, window.innerHeight), deck = SIZE.width / SIZE.height;
    return screen >= deck ? { width: Math.round(SIZE.height * screen), height: SIZE.height }
                          : { width: SIZE.width, height: Math.round(SIZE.width / screen) };
  }
  function canFill() { const f = filled(); return f.width - SIZE.width > 8 || f.height - SIZE.height > 8; }
  function apply(s) {
    if (!window.Reveal) return;
    const size = s.wide ? filled() : SIZE;
    Reveal.configure({ margin: s.margin, width: size.width, height: size.height });
  }
  window.addEventListener("resize", function () { if (T.load("slide", null) && setting().wide) apply(setting()); });
  if (T.active && window.Reveal && T.load("slide", null)) {
    if (Reveal.isReady()) apply(setting());
    else Reveal.on("ready", function () { apply(setting()); });
  }

  T.tool("slide", { title: "Slide size", icon: "ruler", w: 360, h: 250, minW: 260, minH: 230, keys: ["slide"] },
    class extends T.ToolElement {
      static css = `
.label { flex: 1; display: flex; align-items: center; justify-content: center; flex-wrap: wrap; gap: 0 0.35em; font-size: clamp(14px, min(12cqh, 6.5cqw), 24px); font-weight: 600; color: var(--ui-muted); }
.value { color: var(--ui-ink); font-size: 1.6em; font-weight: 700; font-variant-numeric: tabular-nums; }
input { width: 100%; margin: 4px 0; accent-color: var(--ui-accent); }
`;
      build(root) {
        const self = this, h = T.h;
        this.value = h("span", { class: "value" });
        this.slider = h("input", { type: "range", min: 0, max: 30, "aria-label": "Space around the slide", oninput: function () {
          const s = setting();
          s.margin = +self.slider.value / 100;
          T.save("slide", s); apply(s); self.paint();
        } });
        this.normal = h("button", { text: "Standard", onclick: function () { self.setWide(false); } });
        this.wide = h("button", { text: "Fill the screen", onclick: function () { self.setWide(true); } });
        root.append(h("div", { class: "label" }, h("span", { text: "Space around the slide" }), this.value), this.slider,
          h("div", { class: "ui-actions" }, h("div", { class: "ui-seg" }, this.normal, this.wide),
            h("button", { class: "ui-btn ui-small", text: "Reset", onclick: function () {
              try { localStorage.removeItem("chalkline-tools:slide"); } catch (e) { /* private window */ }
              apply(setting()); self.paint();
            } })));
        this.paint();
      }
      setWide(on) { const s = setting(); s.wide = on; T.save("slide", s); apply(s); this.paint(); }
      paint() {
        const s = setting();
        this.slider.value = Math.round(s.margin * 100);
        this.value.textContent = Math.round(s.margin * 100) + "%";
        const room = canFill();
        this.normal.classList.toggle("ui-on", !s.wide || !room);
        this.wide.classList.toggle("ui-on", !!s.wide && room);
        this.wide.disabled = !room;
        this.wide.title = room ? "Add space so the slide has this screen's shape" : "This deck already has the screen's shape";
      }
      refresh() { this.paint(); }
    });
})();
