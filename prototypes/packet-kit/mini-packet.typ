// A mini packet to test the kit: every layout, in one theme. Build all three:
//   python prototypes/packet-kit/build.py
#import "kit.typ": *
#import "organizers.typ": *
#let theme = sys.inputs.at("theme", default: "sky")
#let img(name) = "/_extensions/chalkline/guide/images/units/" + name
// a paragraph number, so questions can point to "¶3" (page positions move when the layout changes)
#let pn(n) = context box(text(font: TH.get().label-font, size: 8pt, weight: "bold", fill: TH.get().accent, "¶" + str(n)) + h(3pt))

#show: packet.with(theme: theme, title: "Roads of Rome", unit: "Unit 2 · Ancient Rome")

// ---------------------------------------------------------------- 1 · title page (hero: a photo, a placeholder, or the theme's decoration)
#title-page(course: "Grade 6 Humanities", unit: "Ancient Rome", unit-number: "2", teacher: "Ms. Teacher Name",
  school: "School Name", year: "2026–27 · Term 1",
  hero: if theme == "sky" { "placeholder" } else if theme == "trail" { img("colosseum-forum.jpg") } else { none })
#pagebreak()

// ---------------------------------------------------------------- 2 · contents (inside the cover, a left-hand page)
#contents(depth: 3)
#pagebreak()

// ---------------------------------------------------------------- 3 · unit overview
#unit-start("2", "Ancient Rome")
#titled("Unit overview", sub: "What we'll learn, and what you already know.")
#panel(title: "Big question:")[#text(size: 14pt)[How did the Romans hold a huge empire together?]]
#v(3mm)
#grid(columns: (1fr, 1fr), column-gutter: 6mm,
  panel(title: "In this unit you will …")[
    - read about Roman roads, aqueducts and buildings
    - learn and use 12 key words
    - solve equations and design a bridge
    - put Rome's history on a timeline
  ],
  panel(title: "Key words")[#context {
    let t = TH.get()
    for r in VOCAB.filter(r => r.id.starts-with("ROM-")) { box(inset: (x: 6pt, y: 3pt), radius: 8pt, stroke: 0.6pt + t.line, text(size: 9pt, r.term_en)); h(3pt) }
  }])
#v(3mm)
#grid(columns: (1fr, 1fr), column-gutter: 5mm, work-space(height: 1fr, style: "lines", label: "What I already know about Rome"), work-space(height: 1fr, style: "lines", label: "What I want to find out"))

#subunit("2.1", "Water and roads")
// ---------------------------------------------------------------- 2–3 · a feature spread: panorama over the spine, a box across the foot
#include "pages/feature-water.typ"

// ---------------------------------------------------------------- 4–5 · spread: a long reading, glossed in the margins
#spread-start()
#OUTSIDE.update(54mm)
#[
#set page(margin: (inside: 20mm, outside: 54mm, top: PAGE.top, bottom: PAGE.bottom))
#titled("Roads that held an empire", sub: "Read the text. The words in bold are explained in the margin.")
#set par(justify: true, leading: 0.68em)
#set text(size: 11pt)

#figure(box(width: 100%, height: 70mm, clip: true, radius: 4pt, image(img("via-appia.jpg"), width: 100%, height: 70mm, fit: "cover")),
  caption: text(size: 8pt)[The Via Appia near Rome, more than 2,000 years old. Public domain, Wikimedia Commons.])

#pn(1) Two thousand years ago, Rome ruled a huge #vgloss("ROM-005"). It stretched from Britain in the north to Egypt in the south. To hold it together, Rome needed a fast way to move soldiers, letters and food. Its answer was roads. A soldier could march 30 kilometres in a day on a good road. A journey that once took weeks now took days.

#pn(2) Roman roads were not just paths of dirt. Builders dug a deep trench and filled it layer by layer. First came large stones, then a layer of #gloss("gravel", "small stones", zh: "碎石") and sand, and on top, flat paving stones that fitted together like a puzzle. The top of the road was curved, a little higher in the middle than at the sides. When it rained, the water ran to the edges and into ditches. A road that could #gloss("drain", "let water flow away", zh: "排水") stayed dry and sturdy for many years.

