# Packet kit: a prototype (capabilities test)

Print themes and page layouts for packets, written straight in Typst (no Quarto yet), to see what the PDF side can do before building it into Chalkline. **Not used by the site.**

    python prototypes/packet-kit/build.py      # out/mini-packet-sky.pdf, -trail.pdf, -blueprint.pdf, -sky-loose.pdf, printer-test.pdf
    python prototypes/packet-kit/sheets.py     # out/sheet-<theme>.png: every page, laid out as spreads

- `kit.typ`: the themes and the pieces.
- `mini-packet.typ`: a 16-page sample packet ("Roads of Rome") that uses every layout.
- `printer-test.typ`: one page per theme with every colour, tint, line, surface and text size. Print it, photocopy the print, and tick what still shows on both.

## Themes

Three, echoing the slide schemes, all print-safe. Paper stays white. Colour goes only into lines, small marks and very light tints, which turn pale grey on a black-and-white copier. Each theme is one dictionary of tokens (ink, heading, accent, tint, line colours, fonts, corner radius, box stroke, section, badge and rule style), like the slide tokens.

- **Sky:** soft and rounded. Poppins headings, blue accents, soft bands behind section titles.
- **Trail:** a field notebook. Serif headings, dashed "stitched" boxes, a zigzag rule, square badges.
- **Blueprint** (Night, for paper): navy lines, square corners, a monospace label font, a drafting-grid cover panel.

## Pieces

| Piece | What it does |
|---|---|
| `work-space(width, height, style, label)` | A space to write or draw. `height: auto` fills the rest of the page. Style: blank, lines, grid, dots. Half width: put two in a `grid`. |
| `problems(cols: 2 or 3, items)` | Math problems in tall cells that fill the page. Each cell has the problem at the top, a grid or dots to work on, and an answer box at the bottom. |
| `vocab-hunt(entries)` | Where, Clue, Word, in two tables side by side. The Word column is wide enough to write in. |
| `recall(questions)` | Questions with two answer lines each, for full sentences. |
| `sequence(events)` | A box for the order, then the event. |
| `panel(title)` | A boxed prompt ("Name the reading", "Think about it"). |
| `reading-page(passage, questions, beside)` | The passage in two columns across the top. The lower half has a picture or word box on the left and the questions box on the right. |
| `gloss(word, meaning, zh)` | The word in bold, its meaning in the outer margin level with the line. Notes that would overlap are pushed down. Needs a wide outer margin (the reading spread uses 54 mm). |
| `angle-pic`, `event-card`, `timeline-part` | Reference drawings, timeline cards, and a timeline drawn across two facing pages. |
| `feature-spread(title, kicker, standfirst, panorama, left-box, right-box)` | A magazine spread. One panorama runs across both pages, over the spine. The text is in two columns flowing from the left page to the right, with pictures (`col-picture`, floats, so no gaps) and a `pull-quote` set in. A box crosses the foot of both pages, open at the spine, with a badge sitting on the fold. The panorama and box are drawn as page backgrounds in space the text is kept out of, so the halves always line up. The text must fit two pages (about 900 words with two pictures). |
| `landscape(body)` | A landscape worksheet turned 90° on a normal portrait page, so the packet still prints and staples as one. |
| `vgloss("ROM-011")` | A gloss whose meaning and 中文 come from `vocab/data/vocab.csv`, so it can't disagree with the vocab list. |
| `spread-start()` | The next page is a left-hand page. If that leaves an empty page, Typst adds it and it's drawn as a Notes page. |
| `finish-booklet()` | Pads the end with Notes pages to a multiple of 4, for a folded, stapled booklet. |

## Settings

- `--input theme=sky|trail|blueprint`.
- `--input booklet=false` makes **loose sheets** (printed double-sided, stapled in the corner): no facing pages, so no forced left-hand pages, no padding, and equal margins. The feature spread still assumes facing pages; in loose mode it should become two separate pages (not done).

## What we learned

- **Solid** (Typst does it natively, no extra passes):
  - stretching a box to fill the page;
  - grid, line and dot surfaces;
  - facing-page margins;
  - "start on a left-hand page";
  - floating a picture to the next page so text fills the gap.
- **Needed care:**
  - **Anything that measures page numbers and then adds pages** (the first versions of `spread-start` and `finish-booklet`) can fail to settle within Typst's five layout passes. The fixes: let Typst add the blank page itself and draw the Notes on it as a background, and measure from a label the padding can't move.
- **Didn't work, so changed:**
  - **A box pinned to "the bottom of the right column"** lands wherever the text happens to end. `reading-page` uses a fixed layout instead: the passage on top, the questions box in the lower right. The limit is that the passage has to fit in the top half.
- **Running headers lagged a page** when they read "the current section" as state: the header is drawn before the page's own section title. Fixed by putting a marker at each title and having the header look for one on its own page.
- **Pictures in columns** that are plain blocks leave gaps when they don't fit at the bottom of a column. As floats (`place(auto, float: true)`), text fills in around them.
- **Page references move.** "Top of page 2" changes whenever a picture or margin changes, so the vocab hunt points to paragraph numbers (`¶3`), shown in the reading.

## Not done (next, if we build it)

- Wiring it into Quarto. Today a worksheet is a `.qmd` that Quarto turns into Typst. The pieces would become shortcodes or classes (`::: {.work-space size="half"}`), and the theme a setting (`packet-theme: trail`).
- Checking the themes on the school's printer. The pale tints and dotted lines are the parts most likely to vanish or come out too dark.
