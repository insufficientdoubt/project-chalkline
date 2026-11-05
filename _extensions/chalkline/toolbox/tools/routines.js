/*
  Routines: the steps of a classroom routine (Think-Pair-Share and others), always at hand. Pick a
  routine; its steps show in English and 中文 (中 hides the 中文), with a box to write today's question
  and a timer that runs through the steps: each step has its own time, a beep marks the next one,
  and a step without a time (like "get a number") waits for ▶. Tap a step to go to it.
  Saved as "routines": { id, zh, q: { routine id: question }, step, left (seconds), since (start
  time while running, or 0) }, so the question and the timer come back in the next deck.

  To add a routine, add an entry to ROUTINES: an id, its name in both languages, and its steps
  (en, zh, the step's instruction in each, and min: its minutes, 0 for a step without a timer).
*/
(function () {
  const T = window.ChalklineToolbox;

  const ROUTINES = [
    { id: "tps", en: "Think-Pair-Share", zh: "思考-结对-分享", steps: [
      { en: "Think", zh: "思考", do_en: "Think on your own. No talking.", do_zh: "独立思考，不说话。", min: 1 },
      { en: "Pair", zh: "结对", do_en: "Tell your partner your idea. Then listen to theirs.", do_zh: "告诉同伴你的想法，再听听他的想法。", min: 2 },
      { en: "Share", zh: "分享", do_en: "Share your pair's best idea with the class.", do_zh: "和全班分享你们最好的想法。", min: 2 },
    ] },
    { id: "nht", en: "Numbered Heads Together", zh: "编号合作", steps: [
      { en: "Number", zh: "编号", do_en: "Everyone in your group gets a number: 1, 2, 3 or 4.", do_zh: "小组里每人领一个号码：1、2、3或4。", min: 0 },
      { en: "Think", zh: "思考", do_en: "Think on your own. Write your answer.", do_zh: "独立思考，写下你的答案。", min: 1 },
      { en: "Heads together", zh: "一起讨论", do_en: "Share your answers. Make sure everyone can explain the group's answer.", do_zh: "交流答案，确保每个人都能解释小组的答案。", min: 3 },
      { en: "Answer", zh: "回答", do_en: "The teacher calls a number. That person answers for the group.", do_zh: "老师叫一个号码，那个人代表小组回答。", min: 0 },
    ] },
    { id: "gallery", en: "Gallery Walk", zh: "画廊漫步", steps: [
      { en: "Go", zh: "出发", do_en: "Go with your group to the next poster.", do_zh: "和小组一起走到下一张海报前。", min: 0 },
      { en: "Read and talk", zh: "阅读讨论", do_en: "Read the poster. Talk about it quietly.", do_zh: "阅读海报，小声讨论。", min: 3 },
      { en: "Write", zh: "写一写", do_en: "Add one comment or question on a sticky note.", do_zh: "在便利贴上写一条评论或一个问题。", min: 1 },
      { en: "Move", zh: "换位置", do_en: "Move to the next poster. Repeat until you are back at your own.", do_zh: "走到下一张海报，直到回到自己的海报前。", min: 0 },
    ] },
    { id: "shp", en: "Stand Up, Hand Up, Pair Up", zh: "起立-举手-配对", steps: [
      { en: "Stand up", zh: "起立", do_en: "Stand up and push in your chair.", do_zh: "站起来，把椅子推进去。", min: 0 },
      { en: "Hand up", zh: "举手", do_en: "Put your hand up. Walk around the room quietly.", do_zh: "举起手，在教室里安静地走动。", min: 0.5 },
      { en: "Pair up", zh: "配对", do_en: "High-five the nearest person with a hand up. Talk about the question.", do_zh: "和最近举手的同学击掌，讨论问题。", min: 2 },
      { en: "Thank and move", zh: "道谢换人", do_en: "Say thank you. Hand up again and find a new partner.", do_zh: "说谢谢，再举手找一个新同伴。", min: 0 },
    ] },
  ];
  const byId = function (id) { return ROUTINES.find(function (r) { return r.id === id; }) || ROUTINES[0]; };
  const DEFAULT = { id: "tps", zh: true, q: {}, step: 0, left: ROUTINES[0].steps[0].min * 60, since: 0 };

  T.tool("routines", { title: "Routines", icon: "repeat", w: 560, h: 520, minW: 360, minH: 380, keys: ["routines"] },
    class extends T.ToolElement {
      static css = `
.wrap { flex: 1; min-height: 0; display: flex; flex-direction: column; gap: 1.6cqh; padding: 2.2cqh 2.4cqw; font-size: clamp(13px, 3.4cqh, 26px); }
.top { display: flex; align-items: center; gap: 0.5em; }
.top .ui-select { flex: 1; min-width: 0; }
.name { font-weight: 800; line-height: 1.1; color: var(--ui-ink); font-size: 1.25em; }
.name small { display: block; font-weight: 600; font-size: 0.68em; color: var(--ui-muted); margin-top: 0.15em; }
.zh-off .zh { display: none; }
.zhbtn { min-width: 2.2em; font-weight: 800; }
.zhbtn.on { background: var(--ui-accent); color: #fff; }
textarea {
  width: 100%; min-height: 2.6em; height: 3.2em; resize: none; padding: 0.35em 0.55em;
  border: 2px dashed var(--ui-line); border-radius: var(--ui-r-sm, 10px); background: var(--ui-soft);
  font-weight: 700; font-size: 1.05em; line-height: 1.25; color: var(--ui-ink);
}
textarea:focus { outline: none; border-color: var(--ui-focus); border-style: solid; background: #fff; }
ol { list-style: none; margin: 0; padding: 0; flex: 1; min-height: 0; overflow: auto; display: flex; flex-direction: column; gap: 0.35em; }
li {
  display: grid; grid-template-columns: 1.7em 1fr auto; gap: 0.2em 0.6em; align-items: center; padding: 0.35em 0.55em;
  border-radius: var(--ui-r-sm, 10px); cursor: pointer; background: var(--ui-soft); color: var(--ui-ink); transition: background 0.2s, opacity 0.2s;
}
li:hover { background: var(--ui-soft-hover); }
li .n { width: 1.7em; height: 1.7em; display: grid; place-items: center; border-radius: 50%; background: #fff; font-weight: 800; color: var(--ui-accent); }
li .what b { font-weight: 800; }
li .what .zh { display: block; font-size: 0.8em; color: var(--ui-muted); }
li .t { font-size: 0.8em; font-weight: 700; color: var(--ui-muted); white-space: nowrap; }
li.done { opacity: 0.5; }
li.now { background: var(--ui-accent); color: #fff; }
li.now .n { color: var(--ui-accent); }
li.now .what .zh, li.now .t { color: rgba(255, 255, 255, 0.85); }
.bottom { display: flex; align-items: center; gap: 0.6em; }
.time { font-size: 2em; font-weight: 800; font-variant-numeric: tabular-nums; line-height: 1; min-width: 3.4em; color: var(--ui-ink); }
.time.wait { font-size: 1em; color: var(--ui-muted); min-width: 0; }
.bar { flex: 1; height: 0.45em; border-radius: 0.3em; background: var(--ui-soft); overflow: hidden; }
.fill { height: 100%; width: 0; background: var(--ui-accent); transition: width 0.25s linear; }
.round {
  width: 2.1em; height: 2.1em; display: grid; place-items: center; padding: 0; border: 0; border-radius: 50%; cursor: pointer;
  background: var(--ui-soft); color: var(--ui-ink); font-size: inherit; transition: background 0.12s, transform 0.06s;
}
.round:hover { background: var(--ui-soft-hover); }
.round:active { transform: scale(0.94); }
.round.go { background: var(--ui-accent); color: #fff; }
.round.go svg { fill: currentColor; }
.round .ui-icon { font-size: 0.85em; }
.end li.now { background: var(--ui-ok, #23824a); }
`;
      build(root) {
        const self = this, h = T.h;
        this.pick = h("select", { "aria-label": "Routine", onchange: function () { self.choose(self.pick.value); } });
        ROUTINES.forEach(function (r) { self.pick.append(h("option", { value: r.id, text: r.en + " · " + r.zh })); });
        this.zhBtn = h("button", { class: "ui-btn ui-small zhbtn", text: "中", title: "Show or hide 中文", onclick: function () {
          const s = self.state(); s.zh = !s.zh; self.store(s); self.paint();
        } });
        this.name = h("div", { class: "name" });
        this.q = h("textarea", { placeholder: "Write the question here · 在这里写问题", "aria-label": "Question",
          oninput: function () { const s = self.state(); s.q[s.id] = self.q.value; self.store(s); } });
        this.list = h("ol");
        this.time = h("div", { class: "time" });
        this.fill = h("div", { class: "fill" });
        this.go = h("button", { class: "round go", onclick: function () { self.toggle(); } });
        const next = h("button", { class: "round", title: "Next step", "aria-label": "Next step", onclick: function () { self.advance(false); } }, T.icon("skip-forward"));
        const reset = h("button", { class: "round", title: "Start again", "aria-label": "Start again", onclick: function () { self.goTo(0, false); } }, T.icon("rotate-ccw"));
        this.wrap = h("div", { class: "wrap" },
          h("div", { class: "top" }, h("label", { class: "ui-select" }, this.pick, h("span", { class: "ui-select-arrow" }, T.icon("chevron-down"))), this.zhBtn),
          this.name, this.q, this.list,
          h("div", { class: "bottom" }, this.time, h("div", { class: "bar" }, this.fill), this.go, next, reset));
        root.append(this.wrap);
        this.paint();
        this.timer = setInterval(function () { self.tick(); }, 250);
      }
      state() { return Object.assign({}, DEFAULT, T.load("routines", {})); }
      store(s) { T.save("routines", s); }
      routine() { return byId(this.state().id); }
      leftNow(s) { return s.since ? Math.max(0, s.left - (Date.now() - s.since) / 1000) : s.left; }
      choose(id) {
        const s = this.state(); s.id = id; s.step = 0; s.left = byId(id).steps[0].min * 60; s.since = 0; s.done = false;
        this.store(s); this.paint();
      }
      goTo(i, run) {
        const s = this.state(), steps = this.routine().steps;
        s.step = Math.max(0, Math.min(i, steps.length - 1));
        s.done = false;
        s.left = steps[s.step].min * 60;
        s.since = run && s.left > 0 ? Date.now() : 0;
        this.store(s); this.paint();
      }
      toggle() {
        const s = this.state(), step = this.routine().steps[s.step];
        if (s.done) { this.goTo(0, false); return; }
        if (!step.min) { this.advance(true); return; }          // a step without a time: ▶ moves on
        if (s.since) { s.left = this.leftNow(s); s.since = 0; }   // pause
        else { if (s.left <= 0) s.left = step.min * 60; s.since = Date.now(); }
        this.store(s); this.paint();
      }
      advance(run) {
        const s = this.state(), steps = this.routine().steps;
        if (s.step >= steps.length - 1) {   // the last step: done
          s.since = 0; s.left = 0; s.done = true; this.store(s); this.paint();
          T.beep(660, 0.3, 0.15, "sine"); T.beep(880, 0.45, 0.15, "sine", 0.3);
          return;
        }
        s.done = false; this.store(s);
        this.goTo(s.step + 1, run);
      }
      tick() {
        const s = this.state();
        if (!s.since) return this.paintTime(s);
        if (this.leftNow(s) <= 0) { T.beep(880, 0.25, 0.15, "sine"); this.advance(true); return; }
        this.paintTime(s);
      }
      paintTime(s) {
        const steps = this.routine().steps, step = steps[s.step], left = Math.ceil(this.leftNow(s));
        if (s.done) {
          this.time.className = "time wait"; this.time.textContent = "Done · 完成";
          this.fill.style.width = "100%";
        } else if (!step.min) {
          this.time.className = "time wait"; this.time.textContent = "▶ when ready · 准备好就开始";
          this.fill.style.width = "0";
        } else {
          this.time.className = "time";
          this.time.textContent = Math.floor(left / 60) + ":" + String(left % 60).padStart(2, "0");
          this.fill.style.width = (100 * (1 - this.leftNow(s) / (step.min * 60))) + "%";
        }
        const running = !!s.since;
        if (this.running !== running || this.wasDone !== !!s.done) {
          this.running = running; this.wasDone = !!s.done;
          this.go.replaceChildren(T.icon(running ? "pause" : "play"));
          this.go.title = running ? "Pause" : s.done ? "Start again" : "Start";
          this.go.setAttribute("aria-label", this.go.title);
        }
      }
      paint() {
        const self = this, s = this.state(), r = this.routine(), h = T.h;
        this.pick.value = r.id;
        this.wrap.classList.toggle("zh-off", !s.zh);
        this.wrap.classList.toggle("end", !!s.done);
        this.zhBtn.classList.toggle("on", !!s.zh);
        this.name.replaceChildren(r.en, h("small", { class: "zh", text: r.zh }));
        if (this.shadowRoot ? this.shadowRoot.activeElement !== this.q : true) this.q.value = s.q[r.id] || "";
        this.list.replaceChildren.apply(this.list, r.steps.map(function (st, i) {
          const li = h("li", { class: i === s.step ? "now" : i < s.step || s.done ? "done" : "", onclick: function () { self.goTo(i, false); } },
            h("span", { class: "n", text: i + 1 }),
            h("span", { class: "what" }, h("b", { text: st.en }), " · " + st.do_en, h("span", { class: "zh", text: st.zh + " · " + st.do_zh })),
            h("span", { class: "t", text: st.min ? (st.min < 1 ? st.min * 60 + " s" : st.min + " min") : "" }));
          return li;
        }));
        this.running = undefined;
        this.paintTime(s);
      }
      refresh() { this.paint(); }
      close() { clearInterval(this.timer); }
    });
})();
