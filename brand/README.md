# brand/

> **Official colors and logo; placeholder fonts.** The palette comes from the school's color swatches and the emblem is the official logo. The fonts (Poppins and Source Sans 3) are still stand-ins until marketing confirms the school fonts.

## What's here

| File | What it controls |
|---|---|
| `_brand.yml` | **Start here.** Colors, fonts, and which logo files to use. Applies to web pages, slides, and PDFs. |
| `logos/logo-emblem.png` | The official round emblem. Used large: top of page 1 of PDFs. |
| `logos/boat-illustration.svg` | The full White Dolphin boat illustration (the bookmark artwork). Source for the icon; too detailed to use small. |
| `logos/icon-sailboat.svg` | Small icon (white sail and orange hull on a blue circle), simplified from the boat illustration. Used tiny: favicon, slide corners, PDF page headers, website navbar. The emblem isn't readable at those sizes. |
| `logos/icon-sailboat-navy.svg` | One-color version of the icon, for printing in a single color. |
| `revealjs.scss` | The school's slide settings: fonts, and the **official** slide style (`slide-scheme: official`): marketing's colour bands around the edge, the emblem top right, titles with a three-colour line. Example deck: *Welcome to Mingwan* in My templates (`course/guide/01-my-templates/official-slides.qmd`). |
| `fonts/` | The web and slide fonts named in `_brand.yml` (Source Sans 3, Poppins). |
| `styles.scss` | The school's own web-page settings: the font fix, and anything you want to change. Loads after Chalkline's, so it wins. |
| `revealjs.scss` | The school's own slide settings: the slide fonts, and anything you want to change. Loads after Chalkline's. |

The school's name, printed in PDF headers and footers, is `school:` in `_quarto.yml`.

**Chalkline's design** (page, slide and PDF layouts) is in the Chalkline extension, not here: `_extensions/chalkline/styles/` (web pages and slides), `_extensions/chalkline/typst/` (PDF layouts: title banner, Name/Period/Date fields, headings, word-bank and answer-key boxes, header, footer, teacher tab, posters, playful) and `_extensions/chalkline/fonts/print/` (PDF fonts). They take their colors from `_brand.yml`, so a new brand needs no changes there. To change how something looks for this course, add a rule to `styles.scss` or `revealjs.scss` here instead of editing the extension.

## Colors

The school's 10 swatches are consolidated to 4 brand colors and 2 neutrals:

| Name | Hex | Use it for |
|---|---|---|
| **navy** | `#003477` | All text accents, headings, banners. The only text color besides body ink. |
| **blue** | `#0087ff` | Stripes, rules, buttons, big shapes. Too light for small text. |
| **turquoise** | `#14d7cd` | Decoration only. Put navy text on it, never white. |
| **orange** | `#ff8c0f` | Warm highlight and teacher-only items (answer keys, teacher tab). Navy text on it, never white. |
| sky | `#ebf7fd` | Pale panels: section headings, word banks, table stripes. |
| ink | `#1F2933` | Body text. |

Yellow `#fbc400` and cyan `#0abee6` are kept only for charts and polls that need more than four colors. The other swatches were dropped: `#004694` is nearly identical to navy, and the grays/whites are covered by sky and white.

## Changing the brand later

1. Put new logo files in `logos/`. SVG is best; PNG works too.
2. In `_brand.yml`, update the hex codes under `palette:`, the font names under `typography:`, and the logo paths if the file names changed.
3. Keep the palette names Chalkline uses (`navy`, `blue`, `turquoise`, `orange`, `sky`): pages, slides and PDFs take their colors from them. New fonts: also change the font lists in `styles.scss` and `revealjs.scss` here. (The toolbox, games and activities take their colors, corners and shadows from `_extensions/chalkline/ui/ui.css`, which still has the sample's hex codes.)
4. Run `quarto render`.

## Worksheet options (set at the top of a `.qmd` file)

```yaml
doc-type: Work Packet   # small label at the top right and in the footer
name-box: true          # draws Name / Period / Date fields under the title (PDF)
```

The teacher build adds an orange **TEACHER EDITION** tab to every PDF page. That text is set by `edition:` in `_quarto-teacher.yml`.

## Posters (set at the top of a poster's `.qmd` file)

```yaml
layout: poster        # use the poster layout instead of the worksheet layout
papersize: a3         # posters print on A3; everything else is A4
poster-theme: dark    # optional: navy background with white text
hide-title: true      # optional: no title banner (when a big quote is the title)
poster-center: true   # optional: center the content up and down the page
```

The poster blocks (`.value`, `.big-quote`, `.steps`) are described in the main README. Their PDF look is in the extension's `typst/typst-template.typ` (`poster-value`, `poster-quote`, `poster-steps`) and their web look in its `styles/styles.scss`.

## Playful worksheets, for younger students (set at the top of a printable's `.qmd` file)

```yaml
layout: playful       # handwriting fonts, a hand-drawn frame, a dashed "cloud" title, a big Name line
playful-theme: nature # optional: a green frame and title, leaves in the corners and beside headings
name-box: true        # the Name and Date line
```

Fonts: **Patrick Hand** for text and **Fredoka** for titles and numbers (both SIL Open Font License, in the extension's `fonts/print/`). Inside a playful printable, raw Typst blocks can use the playful kit from the extension's `typst/typst-template.typ`:

```{=typst}
#doodle("robot", width: 1.2in)       // line art to color: robot, pencil, star, gear, sun, cloud, sparkle,
                                     //   leaf, flower, tree, ladybug, butterfly, mushroom, bee, snail
#star-num(3)                         // a number in a star (or #flower-num(3), in a flower)
#work-box(height: 1.4in)[Draw it!]   // a dashed box with room to work
```

The doodles are simple outlines drawn for Chalkline. For more (animals, school things), add bought or openly licensed clip art and credit it like any picture. Example: `course/units/04-stem/garden-times-tables.qmd`.

## Writing space, checkboxes, callouts

Use the shortcodes from the main README (`{{< lines 3 >}}`, `{{< drawing-box >}}`, `::: {.keep}`, `::: {.write-in}`). They call `answer-lines`, `drawing-box`, `keep` and `write-in` in the extension's `typst/typst-template.typ`, so writing space looks the same on every worksheet.

Type `☐` anywhere for a drawn checkbox.

Any callout whose title contains "Answer" or "Teacher" (like `::: {.callout-note title="Answer key"}`) gets the orange teacher style. Every other callout gets the blue style.

Chinese text in PDFs uses Noto Sans SC automatically (in the extension's `fonts/print/`); web pages use the computer's own Chinese font. All font files are in the project, so builds work without the internet.
