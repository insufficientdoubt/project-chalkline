// Shared by the packet (mini-packet.typ) and the loose sheet (sheets/). Images by absolute path.
#import "../kit.typ": *
#let img(name) = "/_extensions/chalkline/guide/images/units/" + name
#let pn(n) = context box(text(font: TH.get().label-font, size: 8pt, weight: "bold", fill: TH.get().accent, "¶" + str(n)) + h(3pt))

#section("A", "Vocabulary hunt", instructions: [Go to the paragraph in the reading (¶3 = paragraph 3). Find the word that matches the clue and write it in the Word box. A bold word part (*un-*, *-ly*) means the word has that prefix or suffix.])
#vocab-hunt((
  ("¶1", none, [_n._ a group of lands ruled by one leader], "empire"),
  ("¶1", none, [_n._ people who fight in an army], "soldiers"),
  ("¶1", none, [_n._ a long trip], "journey"),
  ("¶2", none, [_n._ one level of material on top of another], "layer"),
  ("¶2", none, [_n._ small stones], "gravel"),
  ("¶2", none, [_adj._ bent like part of a circle], "curved"),
  ("¶2", none, [_v._ to let water flow away], "drain"),
  ("¶2", none, [_adj._ strong; hard to break], "sturdy"),
  ("¶3", none, [_n._ a stone that shows how far you have come], "milestone"),
  ("¶3", none, [_n._ people who buy and sell things], "merchants"),
  ("¶4", "-er", [_n._ people who make things], "builders"),
  ("¶4", none, [_n._ a channel or bridge that carries water], "aqueduct"),
  ("¶4", none, [_n._ the force that pulls things down], "gravity"),
  ("¶4", none, [_n._ a surface that goes slowly up or down], "slope"),
  ("¶5", none, [_n._ low land between hills], "valley"),
  ("¶5", none, [_n._ curved shapes that hold up a bridge], "arches"),
  ("¶5", "un-", [_adj._ still in one piece], "unbroken"),
  ("¶6", "-ly", [_adv._ with great care], "carefully"),
  ("¶6", "-ous", [_adj._ known by many people], "famous"),
  ("¶6", none, [_v._ to fix], "repair"),
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
  ([Why did Rome need roads?], [To move soldiers, letters and food quickly around the empire.]),
  ([What were the layers of a Roman road?], [Large stones, then gravel and sand, then flat paving stones.]),
  ([Why was the top of the road curved?], [So rain ran off to the sides and the road stayed dry.]),
  ([How did water move along an aqueduct without pumps?], [Gravity: the channel sloped gently downhill all the way.]),
))
#section("C", "Building a road", instructions: [Number the steps from 1 to 6 in the order the builders did them.])
#sequence(order: (4, 1, 6, 2, 5, 3), (
  [Lay flat paving stones on top.],
  [Dig a deep trench.],
  [Put up a milestone every Roman mile.],
  [Fill the bottom with large stones.],
  [Make the top curved so rain runs off.],
  [Add a layer of gravel and sand.],
))