#pn(3) Every Roman mile, about 1.5 kilometres, there was a milestone. It told travellers how far they were from the next town. #gloss("Merchants", "people who buy and sell things", zh: "商人") used the roads to carry wine, oil and cloth. News travelled along them too. People said that "all roads lead to Rome," and in a way they did: more than 80,000 kilometres of stone roads joined the empire's cities.

#pn(4) Roads were only half of the story. Cities also needed clean water, often from springs far away in the hills. The builders' answer was the #vgloss("ROM-011"). An aqueduct is a long channel that runs gently downhill all the way from the spring to the city. It has no pumps. It uses #gloss("gravity", "the force that pulls things down", zh: "重力"): water always flows down a slope, so the channel had to drop a little, but only a little, over every kilometre.

#figure(placement: auto, box(width: 100%, height: 74mm, clip: true, radius: 4pt, image(img("pont-du-gard.jpg"), width: 100%, height: 74mm, fit: "cover")),
  caption: text(size: 8pt)[The Pont du Gard in France carried water across a valley. Photo: Benh LIEU SONG, CC BY-SA 3.0, Wikimedia Commons.])

#pn(5) When an aqueduct came to a deep valley, the builders could not let it go down and up again. Instead they built a bridge with rows of #gloss("arches", "curved shapes that hold up a bridge or roof", zh: "拱"). An arch is strong because each stone pushes against the stones beside it, and the weight goes down into the ground. The Pont du Gard in France has three rows of arches, one on top of another. It still stands, almost unbroken, after 2,000 years.

#pn(6) The builders worked carefully, and their work lasted. Some Roman roads are still used today, and travellers walk on the famous stones of the Via Appia. When parts wear out, people #gloss("repair", "fix", zh: "修理") them, but the plan underneath is the one the Romans made.

#pn(7) Maps helped too. Roman travellers carried lists of the towns along a road and the distance between them, a little like the stops on a bus route. One old copy of a Roman road map is almost seven metres long. It is drawn as a long, thin strip, because what mattered was the order of the towns, not the shape of the land.

#v(3mm)
#panel(title: "Key facts")[
  #set par(justify: false)
  #grid(columns: (1fr, 1fr), column-gutter: 6mm, row-gutter: 4pt,
    [*80,000 km* of stone roads], [*1 Roman mile* ≈ 1.5 km],
    [*3 layers* under the paving], [*No pumps:* water flows downhill])
]
#v(3mm)
#panel(title: "Think about it:")[Roads, aqueducts and maps all helped Rome hold its empire together. Which one do you think was the most important? Why?
  #answer-lines(n: 3)
]
]
#OUTSIDE.update(PAGE.outside)
#pagebreak()

// ---------------------------------------------------------------- 8–10 · key words (with pictures, a word list) and language
#subunit("2.2", "Words and language")
#titled("Key words", sub: "Learn these words. The pictures help you remember them.")
#vocab-page(prefix: "ROM", pictures: true)
#pagebreak()
#titled("Word list", sub: "Read each meaning. Then write your own sentence with the word.")
#vocab-page(prefix: "ROM", pictures: false)
#pagebreak()
#titled("Language for this unit", sub: "Use these when you talk and write about Rome.")
#language-page(("FRM-011", "FRM-012", "FRM-013", "FRM-001", "FRM-002", "FRM-005", "FRM-006", "FRM-007", "FRM-008", "FRM-023", "FRM-024"))
#v(3mm)
#work-space(style: "lines", label: "Practise: write three sentences about Rome. Use a frame or a stem from this page in each one.")
#pagebreak()

// ---------------------------------------------------------------- 4 · vocabulary hunt
#include "pages/words-hunt.typ"
#pagebreak()

