// Chalkline packet kit (a prototype): print themes and page pieces for packets.
// Typst only, no Quarto, so it's quick to try: see README.md. Everything reads the theme, like the slide tokens.

// ---------------------------------------------------------------- themes
// Print-safe: white paper, colour only in lines, small marks and very light tints (they turn pale grey on a
// black-and-white copier and still read). No big filled areas.
#let themes = (
  sky: (
    name: "Sky",
    ink: rgb("#1f2933"), muted: rgb("#52606d"), head: rgb("#003477"), accent: rgb("#0087ff"), hot: rgb("#ff8c0f"),
    tint: rgb("#f1f8fd"), line: rgb("#a9cbe6"), faint: rgb("#cfe2f1"),
    head-font: ("Poppins", "Noto Sans SC"), body-font: ("Source Sans 3", "Noto Sans SC"), label-font: ("Poppins", "Noto Sans SC"),
    radius: 9pt, box-stroke: 0.9pt + rgb("#a9cbe6"), section: "band", badge: "circle", rule: "soft",
  ),
  trail: (
    name: "Trail",
    ink: rgb("#3a322b"), muted: rgb("#6b5f52"), head: rgb("#4b3324"), accent: rgb("#8a7d4f"), hot: rgb("#2f8f88"),
    tint: rgb("#f8f4ee"), line: rgb("#bfae93"), faint: rgb("#e2d8c8"),
    head-font: ("Libertinus Serif", "Noto Sans SC"), body-font: ("Source Sans 3", "Noto Sans SC"), label-font: ("Libertinus Serif", "Noto Sans SC"),
    radius: 3pt, box-stroke: (paint: rgb("#8a7d4f"), thickness: 0.9pt, dash: "dashed"), section: "stitch", badge: "square", rule: "zigzag",
  ),
  blueprint: (
    name: "Blueprint",
    ink: rgb("#14213d"), muted: rgb("#4a5b78"), head: rgb("#0b1f4d"), accent: rgb("#1f5fbf"), hot: rgb("#e07a10"),
    tint: rgb("#f3f6fb"), line: rgb("#9db4d6"), faint: rgb("#d5e0f0"),
    head-font: ("Poppins", "Noto Sans SC"), body-font: ("Source Sans 3", "Noto Sans SC"), label-font: ("DejaVu Sans Mono", "Noto Sans SC"),
    radius: 0pt, box-stroke: 0.8pt + rgb("#0b1f4d"), section: "bar", badge: "mono", rule: "double",
  ),
)
#let TH = state("chalkline-theme", themes.sky)
#let SECTION = state("chalkline-section", "")
#let PAGE = (w: 210mm, h: 297mm, inside: 20mm, outside: 15mm, top: 19mm, bottom: 17mm)
// booklet (folded and stapled: spreads on facing pages, padded to a multiple of 4) or loose sheets
// (printed double-sided, stapled in the corner: no facing pages, so no blank pages and no padding)
#let BOOKLET = sys.inputs.at("booklet", default: "true") != "false"
#let PAGE = if BOOKLET { PAGE } else { (..PAGE, inside: 17.5mm, outside: 17.5mm) }

// ---------------------------------------------------------------- small pieces
#let badge(t, body, size: 1.6em) = {
  let c = text(font: t.label-font, weight: "bold", fill: if t.badge == "mono" { t.head } else { white }, size: 0.85em, body)
  if t.badge == "circle" { box(baseline: 25%, circle(radius: size / 2, fill: t.accent, stroke: none, align(center + horizon, c))) }
  else if t.badge == "square" { box(baseline: 25%, rect(width: size, height: size, radius: 2pt, fill: t.head, align(center + horizon, c))) }
  else { box(baseline: 20%, rect(width: size, height: size, stroke: 1pt + t.head, align(center + horizon, c))) }
}

// a rule under titles: soft (rounded), zigzag (stitched), double (drafting)
#let rule(t, width: 100%) = {
  if t.rule == "soft" { box(width: width, height: 3pt, radius: 2pt, fill: t.accent.lighten(55%)) }
  else if t.rule == "zigzag" {
    box(width: width, height: 5pt, fill: tiling(size: (8pt, 5pt), curve(stroke: 0.9pt + t.accent, curve.move((0pt, 4.5pt)), curve.line((4pt, 0.5pt)), curve.line((8pt, 4.5pt)))))
  } else { stack(spacing: 1.5pt, line(length: width, stroke: 1.1pt + t.head), line(length: width, stroke: 0.4pt + t.head)) }
}

