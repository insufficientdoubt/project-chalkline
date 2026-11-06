// A loose sheet: the same page(s) as in the packet, printed on their own (see kit.typ, worksheet()).
#import sys.inputs.at("kit", default: "/_extensions/chalkline/typst/packet") + "/kit.typ": *
#show: worksheet.with(theme: sys.inputs.at("theme", default: "sky"), title: "Water for a city", unit: "Unit 2 · Ancient Rome", goes-with: "pages 4–5", name: false)
#include "../pages/feature-water.typ"
