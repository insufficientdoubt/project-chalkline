// History pages for the packet kit, rebuilt from a colleague's Mesopotamia worksheets: a source dossier card,
// an artifact investigation, a design-your-own artifact, and a formative assessment with a rubric.
#import "kit.typ": *

// English, then 中文 under it, quieter
#let bi(en, zh, size: 1em) = context [#en #if zh != none and zh != "" [#linebreak()#text(size: size * 0.86, fill: TH.get().muted, zh)]]
// a numbered marker: on a picture, and the same number beside its note
#let marker(n, size: 6mm) = context {
  let t = TH.get()
  box(width: size, height: size, circle(radius: size / 2, fill: white, stroke: 1.5pt + t.hot, align(center + horizon, text(font: t.label-font, size: size * 0.5, weight: "bold", fill: t.head, str(n)))))
}
// part of a picture: the pixel box (x0, y0)–(x1, y1) of an image w × h pixels, shown `width` wide,
// with numbered markers at (n, x, y) in pixels of the original
#let crop(path, w, h, x0, y0, x1, y1, width: 80mm, markers: ()) = {
  let s = width / (x1 - x0)
  box(width: width, height: (y1 - y0) * s, clip: true, radius: 3pt, inset: 0pt, {
    // placed (it takes no room), pinned to the top left, at full size; the box clips it
    place(top + left, dx: -x0 * s, dy: -y0 * s, image(path, width: w * s, height: h * s))
    for (n, x, y) in markers { place(top + left, dx: (x - x0) * s - 3mm, dy: (y - y0) * s - 3mm, marker(n)) }
  })
}
// the same, with the picture given as content (an image Quarto placed, already sized w × scale wide): for .qmd pages
#let crop-content(img, w, h, x0, y0, x1, y1, width: 80mm, markers: ()) = {
  let s = width / (x1 - x0)
  box(width: width, height: (y1 - y0) * s, clip: true, radius: 3pt, inset: 0pt, {
    place(top + left, dx: -x0 * s, dy: -y0 * s, img)
    for (n, x, y) in markers { place(top + left, dx: (x - x0) * s - 3mm, dy: (y - y0) * s - 3mm, marker(n)) }
  })
}
#let tag(body, c) = box(inset: (x: 6pt, y: 2.5pt), radius: 3pt, stroke: 0.8pt + c, text(font: ("Source Sans 3", "Noto Sans SC"), size: 8pt, weight: "bold", fill: c, body))