// writing and drawing surfaces, as fills: lines, squares, dots, or nothing
#let surface(t, style) = {
  if style == "lines" { tiling(size: (10mm, 8.5mm), place(line(start: (0pt, 8.5mm), end: (10mm, 8.5mm), stroke: 0.5pt + t.line))) }
  else if style == "grid" { tiling(size: (5mm, 5mm), rect(width: 5mm, height: 5mm, stroke: (top: 0.35pt + t.faint, left: 0.35pt + t.faint))) }
  else if style == "dots" { tiling(size: (5mm, 5mm), place(dx: -0.4pt, dy: -0.4pt, circle(radius: 0.55pt, fill: t.line))) }
  else { none }
}

// A space to write or draw. width: "full" or "half"; height: a length, or auto to fill the rest of the page.
#let work-space(width: "full", height: auto, style: "blank", label: none) = context {
  let t = TH.get()
  let w = if width == "half" { 100% } else { 100% }
  block(width: w, height: if height == auto { 1fr } else { height }, breakable: false, above: 0.6em, below: 0.6em,
    radius: t.radius, stroke: t.box-stroke, clip: true, inset: 0pt, {
      if style != "blank" { place(block(width: 100%, height: 100%, fill: surface(t, style))) }
      if label != none { place(top + left, dx: 6pt, dy: 5pt, box(fill: white, inset: (x: 3pt, y: 1pt), text(size: 8.5pt, fill: t.muted, font: t.label-font, label))) }
    })
}

#let answer-lines(n: 2, gap: 8.5mm) = context {
  let t = TH.get()
  for i in range(n) { v(gap - 1pt); line(length: 100%, stroke: 0.6pt + t.line) }
}

#let name-row() = context {
  let t = TH.get()
  let field(label, w) = box(width: w)[#text(size: 9pt, fill: t.muted, font: t.label-font, label) #box(width: 1fr, line(length: 100%, stroke: 0.6pt + t.muted))]
  grid(columns: (1fr, 0.45fr, 0.45fr), column-gutter: 8mm, field("Name", 100%), field("Class", 100%), field("Date", 100%))
}

// Section heading: a letter, a title, the instructions.
#let section(letter, title, instructions: none) = { [#metadata(title) <section-title>]; context {
  let t = TH.get()
  let head = [#badge(t, letter) #h(4pt) #text(font: t.head-font, weight: "bold", size: 13pt, fill: t.head, title)]
  let inner = [#head #if instructions != none { linebreak(); text(size: 9.5pt, fill: t.muted, instructions) }]
  v(2mm, weak: true)
  if t.section == "band" { block(width: 100%, fill: t.tint, radius: t.radius, inset: (x: 8pt, y: 6pt), inner) }
  else if t.section == "stitch" { block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: (x: 8pt, y: 6pt), inner) }
  else { block(width: 100%, stroke: (left: 3pt + t.head, bottom: 0.5pt + t.line), inset: (left: 8pt, y: 5pt), inner) }
  v(1mm)
} }

#let titled(title, sub: none) = { [#metadata(title) <section-title>]; context {
  let t = TH.get()
  text(font: t.head-font, weight: "bold", size: 20pt, fill: t.head, title)
  if sub != none { linebreak(); text(size: 10.5pt, fill: t.muted, sub) }
  v(-2pt); rule(t); v(2mm)
} }

// a box for a task or a prompt
#let panel(title: none, body) = context {
  let t = TH.get()
  block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 9pt, breakable: false, {
    if title != none { text(font: t.head-font, weight: "bold", fill: t.head, title); h(4pt) }
    body
  })
}