// ---------------------------------------------------------------- a reading with questions in the lower right
#subunit("2.3", "Buildings")
#titled("Before you read: KWL", sub: "The Colosseum")
#kwl([The Colosseum], k-example: [It is in Rome.], w-example: [How many people could sit inside?], l-example: [Up to 50,000 people.], where-example: [p.13 ¶1])
#pagebreak()
#titled("The Colosseum", sub: "Read the text. Then answer the questions in the box.")
#reading-page(beside: context {
  let t = TH.get()
  box(width: 100%, height: 72mm, clip: true, radius: calc.min(t.radius, 5pt), image(img("colosseum-forum.jpg"), width: 100%, height: 72mm, fit: "cover"))
  text(size: 7.5pt, fill: t.muted)[The Colosseum in Rome today. Photo: Wilfredor, CC0, Wikimedia Commons.]
  v(2mm)
  panel(title: "Words")[*arena* a space for shows · *concrete* a mix that sets as hard as rock · *velarium* a cloth roof]
}, [
  #pn(1) In the middle of Rome stands a giant stone oval. It is the Colosseum, the largest arena the Romans ever built. Work began in AD 72 under the emperor Vespasian, and it opened eight years later, in AD 80. Up to 50,000 people could sit inside, more than in many football stadiums today.

  #pn(2) The Colosseum is built from stone, brick and concrete. Concrete was one of the Romans' great inventions: a mix of lime, volcanic ash, water and small stones that set as hard as rock. It let builders make thick walls and curved shapes quickly. The outside wall has four levels. The first three have rows of arches, and each row uses a different style of column.

  #pn(3) Getting 50,000 people in and out was a puzzle. The builders solved it with 80 entrances, each with a number painted above it. A ticket showed your entrance, your section and your row. Wide stairs and corridors led to every seat, so the arena could empty in a few minutes.

  #pn(4) On hot days, sailors pulled a huge cloth roof, the _velarium_, over the seats to make shade. Under the floor was a world of tunnels, rooms and lifts, where animals and fighters waited before they appeared in the arena.

  #pn(5) The arena floor was made of wood covered with sand. The Latin word for sand is _harena_, and that is where our word "arena" comes from. Trapdoors in the floor let animals and scenery appear as if by magic, lifted up from the rooms below by ropes and wooden lifts.

  #pn(6) The shows were often cruel: gladiators fought, and wild animals were hunted. Today we study the Colosseum for what it tells us about Roman life and Roman engineering. Earthquakes and stone robbers took away almost half of it, but what is left still shows how well it was planned.

], (
  [When did the Colosseum open?],
  [What is concrete made of?],
  [How did people find their seats?],
  [Why do you think the Romans needed so many entrances?],
))
#pagebreak()

// ---------------------------------------------------------------- 11 · a landscape page (turned 90° on a portrait page)
#landscape[
  #section("D", "Compare: Roman structures", instructions: [Use the readings. Write short notes in each box, then sketch each structure in the last column.])
  #context {
    let t = TH.get()
    let h(s) = text(font: t.label-font, size: 8.5pt, weight: "bold", fill: t.head, s)
    block(height: 1fr, table(columns: (30mm, 1fr, 1fr, 1fr, 1fr, 46mm), rows: (auto, 1fr, 1fr, 1fr, 1fr), inset: 6pt,
      fill: (x, y) => if y == 0 or x == 0 { t.tint } else { none }, align: (x, y) => if x == 0 { left + horizon } else { left + top },
      h("Structure"), h("What is it for?"), h("What is it made of?"), h("How does it work?"), h("Where can you see one today?"), h("Sketch"),
      text(weight: "bold", fill: t.head)[Road], [], [], [], [], [],
      text(weight: "bold", fill: t.head)[Aqueduct], [], [], [], [], [],
      text(weight: "bold", fill: t.head)[Arch bridge], [], [], [], [], [],
      text(weight: "bold", fill: t.head)[Arena], [], [], [], [], []))
  }
]
#pagebreak()

// ---------------------------------------------------------------- math, two columns
#subunit("2.4", "Math")
#include "pages/two-step.typ"
#pagebreak()

