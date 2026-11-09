# The packet kit

Print themes and page layouts for unit packets, in Typst. Packets are printed on A3 and folded.

**In Chalkline:**
- this folder (`typst/packet/`) is the kit;
- every printable's PDF is laid out with it (`typst-show.typ`: `kit.worksheet`), and so is every unit packet (`scripts/packets.py`: `kit.booklet`);
- pages are written in `.qmd` with the packet blocks (`kit-blocks.lua`); the guide's example units (`guide/examples/example-*/`) use every one;
- `scripts/packet_kit.py` builds the printer check and the list of example pages for the guide's **Packet Templates** page.

    python chalkline.py packet-kit      # the printer check and the page list, now (into _site-teacher/)

**The files:**
- `kit.typ`: the themes and the shared pieces (title page, contents, sections, work spaces, readings, glosses, word and language pages, spreads, the teacher edition, loose sheets, and `about()`, the hidden note on each page).
- `organizers.typ`: graphic organizers: KWL, Venn, Frayer, causes and effects, process flow, concept web, and main idea as a temple.
- `history.typ`: source pages: a source dossier card with photo markers, the Observe / Infer / Evidence investigation, a design challenge, and an assessment with marks, a rubric and a paragraph planner.

**Chalkline imports the kit** in `typst-template.typ`, with the path `filter.lua` works out (so it works wherever Chalkline is installed). Words and language points come to the word and language pages from `kit-blocks.lua` (Chalkline's merged lists); `edition=teacher` (or the page's `edition:`) gives the teacher edition.

**Hidden notes:** start each page with `::: {.page-about name="…" uses="…; …" pieces="…"}` (`#about(…)` in Typst). Nothing is printed. `scripts/packet_kit.py` reads them from the example pages into `packet-templates.json` for the guide page.

**Two ways to print, one design.**

- **The packet:** printed on A3 and folded. It's a booklet of A4 pages, the page count is a multiple of 4, and pages 2–3, 4–5 … face each other.
- **A loose sheet:** one worksheet printed on its own, for example something added after the packets were printed.
  - A4, with equal margins.
  - Name / Class / Date at the top, "Page 1 of 2" and "Goes with packet page 15" at the foot.
  - No Notes pages or back cover.
  - A two-page spread comes out as two A4 pages, one after the other (a landscape organizer as a real landscape page).