// ---------------------------------------------------------------- margin glosses
// gloss("aqueduct", "a bridge that carries water", zh: "渡槽"): the word in bold, its meaning in the outer
// margin, level with the line. Notes that would overlap are pushed down.
#let GLOSS = state("gloss-last", (page: 0, y: 0pt))
#let OUTSIDE = state("chalkline-outside", PAGE.outside)   // the outer margin now (wider on a glossed reading)
#let gloss(word, meaning, zh: none) = context {
  let t = TH.get()
  let note = block(width: 36mm, text(size: 8pt, fill: t.ink, [#text(weight: "bold", fill: t.head, word) #h(2pt) #meaning #if zh != none [#linebreak()#text(fill: t.muted, zh)]]))
  let p = here().position()
  let odd = calc.odd(p.page)
  let out = OUTSIDE.get()
  let x = if odd { PAGE.w - out + 6mm } else { out - 6mm - 40mm }
  let last = GLOSS.get()
  let y = if last.page == p.page { calc.max(p.y - 2pt, last.y + 3pt) } else { p.y - 2pt }
  let hgt = measure(note).height
  box(width: 0pt, place(top + left, dx: x - p.x, dy: y - p.y, {
    block(stroke: (if odd { (left: 1.5pt + t.accent) } else { (right: 1.5pt + t.accent) }), inset: (x: 5pt, y: 2pt), note)
  }))
  GLOSS.update((page: p.page, y: y + hgt + 6pt))
  text(weight: "bold", fill: t.head, word)
}

// ---------------------------------------------------------------- spreads and booklets
#let notes-page() = context {
  let t = TH.get()
  text(font: t.head-font, weight: "bold", size: 14pt, fill: t.head, "Notes")
  v(1mm)
  work-space(style: "lines")
}
// Start a two-page spread: the next page is a left-hand (even) page. Typst adds the blank page when one is
// needed (pagebreak(to: "even"): no extra layout passes). Markers either side of the break show which page
// was added, and the page background draws Notes lines on it (see notes-background), which can't move anything.
#let spread-start() = if BOOKLET { [#metadata("pre-spread") <pre-spread>#pagebreak(to: "even")#metadata("spread") <spread>] } else { pagebreak(weak: true) }
#let notes-background(t) = context {
  let p = here().page()
  let pres = query(<pre-spread>).map(m => m.location().page())
  let posts = query(<spread>).map(m => m.location().page())
  let added = pres.zip(posts).any(((a, b)) => b - a == 2 and p == a + 1)
  if not added { return }
  let left = if calc.odd(p) { PAGE.inside } else { PAGE.outside }
  place(dx: left, dy: PAGE.top + 4mm, block(width: PAGE.w - PAGE.inside - PAGE.outside, height: PAGE.h - PAGE.top - PAGE.bottom - 8mm, {
    text(font: t.head-font, weight: "bold", size: 14pt, fill: t.head, "Notes")
    v(2mm)
    block(width: 100%, height: 1fr, radius: t.radius, stroke: t.box-stroke, fill: surface(t, "lines"))
  }))
}
// Pad the end with Notes pages so the page count is a multiple of 4 (a folded, stapled booklet).
#let finish-booklet() = if not BOOKLET { none } else [#metadata("content-end") <content-end>#context {
  let n = locate(<content-end>).page()   // where the content ends: a marker the padding can't move
  let pad = calc.rem(4 - calc.rem(n, 4), 4)
  for i in range(pad) { pagebreak(); notes-page() }
}]

