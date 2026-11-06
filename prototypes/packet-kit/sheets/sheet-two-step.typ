// A loose sheet: the same page(s) as in the packet, printed on their own (see kit.typ, worksheet()).
#import "../kit.typ": *
#show: worksheet.with(theme: sys.inputs.at("theme", default: "sky"), title: "Two-step equations", unit: "Unit 2 · Ancient Rome", goes-with: "page 15", name: true)
#include "../pages/two-step.typ"
