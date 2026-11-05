/*
  Routines: the steps of a classroom routine (Think-Pair-Share and others), always at hand, big enough
  for students to read. Pick a routine; write today's question at the top; the step you're on fills a
  big card (a picture, what to do in English and 中文, and its time); all the steps sit in a strip
  under it. The timer runs through the steps, with a beep at each one; a step without a time (like
  "get a number") waits for ▶. A step can also chime softly every minute (Crazy 8s: a new idea each
  minute). Tap a step to go to it; 中 hides or shows the 中文.
  It takes the colours, fonts and corners of the slide on screen (its colour scheme), and changes
  with it.
  Saved as "routines": { id, zh, q: { routine id: question }, step, left (seconds), since (start
  time while running, or 0), done }, so the question and the timer come back in the next deck.

  To add a routine, add an entry to ROUTINES: an id, its name in both languages, and its steps:
  en, zh (the step's name), do_en, do_zh (what to do), min (minutes, 0 for no timer), and if you
  like pic (a drawing from PICS), chime (seconds between soft chimes) and count (a counter, "3 of 8").
*/
(function () {
  const T = window.ChalklineToolbox;

  // Line drawings in the theme's colour (currentColor). The seating drawings are the Think-Pair-Share
  // slide's (guide/images/tps-*.svg); the others are drawn the same way. All original.
  const G = function (inner) {
    return '<svg viewBox="0 0 160 110" aria-hidden="true"><g fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round">' + inner + "</g></svg>";
  };
  const PICS = {
    listen: G('<rect x="44" y="8" width="72" height="40" rx="4"/><circle cx="30" cy="26" r="9"/><path d="M 18 60 Q 18 40 30 40 Q 42 40 44 30"/>' +
      '<circle cx="32" cy="78" r="8"/><path d="M 19 102 Q 19 88 32 88 Q 45 88 45 102"/><circle cx="64" cy="78" r="8"/><path d="M 51 102 Q 51 88 64 88 Q 77 88 77 102"/>' +
      '<circle cx="96" cy="78" r="8"/><path d="M 83 102 Q 83 88 96 88 Q 109 88 109 102"/><circle cx="128" cy="78" r="8"/><path d="M 115 102 Q 115 88 128 88 Q 141 88 141 102"/>'),
    think: G('<circle cx="58" cy="50" r="13"/><path d="M 36 104 Q 36 72 58 72 Q 80 72 80 104"/>' +
      '<circle cx="80" cy="30" r="3"/><circle cx="90" cy="20" r="4.5"/><path d="M 100 30 Q 92 30 92 20 Q 92 6 108 6 Q 118 -2 130 6 Q 146 6 144 20 Q 146 34 128 34 Q 116 40 106 34 Q 100 34 100 30 Z"/>' +
      '<path d="M 112 20 h 20" stroke-width="3"/>'),
    knee: G('<circle cx="55" cy="22" r="11"/><path d="M 40 62 Q 42 38 56 37 Q 70 38 72 52 L 86 60"/><path d="M 42 62 L 42 92 M 40 62 L 76 64 L 76 92"/>' +
      '<circle cx="105" cy="22" r="11"/><path d="M 120 62 Q 118 38 104 37 Q 90 38 88 52 L 74 60"/><path d="M 118 62 L 118 92 M 120 62 L 84 64 L 84 92"/>'),
    face: G('<circle cx="32" cy="24" r="11"/><path d="M 18 66 Q 18 40 32 40 Q 44 40 48 56 L 58 58"/><path d="M 18 66 L 18 96 M 18 66 L 44 66 L 44 96"/>' +
      '<circle cx="128" cy="24" r="11"/><path d="M 142 66 Q 142 40 128 40 Q 116 40 112 56 L 102 58"/><path d="M 142 66 L 142 96 M 142 66 L 116 66 L 116 96"/>' +
      '<path d="M 60 60 H 100 M 80 60 V 96 M 68 96 H 92"/>'),
    share: G('<circle cx="32" cy="78" r="8"/><path d="M 19 102 Q 19 88 32 88 Q 45 88 45 102"/><circle cx="64" cy="78" r="8"/><path d="M 51 102 Q 51 88 64 88 Q 77 88 77 102"/>' +
      '<circle cx="128" cy="78" r="8"/><path d="M 115 102 Q 115 88 128 88 Q 141 88 141 102"/>' +
      '<circle cx="96" cy="56" r="9"/><path d="M 82 102 L 82 82 Q 82 68 96 68 Q 110 68 110 82 L 110 102"/><path d="M 110 76 L 124 58"/>' +
      '<path d="M 40 10 H 108 Q 116 10 116 18 V 36 Q 116 44 108 44 H 92 L 82 54 L 82 44 H 40 Q 32 44 32 36 V 18 Q 32 10 40 10 Z"/><path d="M 46 24 H 100 M 46 32 H 84" stroke-width="3"/>'),
    notes: G('<rect x="10" y="8" width="30" height="30" rx="3"/><rect x="46" y="8" width="30" height="30" rx="3"/><rect x="82" y="8" width="30" height="30" rx="3"/><rect x="118" y="8" width="30" height="30" rx="3"/>' +
      '<rect x="10" y="48" width="30" height="30" rx="3"/><rect x="46" y="48" width="30" height="30" rx="3"/><rect x="82" y="48" width="30" height="30" rx="3"/><rect x="118" y="48" width="30" height="30" rx="3" stroke-dasharray="5 5"/>' +
      '<path d="M 17 28 L 25 18 L 33 28 M 53 20 h 16 M 53 28 h 10 M 96 14 a 8 8 0 1 0 0.1 0 M 18 66 h 14 M 54 58 l 14 12 M 68 58 l -14 12 M 90 70 q 7 -16 14 0" stroke-width="3"/>' +
      '<path d="M 128 98 L 140 86 L 146 92 L 134 104 L 126 106 Z" stroke-width="3"/>'),
    sort: G('<ellipse cx="42" cy="56" rx="36" ry="44" stroke-dasharray="6 6"/><ellipse cx="118" cy="56" rx="36" ry="44" stroke-dasharray="6 6"/>' +
      '<rect x="24" y="22" width="24" height="24" rx="3"/><rect x="38" y="52" width="24" height="24" rx="3"/><rect x="22" y="70" width="24" height="24" rx="3"/>' +
      '<rect x="102" y="24" width="24" height="24" rx="3"/><rect x="112" y="60" width="24" height="24" rx="3"/>' +
      '<path d="M 70 8 h 20 M 80 2 v 12" stroke-width="3"/>'),
  };

  const ROUTINES = [
    { id: "tps", en: "Think-Pair-Share", zh: "思考-结对-分享", steps: [
      { en: "Listen", zh: "听", do_en: "Listen to the question.", do_zh: "听问题。", min: 0, pic: "listen" },
      { en: "Think", zh: "想", do_en: "Think about your answer. No talking.", do_zh: "想一想你的答案，不说话。", min: 1, pic: "think" },
      { en: "Talk", zh: "说", do_en: "Knee to knee: tell your partner. Then listen to them.", do_zh: "膝对膝：告诉同伴你的想法，再听他说。", min: 2, pic: "knee" },
      { en: "Share", zh: "分享", do_en: "Share your best idea with the whole class.", do_zh: "和全班分享你们最好的想法。", min: 2, pic: "share" },
    ] },
    { id: "crazy8", en: "Crazy 8s", zh: "疯狂8格", steps: [
      { en: "Get ready", zh: "准备", do_en: "Take 8 sticky notes, or fold a paper into 8 boxes.", do_zh: "拿8张便利贴，或把一张纸折成8格。", min: 0, pic: "notes" },
      { en: "8 ideas", zh: "8个想法", do_en: "One idea on each note: write or draw. New note at each chime!", do_zh: "每张写或画一个想法。听到铃声就换下一张！", min: 8, chime: 60, count: 8, pic: "notes" },
      { en: "Show", zh: "展示", do_en: "Take turns. Show your ideas to your team.", do_zh: "轮流向小组展示你的想法。", min: 3, pic: "face" },
      { en: "Group and sort", zh: "分组整理", do_en: "Put ideas that are alike together. Give each group a name.", do_zh: "把相似的想法放在一起，给每组起个名字。", min: 5, pic: "sort" },
    ] },
    { id: "nht", en: "Numbered Heads Together", zh: "编号合作", steps: [
      { en: "Number", zh: "编号", do_en: "Everyone in your group gets a number: 1, 2, 3 or 4.", do_zh: "小组里每人领一个号码：1、2、3或4。", min: 0, pic: "face" },
      { en: "Think", zh: "想", do_en: "Think on your own. Write your answer.", do_zh: "独立思考，写下你的答案。", min: 1, pic: "think" },
      { en: "Heads together", zh: "一起讨论", do_en: "Share answers. Make sure everyone can explain the answer.", do_zh: "交流答案，确保每个人都能解释答案。", min: 3, pic: "face" },
      { en: "Answer", zh: "回答", do_en: "The teacher calls a number. That person answers for the group.", do_zh: "老师叫一个号码，那个人代表小组回答。", min: 0, pic: "share" },
    ] },
    { id: "gallery", en: "Gallery Walk", zh: "画廊漫步", steps: [
      { en: "Go", zh: "出发", do_en: "Go with your group to the next poster.", do_zh: "和小组一起走到下一张海报前。", min: 0 },
      { en: "Read and talk", zh: "阅读讨论", do_en: "Read the poster. Talk about it quietly.", do_zh: "阅读海报，小声讨论。", min: 3 },
      { en: "Write", zh: "写一写", do_en: "Add one comment or question on a sticky note.", do_zh: "在便利贴上写一条评论或一个问题。", min: 1, pic: "notes" },
      { en: "Move", zh: "换位置", do_en: "Move to the next poster. Stop when you are back at your own.", do_zh: "走到下一张海报，回到自己的海报时停下。", min: 0 },
    ] },
    { id: "shp", en: "Stand Up, Hand Up, Pair Up", zh: "起立-举手-配对", steps: [
      { en: "Stand up", zh: "起立", do_en: "Stand up and push in your chair.", do_zh: "站起来，把椅子推进去。", min: 0 },
      { en: "Hand up", zh: "举手", do_en: "Put your hand up. Walk around quietly.", do_zh: "举起手，安静地走动。", min: 0.5 },
      { en: "Pair up", zh: "配对", do_en: "High-five the nearest person with a hand up. Talk about the question.", do_zh: "和最近举手的同学击掌，讨论问题。", min: 2, pic: "knee" },
      { en: "Thank and move", zh: "道谢换人", do_en: "Say thank you. Hand up again: find a new partner.", do_zh: "说谢谢，再举手找一个新同伴。", min: 0 },
    ] },
  ];
  const byId = function (id) { return ROUTINES.find(function (r) { return r.id === id; }) || ROUTINES[0]; };
  const DEFAULT = { id: "tps", zh: true, q: {}, step: 0, left: 0, since: 0, done: false };

  // The slide's colour scheme, as the tool's own colours (the tokens of styles/layout.scss)
  const TOKENS = ["paper", "surface", "surface-2", "ink", "ink-muted", "heading", "accent", "on-accent", "strong", "on-strong", "hot", "line", "radius"];

  T.tool("routines", { title: "Routines", icon: "repeat", w: 640, h: 500, minW: 380, minH: 340, keys: ["routines"], free: true },
    class extends T.ToolElement {
      static css = `
:host { flex: 1; min-height: 0; display: flex; container-type: size; }
.card {
  flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 2.2cqh; padding: 3cqh 3.2cqw 2.6cqh;
  border-radius: calc(var(--t-radius, 14px) * 1.4); background: var(--t-paper, #fff); color: var(--t-ink, #1f2933);
  border: 1px solid var(--t-line, rgba(0,52,119,.18)); box-shadow: 0 1px 3px rgba(16,35,63,.1), 0 18px 44px rgba(16,35,63,.3);
  font-family: var(--t-font, inherit); font-size: clamp(13px, 4.1cqh, 36px);
}
.zh-off .zh { display: none; }
/* top: the routine and 中, small */
.top { display: flex; align-items: center; gap: 0.5em; font-size: 0.6em; }
.top select {
  flex: 1; min-width: 0; appearance: none; padding: 0.3em 1.8em 0.3em 0.7em; border-radius: 999px; cursor: pointer;
  border: 1px solid var(--t-line, #d6dee8); background: var(--t-surface-2, #fff) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23888' stroke-width='2.5'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E") right 0.6em center / 1em no-repeat;
  color: var(--t-heading, #003477); font-weight: 700;
}
.pill { border: 1px solid var(--t-line, #d6dee8); background: transparent; color: var(--t-ink-muted, #52606d); border-radius: 999px; padding: 0.3em 0.8em; font-weight: 800; cursor: pointer; }
.pill.on { background: var(--t-strong, #003477); color: var(--t-on-strong, #fff); border-color: transparent; }
/* the question: big */
textarea {
  width: 100%; height: 2.5em; resize: none; padding: 0.15em 0.4em; border: 2px dashed transparent; border-radius: 10px; background: transparent;
  font-family: var(--t-head-font, inherit); font-size: 1.35em; font-weight: 800; line-height: 1.15; color: var(--t-heading, #003477);
}
textarea::placeholder { color: var(--t-ink-muted, #52606d); opacity: 0.6; font-weight: 600; }
textarea:hover { border-color: var(--t-line, #d6dee8); }
textarea:focus { outline: none; border-color: var(--t-accent, #0087ff); }
/* the step you're on: a big card */
.stage {
  flex: 1; min-height: 0; display: grid; grid-template-columns: auto 1fr auto; align-items: center; gap: 0 3cqw; padding: 2.4cqh 2.6cqw;
  border-radius: var(--t-radius, 14px); background: var(--t-surface, #ebf7fd); border: 1px solid var(--t-line, transparent);
}
.pic { width: 25cqw; max-height: 100%; color: var(--t-heading, #003477); }
.pic svg { display: block; width: 100%; height: auto; }
.pic:empty { display: none; }
.say { min-width: 0; }
.say .step { font-size: 0.75em; font-weight: 800; letter-spacing: 0.04em; text-transform: uppercase; color: var(--t-ink-muted, #52606d); }
.say .what { font-family: var(--t-head-font, inherit); font-size: 1.3em; font-weight: 800; line-height: 1.15; color: var(--t-heading, #003477); margin: 0.1em 0 0.25em; }
.say .what .zh { font-weight: 700; margin-left: 0.3em; }
.say .do { font-size: 1.12em; line-height: 1.25; }
.say .do.zh { font-size: 0.85em; color: var(--t-ink-muted, #52606d); margin-top: 0.2em; }
.clock { display: flex; flex-direction: column; align-items: center; gap: 0.3em; min-width: 5.2em; }
.time { font-family: var(--t-head-font, inherit); font-size: 2.6em; font-weight: 800; line-height: 1; font-variant-numeric: tabular-nums; color: var(--t-heading, #003477); }
.time.small { font-size: 0.9em; text-align: center; color: var(--t-ink-muted, #52606d); font-weight: 700; }
.count { font-size: 0.8em; font-weight: 800; color: var(--t-on-accent, #003477); background: var(--t-accent, #14d7cd); padding: 0.1em 0.7em; border-radius: 999px; }
.count:empty { display: none; }
.bar { width: 100%; height: 0.4em; border-radius: 0.3em; background: var(--t-line, rgba(0,0,0,.1)); overflow: hidden; }
.fill { height: 100%; width: 0; background: var(--t-accent, #0087ff); transition: width 0.25s linear; }
.done .stage { background: color-mix(in srgb, #2e9e4f 14%, var(--t-surface, #ebf7fd)); }
/* all the steps, and the buttons */
.foot { display: flex; align-items: center; gap: 0.6em; font-size: 0.66em; }
ol { flex: 1; min-width: 0; list-style: none; margin: 0; padding: 0; display: flex; gap: 0.35em; flex-wrap: wrap; }
li {
  display: flex; align-items: center; gap: 0.35em; padding: 0.25em 0.75em 0.25em 0.3em; border-radius: 999px; cursor: pointer;
  background: var(--t-surface-2, #f2f6fa); border: 1px solid var(--t-line, transparent); color: var(--t-ink, #1f2933); font-weight: 700;
}
li .zh { font-weight: 600; opacity: 0.8; }
li .n { width: 1.5em; height: 1.5em; display: grid; place-items: center; border-radius: 50%; background: var(--t-surface, #ebf7fd); font-size: 0.85em; font-weight: 800; }
li.past { opacity: 0.55; }
li.now { background: var(--t-accent, #14d7cd); color: var(--t-on-accent, #003477); border-color: transparent; }
li.now .n { background: var(--t-paper, #fff); color: var(--t-heading, #003477); }
.round {
  width: 2.2em; height: 2.2em; display: grid; place-items: center; padding: 0; border: 0; border-radius: 50%; cursor: pointer; flex: none;
  background: var(--t-surface-2, #eef3f8); color: var(--t-heading, #003477); font-size: inherit; transition: transform 0.06s;
}
.round:active { transform: scale(0.94); }
.round.go { background: var(--t-strong, #003477); color: var(--t-on-strong, #fff); }
.round.go svg { fill: currentColor; }
.round .ui-icon { font-size: 0.9em; }
/* small window: picture and time stack */
@container (max-width: 470px) {
  .stage { grid-template-columns: 1fr auto; }
  .pic { display: none; }
}
`;
      build(root) {
        const self = this, h = T.h;
        this.pick = h("select", { "aria-label": "Routine", onchange: function () { self.choose(self.pick.value); } });
        ROUTINES.forEach(function (r) { self.pick.append(h("option", { value: r.id, text: r.en + " · " + r.zh })); });
        this.zhBtn = h("button", { class: "pill", text: "中", title: "Show or hide 中文", onclick: function () {
          const s = self.state(); s.zh = !s.zh; self.store(s); self.paint();
        } });
        this.q = h("textarea", { placeholder: "Write the question here · 在这里写问题", "aria-label": "Question", rows: 2,
          oninput: function () { const s = self.state(); s.q[s.id] = self.q.value; self.store(s); } });
        this.pic = h("div", { class: "pic" });
        this.say = h("div", { class: "say" });
        this.time = h("div", { class: "time" });
        this.countEl = h("div", { class: "count" });
        this.fill = h("div", { class: "fill" });
        this.list = h("ol");
        this.go = h("button", { class: "round go", onclick: function () { self.toggle(); } });
        const next = h("button", { class: "round", title: "Next step", "aria-label": "Next step", onclick: function () { self.advance(false); } }, T.icon("skip-forward"));
        const again = h("button", { class: "round", title: "Start again", "aria-label": "Start again", onclick: function () { self.goTo(0, false); } }, T.icon("rotate-ccw"));
        this.card = h("div", { class: "card" },
          h("div", { class: "top" }, this.pick, this.zhBtn),
          this.q,
          h("div", { class: "stage" }, this.pic, this.say, h("div", { class: "clock" }, this.time, h("div", { class: "bar" }, this.fill), this.countEl)),
          h("div", { class: "foot" }, this.list, this.go, next, again));
        root.append(this.card);
        this.theme();
        this.paint();
        this.timer = setInterval(function () { self.tick(); }, 250);
        this.themer = setInterval(function () { self.theme(); }, 1000);   // a palette change, a new slide
        this.onSlide = function () { self.theme(); };
        if (window.Reveal) Reveal.on("slidechanged", this.onSlide);
      }
      // Copy the slide's colours, fonts and corners onto the tool (they don't reach it on their own:
      // the tools float outside the slides).
      theme() {
        const slide = window.Reveal && Reveal.getCurrentSlide && Reveal.getCurrentSlide();
        if (!slide) return;
        const st = getComputedStyle(slide), sig = [];
        TOKENS.forEach(function (t) { sig.push(st.getPropertyValue("--" + t).trim()); });
        sig.push(st.fontFamily, st.getPropertyValue("--r-heading-font").trim());
        const key = sig.join("|");
        if (key === this.themeKey) return;
        this.themeKey = key;
        const self = this;
        TOKENS.forEach(function (t, i) { if (sig[i]) self.style.setProperty("--t-" + t, sig[i]); else self.style.removeProperty("--t-" + t); });
        this.style.setProperty("--t-font", st.fontFamily);
        if (sig[TOKENS.length + 1]) this.style.setProperty("--t-head-font", sig[TOKENS.length + 1]);
      }
      state() { const s = Object.assign({}, DEFAULT, T.load("routines", {})); s.q = s.q || {}; return s; }
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
        this.chimed = 0;
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
        this.goTo(s.step + 1, run);
      }
      chime() {   // soft: two quiet bell tones
        T.beep(1318.5, 0.9, 0.05, "sine"); T.beep(1975.5, 0.7, 0.025, "sine", 0.02);
      }
      tick() {
        const s = this.state(), step = this.routine().steps[s.step];
        if (s.since) {
          if (this.leftNow(s) <= 0) { T.beep(880, 0.25, 0.15, "sine"); this.advance(true); return; }
          if (step.chime) {   // a soft chime every chime seconds (not at the very start or end)
            const n = Math.floor((step.min * 60 - this.leftNow(s)) / step.chime);
            if (this.chimed === undefined || this.chimed > n) this.chimed = n;
            if (n > this.chimed) { this.chimed = n; this.chime(); }
          }
        }
        this.paintTime(s);
      }
      paintTime(s) {
        const step = this.routine().steps[s.step], left = Math.ceil(this.leftNow(s));
        if (s.done) {
          this.time.className = "time small"; this.time.textContent = "Done! · 完成！"; this.fill.style.width = "100%"; this.countEl.textContent = "";
        } else if (!step.min) {
          this.time.className = "time small"; this.time.textContent = "▶"; this.fill.style.width = "0"; this.countEl.textContent = "";
        } else {
          this.time.className = "time";
          this.time.textContent = Math.floor(left / 60) + ":" + String(left % 60).padStart(2, "0");
          const gone = step.min * 60 - this.leftNow(s);
          this.fill.style.width = (100 * gone / (step.min * 60)) + "%";
          this.countEl.textContent = step.count ? Math.min(step.count, Math.floor(gone / (step.chime || 60)) + 1) + " / " + step.count : "";
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
        const self = this, s = this.state(), r = this.routine(), h = T.h, step = r.steps[s.step];
        this.pick.value = r.id;
        this.card.classList.toggle("zh-off", !s.zh);
        this.card.classList.toggle("done", !!s.done);
        this.zhBtn.classList.toggle("on", !!s.zh);
        if (!this.shadowRoot || this.shadowRoot.activeElement !== this.q) this.q.value = s.q[r.id] || "";
        this.pic.innerHTML = step.pic && PICS[step.pic] ? PICS[step.pic] : "";
        this.say.replaceChildren(
          h("div", { class: "step", text: (s.step + 1) + " / " + r.steps.length }),
          h("div", { class: "what" }, step.en, h("span", { class: "zh", text: step.zh })),
          h("div", { class: "do", text: step.do_en }),
          h("div", { class: "do zh", text: step.do_zh }));
        this.list.replaceChildren.apply(this.list, r.steps.map(function (st, i) {
          return h("li", { class: i === s.step && !s.done ? "now" : i < s.step || s.done ? "past" : "", title: st.do_en,
            onclick: function () { self.goTo(i, false); } },
            h("span", { class: "n", text: i + 1 }), st.en, h("span", { class: "zh", text: st.zh }));
        }));
        this.running = undefined;
        this.paintTime(s);
      }
      refresh() { this.paint(); }
      close() {
        clearInterval(this.timer); clearInterval(this.themer);
        if (window.Reveal && this.onSlide) Reveal.off("slidechanged", this.onSlide);
      }
    });
})();