// ---------------------------------------------------------------- 8 · math, three columns
#section("F", "One-step equations", instructions: [Solve. Write the inverse operation you used, then the answer.])
#problems(cols: 3, items: ([$x + 9 = 17$], [$x - 6 = 11$], [$4x = 36$], [$x / 5 = 7$], [$12 = x + 4$], [$3x = 27$], [$x - 2.5 = 4$], [$8x = 56$], [$x / 3 = 9$]), surface-style: "dots")

// ---------------------------------------------------------------- 10–11 · spread: reference on the left, design on the right
// (if the math ended on a left-hand page, spread-start() would make the next page a Notes page)
#subunit("2.5", "Design and time")
#spread-start()
#titled("Angles: a reference", sub: "Use this page while you design your bridge.")
#context {
  let t = TH.get()
  let card(title, pic, body) = block(width: 100%, height: 100%, stroke: t.box-stroke, radius: t.radius, inset: 7pt, breakable: false, {
    text(font: t.head-font, weight: "bold", fill: t.head, size: 11pt, title)
    v(1mm); align(center, pic); v(1fr)
    text(size: 9pt, body)
  })
  block(height: 1fr, grid(columns: (1fr, 1fr, 1fr), rows: (1fr, 1fr, 1fr), gutter: 4mm,
    card("Acute", angle-pic(50, t), [Less than 90°. A sharp corner.]),
    card("Right", angle-pic(90, t), [Exactly 90°. A square corner: mark it with a small box.]),
    card("Obtuse", angle-pic(130, t), [More than 90°, less than 180°.]),
    card("Straight", angle-pic(180, t), [Exactly 180°. A straight line.]),
    card("Reflex", angle-pic(240, t, reflex: true), [More than 180°, less than 360°.]),
    card("Full turn", angle-pic(0, t, reflex: true), [360°. All the way around.]),
    card("Parallel", box(width: 24mm, height: 20mm, { place(dy: 6mm, line(length: 24mm, stroke: 1.4pt + t.head)); place(dy: 14mm, line(length: 24mm, stroke: 1.4pt + t.head)) }), [Lines that never meet. Always the same distance apart.]),
    card("Perpendicular", box(width: 24mm, height: 20mm, { place(dy: 14mm, line(length: 24mm, stroke: 1.4pt + t.head)); place(dx: 12mm, dy: 2mm, line(length: 12mm, angle: 90deg, stroke: 1.4pt + t.head)); place(dx: 12mm, dy: 11mm, rect(width: 3mm, height: 3mm, stroke: 0.8pt + t.accent)) }), [Lines that meet at a right angle.]),
    card("Measure it", box(height: 20mm, align(horizon, text(size: 9pt)[1. Put the centre on the vertex.\ 2. Line up 0 with one side.\ 3. Read where the other side crosses.])), [Use a protractor.]),
  ))
}
#pagebreak()
#titled("Design: an arch bridge", sub: "Draw a Roman bridge on the grid. It must carry a road or water across a valley.")
#context {
  let t = TH.get()
  let check(s) = box[#box(width: 3.5mm, height: 3.5mm, stroke: 0.8pt + t.head, radius: 1pt) #h(2pt) #s]
  panel[*Your design must have:* #h(4pt) #check[an acute angle] #h(6pt) #check[a right angle] #h(6pt) #check[an obtuse angle] #h(6pt) #check[a straight angle] #h(6pt) #check[labels on each angle]]
}
#work-space(style: "grid", label: "Draw your bridge here")
#grid(columns: (1fr, 1fr), column-gutter: 5mm, work-space(height: 24mm, style: "lines", label: "Why is your bridge strong?"), work-space(height: 24mm, style: "lines", label: "What would you change?"))

// ---------------------------------------------------------------- 12–13 · spread: a timeline across both pages
#spread-start()
#titled("Rome on a timeline", sub: "Write each event's letter above the right place on the line. The line runs across both pages.")
#block(height: 96mm, grid(columns: (1fr,) * 3, rows: (1fr, 1fr), gutter: 4mm,
  event-card("A", [Rome is founded (the story says by Romulus).], pic: none),
  event-card("B", [Rome becomes a republic. No more kings.]),
  event-card("C", [The Via Appia, the first great Roman road, is built.], pic: img("via-appia.jpg")),
  event-card("D", [Julius Caesar is killed in the Senate.]),
  event-card("E", [Augustus becomes the first emperor.], pic: img("augustus-prima-porta.jpg")),
  event-card("F", [The Colosseum opens.], pic: img("colosseum-forum.jpg")),
))
#v(1fr)
#timeline-part(-800, -150, first: true, height: 110mm)
#pagebreak()
#titled("Use the timeline", sub: "The dates you need are on the cards: 753 BC, 509 BC, 312 BC, 44 BC, 27 BC, AD 80.")
#context {
  let t = TH.get()
  block(height: 1fr, {
    recall(([How many years passed between A and B?], [Which came first, the Via Appia or Augustus? How do you know?], [How old was the Via Appia when the Colosseum opened?]), lines: 1)
    work-space(style: "grid", label: "Work it out")
  })
}
#timeline-part(-150, 500, first: false, height: 110mm)

