# Changelog

## Unreleased

- **The Rome example has the picture layouts** (2026-11-09): three new pages (The Roman Army, How Rome Grew, Greek Roots) show the mixed page, picture steps and the picture column in a real packet. In picture steps, a picture that cropping would cut in half (a tall statue) is now shown whole.
- **Cause and effect** (2026-11-09): the event in the middle column is turned 90° and set larger, so it reads along the column instead of in short squeezed lines.
- **The ten-minute tour is new** (2026-11-09): Getting started › *Chalkline in Ten Minutes* now shows Chalkline as it is: the guide to copy from, the Template Library's columns, A3 packets and the teacher edition, Routines, colour schemes, and the one-line start with `quarto use template`.
- **Event cards** (2026-11-09): a card's picture fills the space under its words (it was a thin 17 mm strip); a tall picture, like a statue, is shown whole instead of cut. Write the picture with no size: `- C | The Via Appia is built. | ![](images/via-appia.jpg)` (an old `{width height}` is ignored).
- **Fix** (2026-11-09): a glossed reading (`::: glossed-reading`) in a unit packet no longer prints its margin notes over the text on left-hand pages. Rebuild the packet to get the fix.
- **Fix** (2026-11-09): `{{< blitz words="…" >}}` no longer logs "ERROR … circular reference" when a deck renders (the game itself always worked).
- **Page layouts with pictures** (2026-11-09): three new printables in the guide's **Printable templates**: a mixed page (text, a drawing beside the text, photos in a row, tables), **picture steps** (`::: picture-steps`: a process, one picture per step down the left third, the words beside each) and a **picture column** (`::: picture-column`: pictures down one side, one box of text beside them). `::: side-by-side` takes `widths="3, 2"`. Every printable's Markdown tables now take the page's width and the theme's colours (a column as wide as its longest cell needs; `tbl-colwidths` sets them), and short tables aren't split across pages; picture captions are small and grey, with no "Figure 1:" (the numbers repeated). **In an existing course:** nothing to do; re-render a printable to see its tables in the new look.
- **`python chalkline.py update`** (2026-11-08): gets the newest **release** of Chalkline from GitHub (never unreleased work or test releases; testers can ask for them with `--pre` or `--from main`) and puts it in place of the old one (the extension folder, `chalkline.py`, the launchers, `requirements.txt`); your course isn't touched. It stops if Chalkline's files have uncommitted changes, and lists what's new from this file. `--check` shows your version and the newest release. Also a VS Code task, **Update Chalkline**. Don't use `quarto update` in a cloned course: it installs a second copy.
- **The guide has a front page** (2026-11-08): **How to use Chalkline** opens with the key pages as cards with pictures; the example units and sample printables are in their own folders (`guide/examples/`, `guide/samples/`); the key pages are starred in the sidebar. The Slide kit deck is retired (the Template Library has all of it).
- **Breaking: every PDF is laid out by the packet kit** (2026-11-06 to 08). Printables are A4 loose sheets in the course's packet theme (`packet-theme:` sky, trail or blueprint), with Name / Class / Date, "Page 1 of 2" and "Goes with packet page …"; unit packets are A3-folded booklets with a cover, contents, Notes pages and a teacher edition. The old worksheet and playful layouts are gone: `layout: playful`, `playful-theme:`, `doc-type:` and `name-box:` no longer do anything (posters keep `layout: poster`). Write pages with the packet blocks (`::: panel`, `::: recall`, `::: {.work-space}`, `::: venn`, `::: source-card` and the rest; the guide's **Packet templates** page lists them all). **In an existing course:** old printables still build, but look plainer until they use the blocks. A unit's `index.qmd` can set `packet-theme:`, `packet-hero:` (a cover picture) and `packet-hero-credit:`.
- **Three example units in the guide** (2026-11-06 to 08): Angles (math), Ancient Rome and Mesopotamia (history), with their slides, printables and packets, to copy into `course/units/`.

- **Live boards fill the slide** (2026-11-04): the board takes the whole slide, with a small corner card for the QR code,
  link and buttons (`layout="inline"` for the old look). Excalidraw shows its room's QR code and an Open button instead
  of a second, private board. `zoom="0.7"` shows a board smaller so more fits (Padlet starts at 0.7).
- **The exemplar lesson** (2026-11-04, first draft): `guide/exemplar-slides.qmd`, a SIOP lesson on angles as a 2D deck
  (seven phases across, options down, each with a note on when to choose it), with its worksheet `guide/angle-hunt.qmd`.
  Shown first in the teacher site's "How to use Chalkline".
