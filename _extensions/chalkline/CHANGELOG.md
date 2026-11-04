# Changelog

## Unreleased

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
