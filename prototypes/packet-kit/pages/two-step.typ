// Shared by the packet (mini-packet.typ) and the loose sheet (sheets/). Images by absolute path.
#import "../kit.typ": *
#let img(name) = "/_extensions/chalkline/guide/images/units/" + name
#let pn(n) = context box(text(font: TH.get().label-font, size: 8pt, weight: "bold", fill: TH.get().accent, "¶" + str(n)) + h(3pt))

#section("E", "Two-step equations", instructions: [Solve each equation. Show every step in the box. Check your answer by putting it back into the equation.])
#problems(cols: 2, items: (
  ([$3x + 5 = 20$], [5], [3x = 15 \ x = 5 \ check: 3·5 + 5 = 20 ✓]),
  ([$2x - 7 = 9$], [8], [2x = 16 \ x = 8]),
  ([$x / 4 + 3 = 8$], [20], [x/4 = 5 \ x = 20]),
  ([$5x + 2 = 3x + 10$], [4], [2x + 2 = 10 \ 2x = 8 \ x = 4]),
  ([$4(x - 2) = 20$], [7], [x − 2 = 5 \ x = 7]),
  ([$7 - 2x = 1$], [3], [−2x = −6 \ x = 3]),
))