Each printable is one `.qmd` file: its own PDF is the loose sheet, and the unit's packet is put together from them.
- `guide/packet/printer-test.typ`: one page per theme with every colour, tint, line, surface and text size. Print it, photocopy the print, and tick what still shows on both.

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
| `picture-steps(steps, pic, height, start)` | A process, step by step: each step's picture in the left third (one height, cropped to fill it), and beside it the step's number, title and words. A step never splits across pages. In a .qmd: `::: picture-steps`. |
| `picture-column(pictures, words, pic, side, title, boxed)` | Pictures down one side (a third of the page) and one box of text beside them that runs on its own; a box shorter than the pictures is stretched to end level with them. In a .qmd: `::: picture-column`. |
| `doc-style(t)`, `text-table(keep)` | A page's own figures and tables (plain Markdown): small grey captions with no "Figure 1:"; tables as wide as the page, in the theme, a short one kept on one page. Applied for you by `worksheet` and `packet`, and by the filter for every Markdown table. |
| `reading-page(passage, questions, beside)` | The passage in two columns across the top. The lower half has a picture or word box on the left and the questions box on the right. |
| `gloss(word, meaning, zh)` | The word in bold, its meaning in the outer margin level with the line. Notes that would overlap are pushed down. Needs a wide outer margin (the reading spread uses 54 mm). |
| `angle-pic`, `event-card`, `timeline-part` | Reference drawings, timeline cards, and a timeline drawn across two facing pages. |
| `feature-spread(title, kicker, standfirst, panorama, left-box, right-box)` | A magazine spread. One panorama runs across both pages, over the spine. The text is in two columns flowing from the left page to the right, with pictures (`col-picture`, floats, so no gaps) and a `pull-quote` set in. A box crosses the foot of both pages, open at the spine, with a badge sitting on the fold. The panorama and box are drawn as page backgrounds in space the text is kept out of, so the halves always line up. The text must fit two pages (about 900 words with two pictures). |
| `landscape(body)` | A landscape worksheet turned 90° on a normal portrait page, so the packet still prints and staples as one. |
| `vgloss("ROM-011")` | A gloss whose meaning and 中文 come from `vocab/data/vocab.csv`, so it can't disagree with the vocab list. |
| `title-page(course, unit, unit-number, teacher, school, year, hero)` | The front cover. `hero` is a picture, `"placeholder"` (a dashed box), or `none` (the theme's decoration). There's a logo placeholder and a "this packet belongs to" box. |
| `unit-start(n, name)`, `subunit(n, name)`, `contents(depth)` | The contents page is built from the markers and the page titles, with real page numbers. `depth: 1` lists units, `2` units and subunits, `3` every titled page too. |
| `vocab-page(prefix, pictures)` | Key words in two columns, from `vocab/data/vocab.csv`. With pictures, it makes reference cards (picture, word, 中文, meaning, example). Without, it makes a word list with lines for the student's own sentence. |
| `language-page(ids)` | Language points from `vocab/data/frames.csv`, grouped by kind (grammar, stems, frames, questions and answers) and balanced across two columns. |
| `self-check(statements)` | "I can" statements, each rated 1–3 at the start and at the end of the unit. |
| `back-cover(school, credits)` | The last page: the school and the picture credits. |
| `spread-start()` | The next page is a left-hand page. If that leaves an empty page, Typst adds it and it's drawn as a Notes page. |
| `finish-booklet(back)` | Pads with Notes pages, then puts the back cover on the very last page, so the page count is a multiple of 4. |

## Graphic organizers

Each has the same small details, so generated pages still look thought through:
- a "Use this to …" line;
- the language students need, printed where they use it (signal words, question starters, compare frames);
- a faint grey worked example in the first space, showing the size and kind of answer;
- a "So what?" box that turns the organizer into a sentence or two.

| Organizer | What it is |
|---|---|
| `kwl-landscape`, `venn-landscape` | The same, on a landscape page. The title, instructions, language and "So what?" are in a column down the side, so the diagram gets the rest of the page. These are the ones the sample packet uses. |
| `kwl(topic, …)` | K and W marked "before reading", L "after reading". Big faint letters, starters in each column, a "Where?" column (page and ¶) for evidence, and "surprised me" and "still wondering" boxes. |
| `venn(a, b, …)` | Lined, lightly tinted circles; the overlap shows darker. Compare frames, and "So what?". |
| `frayer(id)` | The word and its 中文 from the vocab list, in the middle of four boxes (definition in your own words, facts, examples ✓, non-examples ✗). Two to a page. |
| `cause-effect(event, …)` | Three causes, the event, three effects, with signal words and arrows. |
| `flow(…)` | Six steps in a snake: a sketch box and lines in each, with order words. |
| `web(topic, branches)` | Six groups around the topic, each with two dotted detail bubbles. |
| `temple(…)` | Main idea and details as a Roman temple: the roof holds the main idea, the columns the details, the base the conclusion. |

## The teacher edition (answer keys)

`--input edition=teacher` builds the same packet with the answers written in, in red handwriting, where students write theirs, plus a TEACHER EDITION tab in the header. The answers are drawn on top of the student page, so nothing moves: the teacher's page 11 is the student's page 11. Pieces that take answers:
- `vocab-hunt`: a fourth item per entry;
- `recall`: (question, answer) pairs;
- `sequence(order:)`;
- `problems`: (problem, answer, working);
- `answer-lines(answer:)`;
- `key-here(body)` puts an answer anywhere.

## Settings

- `--input theme=sky|trail|blueprint`.
- Booklet or loose sheet isn't a setting: it's whether the file starts with `packet` or `worksheet`. Pieces that behave differently (spreads, glosses, padding) read the mode from the page.
- `scripts/packet_kit.py` puts a loose sheet's spreads on A3 afterwards (`impose()`). It asks Typst where spreads start (the `<spread-page>` markers) and places each pair of A4 pages side by side.

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

- "Goes with packet page 15" is typed in by hand here. Built into Chalkline, the packet build knows each printable's pages and can fill it in.

- Wiring it into Quarto. Today a worksheet is a `.qmd` that Quarto turns into Typst. The pieces would become shortcodes or classes (`::: {.work-space size="half"}`), and the theme a setting (`packet-theme: trail`).
- Checking the themes on the school's printer. The pale tints and dotted lines are the parts most likely to vanish or come out too dark.
