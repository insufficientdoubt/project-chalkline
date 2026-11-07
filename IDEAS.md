# Ideas for later

Things we've talked about but not built yet. Add to this list; move an idea out when it's built (and log it in `TOOL-CHANGES.md`).

## To do next

- **A year-long list of sentence frames (for Monday, 2 November).** Like the vocab list: one central list of sentence frames and stems for the whole year, reused across units and lessons (on slides, worksheets and the lesson intro's language objective), instead of writing them slide by slide. Look at **School 21** (London, UK), known for its oracy teaching and talk frameworks and sentence stems, as possible inspiration. Now part of a bigger plan: **Language goals** (below), which is part of version 1 (`V1-PLAN.md`, section 5).
- **Packet layout templates: pages that aren't walls of text.** Today most printables flow top to bottom as one long column, and real teachers' packets came out as walls of text. Build a set of page layouts for packets, modelled on **sample pages from textbooks** that we collect as examples (for example: a reading with a margin glossary, a picture with labelled callouts, a two-column compare page, a timeline strip, a "key facts" box beside a short text, a vocab panel with pictures, a step-by-step how-to, a review page with mixed question types). For each layout: a Typst layout in `typst/` and a starter in `templates/`. **Tag every layout by function**, the same way slide templates are (introduce, read, compare, sequence, label, practice, review…), with a line on when to use it, so teachers and AI assistants pick a layout that fits the content instead of a random one. Keep the source examples' credits; build similar layouts, never copy the pages. This comes before the "Packet theming" decorations below.
- **Math worksheets: still an area of concern, need more work.** The Unit 4 practice worksheets (Times and Divide, Mixed Review, Garden Times Tables) are a first pass, not finished. Not tonight: the plan is to ask the math teachers for copies of their current worksheets and match their style, then rework the layouts, problem mix and difficulty.
- **A new intro deck: everything interactive.** One deck that walks a new teacher through every interactive option now in Chalkline (review games, learning activities, timelines, Label it, polls, the toolbox, the chalkboard, PDF worksheets), each with a live example and one line on how to write it. The Start here catalogue slide lists them; this would *teach* them.
- **An intro piece: "lists are the secret".** A short deck (or a section of the one above) that drives home the big idea: **make lists of your course's vocabulary and key facts first** (words and meanings, dates and events, people and what they did, places and pictures). Once a list exists, it becomes a quick, reusable activity in minutes: snowman, matching, memory, bingo, Jeopardy, sort it, timelines, flashcards, quizzes. Show one list turning into five activities. The vocab list (`vocab/data/vocab.csv`) is the model.

## Language goals: a list of lists (plan)

**Built 2026-11-05, simpler than planned:** one list, `vocab/data/frames.csv`, with a `kind` column (grammar, phrase, stem, frame, question) instead of a list per format, and one shortcode, `{{< frames >}}`, that draws each kind its own way (see `vocab/README.md`). Looked at first: SIOP's language objectives (vocabulary, functions, structures, strategies) and School 21 / Voice 21's oracy framework and discussion roles. Left for later: talk roles (School 21's six) and a grammar-pattern column, each one more column; strategies stay out (teaching moves, not student language). Still to decide: where the whole list is shown (the vocab sidebar, the vocab app, or a page).

Language goals come in different formats, and each needs its own fields and its own look. Sentence frames are only one of them. The plan: store each format as its own list, in its own terms, and inject any of them with shortcodes.

**Formats** (a first list; more can be added the same way):

- **Sentence frames, with response frames.** A question frame and the frames to answer it: *What happens when ___?* → *When ___, the angle ___.* / *I think ___ because ___.* One frame can have several response frames (agree, disagree, add on).
- **Phrases and collocations.** Words that go together: *make a decision*, *turn all the way around*, *measure an angle*. Fields like the phrase, its pattern (verb + noun…), an example sentence, 中文, and the vocab words it uses.
- **Conversation starters.** Questions or prompts that open a talk: *Where do you see a straight angle at home?* Maybe with a follow-up question or two.
- **Maybe later:** discussion roles (summarizer, questioner…), signal words (*first, then, because, however*), question stems for each thinking level, oracy talk moves (School 21).

**Data: a list of lists.** One list per format, each with its own columns, in one place (for example `language/data/frames.csv`, `phrases.csv`, `starters.csv`, or a YAML file per format if lists inside lists, like a frame's responses, are easier there).

- **Shared columns** in every list, so they work alike: `id` (a prefix per format: `FRM-`, `PHR-`, `CNV-`; permanent, like vocab IDs), `zh`, `level`, `units`, `vocab_ids` (links to `vocab/data/vocab.csv`), `situation` (discussion, writing…), `status`.
- **Own columns** for the rest: a frame's `responses`, a phrase's `pattern`, a starter's `follow_ups`.
- **The column rules** go in a schema like `vocab/schema.yaml`, checked by `python chalkline.py validate`. The existing `vocab/data/frames.csv` (4 frames) moves in as the first list.
- **Same language rules as vocab:** English is the target and 中文 is support; 中文 in reference materials, never in review materials.

**Shortcodes.** Either or both:

- **One per format:** `{{< frame "FRM-001" >}}`, `{{< phrases unit=5 >}}`, `{{< starters unit=5 >}}`, each drawn in its own way (a frame with its response frames under it, phrases as a list or chips, starters as cards).
- **One meta shortcode** that looks up any point and draws it in its format's layout, from the ID's prefix: `{{< lang "FRM-001, PHR-004, CNV-002" >}}`, or `{{< lang unit=5 >}}` for a unit's language goals, grouped by format. Each format's layout stays its own small Lua function, so adding a format means a list, a few schema lines and one function.

**Where it shows:** slides (with `zh=true` or the bilingual tool's two languages), printables (a language box on worksheets), the lesson intro's language objective, the toolbox (a **Language** sidebar next to Vocab), and later the review games (a frame with a gap to fill, a phrase to match), always English only there.

**To decide:** CSV or YAML (frames with several responses are a list inside a list); one folder for all language lists or next to vocab; whether units pick their points in `course/vocab/<unit>.yml` or a new `course/language/<unit>.yml`; how the angles unit's hand-written frames (Activity 3 slide) move to the list as a test.

## Packet templates: next steps

**Decided 2026-11-06: the rebuild (backwards compatibility can break).**
1. **The kit becomes Chalkline's only PDF layout.**
   - Chalkline's current Typst template (worksheet, playful) is retired.
   - **Posters stay**, as a kit option (A3 single pages), for vocabulary word walls and diagrams of key content.
2. **Shortcodes and blocks for the kit's pieces**, so packet pages are written as `.qmd` with the usual labels:
   - work spaces, problems, vocab hunt, recall, sequence, KWL, Venn, Frayer, source card, etc.;
   - answers written next to their questions, for the teacher edition.
3. **`packets.py` builds each unit's booklet with the kit:**
   - themes, A3 folded, spreads, padding, contents by unit and subunit;
   - a teacher edition;
   - loose sheets, with "Goes with packet page …" filled in.
4. **Web versions:** simple pages as real web pages; layout-heavy pages (spreads, Venn, timeline) show their PDF page.
5. **Two units become guide examples,** copied into the guide, cleaned up, and rewritten with the new templates for both slides and printables:
   - **Unit 5 (Angles, the math unit);**
   - **one of the Greco-Roman units** (Greece or Rome: to choose).
6. **The other demo units are archived.**
7. **The Mesopotamia and Rome samples become `.qmd`**, and the guide's own printables (Angle Hunt, Thinker Card, Self-Check) are redone with the kit.
8. **Work on its own branch,** so the site keeps publishing until it's merged. Note the breaking change in `TOOL-CHANGES.md` and the README.

**Progress (branch `ccr-763051f4-zrh2pq`, 2026-11-06):**
- Done: 1 (the kit lays out every printable; posters kept), 2 (blocks in `.qmd`: `kit-blocks.lua`), 3 (with "Goes with packet page …" on loose sheets), 5 (guide `example-angles/`, `example-rome/` with the Greek slides), 6 (units 01–05 in `archive/units/`; Start Here now tours the Template Library).
- Done since: 4 (a Venn or KWL page shows its PDF on the web, in the viewer with pens; loose landscape sheets are real landscape pages).
- Still to do: 7 (Mesopotamia and Rome Typst samples as `.qmd`; Angle Hunt, Thinker Card and Self-Check are done); README/TOOL-CHANGES note on the breaking change before merging.


The packet kit is in Chalkline since 2026-11-06 (`_extensions/chalkline/typst/packet/`, samples in `guide/packet/`, the **Packet Templates** guide page). Still to do:

- **Write packet pages from a unit's `.qmd` files.** Today a packet page is a short Typst file. Next:
  - shortcodes and classes for the pieces (`::: {.work-space size="half"}`, `{{< vocab-hunt >}}`, `::: kwl`);
  - a `packet-theme:` setting;
  - `packets.py` building each unit's booklet with the kit: A3 folded, padded to a multiple of 4, a teacher edition, loose sheets with "Goes with packet page …" filled in automatically.
- **More page types** (from the list of common packet pages, upper primary to high school):
  - **Reading and content:** cloze / gap-fill with a word bank; primary source page (source, context, "Who? When? Why?"); annotated diagram / label the picture; data page (a chart or table to read, with questions).
  - **Organizing thinking:** T-chart; Cornell notes; guided notes with blanks; fishbone; storyboard; decision matrix.
  - **Language:** word-building (roots, prefixes, suffixes, word families); matching; crossword and word search, generated from the vocab list.
  - **Practice and tasks:** worked example beside "now you try" (math, science); multiple-choice and short-answer quiz page; lab or investigation report (question, hypothesis, materials, method, results table, graph grid, conclusion); writing planner (PEEL / TEEL paragraph, essay outline) and drafting pages; blank map to label.
  - **Collaboration:** discussion or debate prep (roles, for and against, stems); peer feedback ("two stars and a wish"); group project tracker.
  - **End of a unit:** reflection page; unit review / study guide; exit tickets (several small boxes per page, to cut out).
  - **Booklet furniture:** a glossary at the back, generated from the words used in the packet, with page numbers; homework or reading log; a page for teacher stamps and comments.
- **The rest of the Mesopotamia source dossier:** four more sources (Marduk's cylinder seal, the Humbaba mask, the Flood Tablet, a Gilgamesh tablet), the same way as the first two, with openly licensed museum photos.
- **Print the printer check** on the school's copier and adjust any tint or line that vanishes or comes out too dark.

## Build speed: next steps

Since 2026-11-06 the publish step reuses slide PDFs, slide pictures and packets whose sources didn't change (`scripts/build_cache.py`). What's left:

- **The year packet as an optional build step.** Today it's rebuilt whenever any printable anywhere changes, and it renders every printable in the course twice (teacher and student editions), so it's the part of the packets that keeps growing. It's used very rarely, while unit packets change all the time. The idea:
  - **Leave it out of normal builds.** Teachers work on unit packets until they're happy, and then ask for the year packet once.
  - **Show how far behind it is.** The site (the year packet's link, or the teacher home page) says when the year packet was last made and what has changed since: "Year packet: made 3 Nov · 4 printables changed since". The build can work this out from the cache keys, which already record each printable's sources.
  - **Rebuild it by hand.** A way to ask for it on the next build, for example a "Run workflow" option in the Actions tab (`workflow_dispatch` with a "year packet" switch), a commit message word, or a setting in `_quarto.yml` that the teacher turns on for one build. Locally: `python chalkline.py packets --year`.
  - **Questions to settle:** what the year packet's link shows while it's out of date (the old PDF, with a note?); whether the student site's copy follows the same rule.
- **Page rendering** (about 80 s) still redoes every page on every push. Not worth more work until it's several minutes.

## Packet theming (after v1)

First, after the templates are cleaned up: **better packet layouts** (see "Packet layout templates" under "To do next"). Some packets made by a real teacher came out as long walls of text. Fix that before adding decoration.

**Idea: faint generated decorations for margins and white space.** Inspired by [florilegium](https://github.com/kevinraymond/florilegium) (MIT), which draws Delft-blue floral page margins in Lua inside LuaLaTeX, a new garden for every page. We want a much lighter version: thin line drawings, very faint, that don't use much toner on a photocopier.

- **How:** a Python script (in `scripts/`) that draws SVG decorations from a seed: margin strips, corners, end-of-printable fillers, cover page and unit-divider art. The Typst template places one per page in the page `background:`, picked by page number so rebuilds look the same. Making the SVGs ahead of time is simpler and faster than drawing curves in Typst for each page, and easier to preview.
- **Styles:** plants (vines, leaves, flowers), animal patterns, geometric shapes. For example, a **honeycomb** that fades into the margins and corners.
- **Off by default.** A setting turns it on (e.g. `packet-decoration: honeycomb` in `_quarto.yml`), maybe per printable too.
- **Rules:** stay out of the work area (answer lines, boxes, the name box). Use one light color from the brand. No decoration on quizzes and tests.
- **Later, maybe:** grow into the empty space where a printable ends early, as florilegium does (Typst can find where the text stops with a hidden marker). Margins, covers and dividers come first.

## Classroom tools: next steps

Every tool is now a web component in its own file (`_extensions/chalkline/toolbox/tools/`), with no title bar, and the content is the card. `toolbox.js` is only the frame (panels, menu, remembering). Ideas for later:

- **Lit** (a small, standard library for web components, about 6 KB, no build step) if a tool's template gets long and fiddly. Not needed yet.
- **A teacher's own tool:** with the tools in their own files, a teacher's `_extensions/my-tools/` could add a tool to the menu with one file, the same way. Part of the extension plan below.
- **Games and activities on the shared parts:** they already take their colors and corners from `ui/ui.css`, but their buttons and menus are still their own (`games.css`, `activities.css`). Moving them onto `.ui-btn`, `.ui-seg` and `.ui-pop` would make every button in Chalkline one button.
- **The vocab app** (`vocab/app/`) has its own colors (`brand.css`, made from `brand/`). It could load `ui/ui.css` too.
- **Sidebars:** Vocab and Packet are now docked sidebars (the slides move over to make room). Next: the unit's worksheets by name (Packet). Chalkboard ink stays where it was drawn on the screen when a sidebar opens or closes (the slide moves under it), as it already does when Slide size changes the space around the slide.

## Chalkline as a Quarto extension (after alpha)

The file-by-file plan is in `EXTENSION-PLAN.md`.

**Where we are:** alpha. A couple of teachers are trying Chalkline in their own cloned repositories. Today Chalkline's code lives inside each course (`_extensions/chalkline`, `scripts/`, `brand/`, the Typst template, the launchers, the vocab app), so every course is a full copy, and a fix (like the video sizing) has to be copied into each one by hand.

**The plan:** split it in two.

1. **A Chalkline repository:** the tool only, released as a Quarto extension with a version number. A course installs it with `quarto add <owner>/chalkline` (it lands in `_extensions/chalkline/`) and updates with `quarto update <owner>/chalkline`. A course can stay on an older version until its teacher chooses to update.
2. **A course template:** a starter repository ("Use this template" on GitHub) with `_quarto.yml`, an example unit, `brand/`, `season.yml` and the launchers, which installs the extension. One click makes a new course.

**Layers, so updates never overwrite a teacher's work:**

- **Chalkline:** the shared tool. Nobody edits it inside a course; an update would overwrite those edits.
- **School and course settings:** `_quarto.yml`, the school's `brand/` (colors, logo, fonts) and `season.yml`. Their styles load after Chalkline's, so they win.
- **Personal tools:** a teacher's own small extension beside Chalkline (for example `_extensions/my-tools/`) for their own shortcodes, filters or styles. Quarto runs both.
- **Content:** units, lessons, worksheets, vocab. All theirs.

The rule "log tool changes in `TOOL-CHANGES.md`" becomes "put your changes in your own layer". When a personal tool is useful for everyone, it moves up into Chalkline for the next release; the logs from alpha are where those ideas come from.

**What packs easily, and what needs work:**

- Easy: the Lua filters and shortcodes, the toolbox, games, activities, the video fit, and the web and slide styles.
- Can ship inside the extension, with `_quarto.yml` pointing to them: the Python scripts (the overview catalog, packets, slide PDFs, vocab brand).
- A custom format in the extension: the Typst PDF template (worksheets, the playful layout).
- In the course template rather than the extension: the launchers, the vocab app, `.vscode/` and the publish workflow.

**Moving the alpha testers over:**

1. Read each tester's `TOOL-CHANGES.md` and pull the good changes into Chalkline first.
2. Then, in their repository, delete the old tool folders, `quarto add` the extension, and move anything personal into `_extensions/my-tools/`.
3. Their content doesn't change.

**When:** before a third or fourth course, or before the alpha group grows. Each copy made before then is one more to move over.

## Play at home (phones), next steps

- **Phone layouts for the other one-player games**, one at a time, like Word Blitz's (container queries in `games.css`): Snowman and Scramble (the snowman smaller on top, the letters below), Memory (3 × 4 cards), Picture reveal, Matching (one column). Then take each one off the scale-to-fit list (`FITS_ITSELF` in `games.js`).
- **Play offline (the subway):** a web app manifest and a service worker, so the Play page can be added to the home screen and keeps working with no signal (the page, the games and the vocab pictures saved on the phone).
- **Tests:** keep the Playwright scripts that play each game (slides, desktop page, phone page) in the repo and run them on every push.
- **A shared game kit:** the pieces Word Blitz has that other games could use (the wrong answers from the same unit and another unit, words that come back, high-score tables, timers that pause off-slide, level themes, the canvas fire), maybe on Lit.

## Review games

- **Heads up / Taboo.** A big word card for one student who faces the class; classmates describe the word without saying it (or without the "don't say" words under it). A timer, and *Got it* / *Pass* buttons that count. Good speaking practice for English learners. From the vocab list: the word, with its meaning hidden for the teacher.
- **Spin the wheel.** A colorful wheel that spins and stops on one slice: a question type, a topic, a team, or a student from the name picker's class list. Looks great on a smartboard.
- **Odd one out.** Four pictures or words; students say which doesn't belong, and why. No single right answer, so it's good for talking. From the vocab list: three words from one topic and one from another.
- **Zoom in.** A photo starts zoomed in close; each tap zooms out a little. "What is it?"
- **Who wants to be a millionaire.** A question ladder with lifelines: 50:50, and "ask the class", using the tap-to-vote poll.

## Bingo, next steps

- **Your own words:** a box to paste `word | meaning` lines, kept in the browser, for a bingo that isn't from the vocab list.
- **Picture cards:** pictures on the cards instead of words (for younger students). The vocab drawings are SVG, so they'd need turning into PNG in the browser first.
- **Bigger grids for one unit:** a unit has about 12 words, so its cards are 3 × 3. 4 × 4 and 5 × 5 need 16 or 24 words: all units, or a unit with more words.
- If a unit's vocab list changes, a game code makes different cards than the ones printed before. Make new cards after changing the vocab.
