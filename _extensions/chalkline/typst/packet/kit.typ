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
// Hidden notes for the guide: what a page is (name), what it can be used for (uses) and what it's made of
// (pieces). Nothing is printed; the build reads them (scripts/packet_kit.py) for the Packet Templates page.
#let about(name, uses: (), pieces: ()) = context [#metadata((name: name, uses: uses, pieces: pieces, page: here().page())) <template-info>]
// "booklet": the whole packet, A3 folded (facing pages, padding, a back cover).
// "sheet": one worksheet printed on its own, A4 (no facing pages, no padding; a spread is put on one A3 page).
#let MODE = state("chalkline-mode", "booklet")
// The teacher edition: the same pages with the answers written in (red, handwriting), placed over the
// student page so nothing moves: the teacher's page 11 is the student's page 11. --input edition=teacher
// (a state, so Quarto can set it from the page's `edition`; a build can also pass --input edition=teacher)
#let EDITION = state("chalkline-teacher", sys.inputs.at("edition", default: "student") == "teacher")
#let KEY = rgb("#c8372d")
#let key(body, size: 12.5pt) = text(font: ("Patrick Hand", "Noto Sans SC"), size: size, fill: KEY, body)
// an answer that takes no space: in the student edition nothing, in the teacher edition drawn at this spot
#let key-here(body, dx: 0pt, dy: 0pt, size: 12.5pt) = context if EDITION.get() { box(width: 0pt, height: 0pt, place(dx: dx, dy: dy, box(width: 120mm, key(body, size: size)))) }
// Units and subunits, for the contents page: unit-start("2", "Ancient Rome"), subunit("2.1", "Water and roads").
// Every section and page title is an entry under them.
#let unit-start(number, name) = [#metadata((kind: "unit", number: number, name: name)) <toc-unit>]
#let subunit(number, name) = [#metadata((kind: "sub", number: number, name: name)) <toc-sub>]
#let SECTION = state("chalkline-section", "")
#let PAGE = (w: 210mm, h: 297mm, inside: 20mm, outside: 15mm, top: 19mm, bottom: 17mm)
// Packets are printed on A3 and folded: A4 pages, facing pages, a page count that's a multiple of 4.

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