- **The Chalkline guide: "How to use Chalkline" on the teacher site** (2026-11-04). Chalkline's slide templates
  (the Slide kit deck, with an example handout) live in the extension's `guide/` folder and update with Chalkline.
  `scripts/guide.py`, the first pre-render step, copies them into `course/guide/02-chalkline/` for the teacher site
  only; the copy is git-ignored, so a course never keeps these files. `chalkline-guide: false` in `_quarto.yml`
  turns the guide off (nothing is deleted; every template piece keeps working). A teacher's own templates go in
  `course/guide/01-my-templates/` (the starter adds it), listed above Chalkline's. An `index.qmd` with
  `audience: [teacher]` is now left out of the student site. **In an existing course:** add
  `- auto: course/guide` to the sidebar in `_quarto.yml` (after `- auto: course/units`) and
  `course/guide/02-chalkline/` to `.gitignore`.
- **No more "For families" page or `parent` audience** (2026-11-03). Chalkline makes two sites only: the
  student site (public; families use it too) and the teacher site. `{{< overview learning >}}` and
  `{{< overview family-picks >}}` are gone. **In an existing course:** delete `families.qmd`, remove it from
  `render:` and the navbar in `_quarto.yml`, and change `audience: [teacher, student, parent]` to
  `audience: [teacher, student]` (a leftover `parent` does nothing).
- **Bilingual text** (`bilingual/`): `[English | 中文]{.bi}` in any title, bullet, table cell or box, on
  slides, pages and PDFs. Alone in its line, the two languages stack; inside a sentence, they stay on one
  line. Only the second language is styled (smaller, lighter), so it takes its place's own size and colour.
  A deck's `bilingual: {primary, show}` labels set the start; slides get a language switch in the corner.
- **Slide kit** (experiment, `styles/layout.scss`): design tokens (`--accent`, `--surface`, `--radius`,
  `--step-1`, ...), layout pieces (`.tiles`, `.chain`, `.row`, `.cover`, `.box`, `.strip`) and text roles
  (`.kicker`, `.big`, `.lead`, `.pill`, `.num`, `.muted`, `.small`, `.fine`, `.gap`). A `.box` that starts with
  a `###` title stays one box. A look for a slide or deck is a few token changes in the course's own CSS.
- **Colour schemes** (`styles/schemes.scss`, `schemes.html`): night (from the Robotics League course's dark
  slides), sky, lagoon and sunrise, all made from the brand colours. `{.scheme-night}` on a slide's title, or
  `slide-scheme: night` in a deck's labels. Chalkline's own slide styles (titles, tables, steps, vocab cards,
  timelines) now read the slide kit's tokens, so a scheme reaches them too; light decks look as before.
- **To be removed:** `slide-style/` and `toolbox/tools/style.js` (the `{.styled kind="..."}` experiment).

- **Hosting** (`HOSTING.md`, `hosting/`): step-by-step setup for a student site and a teacher site with
  email-code sign-in on Cloudflare Workers, mostly done by Claude with the Cloudflare API connector.
  `hosting/` has the GitHub workflow and Worker settings to copy into a course.
- **View source** (U, in the toolbox): the current slide's source as typed, with colors and line numbers;
  Copy, and Open in VS Code on your own computer. Teacher site only. `toolbox/source.lua` cuts the deck
  into slides; `toolbox/tools/source.js` shows them.
- A new course: `quarto use template insufficientdoubt/project-chalkline` copies the course files
  without the sample's content, and `python chalkline.py setup` (run by the first build) adds a starter
  unit (one slide deck, one handout, four vocab words) and the course files from `starter/`.
- **All slides** (`{{< slide-wall >}}`, the course's `all-slides.qmd`): every unit's decks as rows of slide
  pictures; a click opens the deck at that slide. `scripts/slide_pictures.py` takes the pictures after each
  full build. Slide PDFs and pictures also work with a Chromium installed by Playwright (build servers).
- The robotics-only slide styles are gone; VEX names in the code are general.

## 0.1.0 (2026-10-25)

The first version as a Quarto extension, taken out of the Chalkline sample course
(insufficientdoubt/project-chalkline, which keeps the earlier history; see its TOOL-CHANGES.md).

- One extension: the classroom shortcodes and filters, games, toolbox and PDF viewer.
- A `chalkline` project type: page, slide and PDF layouts, print fonts, and the build steps.
- Scripts run with `python chalkline.py <command>` from a course.
- Shortcodes instead of Python cells: `vocab-cards`, `word-bank`, `vocab-table`, `vocab-list`,
  `fill-in-the-blank`, `overview`, `season-events`.
- The vocab app and vocab checker; starter templates for a slide deck and a worksheet.
