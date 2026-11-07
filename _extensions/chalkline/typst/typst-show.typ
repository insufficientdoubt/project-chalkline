// Every printable is laid out by the packet kit; a packet (packet-booklet: true) by kit.booklet. Otherwise (kit.worksheet: A4, the theme in `packet-theme:`, Name /
// Class / Date, the title, "Page 1 of 2"; the teacher edition when the page has `edition:`). Posters
// (`layout: poster`) keep the older `article` layout in typst-template.typ. Replaces Quarto's default.
#let chalkline-layout = "$if(layout)$$layout$$endif$"
#show: doc => if $if(packet-booklet)$true$else$false$endif$ {
  // a unit or year packet (scripts/packets.py): the whole book as an A3-folded booklet
  kit.booklet(
    theme: "$if(packet-theme)$$packet-theme$$else$sky$endif$",
    title: [$if(title)$$title$$endif$],
    unit: [$if(unit-name)$$unit-name$$endif$],
    teacher: $if(edition)$true$else$false$endif$,
    school: [$if(school)$$school$$endif$],
    doc,
  )
} else if chalkline-layout != "poster" {
  kit.worksheet(
    theme: "$if(packet-theme)$$packet-theme$$else$sky$endif$",
    title: [$if(title)$$title$$endif$],
    subtitle: $if(subtitle)$[$subtitle$]$else$none$endif$,
    unit: [$if(unit-name)$$unit-name$$endif$],
    teacher: $if(edition)$true$else$false$endif$,
    name: $if(opens-full-page)$false$else$true$endif$,
    show-title: $if(opens-own-title)$false$else$auto$endif$,
    goes-with: $if(goes-with)$"$goes-with$"$else$none$endif$,   // "page 5": where it starts in its unit packet (filter.lua)   // a full-page Venn or KWL has its own title and Name
    doc,
  )
} else { article(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(doc-type)$
  doc-type: [$doc-type$],
$endif$
$if(edition)$
  edition: [$edition$],
$endif$
$if(name-box)$
  name-box: true,
$endif$
$if(layout)$
  layout: "$layout$",
$endif$
$if(poster-theme)$
  poster-theme: "$poster-theme$",
$endif$
$if(hide-title)$
  poster-title: false,
$endif$
$if(poster-center)$
  poster-center: true,
$endif$
$if(playful-theme)$
  playful-theme: "$playful-theme$",
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(brand.typography.base.family)$
  font: $brand.typography.base.family$,
$endif$
$if(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(brand.typography.headings.family)$
  heading-family: $brand.typography.headings.family$,
$endif$
  colors: brand-color,
  logos: brand-logo-images,
$if(school)$
  school: [$school$],
$endif$
  doc,
)
}
