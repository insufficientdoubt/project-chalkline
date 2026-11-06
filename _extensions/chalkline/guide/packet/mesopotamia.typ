// A second sample: a colleague's Mesopotamia worksheets, rebuilt with the kit (a 12-page booklet).
//   python prototypes/packet-kit/build.py   ->   out/mesopotamia-<theme>.pdf (and -teacher)
#import sys.inputs.at("kit", default: "/_extensions/chalkline/typst/packet") + "/kit.typ": *
#import sys.inputs.at("kit", default: "/_extensions/chalkline/typst/packet") + "/history.typ": *
#let theme = sys.inputs.at("theme", default: "trail")
#let U = sys.inputs.at("guide", default: "/_extensions/chalkline/guide") + "/images/units/"
#let H = U + "hammurabi-stele.jpg"      // the Code of Hammurabi, Louvre (Mbzt, CC BY 3.0), 1215 × 2000 px
#let B = U + "burney-relief.jpg"         // the Burney Relief, British Museum (CC0), 1280 × 1703 px

#show: packet.with(theme: theme, title: "Gods, kings and laws", unit: "Unit 1 · Mesopotamia")

#about("Title page (decoration)", uses: ("the front of any unit packet",), pieces: ("title-page",))
#title-page(course: "Grade 6 Social Studies", unit: "Mesopotamia", unit-number: "1", teacher: "Ms. Teacher Name",
  school: "School Name", year: "2026–27 · Term 1",
  hero: none)