// ---------------------------------------------------------------- the packet
#let packet(theme: "sky", title: "", unit: "", body) = {
  let t = themes.at(theme)
  TH.update(t)
  set page(paper: "a4", binding: left, background: notes-background(t), margin: (inside: PAGE.inside, outside: PAGE.outside, top: PAGE.top, bottom: PAGE.bottom),
    header: context {
      let n = here().page()
      if n == 1 { return }
      let odd = calc.odd(n)
      set text(size: 8pt, fill: t.muted, font: t.label-font)
      let name = if t.badge == "mono" { upper(title) } else { title }
      let titles = query(<section-title>)
      let here-titles = titles.filter(m => m.location().page() == n)
      let before = titles.filter(m => m.location().page() < n)
      let sec = if here-titles.len() > 0 { here-titles.first().value } else if before.len() > 0 { before.last().value } else { "" }
      grid(columns: (1fr, 1fr), align(left)[#if not odd { name } else { unit }], align(right)[#if odd { sec } else { "" }])
      v(-6pt)
      if t.rule == "zigzag" { line(length: 100%, stroke: (paint: t.line, thickness: 0.6pt, dash: "dashed")) }
      else if t.rule == "double" { line(length: 100%, stroke: 0.4pt + t.head) }
      else { line(length: 100%, stroke: 0.6pt + t.faint) }
    },
    footer: context {
      let n = here().page()
      if n == 1 { return }
      let num = if t.badge == "mono" { text(font: t.label-font, size: 8pt, fill: t.head, "P." + str(n)) }
        else if t.badge == "square" { box(stroke: t.box-stroke, inset: (x: 5pt, y: 3pt), radius: 2pt, text(size: 8.5pt, fill: t.head, str(n))) }
        else { box(fill: t.tint, inset: (x: 7pt, y: 3pt), radius: 8pt, text(size: 8.5pt, weight: "bold", fill: t.head, str(n))) }
      align(if calc.odd(n) { right } else { left }, num)
    })
  set text(font: t.body-font, size: 10.5pt, fill: t.ink, lang: "en")
  set par(leading: 0.6em, spacing: 0.9em)
  set table(stroke: 0.6pt + t.line)
  body
}

#let cover(title, sub, contents) = context {
  let t = TH.get()
  v(18mm)
  text(font: t.label-font, size: 10pt, fill: t.accent, tracking: 1.5pt, upper("Chalkline · mini packet"))
  v(2mm)
  text(font: t.head-font, size: 34pt, weight: "bold", fill: t.head, title)
  v(-4pt); rule(t, width: 60%); v(3mm)
  text(size: 13pt, fill: t.muted, sub)
  v(10mm)
  name-row()
  v(12mm)
  panel(title: "In this packet")[
    #set text(size: 10.5pt)
    #grid(columns: (auto, 1fr, auto), row-gutter: 6pt, column-gutter: 8pt, ..contents.map(c => (badge(t, c.at(0), size: 1.4em), c.at(1), text(fill: t.muted, c.at(2)))).flatten())
  ]
  v(1fr)
  // a light theme mark at the foot of the cover: clouds, stitches or a drafting grid; little ink either way
  if t.section == "band" {
    box(width: 100%, height: 40mm, { for (x, y, r) in ((10%, 20mm, 14mm), (22%, 12mm, 18mm), (36%, 22mm, 12mm), (70%, 16mm, 16mm), (83%, 24mm, 11mm)) { place(dx: x, dy: y, circle(radius: r, stroke: 1pt + t.faint)) } })
  } else if t.section == "stitch" {
    box(width: 100%, height: 40mm, stroke: t.box-stroke, radius: 4pt, inset: 10pt, align(center + horizon, text(font: t.head-font, size: 12pt, fill: t.muted, style: "italic", "Field notes · keep this packet with your book")))
  } else {
    box(width: 100%, height: 40mm, fill: surface(t, "grid"), stroke: 0.6pt + t.head, inset: 8pt, align(bottom + right, text(font: t.label-font, size: 8pt, fill: t.head, "SHEET 01 · SCALE 1:1")))
  }
}

// ---------------------------------------------------------------- page layouts