#let answer-lines(n: 2, gap: 8.5mm, answer: none) = context {
  let t = TH.get()
  for i in range(n) {
    v(gap - 1pt)
    if i == 0 and answer != none and EDITION.get() { place(dx: 2mm, dy: -gap + 2.2mm, block(width: 100% - 4mm, key(answer))) }
    line(length: 100%, stroke: 0.6pt + t.line)
  }
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
  let odd = calc.odd(p.page) or MODE.get() == "sheet"
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
// chapter: true when a chapter's heading starts it (the page it's on so far holds only that heading)
#let spread-start(chapter: false) = context {
  if MODE.get() == "booklet" { [#metadata(if chapter { "pre-spread-chapter" } else { "pre-spread" }) <pre-spread>#pagebreak(to: "even")#metadata("spread") <spread>] }
  else { [#pagebreak(weak: true)#metadata("spread") <spread>] }
  context [#metadata(here().page()) <spread-page>]
}
#let notes-background(t) = context {
  let p = here().page()
  let pres = query(<pre-spread>)
  let posts = query(<spread>).map(m => m.location().page())
  // the page Typst added before a spread; or, when a chapter starts the spread, the page its heading was alone on
  let added = pres.zip(posts).any(((m, b)) => { let a = m.location().page(); (b - a == 2 and p == a + 1) or (m.value == "pre-spread-chapter" and b - a == 1 and p == a) })
  if not added { return }
  let left = if calc.odd(p) { PAGE.inside } else { PAGE.outside }
  place(dx: left, dy: PAGE.top + 4mm, block(width: PAGE.w - PAGE.inside - PAGE.outside, height: PAGE.h - PAGE.top - PAGE.bottom - 8mm, {
    text(font: t.head-font, weight: "bold", size: 14pt, fill: t.head, "Notes")
    v(2mm)
    block(width: 100%, height: 1fr, radius: t.radius, stroke: t.box-stroke, fill: surface(t, "lines"))
  }))
}
// The end of the booklet: Notes pages, then the back cover (if any) on the very last page, so the page count
// is a multiple of 4 (A3 sheets, folded). Measured from a marker, so the padding can't move what it measures.
#let finish-booklet(back: none) = [#metadata("content-end") <content-end>#context {
  if MODE.get() != "booklet" { return }
  let n = locate(<content-end>).page()
  let total = calc.ceil((n + if back != none { 1 } else { 0 }) / 4) * 4
  for i in range(total - n - if back != none { 1 } else { 0 }) { pagebreak(); notes-page() }
  if back != none { pagebreak(); back }
}]

// ---------------------------------------------------------------- the packet
#let packet(theme: "sky", title: "", unit: "", teacher: auto, body) = {
  let t = themes.at(theme)
  TH.update(t)
  if teacher != auto { EDITION.update(teacher) }
  set page(paper: "a4", binding: left, background: notes-background(t), margin: (inside: PAGE.inside, outside: PAGE.outside, top: PAGE.top, bottom: PAGE.bottom),
    header: context {
      let n = here().page()
      if n == 1 or n == counter(page).final().first() { return }   // not on the covers
      let odd = calc.odd(n)
      set text(size: 8pt, fill: t.muted, font: t.label-font)
      let name = if t.badge == "mono" { upper(title) } else { title }
      let titles = query(<section-title>)
      let here-titles = titles.filter(m => m.location().page() == n)
      let before = titles.filter(m => m.location().page() < n)
      let sec = if here-titles.len() > 0 { here-titles.first().value } else if before.len() > 0 { before.last().value } else { "" }
      let ribbon = if EDITION.get() { box(fill: KEY, inset: (x: 5pt, y: 2pt), radius: 2pt, text(fill: white, weight: "bold", size: 7pt, "TEACHER EDITION")) }
      grid(columns: (1fr, auto, 1fr), align(left)[#if not odd { name } else { unit }], ribbon, align(right)[#if odd { sec } else { "" }])
      v(-6pt)
      // On an intentional spread (one started with spread-start), the line runs on to the spine, so the two
      // pages' lines meet in the middle and read as one line across the spread.
      let starts = query(<spread>).map(m => m.location().page())
      let spread-left = starts.contains(n)
      let spread-right = starts.contains(n - 1)
      let st = if t.rule == "zigzag" { (paint: t.line, thickness: 0.6pt, dash: "dashed") } else if t.rule == "double" { 0.4pt + t.head } else { 0.6pt + t.faint }
      if spread-left { line(length: 100% + PAGE.inside, stroke: st) }
      else if spread-right { move(dx: -PAGE.inside, line(length: 100% + PAGE.inside, stroke: st)) }
      else { line(length: 100%, stroke: st) }
    },
    footer: context {
      let n = here().page()
      if n == 1 or n == counter(page).final().first() { return }
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
  let cell(i, item) = block(width: 100%, height: 100%, radius: t.radius, stroke: t.box-stroke, clip: true, inset: 0pt, {
    let (q, a, work) = if type(item) == array { (item.at(0), item.at(1), item.at(2, default: none)) } else { (item, none, none) }
    place(block(width: 100%, height: 100%, fill: surface(t, surface-style)))
    if EDITION.get() and work != none { place(top + left, dx: 12mm, dy: 15mm, box(width: 100% - 18mm, key(work, size: 12pt))) }
    place(top + left, dx: 7pt, dy: 7pt, box(fill: white, inset: (right: 6pt, bottom: 3pt), [#badge(t, str(i + 1), size: 1.5em) #h(3pt) #text(size: 12.5pt, weight: "bold", q)]))
    place(bottom + right, dx: -7pt, dy: -7pt, box(fill: white, inset: 4pt, stroke: 0.6pt + t.line, radius: calc.min(t.radius, 4pt),
      [#text(size: 10pt, fill: t.muted, answer) #box(width: 18mm, height: 1em, if EDITION.get() and a != none { place(dy: -3pt, key(a, size: 14pt)) })]))
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
    ..es.map(e => (text(size: 9pt, fill: t.muted, e.at(0)), text(size: 9.5pt)[#if e.at(1) != none [*#e.at(1)* #h(2pt)]#e.at(2)],
      if EDITION.get() and e.len() > 3 { key(e.at(3), size: 13.5pt) } else { [] })).flatten())
  grid(columns: (1fr, 1fr), column-gutter: 5mm, tbl(entries.slice(0, half)), tbl(entries.slice(half)))
}

// Questions answered in full sentences: two lines each, so there's room for one.
#let recall(questions, lines: 2) = context {
  let t = TH.get()
  for (i, item) in questions.enumerate() {
    let (q, a) = if type(item) == array { (item.at(0), item.at(1)) } else { (item, none) }
    block(breakable: false, below: 4mm)[#text(weight: "bold", fill: t.head, str(i + 1) + ".") #h(3pt) #q #answer-lines(n: lines, answer: a)]
  }
}

// Put events in order: a box to write the number, then the event.
#let sequence(events, order: none) = context {
  let t = TH.get()
  block(breakable: false, table(columns: (17mm, 1fr), rows: (auto,) + (10mm,) * events.len(), inset: (x: 7pt, y: 4pt), align: (center + horizon, left + horizon),
    fill: (_, y) => if y == 0 { t.tint } else { none },
    table.header(text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, "Order"), text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, "Event")),
    ..events.enumerate().map(((i, e)) => (box(width: 9mm, height: 7mm, stroke: 0.8pt + t.line, radius: calc.min(t.radius, 3pt),
      if EDITION.get() and order != none { align(center + horizon, key(str(order.at(i)), size: 14pt)) }), e)).flatten()))
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
    if pic != none { v(1fr); box(width: 100%, height: 17mm, clip: true, radius: calc.min(t.radius, 4pt), if type(pic) == str { image(pic, width: 100%, height: 17mm, fit: "cover") } else { pic }) }
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
  let starts = query(<spread>).map(m => m.location().page()).filter(x => x <= p)
  let left-page = if starts.len() > 0 { calc.even(p - starts.last()) } else { calc.even(p) }
  let full = 2 * PAGE.w - 2 * FEAT.edge
  // the panorama: one picture, cut at the spine
  place(dx: if left-page { FEAT.edge } else { FEAT.edge - PAGE.w }, dy: FEAT.edge,
    box(width: full, height: FEAT.pano-h, clip: true, radius: if t.radius > 0pt { 4pt } else { 0pt }, if type(panorama) == str { image(panorama, width: full, height: FEAT.pano-h, fit: "cover") } else { panorama }))
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
  if MODE.get() == "booklet" { place(dx: if left-page { PAGE.outside } else { 0mm }, dy: FEAT.box-top + FEAT.box-h + 4mm,
    block(width: PAGE.w - PAGE.outside, align(if left-page { left } else { right }, text(size: 8.5pt, weight: "bold", fill: t.head, str(p))))) }
  // a badge on the spine: half on each page
  let r = 11mm
  place(dx: (if left-page { PAGE.w } else { 0mm }) - r, dy: FEAT.box-top - r + 2mm,
    circle(radius: r, fill: white, stroke: 1.4pt + t.accent, align(center + horizon, text(font: t.head-font, weight: "bold", size: 20pt, fill: t.accent, badge-text))))
}
#let feature-spread(title: "", kicker: "", standfirst: [], panorama: none, credit: [], left-box: [], right-box: [], badge-text: "?", body) = {
  spread-start()
  context {
    let t = TH.get()
    // the inside margin on the spine side of each half: in a booklet the spread starts on an even page;
    // on a loose sheet it may start on page 1, so the binding side is set from where it starts
    let start = here().page()
    set page(binding: if calc.odd(start) { right } else { left },
      margin: (inside: PAGE.inside, outside: PAGE.outside, top: FEAT.top, bottom: FEAT.bottom), header: none, footer: none,
      background: feature-bg(t, panorama, left-box, right-box, badge-text, credit))
    [#metadata(title) <section-title>#metadata(title) <own-title>]
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
    box(width: 100%, height: height, clip: true, radius: calc.min(t.radius, 4pt), if type(path) == str { image(path, width: 100%, height: height, fit: "cover") } else { path })
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
// The word and language lists: the course's own, unless the build names others (--input vocab=, frames=,
// vocab-images=; the guide's samples use the guide's own lists, so they work in any course).
#let VOCAB = csv(sys.inputs.at("vocab", default: "/vocab/data/vocab.csv"), row-type: dictionary)
#let VOCAB-IMAGES = sys.inputs.at("vocab-images", default: "/vocab/images")
#let vgloss(id, word: none) = {
  let row = VOCAB.find(r => r.id == id)
  if row == none { return text(fill: red, "[no " + id + "]") }
  gloss(if word == none { row.term_en } else { word }, row.short_def, zh: row.zh)
}

// a paragraph number, so questions can point to "¶3" (page positions move when the layout changes)
#let pn(n) = context box(text(font: TH.get().label-font, size: 8pt, weight: "bold", fill: TH.get().accent, "¶" + str(n)) + h(3pt))

// two lines: "parallel" or "perpendicular" (for reference cards, next to angle-pic)
#let line-pic(kind, t) = box(width: 24mm, height: 20mm, if kind == "parallel" {
  place(dy: 6mm, line(length: 24mm, stroke: 1.4pt + t.head)); place(dy: 14mm, line(length: 24mm, stroke: 1.4pt + t.head))
} else {
  place(dy: 14mm, line(length: 24mm, stroke: 1.4pt + t.head)); place(dx: 12mm, dy: 2mm, line(length: 12mm, angle: 90deg, stroke: 1.4pt + t.head))
  place(dx: 12mm, dy: 11mm, rect(width: 3mm, height: 3mm, stroke: 0.8pt + t.accent))
})
// reference cards in a grid that fills the rest of the page: cards: ((title, picture, text), …)
#let card-grid(cards, cols: 3) = context {
  let t = TH.get()
  let rows = calc.ceil(cards.len() / cols)
  let card((title, pic, body)) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, inset: 7pt, breakable: false, {
    text(font: t.head-font, weight: "bold", fill: t.head, size: 11pt, title)
    v(1mm); align(center, pic); v(1fr)
    text(size: 9pt, body)
  })
  block(height: 1fr, grid(columns: (1fr,) * cols, rows: (1fr,) * rows, gutter: 4mm, ..cards.map(card)))
}

// ---------------------------------------------------------------- a landscape page inside a portrait packet
// In a packet, the content is turned 90° on an ordinary portrait page, so the packet still prints and folds
// as one. A loose sheet gets a real landscape page instead (the same room), so it shows the right way up on
// a screen, and ink written on it in the PDF viewer lands in the right place.
#let landscape(body) = context {
  let w = PAGE.h - PAGE.top - PAGE.bottom - 6mm
  let h = PAGE.w - PAGE.inside - PAGE.outside
  if MODE.get() == "sheet" {
    page(flipped: true, margin: (x: (PAGE.h - w) / 2, top: 17mm, bottom: 17mm), align(center + horizon, block(width: w, height: h, body)))
  } else {
    pagebreak(weak: true)
    align(center + horizon, rotate(-90deg, reflow: true, block(width: w, height: h, body)))
  }
}

// A chart to fill in on a landscape page: a row per thing, a column per question (the last can be "Sketch")
#let compare-chart(title, first, columns, rows, instructions: none, letter: none) = [#metadata(title) <own-title>] + landscape({
  set align(left + top)
  context if MODE.get() == "sheet" { name-row(); v(2mm) }   // a loose sheet: the Name line is on this page
  if letter != none { section(letter, title, instructions: instructions) } else { titled(title); if instructions != none { text(size: 9.5pt, instructions); v(2mm) } }
  context {
    let t = TH.get()
    let h(s) = text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, s)
    let n = columns.len()
    block(height: 1fr, table(columns: (30mm,) + (1fr,) * n, rows: (auto,) + (1fr,) * rows.len(), inset: 6pt,
      fill: (x, y) => if y == 0 or x == 0 { t.tint } else { none }, align: (x, y) => if x == 0 { left + horizon } else { left + top },
      h(first), ..columns.map(h),
      ..rows.map(r => (text(weight: "bold", fill: t.head, r),) + ([],) * n).flatten()))
  }
})

// ---------------------------------------------------------------- title page, contents, overview, self-check, back
#let placeholder(label, height: 40mm, width: 100%) = context {
  let t = TH.get()
  block(width: width, height: height, stroke: (paint: t.line, thickness: 1pt, dash: "dashed"), radius: t.radius,
    align(center + horizon, text(size: 9pt, fill: t.muted, font: t.label-font, label)))
}
// The school's logo (a path from the course folder; packets.py passes the brand's), or a dashed circle
#let LOGO = state("chalkline-logo", none)
#let logo-mark(size) = context {
  let t = TH.get()
  let logo = LOGO.final()
  if logo != none { box(width: size, height: size, image(logo, width: size, height: size, fit: "contain")) }
  else { box(width: size, height: size, stroke: (paint: t.line, dash: "dashed"), radius: 50%, align(center + horizon, text(size: 6.5pt, fill: t.muted, "Logo"))) }
}
// hero: a picture path, "placeholder" (a dashed box to fill in later), or none (the theme's decoration)
#let title-page(course: "", unit: "", unit-number: "", teacher: "", school: "", year: "", hero: none, logo: none) = context {
  let t = TH.get()
  if logo != none { LOGO.update(logo) }
  grid(columns: (auto, 1fr, auto), align: horizon, column-gutter: 4mm,
    logo-mark(13mm),
    text(font: t.label-font, size: 9pt, fill: t.muted, school), text(font: t.label-font, size: 9pt, fill: t.muted, year))
  v(10mm)
  text(font: t.label-font, size: 11pt, fill: t.accent, tracking: 1.5pt, upper(course))
  v(1mm)
  grid(columns: (auto, 1fr), column-gutter: 5mm, align: bottom,
    text(font: t.head-font, size: 64pt, weight: "bold", fill: t.accent.lighten(30%), unit-number),
    text(font: t.head-font, size: 34pt, weight: "bold", fill: t.head, unit))
  v(-3pt); rule(t, width: 70%); v(6mm)
  if hero == "placeholder" { placeholder("Hero picture (optional) · about 170 × 95 mm", height: 95mm) }
  else if hero != none { box(width: 100%, height: 95mm, clip: true, radius: calc.min(t.radius, 6pt), image(hero, width: 100%, height: 95mm, fit: "cover")) }
  else if t.section == "band" {
    box(width: 100%, height: 95mm, { for (x, y, r) in ((6%, 30mm, 18mm), (18%, 18mm, 26mm), (33%, 36mm, 16mm), (60%, 22mm, 24mm), (76%, 34mm, 15mm), (88%, 14mm, 12mm)) { place(dx: x, dy: y, circle(radius: r, stroke: 1pt + t.faint)) } })
  } else if t.section == "stitch" {
    box(width: 100%, height: 95mm, stroke: t.box-stroke, radius: 4pt, inset: 12pt, align(center + horizon, text(font: t.head-font, size: 14pt, fill: t.muted, style: "italic", "Field notes")))
  } else {
    box(width: 100%, height: 95mm, fill: surface(t, "grid"), stroke: 0.8pt + t.head, inset: 8pt, align(bottom + right, text(font: t.label-font, size: 8pt, fill: t.head, "SHEET 01 · UNIT " + unit-number)))
  }
  v(1fr)
  grid(columns: (1fr, 1fr), column-gutter: 8mm, row-gutter: 6mm,
    [#text(size: 9pt, fill: t.muted, font: t.label-font, "Teacher") \ #text(size: 13pt, weight: "bold", fill: t.head, teacher)],
    [#text(size: 9pt, fill: t.muted, font: t.label-font, "Course") \ #text(size: 13pt, weight: "bold", fill: t.head, course)])
  v(6mm)
  panel(title: "This packet belongs to")[#v(2mm) #name-row() #v(1mm)]
}

// Contents from the markers: depth 1 = units, 2 = units and subunits, 3 = every titled page too.
#let contents(depth: 3, title: "Contents") = context {
  let t = TH.get()
  text(font: t.head-font, weight: "bold", size: 22pt, fill: t.head, title)
  v(-4pt); rule(t); v(4mm)
  let items = query(selector(<toc-unit>).or(<toc-sub>).or(<section-title>))
  let seen = ()
  // a unit or subunit takes the page of the first titled page after it (a marker just before a spread
  // would otherwise sit on the page before the spread starts)
  let page-of(i) = { let rest = items.slice(i).filter(x => type(x.value) != dictionary); if rest.len() > 0 { rest.first().location().page() } else { items.at(i).location().page() } }
  for (i, m) in items.enumerate() {
    let pg = page-of(i)
    let val = m.value
    let kind = if type(val) == dictionary { val.kind } else { "page" }
    if kind == "page" and (depth < 3 or val == title) { continue }
    if kind == "sub" and depth < 2 { continue }
    let num = text(fill: t.head, weight: "bold", str(pg))
    let lead = box(width: 1fr, repeat(text(fill: t.line, " . ")))
    if kind == "unit" {
      v(3mm)
      block(below: 2mm, grid(columns: (auto, 1fr, auto), column-gutter: 3mm, align: horizon,
        if val.number != "" { badge(t, val.number, size: 2em) } else { box(width: 0pt) }, text(font: t.head-font, weight: "bold", size: 15pt, fill: t.head, val.name), text(size: 12pt, num)))
    } else if kind == "sub" {
      block(above: 3.5mm, below: 1.5mm, inset: (left: 9mm), grid(columns: (auto, 1fr, auto), column-gutter: 2mm,
        text(font: t.label-font, weight: "bold", fill: t.accent, val.number), [#text(weight: "bold", fill: t.head, val.name) #lead], num))
    } else {
      if (val, pg) in seen { continue }
      seen.push((val, pg))
      block(above: 1mm, below: 1mm, inset: (left: 18mm), grid(columns: (1fr, auto), column-gutter: 2mm, [#val #lead], text(fill: t.muted, str(pg))))
    }
  }
}

// A vocab page in two columns, from the vocab list. pictures: true gives each word its picture (a reference
// card); false gives a denser list with a line for the student's own sentence.
// rows: the words themselves, ((term_en:, zh:, short_def:, example:, path:), …), for a .qmd page (kit-blocks.lua
// passes them from Chalkline's merged word list); otherwise they come from the vocab list, by prefix or ids
#let vocab-page(prefix: "ROM", pictures: true, ids: none, rows: none) = context {
  let t = TH.get()
  let rows = if rows != none { rows } else { VOCAB.filter(r => if ids != none { r.id in ids } else { r.id.starts-with(prefix + "-") }) }
  let entry(r) = if pictures {
    block(width: 100%, height: 34mm, stroke: t.box-stroke, radius: t.radius, inset: 5pt, breakable: false, clip: true,
      grid(columns: (30mm, 1fr), column-gutter: 4mm,
        box(width: 30mm, height: 26mm, clip: true, radius: calc.min(t.radius, 4pt), if r.at("path", default: "") != "" { image(r.path, width: 30mm, height: 26mm, fit: "contain") } else if r.at("image", default: "") != "" and "path" not in r { image(VOCAB-IMAGES + "/" + r.image, width: 30mm, height: 26mm, fit: "contain") }),
        [#text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, r.term_en) #h(2pt) #text(fill: t.muted, r.zh)          #text(size: 9pt, r.short_def) \ #v(1pt) #text(size: 8pt, fill: t.muted, style: "italic", r.example)]))
  } else {
    block(width: 100%, breakable: false, below: 3mm, {
      grid(columns: (1fr, auto), [#text(font: t.head-font, weight: "bold", size: 11pt, fill: t.head, r.term_en) #h(3pt) #text(size: 9.5pt, fill: t.muted, r.zh)], [])
      v(-2pt); text(size: 9pt, r.short_def)
      v(6mm); line(length: 100%, stroke: 0.6pt + t.line)
      v(6mm); line(length: 100%, stroke: 0.6pt + t.line)
    })
  }
  grid(columns: (1fr, 1fr), column-gutter: 6mm, row-gutter: if pictures { 3.5mm } else { 3mm }, ..rows.map(entry))
}

// Language points in two columns, grouped by kind, from vocab/data/frames.csv.
#let FRAMES = csv(sys.inputs.at("frames", default: "/vocab/data/frames.csv"), row-type: dictionary)
#let language-page(ids, rows: none) = context {
  let t = TH.get()
  let names = (grammar: "Grammar", phrase: "Phrases", stem: "Sentence stems", frame: "Sentence frames", question: "Questions and answers")
  let blank(s) = s.replace("___", "______")
  let item(r) = block(width: 100%, breakable: false, below: 3.5mm, inset: (left: 8pt), stroke: (left: 2pt + t.accent), {
    text(weight: "bold", fill: t.head, blank(r.en)); if r.zh != "" { linebreak(); text(size: 9pt, fill: t.muted, r.zh) }
    if r.answer_en != "" { linebreak(); text(size: 9.5pt)[→ #blank(r.answer_en)] }
    if r.example != "" { linebreak(); text(size: 8.5pt, fill: t.muted, style: "italic", r.example) }
  })
  let rows = if rows != none { rows } else { FRAMES.filter(r => r.id in ids) }
  let groups = ("grammar", "phrase", "stem", "frame", "question").filter(k => rows.any(r => r.kind == k))
  // two columns, balanced: whole groups go left until about half the points are placed
  let group(k) = { block(below: 2mm, text(font: t.label-font, weight: "bold", size: 9pt, fill: t.accent, tracking: 0.8pt, upper(names.at(k)))); for r in rows.filter(r => r.kind == k) { item(r) }; v(2mm) }
  let left = (); let right = (); let n = 0
  for k in groups { let c = rows.filter(r => r.kind == k).len(); if n < rows.len() / 2 { left.push(k); n += c } else { right.push(k) } }
  grid(columns: (1fr, 1fr), column-gutter: 7mm, { for k in left { group(k) } }, { for k in right { group(k) } })
}

// I can ... at the start and the end of the unit: three circles each (not yet, getting there, I can).
// lesson: true for one lesson's check (four stars to colour, "How well?"); otherwise a unit's (1 2 3 at the
// start of the unit and again at the end)
#let star(t, size: 6.5mm) = box(width: size, height: size, {
  let pts = range(10).map(i => {
    let r = if calc.even(i) { size / 2 } else { size / 5 }
    let a = -90deg + i * 36deg
    (size / 2 + r * calc.cos(a), size / 2 + r * calc.sin(a))
  })
  place(polygon(stroke: (paint: t.line, thickness: 0.9pt, join: "round"), ..pts))
})
#let self-check(statements, lesson: false) = context {
  let t = TH.get()
  if lesson {
    let hd(s) = text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, s)
    let stars = box(for i in range(4) { star(t); h(2mm) })
    table(columns: (1fr, 42mm), inset: 6pt, rows: (auto,) + (15mm,) * statements.len(), align: (left + horizon, center + horizon),
      fill: (_, y) => if y == 0 { t.tint } else { none },
      hd("I can …"), hd("How well?"), ..statements.map(s => (s, stars)).flatten())
    text(size: 8.5pt, fill: t.muted)[Colour the stars. 1 star = I need help · 4 stars = I can teach it]
    return
  }
  let circles = box(for (i, l) in ("1", "2", "3").enumerate() { box(width: 7mm, height: 7mm, stroke: 0.8pt + t.line, radius: 50%, align(center + horizon, text(size: 7pt, fill: t.muted, l))); h(1.5mm) })
  let hd(s) = text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, s)
  table(columns: (1fr, 31mm, 31mm), inset: 6pt, rows: (auto,) + (15mm,) * statements.len(), align: (left + horizon, center + horizon, center + horizon),
    fill: (_, y) => if y == 0 { t.tint } else { none },
    hd("I can …"), hd("Start of the unit"), hd("End of the unit"),
    ..statements.map(s => (s, circles, circles)).flatten())
  text(size: 8.5pt, fill: t.muted)[1 = not yet · 2 = getting there · 3 = I can do it on my own]
}

// Picture credits for the back cover: #kit.credit[The cover: …] anywhere in the packet adds one.
#let CREDITS = state("chalkline-credits", ())
#let credit(body) = CREDITS.update(c => c + (body,))
#let back-cover(school: "", credits: []) = context {
  let t = TH.get()
  v(1fr)
  align(center, {
    logo-mark(16mm)
    v(3mm); text(font: t.head-font, weight: "bold", size: 12pt, fill: t.head, school)
    v(10mm)
  })
  let listed = CREDITS.final()
  panel(title: "Picture credits")[#set text(size: 8pt); #credits #if listed.len() > 0 { list(..listed) }]
  v(8mm)
}

// ---------------------------------------------------------------- a worksheet printed on its own
// #show: worksheet.with(theme: "sky", title: "Two-step equations", unit: "Unit 2 · Ancient Rome", goes-with: "page 15")
// The same pages as in the packet, on A4: equal margins, Name / Class / Date at the top, "Page 1 of 2" and
// where it goes in the packet at the foot. A spread in it is put on one A3 page by build.py (impose()).
#let worksheet(theme: "sky", title: "", subtitle: none, unit: "", goes-with: none, name: true, teacher: auto, show-title: auto, body) = {
  let t = themes.at(theme)
  TH.update(t)
  if teacher != auto { EDITION.update(teacher) }
  MODE.update("sheet")
  set page(paper: "a4", margin: (x: 17.5mm, top: PAGE.top, bottom: PAGE.bottom), background: none, numbering: none,   // (none: no logo Quarto adds)
    header: context {
      set text(size: 8pt, fill: t.muted, font: t.label-font)
      let ribbon = if EDITION.get() { box(fill: KEY, inset: (x: 5pt, y: 2pt), radius: 2pt, text(fill: white, weight: "bold", size: 7pt, "TEACHER EDITION")) }
      grid(columns: (1fr, auto, 1fr), align(left, unit), ribbon, align(right, title))
      v(-6pt); line(length: 100%, stroke: if t.rule == "zigzag" { (paint: t.line, thickness: 0.6pt, dash: "dashed") } else { 0.6pt + t.faint })
    },
    footer: context {
      set text(size: 8pt, fill: t.muted, font: t.label-font)
      let n = counter(page).get().first(); let total = counter(page).final().first()
      grid(columns: (1fr, auto, 1fr), [], text(weight: "bold", fill: t.head, "Page " + str(n) + " of " + str(total)),
        align(right, if goes-with != none { "Goes with packet " + goes-with } else { "" }))
    })
  set text(font: t.body-font, size: 10.5pt, fill: t.ink, lang: "en")
  set par(leading: 0.6em, spacing: 0.9em)
  set table(stroke: 0.6pt + t.line)
  // a printable's own ## headings take the theme's look (over the site's brand heading style)
  show heading: it => block(above: 5mm, below: 2.5mm, breakable: false, sticky: true, {   // sticky: never alone at the foot of a page
    set text(font: t.head-font, fill: t.head, weight: "bold", size: if it.level <= 2 { 14pt } else { 11.5pt })
    it.body
    if it.level <= 2 { v(-2pt); box(width: 30mm, rule(t)) }
  })
  if name { name-row(); v(3mm) }   // (a spread starts on a new page: put the name in it instead)
  // the title on page 1: shown when the page is a whole printable from a .qmd (show-title: auto, a title)
  if show-title == true or (show-title == auto and title != "" and title != []) { titled(title, sub: subtitle) }
  body
}

// ---------------------------------------------------------------- a unit packet built by Quarto (packets.py)
// The packet as Quarto makes it: a book whose chapters are the unit's printables, each starting with a level-1
// heading. Each one starts on a new page with its title in the theme; packets.py's first chapter draws the
// title page and the contents; Notes pages and the back cover make it a multiple of 4 pages (A3, folded).
#let booklet(theme: "sky", title: "", unit: "", teacher: auto, school: "", body) = {
  show: packet.with(theme: theme, title: title, unit: unit, teacher: teacher)
  let t = themes.at(theme)
  show heading: it => block(above: 5mm, below: 2.5mm, breakable: false, sticky: true, {
    set text(font: t.head-font, fill: t.head, weight: "bold", size: if it.level <= 2 { 14pt } else { 11.5pt })
    it.body
    if it.level <= 2 { v(-2pt); box(width: 30mm, rule(t)) }
  })
  show heading.where(level: 1): it => {
    if it.body == [] { return }   // an outside PDF's chapter, or the title chapter: no title of its own
    // A chapter whose page is a full-page organizer with its own title (a Venn, a KWL) skips the chapter title,
    // or the title would sit alone on a page of its own.
    pagebreak(weak: true)
    context {
      let next = query(heading.where(level: 1).after(here(), inclusive: false))
      let own = selector(<own-title>).after(here())
      let spread = selector(<spread-first>).after(here())
      if next.len() > 0 { own = own.before(next.first().location()); spread = spread.before(next.first().location()) }
      if query(spread).len() > 0 { spread-start(chapter: true) }   // a chapter that opens with a spread: its title on the left-hand page
      if query(own).len() == 0 { titled(it.body) }
    }
  }
  body
  finish-booklet(back: back-cover(school: school, credits: []))
}

// ---------------------------------------------------------------- pictures to name, true or false
// items: ((picture, label, answer), …): each picture in a box, its label, a line to write on (the answer
// written in, in the teacher edition)
#let picture-answers(cols: 3, height: 32mm, items) = context {
  let t = TH.get()
  grid(columns: (1fr,) * cols, column-gutter: 4mm, row-gutter: 4mm, ..items.map(((pic, label, answer)) => block(breakable: false, {
    block(width: 100%, height: height, stroke: t.box-stroke, radius: t.radius, inset: 4pt, align(center + horizon, pic))
    v(1.5mm)
    grid(columns: (auto, 1fr), column-gutter: 2mm, align: bottom, text(weight: "bold", fill: t.head, label),
      box(width: 100%, height: 1.1em, stroke: (bottom: 0.6pt + t.line), if answer != none and EDITION.get() { place(dy: -2pt, key(answer, size: 12pt)) }))
  })))
}
// items: ((statement, answer), …): a box for T or F before each statement
#let true-false(items) = context {
  let t = TH.get()
  for (i, (stmt, answer)) in items.enumerate() {
    block(below: 3mm, breakable: false, grid(columns: (auto, 9mm, 1fr), column-gutter: 3mm, align: horizon,
      text(weight: "bold", fill: t.head, str(i + 1) + "."),
      box(width: 9mm, height: 7mm, stroke: 0.8pt + t.line, radius: calc.min(t.radius, 3pt), align(center + horizon, if answer != none and EDITION.get() { key(answer, size: 14pt) })),
      stmt))
  }
}
