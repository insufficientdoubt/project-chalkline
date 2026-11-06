// Every printable is laid out by the packet kit (kit.worksheet: A4, the theme in `packet-theme:`, Name /
// Class / Date, the title, "Page 1 of 2"; the teacher edition when the page has `edition:`). Posters
// (`layout: poster`) keep the older `article` layout in typst-template.typ. Replaces Quarto's default.
#let chalkline-layout = "$if(layout)$$layout$$endif$"
#show: doc => if chalkline-layout != "poster" {
  kit.worksheet(
    theme: "$if(packet-theme)$$packet-theme$$else$sky$endif$",
    title: [$if(title)$$title$$endif$],
    subtitle: $if(subtitle)$[$subtitle$]$else$none$endif$,
    unit: [$if(unit-name)$$unit-name$$endif$],
    teacher: $if(edition)$true$else$false$endif$,
    name: $if(name-box)$true$else$true$endif$,
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