// Problems in 2 or 3 columns, each cell tall: the problem at the top, room to work, the answer at the bottom.
// The grid fills the rest of the page, so the cells are as tall as the page allows.
#let problems(cols: 2, items: (), surface-style: "grid", answer: "x =") = context {
  let t = TH.get()
  let rows = calc.ceil(items.len() / cols)
  let cell(i, q) = block(width: 100%, height: 100%, radius: t.radius, stroke: t.box-stroke, clip: true, inset: 0pt, {
    place(block(width: 100%, height: 100%, fill: surface(t, surface-style)))
    place(top + left, dx: 7pt, dy: 7pt, box(fill: white, inset: (right: 6pt, bottom: 3pt), [#badge(t, str(i + 1), size: 1.5em) #h(3pt) #text(size: 12.5pt, weight: "bold", q)]))
    place(bottom + right, dx: -7pt, dy: -7pt, box(fill: white, inset: 4pt, stroke: 0.6pt + t.line, radius: calc.min(t.radius, 4pt),
      [#text(size: 10pt, fill: t.muted, answer) #box(width: 18mm, height: 1em)]))
  })
  block(width: 100%, height: 1fr, grid(columns: (1fr,) * cols, rows: (1fr,) * rows, gutter: 5mm,
    ..items.enumerate().map(((i, q)) => cell(i, q))))
}

// A vocab hunt: Where | Clue | Word, in two tables side by side. Each entry: (where, part, clue) with
// part the word part in bold (a prefix or suffix) or none. The Word column is wide enough to write in.
#let vocab-hunt(entries, row: 12.5mm) = context {
  let t = TH.get()
  let half = calc.ceil(entries.len() / 2)
  let tbl(es) = table(columns: (11mm, 1fr, 0.8fr), rows: (auto,) + (row,) * es.len(), inset: (x: 5pt, y: 4pt),
    align: (center + horizon, left + horizon, left + horizon), fill: (_, y) => if y == 0 { t.tint } else { none },
    table.header(..("Where", "Clue", "Word").map(h => text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, h))),
    ..es.map(e => (text(size: 9pt, fill: t.muted, e.at(0)), text(size: 9.5pt)[#if e.at(1) != none [*#e.at(1)* #h(2pt)]#e.at(2)], [])).flatten())
  grid(columns: (1fr, 1fr), column-gutter: 5mm, tbl(entries.slice(0, half)), tbl(entries.slice(half)))
}

// Questions answered in full sentences: two lines each, so there's room for one.
#let recall(questions, lines: 2) = context {
  let t = TH.get()
  for (i, q) in questions.enumerate() {
    block(breakable: false, below: 4mm)[#text(weight: "bold", fill: t.head, str(i + 1) + ".") #h(3pt) #q #answer-lines(n: lines)]
  }
}

// Put events in order: a box to write the number, then the event.
#let sequence(events) = context {
  let t = TH.get()
  table(columns: (17mm, 1fr), rows: (auto,) + (10mm,) * events.len(), inset: (x: 7pt, y: 4pt), align: (center + horizon, left + horizon),
    fill: (_, y) => if y == 0 { t.tint } else { none },
    table.header(text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, "Order"), text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, "Event")),
    ..events.map(e => (box(width: 9mm, height: 7mm, stroke: 0.8pt + t.line, radius: calc.min(t.radius, 3pt)), e)).flatten())
}

// A reading in two columns across the top; the lower half split: `beside` on the left (a picture, a word
// box, key facts), the questions in a box on the right. A fixed layout, so the box is always in the lower
// right; the passage must fit the top (about 450 words at this size).
#let reading-page(passage, questions, beside: none, lower: 112mm, title: "Questions") = context {
  let t = TH.get()
  block(width: 100%, height: 1fr, columns(2, gutter: 7mm, { set par(justify: true); passage }))
  grid(columns: (1fr, 1fr), column-gutter: 7mm, rows: lower,
    block(width: 100%, height: 100%, beside),
    block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, inset: 9pt, fill: if t.section == "band" { t.tint } else { none }, {
      text(font: t.head-font, weight: "bold", fill: t.head, title)
      v(1mm)
      set text(size: 9.5pt)
      for (i, q) in questions.enumerate() { block(below: 2.5mm)[*#(i + 1).* #q #answer-lines(n: 2, gap: 7mm)] }
    }))
}

// ---------------------------------------------------------------- drawings for reference cards
#let angle-pic(deg, t, size: 22mm, label: none, reflex: false) = {
  let r = size * 0.42
  let o = (size * 0.22, size * 0.72)
  let a = deg * 1deg
  let end = (o.at(0) + r * 1.5 * calc.cos(a), o.at(1) - r * 1.5 * calc.sin(a))
  let n = 24
  let from = if reflex { a } else { 0deg }
  let to = if reflex { 360deg } else { a }
  let pts = range(n + 1).map(i => { let x = from + (to - from) * i / n; (o.at(0) + r * 0.45 * calc.cos(x), o.at(1) - r * 0.45 * calc.sin(x)) })
  box(width: size * 1.1, height: size, {
    place(curve(stroke: 1pt + t.accent, curve.move(pts.first()), ..pts.slice(1).map(p => curve.line(p))))
    place(line(start: o, end: (o.at(0) + r * 1.6, o.at(1)), stroke: 1.4pt + t.head))
    if deg != 0 and deg != 360 { place(line(start: o, end: end, stroke: 1.4pt + t.head)) }
    place(dx: o.at(0) - 1.5pt, dy: o.at(1) - 1.5pt, circle(radius: 1.5pt, fill: t.head))
    if deg == 90 { place(dx: o.at(0), dy: o.at(1) - 3mm, rect(width: 3mm, height: 3mm, stroke: 0.8pt + t.accent)) }
  })
}

// ---------------------------------------------------------------- the timeline across a spread
// Years as numbers (negative = BC). One page draws [from, to] of the line; the two pages meet at the spine.
#let year(y) = if y < 0 { str(-y) + " BC" } else if y == 0 { "AD 1" } else { "AD " + str(y) }
#let timeline-part(from, to, height: 62mm, step: 100, first: true) = context {
  let t = TH.get()
  let span = to - from
  let at(y) = (y - from) / span * 100%
  block(width: 100%, height: height, breakable: false, {
    // the writing band above the line: faint guides every half-step
    let guides = range(from, to + 1, step: calc.quo(step, 2))
    for g in guides { place(dx: at(g), dy: 0mm, line(length: height - 16mm, angle: 90deg, stroke: (paint: t.faint, thickness: 0.5pt, dash: "dotted"))) }
    place(dy: height - 16mm, line(length: 100%, stroke: 2.2pt + t.head))
    if not first { place(dx: -3mm, dy: height - 16mm - 3.5pt, text(size: 9pt, fill: t.head, sym.arrow.l.long)) }
    else { place(dx: 100% - 3mm, dy: height - 16mm - 3.5pt, text(size: 9pt, fill: t.head, sym.arrow.r)) }
    for y in range(from, to + 1, step: step) {
      place(dx: at(y) - 0.6pt, dy: height - 19mm, line(length: 6mm, angle: 90deg, stroke: 1.2pt + t.head))
      place(dx: at(y) - 12mm, dy: height - 12mm, box(width: 24mm, align(center, text(font: t.label-font, size: 8pt, fill: t.ink, year(y)))))
    }
    for y in range(from + calc.quo(step, 2), to, step: step) { place(dx: at(y) - 0.4pt, dy: height - 17.5mm, line(length: 3mm, angle: 90deg, stroke: 0.8pt + t.head)) }
  })
}

#let event-card(letter, body, pic: none) = context {
  let t = TH.get()
  block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, inset: 6pt, breakable: false, {
    grid(columns: (auto, 1fr), column-gutter: 5pt, badge(t, letter, size: 1.5em), text(size: 9pt, body))
    if pic != none { v(1fr); box(width: 100%, height: 17mm, clip: true, radius: calc.min(t.radius, 4pt), image(pic, width: 100%, height: 17mm, fit: "cover")) }
  })
}

