// A mini packet to test the kit: every layout, in one theme. Build all three:
//   python prototypes/packet-kit/build.py
#import "kit.typ": *
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
#feature-spread(
  title: "Water for a city",
  kicker: "Feature · Roman engineering",
  standfirst: [How did a million people in ancient Rome get clean water every day, with no pumps and no electricity? The answer is still standing in the hills of Europe.],
  panorama: img("pont-du-gard.jpg"),
  credit: [Photos: Pont du Gard, Benh LIEU SONG, CC BY-SA 3.0; Via Appia and Trajan's Column, public domain; all Wikimedia Commons.],
  badge-text: "?",
  left-box: [#context text(font: TH.get().head-font, weight: "bold", size: 12pt, fill: TH.get().head, "Reflect · 想一想") #v(1mm) #reflect-items(1, ([What surprised you most about the aqueducts?], [Why did the builders need to know about gravity?]))],
  right-box: [#v(5.5mm) #reflect-items(3, ([What does your city do to bring you clean water today?], [If you were a Roman engineer, what problem would you want to solve next?]))],
)[
  #lead-in[Imagine a city] with no taps, no pipes under the street and no water trucks. Every drop for drinking, cooking and washing has to be carried from a river or a well. That was life in many towns two thousand years ago. Rome was different. By the first century AD, about a million people lived there, and water flowed into the city day and night, into fountains on the street corners, into public baths and into the houses of the rich.

  The water came through aqueducts. The first, the Aqua Appia, was built in 312 BC by Appius Claudius, the same official who built the famous road, the Via Appia. Over the next five hundred years, Rome built ten more. Together they brought in more water for each person than many cities use today.

  #col-picture(img("via-appia.jpg"), [The Via Appia. Its builder, Appius Claudius, also built Rome's first aqueduct.], height: 42mm)

  An aqueduct is simple in one way: it is a channel that carries water downhill. But making the water flow the right way for fifty or even ninety kilometres was very hard. The channel could not go uphill, not even a little, or the water would stop. If it went down too steeply, the water would rush and wear the stone away. So the engineers planned a slope so gentle that you could not see it with your eyes. Over one kilometre, the channel might drop by only the height of a hand.

  #pull-quote[No pumps, no motors: just stone, a careful slope and gravity.]

  To measure such a tiny slope, Roman surveyors used tools like the _chorobates_, a long wooden table with a groove of water on top. When the water lay flat in the groove, the table was level. From there they could mark how far each next section should drop. They walked the whole route from the spring to the city, measuring and marking, before anyone started to dig.

  Most of an aqueduct was not a bridge at all. It ran under the ground, in a covered channel that kept the water clean and cool and safe from enemies. Workers could climb down through holes along the way to clean out the mud. Only where the land dropped away, across a valley or a river, did the channel rise up onto arches.

  #col-picture(img("trajans-column-legion.jpg"), [Roman soldiers at work, from Trajan's Column. Soldiers often did the heavy building.], height: 46mm)

  The most famous of these bridges is the Pont du Gard in the south of France. It is almost fifty metres high, with three rows of arches, one on top of another. The stones on the outside were cut so well that the builders did not need mortar to hold them together. Each arch carries the weight sideways and down into the pillars, and the pillars carry it into the ground.

  When the water reached the city, it went into a big tank called a _castellum_. From there, pipes carried it to three places: first to the public fountains, then to the baths, and last to private homes, which paid for it. In a dry summer, the homes were the first to lose their water, and the fountains the last. Everyone, rich or poor, could fill a jar at a fountain.

  Keeping all this working took a small army of people. In AD 97 a man named Frontinus was put in charge of Rome's water. He found leaks, illegal pipes and channels full of stones and roots, and he wrote a book about how to fix them. It is one of the first books ever written about running a city.

  Some Roman aqueducts still carry water today. Others stand empty in fields and valleys, and visitors walk under their arches and look up. They are a reminder that the most important thing a city builds is sometimes the one nobody sees: the water that arrives, every day, at the right place.
]

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
#section("A", "Vocabulary hunt", instructions: [Go to the paragraph in the reading (¶3 = paragraph 3). Find the word that matches the clue and write it in the Word box. A bold word part (*un-*, *-ly*) means the word has that prefix or suffix.])
#vocab-hunt((
  ("¶1", none, [_n._ a group of lands ruled by one leader]),
  ("¶1", none, [_n._ people who fight in an army]),
  ("¶1", none, [_n._ a long trip]),
  ("¶2", none, [_n._ one level of material on top of another]),
  ("¶2", none, [_n._ small stones]),
  ("¶2", none, [_adj._ bent like part of a circle]),
  ("¶2", none, [_v._ to let water flow away]),
  ("¶2", none, [_adj._ strong; hard to break]),
  ("¶3", none, [_n._ a stone that shows how far you have come]),
  ("¶3", none, [_n._ people who buy and sell things]),
  ("¶4", "-er", [_n._ people who make things]),
  ("¶4", none, [_n._ a channel or bridge that carries water]),
  ("¶4", none, [_n._ the force that pulls things down]),
  ("¶4", none, [_n._ a surface that goes slowly up or down]),
  ("¶5", none, [_n._ low land between hills]),
  ("¶5", none, [_n._ curved shapes that hold up a bridge]),
  ("¶5", "un-", [_adj._ still in one piece]),
  ("¶6", "-ly", [_adv._ with great care]),
  ("¶6", "-ous", [_adj._ known by many people]),
  ("¶6", none, [_v._ to fix]),
))
#v(1fr)
#panel(title: "Word parts")[*un-* = not · *-er* = a person who · *-ly* = in this way · *-ous* = full of]
#v(3mm)
#panel(title: "Name the reading:")[The reading is called "Roads that held an empire." Give it a new title. Then explain your title.
  #v(2mm)
  Title: #box(width: 1fr, line(length: 100%, stroke: 0.6pt))
  #answer-lines(n: 2)
]
#pagebreak()

// ---------------------------------------------------------------- 5 · recall, sequence, a prompt
#section("B", "Reading recall", instructions: [Answer each question in a complete sentence.])
#recall((
  [Why did Rome need roads?],
  [What were the layers of a Roman road?],
  [Why was the top of the road curved?],
  [How did water move along an aqueduct without pumps?],
))
#section("C", "Building a road", instructions: [Number the steps from 1 to 6 in the order the builders did them.])
#sequence((
  [Lay flat paving stones on top.],
  [Dig a deep trench.],
  [Put up a milestone every Roman mile.],
  [Fill the bottom with large stones.],
  [Make the top curved so rain runs off.],
  [Add a layer of gravel and sand.],
))
#pagebreak()

// ---------------------------------------------------------------- a reading with questions in the lower right
#subunit("2.3", "Buildings")
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
#section("E", "Two-step equations", instructions: [Solve each equation. Show every step in the box. Check your answer by putting it back into the equation.])
#problems(cols: 2, items: ([$3x + 5 = 20$], [$2x - 7 = 9$], [$x / 4 + 3 = 8$], [$5x + 2 = 3x + 10$], [$4(x - 2) = 20$], [$7 - 2x = 1$]))
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
