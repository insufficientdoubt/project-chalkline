// A printer check: one page per theme with every tint, line, surface and text size the themes use.
// Print it once on the school's printer (and photocopy it once): whatever vanishes or turns muddy needs changing.
#import sys.inputs.at("kit", default: "/_extensions/chalkline/typst/packet") + "/kit.typ": *
#set page(paper: "a4", margin: 15mm)
#set text(font: ("Source Sans 3", "Noto Sans SC"), size: 10pt)

#for (key, t) in themes {
  TH.update(t)
  [
    #text(font: t.head-font, weight: "bold", size: 20pt, fill: t.head)[Printer check: #t.name]
    #v(-4pt) #rule(t) #v(2mm)
    Print this page, then photocopy the print. Tick each box that still shows clearly on *both*.

    #let row(label, sample) = grid(columns: (52mm, 1fr, 12mm), column-gutter: 4mm, align: horizon,
      text(size: 9pt, label), sample, box(width: 4mm, height: 4mm, stroke: 0.7pt))
    #let swatch(c, name) = box(width: 30mm, height: 12mm, fill: c, stroke: 0.3pt + luma(200), inset: 3pt, text(size: 7pt, fill: if name == "tint" { t.ink } else { white }, name))
    #v(2mm)
    #stack(spacing: 5mm,
      row([Colours (heading, accent, highlight)], [#swatch(t.head, "heading") #swatch(t.accent, "accent") #swatch(t.hot, "highlight")]),
      row([The light tint behind boxes], [#swatch(t.tint, "tint") #h(4mm) #text(size: 8pt, fill: t.muted)[should show as a pale grey, not vanish]]),
      row([Box outline], block(width: 100%, height: 12mm, stroke: t.box-stroke, radius: t.radius)),
      row([Writing lines], block(width: 100%, height: 18mm, fill: surface(t, "lines"))),
      row([Squared paper], block(width: 100%, height: 18mm, fill: surface(t, "grid"))),
      row([Dot paper], block(width: 100%, height: 18mm, fill: surface(t, "dots"))),
      row([Faint guide lines (timeline)], box(width: 100%, height: 14mm, { for i in range(12) { place(dx: i * 8%, line(length: 14mm, angle: 90deg, stroke: (paint: t.faint, thickness: 0.5pt, dash: "dotted"))) } })),
      row([Title rule], rule(t)),
      row([Badges], [#badge(t, "1") #h(2mm) #badge(t, "A") #h(2mm) #badge(t, "12")]),
      row([Text sizes], [#text(size: 7.5pt)[7.5 pt captions] #h(3mm) #text(size: 9pt)[9 pt] #h(3mm) #text(size: 10.5pt)[10.5 pt body] #h(3mm) #text(size: 13pt, weight: "bold", fill: t.head)[13 pt heading]]),
      row([Quiet (muted) text], text(fill: t.muted)[Read the text. Then answer the questions in the box. 读课文，然后回答问题。]),
      row([A photo], box(width: 60mm, height: 30mm, clip: true, image("/_extensions/chalkline/guide/images/units/pont-du-gard.jpg", width: 60mm, height: 30mm, fit: "cover"))),
    )
    #v(1fr)
    #text(size: 8pt, fill: luma(90))[Printer: #box(width: 50mm, line(length: 100%, stroke: 0.5pt)) #h(6mm) Date: #box(width: 30mm, line(length: 100%, stroke: 0.5pt)) #h(6mm) Black and white #box(width: 3.5mm, height: 3.5mm, stroke: 0.6pt) #h(2mm) Colour #box(width: 3.5mm, height: 3.5mm, stroke: 0.6pt)]
    #pagebreak(weak: true)
  ]
}