// ---------------------------------------------------------------- 2–3 · the source dossier: two sources, facing
#spread-start()
#unit-start("1", "Mesopotamia")
#subunit("1.1", "Sources")
#about("Source dossier card", uses: ("one primary source per page: an artifact, painting, map, photo or document", "museum and gallery studies", "science specimens with labelled features",), pieces: ("source-card", "crop", "marker", "quote-box",))
#source-card(region: "Babylon · 巴比伦", number: 1, title: "The Code of Hammurabi", title-zh: "《汉谟拉比法典》石碑：太阳与正义之神沙马什",
  picture: grid(columns: (1fr, 15mm), column-gutter: 3mm, align: bottom,
    crop(H, 1215, 2000, 400, 30, 850, 590, width: 66mm, markers: ((1, 760, 175), (2, 612, 330), (3, 545, 150), (4, 650, 505))),
    [#crop(H, 1215, 2000, 330, 20, 900, 1960, width: 15mm) #text(size: 6.5pt)[the whole stele]]),
  caption: [The top of the stele: King Hammurabi (left) stands before Shamash, the sun god (right).],
  glance: (("What", "a stele (stone slab)"), ("When", "about 1754 BCE"), ("Made of", "basalt"), ("Size", "2.25 m tall"), ("Found", "Susa, Iran, 1901"), ("Now", "Louvre, Paris")),
  notes: (
    (1, "Horned crown", "牛角冠", [Rows of horns show that a figure is a god. Shamash wears four.], [层层牛角代表神明身份。]),
    (2, "Rod and ring", "权杖与绳环", [Measuring tools: a builder's rod and rope. They stand for order, fairness and the right to rule.], [测量工具，象征秩序、公正与统治权。]),
    (3, "Hand to the mouth", "以手掩口", [Hammurabi's gesture shows respect and prayer, standing before a god.], [表示敬意与祈祷。]),
    (4, "Mountain pattern", "山形纹样", [The rows under Shamash's feet are mountains: the sun rises over them.], [脚下的纹样代表山峦，太阳从中升起。]),
  ),
  context-en: [Hammurabi was king of Babylon. Near the end of his reign he had 282 laws carved on this stone and set up in public. Most people could not read cuneiform, but everyone could see the picture at the top: the king receiving the right to rule from Shamash, the god of the sun and of justice. The message was clear. The laws did not come from one man's opinion; they came from the gods.],
  context-zh: [汉谟拉比是巴比伦国王。他把282条法律刻在这块石碑上，立在公共场所。大多数人不识楔形文字，却都能看懂顶部的浮雕：国王从太阳与正义之神沙马什手中接受统治权。法律不是一个人的意见，而是来自神明。],
  extra: quote-box("FROM THE PROLOGUE · 法典序言选段", [… to bring about the rule of righteousness in the land, to destroy the wicked and the evil-doers; so that the strong should not harm the weak.], [……使正义之治行于大地，消灭恶人与作恶者，使强者不欺凌弱者。]),
  citation: [_Stele of the Code of Hammurabi._ c. 1754 BCE, basalt, 225 cm. Musée du Louvre, Paris, Sb 8.],
  credit: [Mbzt, CC BY 3.0, via Wikimedia Commons. Translation: L. W. King, 1910.])
#pagebreak()
#source-card(region: "Southern Mesopotamia · 美索不达米亚南部", number: 2, title: "The Burney Relief (Queen of the Night)", title-zh: "伯尼浮雕（夜之女王）",
  picture: stack(spacing: 2mm,
    crop(B, 1280, 1703, 230, 0, 1050, 440, width: 84mm, markers: ((1, 470, 70), (2, 960, 120))),
    crop(B, 1280, 1703, 0, 1020, 1280, 1703, width: 84mm, markers: ((3, 620, 1460), (4, 900, 1330), (5, 1130, 1150)))),
  caption: [Two details: look up (the crown and hands), then look down (the feet, the lions and the owls).],
  glance: (("What", "a clay plaque"), ("When", "about 1750 BCE"), ("Made of", "fired clay"), ("Size", "50 × 37 cm"), ("Found", "southern Iraq"), ("Now", "British Museum")),
  notes: (
    (1, "Horned crown", "牛角冠", [Four rows of horns: she is a goddess, and a powerful one.], [四层牛角：一位强大的女神。]),
    (2, "Rod and ring", "权杖与绳环", [The same symbol Shamash holds on Source 1. What could it mean here?], [与史料一中沙马什手持的相同。]),
    (3, "Bird's talons", "鸟爪", [Her feet are a bird's claws, and she has wings: part human, part bird of prey.], [鸟爪与双翼：半人半猛禽。]),
    (4, "Lions", "雄狮", [She stands on two lions, the strongest animals people knew.], [脚踏两头雄狮。]),
    (5, "Owls", "猫头鹰", [Owls hunt at night. Many think this links her to night or the underworld.], [猫头鹰夜间捕猎，或与夜晚、冥界有关。]),
  ),
  context-en: [This plaque was made of clay and baked hard, and it was once painted: traces of red and black paint survive. Nobody knows exactly where it was found, and there is no writing on it, so historians have to read the picture itself. The wings, talons, owls and lions all point to great power, perhaps over the night or the world of the dead.],
  context-zh: [这块浮雕由黏土烧制而成，原本涂有颜色，至今仍可见红色和黑色的痕迹。它的出土地点不明，上面也没有文字，所以历史学家只能“读”图像本身。],
  context-label: ("Historical context", "历史背景"),
  extra: context {
    let t = TH.get()
    block(width: 100%, stroke: t.box-stroke, radius: t.radius, inset: 7pt, [
      #text(font: t.label-font, size: 8pt, weight: "bold", fill: t.hot, "HISTORIANS DISAGREE · 史学家的分歧")
      #v(1mm)
      #text(size: 9pt)[Who is she? Three ideas: *Ishtar* (Inanna), goddess of love and war; *Ereshkigal*, queen of the underworld; or *Lilitu*, a demon of the night. Which markers support each idea?]
    ])
  },
  citation: [_The Queen of the Night (Burney Relief)._ c. 1750 BCE, fired clay, 49.5 × 37 cm. British Museum, London, 2003,0718.1.],
  credit: [British Museum, CC0, via Wikimedia Commons.])

// ---------------------------------------------------------------- 4–5 · two investigations, facing
#spread-start()
#subunit("1.2", "Investigating sources")
#about("Source investigation (Observe, Infer, Evidence)", uses: ("analysing any primary source", "a picture or artwork study", "a science observation: observe, infer, conclude",), pieces: ("investigation",))
#investigation("A", ("Stele of Hammurabi", "Burney Relief"))
#pagebreak()
#investigation("B", ("Stele of Hammurabi", "Burney Relief"), connect: [Both sources show the *rod and ring*. What does that tell you about how Mesopotamians saw gods and power?])
#pagebreak()

// ---------------------------------------------------------------- 6 · the challenge
#about("Design challenge with a field guide", uses: ("a creative extension", "inventing an artifact, a creature, a machine or a flag", "design and explain",), pieces: ("design-artifact",))
#design-artifact()
#pagebreak()

// ---------------------------------------------------------------- 7–9 · the formative assessment
#subunit("1.3", "Check your learning")
#about("Short-answer assessment", uses: ("formative or summative tests", "a quiz with marks shown", "a check-in at the end of a lesson sequence",), pieces: ("assessment-head", "short-answer",))
#assessment-head("Early river civilizations", "Section 1: content recall and short answer · 第一部分：知识回顾与简答", total: 25,
  instructions: [You may use your packet and notes. [2] = 2 marks; the lines show about how much to write. Section 2 is one paragraph (pages 8–9). #text(fill: luma(110))[可使用学习手册和笔记。]])
#short-answer(1, [What does the Greek word _Mesopotamia_ mean? Why is a Greek word used for this place?], [“Mesopotamia”在希腊语中是什么意思？为什么用希腊语命名这个地区？], 2, answer: [The land between the rivers. Greek writers named it long after.])
#short-answer(2, [Name the two rivers that frame the Mesopotamian valley.], [请写出构成美索不达米亚河谷的两条河流。], 2, lines: 1, answer: [The Tigris and the Euphrates.])
#short-answer(3, [The Sumerians faced floods and droughts. Name ONE thing they built to control water.], [苏美尔人为控制水资源修建了什么？写出一项。], 2, lines: 1, answer: [Irrigation canals (or levees, dams, reservoirs).])
#short-answer(4, [Mesopotamia had no natural barriers. How did Sumerians protect their cities?], [美索不达米亚缺乏天然屏障，苏美尔人如何保护城市？], 2, lines: 1, answer: [They built thick city walls (and armies).])
#short-answer(5, [What is _polytheism_? Name one Mesopotamian god and what they controlled.], [什么是“多神教”？举出一位神明及其掌管的领域。], 3, answer: [Belief in many gods. Shamash: the sun and justice.])
#short-answer(6, [Compare the Mesopotamian view of the afterlife with your own, or with traditional Chinese ideas.], [将美索不达米亚人的来世观与你自己的或中国传统观念作比较。], 3)
#short-answer(7, [Look at the social pyramid. Who was at the top, and who at the bottom? Why?], [观察社会金字塔：谁在顶端，谁在底层？为什么？], 3, answer: [Kings and priests at the top, enslaved people at the bottom: power came from the gods and land.])
#pagebreak()

#about("Paragraph task with a rubric", uses: ("an extended response with a command term", "an MYP criterion task", "any task marked with a rubric",), pieces: ("command-term", "rubric", "panel",))
#[#metadata("Section 2: the paragraph") <section-title>]
#context text(font: TH.get().head-font, weight: "bold", size: 15pt, fill: TH.get().head)[Section 2: the paragraph #h(1fr) #marks(8)]
#context text(size: 9.5pt, fill: TH.get().muted)[第二部分：段落写作 · Criterion A: Knowing and understanding]
#v(2mm)
#panel(title: "The big idea:")[People turned unpredictable rivers into the world's first cities, and their solutions became the foundations of civilization. \ #text(size: 8.5pt, fill: luma(110))[人类把难以预测的河流环境变成世界上最早的城市，他们的解决方案成为文明的基石。]]
#v(2mm)
#context {
  let t = TH.get()
  text(size: 10pt)[Choose *one* environmental challenge the Sumerians faced. Write a paragraph of *5 to 7 sentences* that explains:]
  v(1mm)
  for (n, s, zh) in ((1, [how the Sumerians solved it,], [苏美尔人如何解决这一挑战，]), (2, [how the solution changed their society (cooperation, leaders, social classes),], [这一方案如何改变了社会，]), (3, [how a more complex society came to need laws, like Hammurabi's Code.], [日益复杂的社会如何需要像《汉谟拉比法典》那样的法律。])) {
    block(below: 1.5mm, grid(columns: (6mm, 1fr), box(width: 3.8mm, height: 3.8mm, stroke: 0.8pt + t.head, radius: 1pt), [#text(size: 9.5pt)[*#n.* #s] #text(size: 8.5pt, fill: t.muted, zh)]))
  }
}
#v(2mm)
#command-term("explain", "解释", [Show *how* and *why* things are connected: this happened, *so* that changed, *which led to* … Not a list of facts, but a chain of causes. \ 说明事物之间“如何”以及“为什么”相互联系。])
#rubric("explain", "Criterion A: what each level looks like", (
  ("1–2", [Lists a few facts. The links between them are missing or unclear. Few subject words.], ["Gutenberg made the printing press. People read books. Society changed."]),
  ("3–4", [Describes the events in order, with some links. Uses some subject words.], ["After Gutenberg invented the printing press, more books were made, so more people read."]),
  ("5–6", [Explains how the events are connected in time and cause. Uses subject words correctly.], ["The printing press made books cheaper, so new ideas spread quickly and more people learned to read."], true),
  ("7–8", [Explains the connections in detail, with examples, and shows why they matter.], ["Because the press cut the cost of books, ideas spread across Europe in years, not centuries; literacy rose, and with it the demand for schools."]),
))
#pagebreak()

#about("Paragraph planner and writing page", uses: ("planning then writing a paragraph", "explain or argue: a chain of reasons", "a lab conclusion",), pieces: ("paragraph-chain", "writing-lines", "panel",))
#[#metadata("Section 2: plan and write") <section-title>]
#context text(font: TH.get().head-font, weight: "bold", size: 15pt, fill: TH.get().head)[Plan, then write]
#context text(size: 9.5pt, fill: TH.get().muted)[先规划，再写作。Fill in the chain first: each box becomes one or two sentences.]
#v(2mm)
#paragraph-chain((
  ("The challenge", [floods? drought? no stone? no barriers?]),
  ("The solution", [what they built or did]),
  ("The change", [who had to work together? who led?]),
  ("The need for laws", [why rules had to be written down]),
))
#v(3mm)
#context text(font: TH.get().head-font, weight: "bold", fill: TH.get().head)[My paragraph]
#v(1mm)
#writing-lines(n: 13)
#v(2mm)
#panel(title: "Before you hand it in:")[#context { let t = TH.get(); for s in ([I chose one challenge], [I explained the links with *so*, *because*, *which led to*], [I used subject words (irrigation, surplus, city-state, code)], [I wrote 5 to 7 sentences]) { box[#box(width: 3.5mm, height: 3.5mm, stroke: 0.8pt + t.head, radius: 1pt) #h(2pt) #text(size: 8.5pt, s)]; h(4mm) } }]

#finish-booklet(back: back-cover(school: "School Name", credits: [
  Code of Hammurabi: Mbzt, CC BY 3.0 · Burney Relief: British Museum, CC0 · both via Wikimedia Commons. Translation of the Code: L. W. King (1910), public domain.
]))