#pagebreak()

// ---------------------------------------------------------------- graphic organizers
#subunit("2.6", "Thinking tools")
#titled("Compare: Greek and Roman cities", sub: "Use what you know from Unit 1 (Greece) and this unit.")
#venn("Greek cities", "Roman cities", a-example: [city-states, each with its own rules], both-example: [temples and theatres], b-example: [one empire, roads join the cities],
  prompt: [Which difference matters most? Why? Use a compare word from the top of the page.])
#pagebreak()
#titled("Word study: Frayer models", sub: "Two key words. Fill the four boxes around each word.")
#frayer("ROM-011")
#v(5mm)
#frayer("ROM-001")
#pagebreak()
#titled("Word study: Frayer models", sub: "Two more key words.")
#frayer("ROM-004")
#v(5mm)
#frayer("ROM-012")
#pagebreak()
#titled("Causes and effects", sub: "Why did Rome build aqueducts? What happened because of them?")
#cause-effect([Rome builds aqueducts], cause-example: [The city grew to a million people.], effect-example: [Public fountains on every street.],
  prompt: [Which effect was the most important for ordinary people? Explain with "because".])
#pagebreak()
#titled("A process: water for a city", sub: "From the spring in the hills to a fountain in Rome, in six steps.")
#flow(example: [Find a spring high in the hills.], prompt: [Which step was the hardest for the engineers? Why?])
#pagebreak()
#titled("Concept web: Roman engineering", sub: "Six groups. Add two details to each, from the readings.")
#web([Roman engineering], ("roads", "water", "buildings", "tools", "people", "problems"), example: [Via Appia])
#pagebreak()
#titled("Main idea and details", sub: [Use the reading "Roads that held an empire" (pages 6–7).])
#temple(main-example: [Roads held the empire together.], detail-example: [Soldiers could march 30 km a day.])
#pagebreak()

// ---------------------------------------------------------------- review, then Notes and the back cover (to a multiple of 4 pages)
#subunit("2.6", "Review")
#titled("How did I do?", sub: "Colour a circle at the start of the unit, and again at the end.")
#self-check((
  [explain why Rome built roads and aqueducts],
  [use the 12 key words in a sentence],
  [find information in a reading by paragraph],
  [solve one-step and two-step equations],
  [name and draw acute, right, obtuse and straight angles],
  [put events from Roman history in order on a timeline],
))
#v(4mm)
#work-space(height: 1fr, style: "lines", label: "What was the most interesting thing you learned? What is still hard?")

#finish-booklet(back: back-cover(school: "School Name", credits: [
  Pont du Gard: Benh LIEU SONG, CC BY-SA 3.0 · Colosseum and forum: Wilfredor, CC0 · Via Appia, Augustus of Prima Porta,
  Trajan's Column: public domain · all from Wikimedia Commons. Vocabulary drawings: original, made for Chalkline.
]))
