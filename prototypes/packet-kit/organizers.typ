// Graphic organizers for the packet kit. Each one is a full page and has the same small details, so a
// generated page still looks thought through:
//   - a "use this to …" line (what the organizer is for, in student words)
//   - the language to use, printed where it's used (signal words, question starters, frames)
//   - a faint worked example in the first space, to show the size and kind of answer expected
//   - a "so what?" space at the end, where the organizer turns into a sentence or two
#import "kit.typ": *

// ---------------------------------------------------------------- small shared pieces
#let use-it(body) = context {
  let t = TH.get()
  block(below: 3mm, text(size: 9.5pt, fill: t.muted)[#text(font: t.label-font, weight: "bold", fill: t.accent, "Use this to ") #body])
}
// word chips: signal words, question starters
#let chips(label, words) = context {
  let t = TH.get()
  block(below: 3mm, {
    text(font: t.label-font, size: 8pt, weight: "bold", fill: t.muted, upper(label) + "  ")
    for w in words { box(inset: (x: 6pt, y: 2.5pt), radius: if t.radius > 0pt { 8pt } else { 0pt }, stroke: 0.6pt + t.line, text(size: 8.5pt, w)); h(3pt) }
  })
}
// a faint example: grey italic, so it reads as a model, not an answer to copy
#let eg(body) = context text(size: 8.5pt, fill: TH.get().muted.lighten(25%), style: "italic", [e.g. #body])
// lines inside any box: a block with writing lines as its fill
#let lined(t, height, inset: 6pt, body: none) = block(width: 100%, height: height, fill: surface(t, "lines"), inset: inset, body)
#let so-what(prompt, lines: 3) = context {
  let t = TH.get()
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 9pt, breakable: false, {
    text(font: t.head-font, weight: "bold", fill: t.head, "So what? ")
    text(size: 9.5pt, prompt)
    answer-lines(n: lines, gap: 8mm)
  })
}
// an arrow from one point to another (for webs and flows), with a small head
#let arrow(a, b, stroke) = {
  let (x1, y1) = a
  let (x2, y2) = b
  let ang = calc.atan2((x2 - x1) / 1pt, (y2 - y1) / 1pt)
  let hd = 3.2mm
  place(line(start: a, end: b, stroke: stroke))
  place(polygon(fill: stroke.paint, stroke: none, b,
    (x2 - hd * calc.cos(ang - 25deg), y2 - hd * calc.sin(ang - 25deg)),
    (x2 - hd * calc.cos(ang + 25deg), y2 - hd * calc.sin(ang + 25deg))))
}

// ---------------------------------------------------------------- KWL (with "where I found it")
#let kwl(topic, k-example: [], w-example: [], l-example: [], where-example: []) = context {
  let t = TH.get()
  use-it[sort what you already know from what you find out. Fill in *K* and *W* before you read, *L* after.]
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: (x: 9pt, y: 6pt), below: 3mm,
    [#text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.muted, "TOPIC  ") #text(font: t.head-font, size: 13pt, weight: "bold", fill: t.head, topic)])
  // phase tags over the columns: before reading (K, W) and after reading (L)
  grid(columns: (1fr, 1fr, 1fr, 22mm), column-gutter: 3mm,
    grid.cell(colspan: 2, align(center, box(width: 100%, inset: (y: 2pt), stroke: (bottom: 1.2pt + t.accent), text(font: t.label-font, size: 8pt, weight: "bold", fill: t.accent, "BEFORE READING")))),
    grid.cell(colspan: 2, align(center, box(width: 100%, inset: (y: 2pt), stroke: (bottom: 1.2pt + t.hot), text(font: t.label-font, size: 8pt, weight: "bold", fill: t.hot, "AFTER READING")))))
  v(2mm)
  let col(letter, title, prompt, example, starters: none, narrow: false) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, clip: true, {
    block(width: 100%, inset: (x: 7pt, top: 6pt, bottom: 4pt), fill: if t.section == "band" { t.tint } else { none }, stroke: (bottom: 0.6pt + t.line), {
      if not narrow { place(top + right, dx: 2pt, dy: -8pt, text(font: t.head-font, size: 40pt, weight: "bold", fill: t.faint, letter)) }
      text(font: t.head-font, weight: "bold", size: if narrow { 9pt } else { 12pt }, fill: t.head, title)
      linebreak(); text(size: 8pt, fill: t.muted, prompt)
      if starters != none { v(1mm); text(size: 7.5pt, fill: t.muted, starters) }
    })
    block(width: 100%, height: 1fr, fill: surface(t, "lines"), inset: (x: 7pt, top: 4pt), example)
  })
  block(height: 1fr, grid(columns: (1fr, 1fr, 1fr, 22mm), column-gutter: 3mm, rows: (1fr,),
    col("K", "What I Know", [Facts you are sure of, and things you think are true.], eg(k-example), starters: [I know … · I think … · I remember …]),
    col("W", "What I Wonder", [Questions you want the reading to answer.], eg(w-example), starters: [Who …? · Why did …? · How did …? · What if …?]),
    col("L", "What I Learned", [New facts, and answers to your W questions.], eg(l-example), starters: [I learned … · Now I know … · I was wrong about …]),
    col("", "Where?", [Page and ¶], eg(where-example), narrow: true)))
  v(3mm)
  grid(columns: (1fr, 1fr), column-gutter: 4mm,
    work-space(height: 30mm, style: "lines", label: "One thing that surprised me"),
    work-space(height: 30mm, style: "lines", label: "A question I still have"))
}