// ---------------------------------------------------------------- a feature spread (magazine style)
// A panorama across both pages (over the spine), a standfirst, two columns of text flowing from the left page
// to the right, pictures and a pull quote set in the columns, and a box across the foot of both pages, cut by
// the spine, with a badge sitting on it. The panorama and the box are drawn as page backgrounds in space the
// text is kept out of (big top and bottom margins), so the two halves always line up and can't move the text.
#let FEAT = (edge: 12mm, pano-h: 72mm, top: 92mm, bottom: 82mm, box-top: 222mm, box-h: 60mm)
#let feature-bg(t, panorama, left-box, right-box, badge-text, credit) = context {
  let p = here().page()
  let left-page = calc.even(p)
  let full = 2 * PAGE.w - 2 * FEAT.edge
  // the panorama: one picture, cut at the spine
  place(dx: if left-page { FEAT.edge } else { FEAT.edge - PAGE.w }, dy: FEAT.edge,
    box(width: full, height: FEAT.pano-h, clip: true, radius: if t.radius > 0pt { 4pt } else { 0pt }, image(panorama, width: full, height: FEAT.pano-h, fit: "cover")))
  // the box across the foot: open on the spine side, so it reads as one box across the two pages
  let w = PAGE.w - PAGE.outside
  let open-side = if left-page { (right: none) } else { (left: none) }
  let st = if type(t.box-stroke) == dictionary { t.box-stroke } else { t.box-stroke }
  place(dx: if left-page { PAGE.outside } else { 0mm }, dy: FEAT.box-top,
    block(width: w, height: FEAT.box-h, fill: t.tint, inset: (x: 10mm, y: 8mm),
      stroke: if left-page { (left: st, top: st, bottom: st) } else { (right: st, top: st, bottom: st) },
      radius: if left-page { (top-left: t.radius, bottom-left: t.radius) } else { (top-right: t.radius, bottom-right: t.radius) },
      if left-page { left-box } else { right-box }))
  // the photo credit under the panorama (right-hand page), the page number under the box
  if not left-page { place(dx: 0mm, dy: FEAT.edge + FEAT.pano-h + 1.5mm, block(width: PAGE.w - FEAT.edge, align(right, text(size: 6.5pt, fill: t.muted, credit)))) }
  place(dx: if left-page { PAGE.outside } else { 0mm }, dy: FEAT.box-top + FEAT.box-h + 4mm,
    block(width: PAGE.w - PAGE.outside, align(if left-page { left } else { right }, text(size: 8.5pt, weight: "bold", fill: t.head, str(p)))))
  // a badge on the spine: half on each page
  let r = 11mm
  place(dx: (if left-page { PAGE.w } else { 0mm }) - r, dy: FEAT.box-top - r + 2mm,
    circle(radius: r, fill: white, stroke: 1.4pt + t.accent, align(center + horizon, text(font: t.head-font, weight: "bold", size: 20pt, fill: t.accent, badge-text))))
}
#let feature-spread(title: "", kicker: "", standfirst: [], panorama: none, credit: [], left-box: [], right-box: [], badge-text: "?", body) = {
  spread-start()
  context {
    let t = TH.get()
    set page(margin: (inside: PAGE.inside, outside: PAGE.outside, top: FEAT.top, bottom: FEAT.bottom), header: none, footer: none,
      background: feature-bg(t, panorama, left-box, right-box, badge-text, credit))
    [#metadata(title) <section-title>]
    block(width: 100%, below: 4mm, {
      text(font: t.label-font, size: 8.5pt, fill: t.accent, tracking: 1pt, upper(kicker))
      linebreak()
      text(font: t.head-font, weight: "bold", size: 26pt, fill: t.head, title)
      v(-6pt); rule(t, width: 45%); v(1mm)
      text(size: 12.5pt, fill: t.muted, standfirst)
    })
    columns(2, gutter: 7mm, { set par(justify: true, leading: 0.62em, spacing: 0.75em); set text(size: 10pt); body })
  }
}
// pieces for the feature text
#let lead-in(body) = context text(font: TH.get().head-font, weight: "bold", fill: TH.get().head, smallcaps(body))
#let pull-quote(body) = context {
  let t = TH.get()
  block(width: 100%, inset: (y: 4mm), above: 4mm, below: 4mm, stroke: (top: 1.5pt + t.accent, bottom: 0.5pt + t.line),
    text(font: t.head-font, size: 14pt, fill: t.head, style: if t.section == "stitch" { "italic" } else { "normal" }, weight: "bold", body))
}
#let col-picture(path, caption, height: 48mm, at: auto) = context {
  let t = TH.get()
  // a float: it goes to the top or bottom of the column, and the text fills in around it (no gaps)
  place(at, float: true, scope: "column", clearance: 4mm, block(width: 100%, breakable: false, {
    box(width: 100%, height: height, clip: true, radius: calc.min(t.radius, 4pt), image(path, width: 100%, height: height, fit: "cover"))
    v(1mm, weak: true)
    text(size: 7.5pt, fill: t.muted, caption)
  }))
}
#let reflect-items(start, items) = context {
  let t = TH.get()
  set text(size: 9.5pt)
  for (i, q) in items.enumerate() {
    block(below: 3mm)[#badge(t, str(start + i), size: 1.4em) #h(3pt) #q #v(5mm) #line(length: 100%, stroke: 0.6pt + t.line)]
  }
}

// ---------------------------------------------------------------- the vocab list, for glosses
// vgloss("ROM-011"): the meaning and 中文 come from vocab/data/vocab.csv, so a gloss never disagrees with the list.
#let VOCAB = csv("/vocab/data/vocab.csv", row-type: dictionary)
#let vgloss(id, word: none) = {
  let row = VOCAB.find(r => r.id == id)
  if row == none { return text(fill: red, "[no " + id + "]") }
  gloss(if word == none { row.term_en } else { word }, row.short_def, zh: row.zh)
}

// ---------------------------------------------------------------- a landscape page inside a portrait packet
// The content is turned 90° on an ordinary portrait page, so the packet still prints and staples as one.
#let landscape(body) = {
  pagebreak(weak: true)
  align(center + horizon, rotate(-90deg, reflow: true, block(width: PAGE.h - PAGE.top - PAGE.bottom - 6mm, height: PAGE.w - PAGE.inside - PAGE.outside, body)))
}