// ---------------------------------------------------------------- the source dossier card (one page)
// glance: (("What", "…"), ("When", "…"), …); notes: ((n, title-en, title-zh, en, zh), …)
#let source-card(region: "", number: 1, title: "", title-zh: "", picture: [], caption: [], glance: (), notes: (),
  context-en: [], context-zh: [], context-label: ("Historical context", "历史背景"), extra: none, citation: [], credit: []) = context {
  let t = TH.get()
  [#metadata(title) <section-title>#metadata(title) <own-title>]
  grid(columns: (1fr, auto), align: bottom, [#tag(region, t.accent) #h(3pt) #tag([Primary source #number], t.muted)], text(size: 8pt, fill: t.muted, "Source dossier · 史料档案"))
  v(2mm)
  text(font: t.head-font, weight: "bold", size: 19pt, fill: t.head, title)
  linebreak(); text(size: 12pt, fill: t.muted, title-zh)
  v(-3pt); rule(t); v(2mm)
  // at a glance: a strip of facts
  block(width: 100%, inset: (x: 6pt, y: 4pt), fill: t.tint, radius: calc.min(t.radius, 4pt), below: 3mm,
    grid(columns: (1fr,) * glance.len(), column-gutter: 4mm, ..glance.map(((k, v)) => [#text(font: t.label-font, size: 7pt, weight: "bold", fill: t.muted, upper(k)) \ #text(size: 8.5pt, weight: "bold", v)])))
  grid(columns: (84mm, 1fr), column-gutter: 6mm,
    [#picture #v(1mm) #text(size: 7.5pt, fill: t.muted, caption)],
    [
      #text(font: t.label-font, size: 8pt, weight: "bold", fill: t.accent, "LOOK CLOSELY · 观察要素")
      #v(1mm)
      #for (n, en, zh, body, body-zh) in notes {
        block(below: 2.5mm, grid(columns: (7mm, 1fr), column-gutter: 2mm, marker(n),
          [#text(weight: "bold", size: 9.5pt, fill: t.head, en) #text(size: 8.5pt, fill: t.muted, zh) \ #text(size: 8.5pt, body) \ #text(size: 7.5pt, fill: t.muted, body-zh)]))
      }
    ])
  v(3mm)
  block(width: 100%, stroke: (top: 0.8pt + t.line), inset: (top: 3mm), below: 3mm, {
    text(font: t.label-font, size: 8pt, weight: "bold", fill: t.accent, upper(context-label.at(0)) + " · " + context-label.at(1))
    v(1mm)
    set par(justify: true)
    text(size: 9.5pt, context-en)
    v(1mm)
    text(size: 8.5pt, fill: t.muted, context-zh)
  })
  if extra != none { extra }
  v(1fr)
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 6pt, text(size: 7.5pt)[#text(weight: "bold", "Cite it (MLA 9) · 引用格式  ") #citation #linebreak() #text(fill: t.muted)[Photo: #credit]])
}
#let quote-box(label, en, zh) = context {
  let t = TH.get()
  block(width: 100%, inset: (left: 9pt, y: 6pt), stroke: (left: 3pt + t.hot), below: 2mm, {
    text(font: t.label-font, size: 8pt, weight: "bold", fill: t.hot, label); v(1mm)
    text(size: 9.5pt, style: "italic", en); v(0.5mm); text(size: 8.5pt, fill: t.muted, zh)
  })
}

// ---------------------------------------------------------------- an artifact investigation (one page)
#let investigation(letter, sources, connect: none) = context {
  let t = TH.get()
  [#metadata("Investigation " + letter) <section-title>#metadata(letter) <own-title>]
  let circle-box = box(width: 4mm, height: 4mm, stroke: 0.8pt + t.head, radius: 50%)
  text(font: t.head-font, weight: "bold", size: 17pt, fill: t.head)[Investigation #letter]
  h(3mm); text(size: 11pt, fill: t.muted, if letter == "A" { "史料探究一" } else { "史料探究二" })
  v(-3pt); rule(t); v(2mm)
  block(width: 100%, inset: 7pt, fill: t.tint, radius: calc.min(t.radius, 4pt), below: 3mm, {
    text(font: t.label-font, size: 8pt, weight: "bold", fill: t.muted, "MY SOURCE  ")
    for (i, s) in sources.enumerate() { box[#circle-box #h(2pt) #text(size: 9pt)[#(i + 1). #s]]; h(5mm) }
  })
  let step(n, en, zh, prompt, stem, side, lines) = block(width: 100%, breakable: false, below: 3mm, stroke: t.box-stroke, radius: t.radius, inset: 7pt,
    grid(columns: (1fr, 46mm), column-gutter: 5mm,
      [#badge(t, str(n), size: 1.6em) #h(3pt) #text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, en) #h(3pt) #text(fill: t.muted, zh) \
       #text(size: 8.5pt, fill: t.muted, prompt) #v(1mm) #text(size: 9pt, style: "italic", fill: t.accent, stem)
       #answer-lines(n: lines, gap: 8.5mm)],
      side))
  let markers-used = [#text(size: 7.5pt, fill: t.muted, "Marker numbers I used") \ #v(1mm) #for n in range(1, 6) { box(width: 6.5mm, height: 6.5mm, stroke: 0.8pt + t.line, radius: 50%, align(center + horizon, text(size: 8pt, fill: t.muted, str(n)))); h(1.5mm) }]
  let sure = [#text(size: 7.5pt, fill: t.muted, "How sure are you?") \ #v(1mm) #for l in ("a guess", "fairly sure", "certain") { box[#box(width: 3.5mm, height: 3.5mm, stroke: 0.8pt + t.head, radius: 1pt) #h(2pt) #text(size: 8pt, l)]; linebreak() }]
  step(1, "Observe", "仔细观察", [What can you see? Shapes, sizes, clothes, animals, objects, materials.], [I see …], block(width: 100%, height: 36mm, stroke: (paint: t.line, dash: "dotted"), radius: 3pt, inset: 4pt, text(size: 7.5pt, fill: t.muted, "Sketch one detail")), if connect == none { 4 } else { 3 })
  step(2, "Infer", "合理推断", [What does it tell you about the god's power, or about kings and ordinary people?], [I think … because …], markers-used, if connect == none { 4 } else { 3 })
  step(3, "Evidence", "实证推论", [Make a claim about Mesopotamian beliefs. Point to the detail that proves it.], [This source shows that Mesopotamians believed … The detail that proves it is …], sure, if connect == none { 4 } else { 3 })
  if connect != none {
    v(1fr)
    block(width: 100%, stroke: 1.4pt + t.head, radius: t.radius, inset: 8pt, [#text(font: t.head-font, weight: "bold", fill: t.head, "Connect A and B · 联系两件史料  ") #text(size: 9pt, connect) #answer-lines(n: 3, gap: 8mm)])
  }
}

// ---------------------------------------------------------------- design your own artifact (one page)
#let design-artifact() = context {
  let t = TH.get()
  [#metadata("Design your own artifact") <section-title>#metadata("design") <own-title>]
  grid(columns: (1fr, auto), align: bottom, tag([Challenge · 延伸挑战], t.hot), text(size: 8pt, fill: t.muted, "Creative and historical thinking"))
  v(2mm)
  text(font: t.head-font, weight: "bold", size: 19pt, fill: t.head, "Design your own artifact")
  linebreak(); text(size: 11pt, fill: t.muted, "设计你自己的出土文物")
  v(-3pt); rule(t); v(2mm)
  block(width: 100%, inset: 7pt, fill: t.tint, radius: calc.min(t.radius, 4pt), below: 3mm, bi(
    [Invent a Mesopotamian god who fits the land: the rivers, the floods, the clay, the heat. Draw an artifact an archaeologist might dig up one day. Then write the guide a future historian would need, just like the source dossier.],
    [创造一位符合美索不达米亚自然环境的神明，画出考古学家将来可能发掘的文物，并像史料档案一样写出研读指南。]))
  let chip(s) = box(inset: (x: 5pt, y: 2pt), stroke: 0.6pt + t.line, radius: 6pt, text(size: 8pt, s))
  grid(columns: (90mm, 1fr), column-gutter: 6mm,
    [
      #block(width: 100%, height: 112mm, stroke: t.box-stroke, radius: t.radius, fill: surface(t, "dots"), inset: 6pt,
        [#text(font: t.label-font, size: 8pt, weight: "bold", fill: t.head, "YOUR ARTIFACT") #h(1fr) #text(size: 7.5pt, fill: t.muted)[Add markers #marker(1, size: 4.5mm) #marker(2, size: 4.5mm) #marker(3, size: 4.5mm) to three details]])
      #v(2mm)
      #text(font: t.label-font, size: 8pt, weight: "bold", fill: t.muted, "AT A GLANCE")
      #v(1mm)
      #grid(columns: (auto, 1fr), row-gutter: 5mm, column-gutter: 3mm,
        text(size: 9pt, weight: "bold", "God's name"), line(length: 100%, stroke: 0.6pt + t.line),
        text(size: 9pt, weight: "bold", "Power over"), line(length: 100%, stroke: 0.6pt + t.line),
        text(size: 9pt, weight: "bold", "City-state"), line(length: 100%, stroke: 0.6pt + t.line))
      #v(3mm)
      #text(size: 8.5pt)[*Type:* #chip[seal] #chip[stele] #chip[plaque] #chip[statue] \ #v(1mm) *Made of:* #chip[clay] #chip[basalt] #chip[bronze] #chip[lapis]]
    ],
    [
      #text(font: t.label-font, size: 8pt, weight: "bold", fill: t.accent, "FIELD GUIDE FOR A FUTURE HISTORIAN · 考古研读记录")
      #v(2mm)
      #for (n, q, zh, hint) in (
        (1, [What should a historian *observe*?], "仔细观察", [Describe what markers 1–3 show.]),
        (2, [What can they *infer*?], "合理推断", [What did people hope for, or fear, from this god?]),
        (3, [What *evidence* does it give?], "实证推论", [How does it connect to rivers, floods, farming or kings?]),
      ) {
        block(width: 100%, stroke: (left: 3pt + t.hot), inset: (left: 8pt, y: 4pt), below: 4mm,
          [#text(weight: "bold", fill: t.head)[Step #n · ] #q #text(size: 8.5pt, fill: t.muted, zh) \ #text(size: 8pt, fill: t.muted, hint) #answer-lines(n: 4, gap: 8mm)])
      }
    ])
}

// ---------------------------------------------------------------- the formative assessment
#let marks(n) = context box(inset: (x: 5pt, y: 2pt), radius: 8pt, stroke: 0.8pt + TH.get().line, text(size: 8pt, weight: "bold", fill: TH.get().muted, "[" + str(n) + "]"))
#let assessment-head(title, unit, minutes: 40, total: 25, instructions: []) = context {
  let t = TH.get()
  [#metadata(title) <section-title>#metadata(title) <own-title>]
  grid(columns: (1fr, auto), align: bottom,
    [#tag([Formative assessment], t.hot) \ #v(1mm) #text(font: t.head-font, weight: "bold", size: 18pt, fill: t.head, title) \ #text(size: 9.5pt, fill: t.muted, unit)],
    block(stroke: 1.4pt + t.head, radius: t.radius, inset: 7pt, align(center)[#text(size: 7.5pt, fill: t.muted, "MARKS") \ #text(font: t.head-font, size: 16pt, weight: "bold", fill: t.head)[#h(12mm) / #total] \ #text(size: 7.5pt, fill: t.muted, str(minutes) + " minutes")]))
  v(-1pt); rule(t); v(2mm)
  name-row()
  v(2mm)
  block(width: 100%, inset: 7pt, fill: t.tint, radius: calc.min(t.radius, 4pt), below: 3mm, text(size: 9pt, instructions))
}
// a short answer: the question, its marks, lines sized to the marks
#let short-answer(n, en, zh, m, lines: auto, answer: none) = context {
  let t = TH.get()
  block(width: 100%, breakable: false, below: 2mm, grid(columns: (7mm, 1fr, auto), column-gutter: 2mm,
    text(weight: "bold", fill: t.head, str(n) + "."),
    [#bi(text(size: 10pt, en), zh) #answer-lines(n: if lines == auto { calc.max(2, m) } else { lines }, gap: 7.1mm, answer: answer)],
    marks(m)))
}
// the rubric: levels, what each means, an example on another topic (so it can't be copied)
#let rubric(command, criterion, rows) = context {
  let t = TH.get()
  let hd(s) = text(font: t.label-font, size: 8pt, weight: "bold", fill: t.head, s)
  block(breakable: false, table(columns: (17mm, 1fr, 1fr), inset: 6pt, align: (center + horizon, left + top, left + top),
    fill: (x, y) => if y == 0 { t.tint } else if rows.at(y - 1).at(3, default: false) { t.hot.transparentize(90%) } else { none },
    hd("Level"), hd(criterion), hd("Example (another topic)"),
    ..rows.map(r => (text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, r.at(0)) + if r.at(3, default: false) { linebreak() + text(size: 7pt, fill: t.hot, weight: "bold", "TARGET") }, text(size: 8.5pt, r.at(1)), text(size: 8pt, style: "italic", fill: t.muted, r.at(2)))).flatten()))
}
#let command-term(term, zh, meaning) = context {
  let t = TH.get()
  block(width: 100%, stroke: 1.4pt + t.head, radius: t.radius, inset: 8pt, below: 3mm,
    grid(columns: (auto, 1fr), column-gutter: 5mm, align: horizon,
      [#text(font: t.label-font, size: 7.5pt, fill: t.muted, "COMMAND TERM") \ #text(font: t.head-font, size: 20pt, weight: "bold", fill: t.hot, upper(term)) \ #text(size: 9pt, fill: t.muted, zh)],
      text(size: 9.5pt, meaning)))
}
// plan the paragraph as a chain: each box leads to the next
#let paragraph-chain(steps) = context {
  let t = TH.get()
  let n = steps.len()
  grid(columns: range(2 * n - 1).map(i => if calc.even(i) { 1fr } else { 5mm }), align: horizon,
    ..range(2 * n - 1).map(i => if calc.even(i) {
      let (title, hint) = steps.at(calc.quo(i, 2))
      block(width: 100%, height: 46mm, stroke: t.box-stroke, radius: t.radius, inset: 5pt, fill: surface(t, "lines"),
        [#text(font: t.head-font, weight: "bold", size: 9.5pt, fill: t.head, title) \ #text(size: 7.5pt, fill: t.muted, hint)])
    } else { align(center, text(size: 14pt, fill: t.accent, sym.arrow.r)) }))
}
#let writing-lines(n: 14, gap: 8.6mm, counter: 7) = context {
  let t = TH.get()
  grid(columns: (1fr, 9mm), column-gutter: 2mm,
    block(width: 100%, height: n * gap, fill: tiling(size: (10mm, gap), place(line(start: (0pt, gap), end: (10mm, gap), stroke: 0.6pt + t.line)))),
    [#text(size: 6.5pt, fill: t.muted, "Tick each sentence") #v(1mm) #for i in range(counter) { box(width: 6mm, height: 6mm, stroke: 0.8pt + t.line, radius: 50%, align(center + horizon, text(size: 7pt, fill: t.muted, str(i + 1)))); v(1.5mm, weak: true) }])
}