// ---------------------------------------------------------------- Venn diagram
#let venn(a, b, a-example: [], both-example: [], b-example: [], prompt: []) = context {
  let t = TH.get()
  use-it[find what two things share and what makes each one different. Write in the right part of the circles.]
  chips("Compare", ([Both … and …], [Unlike …, …], [… but …], [… whereas …], [The same as …]))
  let w = 175mm
  // as big as the text width allows, with a wide overlap for "Both"
  let r = 60mm
  let h = 2 * r + 6mm
  let cx1 = w / 2 - 27mm
  let cx2 = w / 2 + 27mm
  let cy = h / 2
  // each circle: a lined disc (lines line up where they overlap), a light tint, an outline
  let disc(cx, c) = place(dx: cx - r, dy: cy - r, box(width: 2 * r, height: 2 * r, radius: r, clip: true, stroke: 1.4pt + c,
    fill: c.transparentize(93%), block(width: 100%, height: 100%, fill: tiling(size: (10mm, 8.5mm), relative: "parent", place(line(start: (0pt, 8.5mm), end: (10mm, 8.5mm), stroke: 0.5pt + t.line))))))
  box(width: w, height: h, {
    disc(cx1, t.accent)
    disc(cx2, t.hot)
    let label(x, title, c, sub) = place(dx: x - 30mm, dy: cy - r + 16mm, box(width: 60mm, align(center, [#text(font: t.head-font, weight: "bold", size: 12pt, fill: c, title) \ #text(size: 7.5pt, fill: t.muted, sub)])))
    label(cx1 - 22mm, a, t.accent, "only")
    label(cx2 + 22mm, b, t.hot, "only")
    place(dx: w / 2 - 15mm, dy: cy - r + 22mm, box(width: 30mm, align(center, text(font: t.head-font, weight: "bold", size: 11pt, fill: t.head, "Both"))))
    place(dx: cx1 - r + 12mm, dy: cy - 4mm, box(width: 38mm, eg(a-example)))
    place(dx: w / 2 - 14mm, dy: cy - 4mm, box(width: 28mm, eg(both-example)))
    place(dx: cx2 + 8mm, dy: cy - 4mm, box(width: 38mm, eg(b-example)))
  })
  v(1fr)
  so-what(prompt)
}

// ---------------------------------------------------------------- Frayer model (two words per page)
#let frayer(id, word: none) = context {
  let t = TH.get()
  let row = VOCAB.find(r => r.id == id)
  let term = if word != none { word } else if row != none { row.term_en } else { id }
  let zh = if row != none { row.zh } else { "" }
  // labels on the outer side of each box, so the word in the middle never covers them
  let quad(title, prompt, mark, side: left) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, clip: true, {
    block(width: 100%, inset: (x: 7pt, top: 5pt, bottom: 3pt), align(side, [#text(font: t.head-font, weight: "bold", fill: t.head, title) #h(3pt) #text(size: 10pt, fill: t.accent, mark) \ #text(size: 7.5pt, fill: t.muted, prompt)]))
    block(width: 100%, height: 1fr, fill: surface(t, "lines"))
  })
  block(height: 1fr, width: 100%, {
    grid(columns: (1fr, 1fr), rows: (1fr, 1fr), gutter: 4mm,
      quad("Definition", [In your own words, not the dictionary's.], ""),
      quad("Facts and features", [What do you always find with it?], "", side: right),
      quad("Examples", [Real ones: from the reading or your life.], sym.checkmark),
      quad("Non-examples", [Things that look like it, but are not.], sym.crossmark, side: right))
    // the word in the middle, over the four boxes
    place(center + horizon, box(width: 50mm, inset: (x: 8pt, y: 7pt), fill: white, stroke: 1.6pt + t.accent, radius: 30mm,
      align(center, [#text(font: t.head-font, weight: "bold", size: 17pt, fill: t.head, term) \ #text(size: 10pt, fill: t.muted, zh)])))
  })
}

// ---------------------------------------------------------------- causes and effects around one event
#let cause-effect(event, cause-example: [], effect-example: [], prompt: []) = context {
  let t = TH.get()
  use-it[show why something happened (causes) and what happened because of it (effects).]
  chips("Signal words", ([because], [since], [so], [as a result], [this led to], [therefore]))
  let cell(example: none, label: "") = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, clip: true,
    block(width: 100%, height: 100%, fill: surface(t, "lines"), inset: (x: 6pt, top: 4pt), [#text(size: 7.5pt, weight: "bold", fill: t.muted, font: t.label-font, label) #if example != none { linebreak(); example }]))
  let arr = align(center + horizon, text(size: 20pt, fill: t.accent, sym.arrow.r))
  block(height: 1fr, grid(columns: (1fr, 8mm, 30mm, 8mm, 1fr), rows: (auto, 1fr, 1fr, 1fr), row-gutter: 4mm,
    align(center, text(font: t.head-font, weight: "bold", fill: t.head, "Causes")), [], align(center, text(font: t.head-font, weight: "bold", fill: t.head, "Event")), [], align(center, text(font: t.head-font, weight: "bold", fill: t.head, "Effects")),
    cell(label: "CAUSE 1", example: eg(cause-example)), arr,
    grid.cell(rowspan: 3, block(width: 100%, height: 100%, fill: t.tint, stroke: 1.6pt + t.head, radius: t.radius, inset: 5pt,
      align(center + horizon, text(font: t.head-font, weight: "bold", size: 11pt, fill: t.head, hyphenate: false, event)))),
    arr, cell(label: "EFFECT 1", example: eg(effect-example)),
    cell(label: "CAUSE 2"), arr, arr, cell(label: "EFFECT 2"),
    cell(label: "CAUSE 3"), arr, arr, cell(label: "EFFECT 3")))
  v(3mm)
  so-what(prompt)
}

// ---------------------------------------------------------------- a process, as a snake of numbered steps
#let flow(steps: 6, example: [], prompt: []) = context {
  let t = TH.get()
  use-it[put the steps of a process in order. Draw a small picture of each step, then write what happens.]
  chips("Order words", ([First,], [Next,], [Then,], [After that,], [Finally,]))
  let step(n, ex) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, inset: 6pt, clip: true, {
    grid(columns: (auto, 1fr), column-gutter: 5pt, badge(t, str(n), size: 1.6em),
      box(width: 100%, height: 27mm, stroke: (paint: t.line, thickness: 0.6pt, dash: "dotted"), radius: calc.min(t.radius, 4pt), align(center + horizon, text(size: 7pt, fill: t.faint, "draw"))))
    v(1mm)
    block(width: 100%, height: 1fr, fill: surface(t, "lines"), if ex != none { eg(ex) })
  })
  let r = sym.arrow.r
  let l = sym.arrow.l
  let a(s) = align(center + horizon, text(size: 18pt, fill: t.accent, s))
  let per = calc.ceil(steps / 2)
  block(height: 1fr, grid(columns: (1fr, 7mm, 1fr, 7mm, 1fr), rows: (1fr, 9mm, 1fr),
    step(1, example), a(r), step(2, none), a(r), step(3, none),
    [], [], [], [], a(sym.arrow.b),
    step(6, none), a(l), step(5, none), a(l), step(4, none)))
  v(3mm)
  so-what(prompt, lines: 2)
}

// ---------------------------------------------------------------- a concept web
#let web(topic, branches, example: none) = context {
  let t = TH.get()
  use-it[collect everything you know about one topic, in groups. Add small bubbles for details.]
  let w = 175mm
  let h = 200mm
  let c = (w / 2, h / 2)
  let R = 20mm
  let r = 15mm
  let st = 1pt + t.line
  box(width: w, height: h, {
    for (i, label) in branches.enumerate() {
      let ang = 30deg + i * 60deg
      let (dx, dy) = (68mm * calc.cos(ang), 66mm * calc.sin(ang))
      let p = (c.at(0) + dx, c.at(1) + dy)
      let d = calc.sqrt((dx / 1mm) * (dx / 1mm) + (dy / 1mm) * (dy / 1mm)) * 1mm
      let ux = dx / d
      let uy = dy / d
      place(line(start: (c.at(0) + ux * R, c.at(1) + uy * R), end: (p.at(0) - ux * r, p.at(1) - uy * r), stroke: 1.4pt + t.accent))
      // two detail bubbles further out
      for off in (-28deg, 28deg) {
        let a2 = ang + off
        let q = (p.at(0) + 27mm * calc.cos(a2), p.at(1) + 27mm * calc.sin(a2))
        place(line(start: (p.at(0) + r * calc.cos(a2), p.at(1) + r * calc.sin(a2)), end: (q.at(0) - 9mm * calc.cos(a2), q.at(1) - 9mm * calc.sin(a2)), stroke: (paint: t.line, thickness: 0.8pt, dash: "dotted")))
        place(dx: q.at(0) - 9mm, dy: q.at(1) - 9mm, circle(radius: 9mm, stroke: 0.8pt + t.line))
      }
      place(dx: p.at(0) - r, dy: p.at(1) - r, circle(radius: r, stroke: 1.2pt + t.accent, fill: white,
        align(center + horizon, box(width: 2 * r - 6pt, [#text(font: t.label-font, size: 7.5pt, weight: "bold", fill: t.accent, upper(label)) #if i == 0 and example != none { linebreak(); eg(example) }]))))
    }
    place(dx: c.at(0) - R, dy: c.at(1) - R, circle(radius: R, fill: t.tint, stroke: 2pt + t.head,
      align(center + horizon, box(width: 2 * R - 8pt, align(center, text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, topic))))))
  })
}

// ---------------------------------------------------------------- main idea and details, as a temple
// The roof (pediment) holds the main idea, each column a detail that holds it up, the base the conclusion.
#let temple(main-example: [], detail-example: [], cols: 3) = context {
  let t = TH.get()
  use-it[find the main idea of a text and the details that hold it up, like columns holding up a roof.]
  let w = 175mm
  block(width: w, height: 1fr, {
    // the roof
    let rh = 42mm
    place(polygon(fill: t.tint, stroke: 1.6pt + t.head, (0mm, rh), (w / 2, 0mm), (w, rh)))
    place(dx: w / 2 - 50mm, dy: 15mm, box(width: 100mm, {
      align(center, text(font: t.head-font, weight: "bold", fill: t.head, "Main idea"))
      v(1mm); line(length: 100%, stroke: 0.6pt + t.line); v(6mm); line(length: 100%, stroke: 0.6pt + t.line)
    }))
    place(dx: w / 2 - 50mm, dy: 23mm, box(width: 100mm, align(center, eg(main-example))))
    // the entablature (a band under the roof)
    place(dy: rh + 1mm, rect(width: w, height: 5mm, fill: none, stroke: 1.2pt + t.head))
    // the columns
    let top = rh + 9mm
    let colh = 112mm
    let cw = (w - 12mm) / cols - 6mm
    for i in range(cols) {
      let x = 6mm + i * (cw + 6mm) + 3mm
      place(dx: x - 2mm, dy: top, rect(width: cw + 4mm, height: 4mm, stroke: 1pt + t.head))   // capital
      place(dx: x, dy: top + 4mm, block(width: cw, height: colh, stroke: (left: 1.2pt + t.head, right: 1.2pt + t.head), fill: surface(t, "lines"), inset: (x: 6pt, top: 4pt), {
        text(font: t.label-font, size: 8pt, weight: "bold", fill: t.accent, "DETAIL " + str(i + 1))
        if i == 0 { linebreak(); eg(detail-example) }
        // fluting: two thin lines down each side
        place(left, dx: -4pt, line(length: colh - 8pt, angle: 90deg, stroke: 0.4pt + t.line))
        place(right, dx: 4pt, line(length: colh - 8pt, angle: 90deg, stroke: 0.4pt + t.line))
      }))
      place(dx: x - 2mm, dy: top + 4mm + colh, rect(width: cw + 4mm, height: 4mm, stroke: 1pt + t.head))   // base of the column
    }
    // the base (steps) holds the conclusion
    let by = top + colh + 10mm
    place(dy: by, block(width: w, height: 30mm, stroke: 1.6pt + t.head, fill: surface(t, "lines"), inset: (x: 8pt, top: 5pt),
      [#text(font: t.head-font, weight: "bold", fill: t.head, "So what?") #h(4pt) #text(size: 8.5pt, fill: t.muted, "Put the main idea and details together in one or two sentences.")]))
    place(dx: 4mm, dy: by + 30mm, rect(width: w - 8mm, height: 3mm, stroke: 1pt + t.head))
  })
}

// ---------------------------------------------------------------- landscape organizers: instructions down the side
// A landscape page (turned on a portrait page) with a narrow column on the left for the title, what to do,
// the language and the "So what?", and the rest of the page for the organizer itself.
#let LW = 255mm   // the landscape page's usable width and height (see kit.landscape)
#let LH = 175mm
#let SIDE = 62mm
#let side-page(title, sub, side, main) = landscape(context {
  let t = TH.get()
  set align(left + top)   // (landscape() centres the turned page; its content reads from the top left)
  [#metadata(title) <section-title>]
  grid(columns: (SIDE, 1fr), column-gutter: 7mm, rows: (LH,),
    block(width: 100%, height: 100%, stroke: (right: 0.6pt + t.line), inset: (right: 6mm), {
      text(font: t.head-font, weight: "bold", size: 17pt, fill: t.head, title)
      if sub != none { linebreak(); text(size: 9pt, fill: t.muted, sub) }
      v(-2pt); rule(t); v(3mm)
      side
    }),
    block(width: 100%, height: 100%, main))
})
#let side-chips(label, words) = context {
  let t = TH.get()
  text(font: t.label-font, size: 8pt, weight: "bold", fill: t.muted, upper(label))
  v(1mm)
  for w in words { box(inset: (x: 6pt, y: 2.5pt), radius: if t.radius > 0pt { 8pt } else { 0pt }, stroke: 0.6pt + t.line, text(size: 8.5pt, w)); h(3pt); v(1.5mm, weak: true) }
  v(3mm)
}

#let kwl-landscape(title, topic, k-example: [], w-example: [], l-example: [], where-example: []) = side-page(title, [Before and after you read], context {
  let t = TH.get()
  use-it[sort what you already know from what you find out.]
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 7pt, below: 3mm,
    [#text(font: t.label-font, size: 8pt, weight: "bold", fill: t.muted, "TOPIC") \ #text(font: t.head-font, size: 12pt, weight: "bold", fill: t.head, topic)])
  text(size: 9pt)[*1.* Before you read: fill in *K* and *W*. \ *2.* After you read: fill in *L*, and write *where* you found it.]
  v(3mm)
  work-space(height: 1fr, style: "lines", label: "One thing that surprised me")
  work-space(height: 1fr, style: "lines", label: "A question I still have")
}, context {
  let t = TH.get()
  let col(letter, title, prompt, example, starters: none, narrow: false, phase: none, pc: none) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, clip: true, {
    if phase != none { block(width: 100%, inset: (y: 2.5pt), fill: pc.transparentize(85%), align(center, text(font: t.label-font, size: 7pt, weight: "bold", fill: pc, phase))) }
    block(width: 100%, inset: (x: 7pt, top: 5pt, bottom: 4pt), stroke: (bottom: 0.6pt + t.line), {
      if not narrow { place(top + right, dx: 2pt, dy: -6pt, text(font: t.head-font, size: 44pt, weight: "bold", fill: t.faint, letter)) }
      text(font: t.head-font, weight: "bold", size: if narrow { 9pt } else { 13pt }, fill: t.head, title)
      linebreak(); text(size: 8pt, fill: t.muted, prompt)
      if starters != none { v(1mm); text(size: 7.5pt, fill: t.muted, starters) }
    })
    block(width: 100%, height: 1fr, fill: surface(t, "lines"), inset: (x: 7pt, top: 4pt), example)
  })
  grid(columns: (1fr, 1fr, 1fr, 22mm), column-gutter: 3mm, rows: (LH,),
    col("K", "What I Know", [Facts you are sure of, and things you think are true.], eg(k-example), starters: [I know … · I think … · I remember …], phase: "BEFORE READING", pc: t.accent),
    col("W", "What I Wonder", [Questions you want the reading to answer.], eg(w-example), starters: [Who …? · Why did …? · How did …? · What if …?], phase: "BEFORE READING", pc: t.accent),
    col("L", "What I Learned", [New facts, and answers to your W questions.], eg(l-example), starters: [I learned … · Now I know … · I was wrong about …], phase: "AFTER READING", pc: t.hot),
    col("", "Where?", [Page and ¶], eg(where-example), narrow: true, phase: "AFTER", pc: t.hot))
})

#let venn-landscape(title, a, b, a-example: [], both-example: [], b-example: [], prompt: []) = side-page(title, none, context {
  let t = TH.get()
  use-it[find what two things share, and what makes each one different.]
  text(size: 9pt)[Write facts in the right part of the circles: only #text(fill: t.accent, weight: "bold", a), *both*, or only #text(fill: t.hot, weight: "bold", b).]
  v(3mm)
  side-chips("Compare", ([Both … and …], [Unlike …, …], [… but …], [… whereas …], [The same as …]))
  v(1fr)
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 7pt, {
    text(font: t.head-font, weight: "bold", fill: t.head, "So what? "); text(size: 8.5pt, prompt)
    answer-lines(n: 5, gap: 8mm)
  })
}, context {
  let t = TH.get()
  let w = LW - SIDE - 7mm
  let r = 74mm
  let cx1 = w / 2 - 25mm
  let cx2 = w / 2 + 25mm
  let cy = LH / 2
  let disc(cx, c) = place(dx: cx - r, dy: cy - r, box(width: 2 * r, height: 2 * r, radius: r, clip: true, stroke: 1.6pt + c,
    fill: c.transparentize(93%), block(width: 100%, height: 100%, fill: tiling(size: (10mm, 8.5mm), relative: "parent", place(line(start: (0pt, 8.5mm), end: (10mm, 8.5mm), stroke: 0.5pt + t.line))))))
  box(width: w, height: LH, {
    disc(cx1, t.accent)
    disc(cx2, t.hot)
    let label(x, title, c) = place(dx: x - 30mm, dy: cy - r + 16mm, box(width: 60mm, align(center, [#text(font: t.head-font, weight: "bold", size: 14pt, fill: c, title) \ #text(size: 7.5pt, fill: t.muted, "only")])))
    label(cx1 - 26mm, a, t.accent)
    label(cx2 + 26mm, b, t.hot)
    place(dx: w / 2 - 15mm, dy: cy - r + 30mm, box(width: 30mm, align(center, text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, "Both"))))
    place(dx: cx1 - r + 14mm, dy: cy - 2mm, box(width: 40mm, eg(a-example)))
    place(dx: w / 2 - 15mm, dy: cy - 2mm, box(width: 30mm, eg(both-example)))
    place(dx: cx2 + 12mm, dy: cy - 2mm, box(width: 40mm, eg(b-example)))
  })
})
