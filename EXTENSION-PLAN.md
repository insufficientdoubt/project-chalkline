# Plan: Chalkline as a Quarto extension

The map for splitting Chalkline into **a Quarto extension** (the shared tool) and **a course template** (a starter course). The why is in `IDEAS.md` ("Chalkline as a Quarto extension"). This file says where every file went, how the pieces fit, and what's left.

Status: **steps 1–5 done** (2026-10-25): this sample is now a course with all of Chalkline inside `_extensions/chalkline/`. **Decision (2026-10-25): stay in one repository for now** (see "One repository for now").

## The three places

| Place | What it is | Who changes it | How it updates |
|---|---|---|---|
| **Extension** | The `chalkline` repository: one Quarto extension | Only Chalkline's maintainers | `quarto update` in each course |
| **Template** | A starter course repository ("Use this template" on GitHub) | Copied once when a course is made, then the course owns it | Never on its own. Changes come as notes in the release notes |
| **Course** | One teacher's own content and settings | The teacher | — |

Rule of thumb: **if a bug fix in this file should reach every course, it goes in the extension.** If every course needs its own copy, it goes in the template. If it's about one subject or one school, it belongs to the course.

## How the pieces fit (as built)

**No paths into the extension.** `quarto add <owner>/chalkline` puts it in `_extensions/<owner>/chalkline/` (checked in Quarto's own code; a local install has no owner folder). So a course never names that folder:

- `_quarto.yml` says `project: type: chalkline`. The extension's `_extension.yml` contributes a **project type**: Chalkline's themes, the overview's type colors, the PDF layouts and print fonts, and the pre-render and post-render scripts, all with paths inside the extension. The course's own settings merge on top (lists add up, so a course's stylesheet loads after Chalkline's and wins).
- `filters: [chalkline]` and the shortcodes are found by name.
- Scripts find the course and the extension with `scripts/extension.py`.
- Teachers, the launchers and VS Code run Chalkline's scripts through **`chalkline.py`** in the course (`python chalkline.py packets --unit 3`), which looks in both places.
- Pages have **no Python that imports Chalkline**: what used to be code cells are shortcodes (`{{< vocab-cards >}}`, `{{< word-bank >}}`, `{{< overview >}}`...) that run Chalkline's Python helpers (`blocks.lua` → `scripts/blocks.py`).

Tested: the whole site built with the extension moved to `_extensions/someowner/chalkline/` gives the same files, and the owner's name appears nowhere in the site.

## Where every file went

### Extension: `_extensions/chalkline/`

| What | Was | Notes |
|---|---|---|
| Filters, shortcodes, toolbox, games, activities, quickref, ui, video fit, polls, countdown | `_extensions/classroom/` | |
| `pdf-viewer/` (pdf.js, pdf-lib) | `_extensions/pdf-viewer/` | One extension now, so a course installs one thing. |
| `blocks.lua` | *(new)* | `{{< vocab-cards >}}`, `{{< word-bank >}}`, `{{< vocab-table >}}`, `{{< vocab-list >}}`, `{{< fill-in-the-blank >}}`, `{{< overview >}}`, `{{< season-events >}}`. |
| `styles/styles.scss`, `styles/revealjs.scss`, `styles/type-colors.html` | `brand/` | Chalkline's page and slide design. Colors come from `_brand.yml`'s palette (`navy`, `blue`, `turquoise`, `orange`, `sky`). |
| `typst/typst-template.typ`, `typst/typst-show.typ` | `brand/typst/` | PDF layouts. The school's name comes from `school:` in `_quarto.yml`. |
| `fonts/print/` (Fredoka, Patrick Hand, Noto Sans SC) | `brand/fonts/print/` | 17 MB, mostly the Chinese font. |
| `scripts/*.py` | `scripts/` | All of them. `import_vex_vocab.py` is now `import_vocab.py` (it works for any course). `vocab_brand.py` is now `vocab_app.py`. New: `extension.py`, `blocks.py`, `new.py`. |
| `scripts/validate_vocab.py` | `vocab/validate.py` | `python chalkline.py validate`. |
| `vocab-app/` (the vocab app, scratchblocks) | `vocab/app/` | Copied into the course's `vocab/app/` before each render (not saved in git), with the brand's logo. |
| `templates/slides.qmd`, `templates/worksheet.qmd` | *(new)* | Starter files for `python chalkline.py new slides 2 "Title"`. |

### Template (copied once, then the course's)

| What | Notes |
|---|---|
| `_quarto.yml`, `_quarto-teacher.yml`, `_quarto-student.yml` | `project: type: chalkline`, `school:`, the title, sidebar, `vocab-title`, `student-site`. The bottom of `_quarto-student.yml` is written by `catalog.py`. |
| `chalkline.py` | Finds the extension and runs its scripts. Small; should rarely change. |
| `Start Chalkline.command`, `Start Chalkline.bat` | Find Quarto, set up Python, `chalkline.py build`, `quarto preview`. |
| `requirements.txt`, `.gitignore`, `.vscode/`, `.github/workflows/publish.yml` | |
| `brand/_brand.yml`, `brand/logos/`, `brand/fonts/*.ttf` | Placeholders for the school's own. |
| `brand/styles.scss`, `brand/revealjs.scss` | The school's fonts and overrides only; they load after Chalkline's. |
| `index.qmd`, `all-slides.qmd`, `course/review-games.qmd`, `course/play.qmd` | Thin pages (an overview shortcode, a `{{< game-picker >}}`, a `{{< slide-wall >}}`). |
| `vocab/config.js`, `vocab/schema.yaml`, `vocab/index.html` | `schema.yaml` lists the course's own topics and ID prefixes, so it's the course's (not the extension's, as first planned). |
| `README.md`, `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `brand/README.md`, `vocab/README.md` | Rewrite "Changing the tool" (below). |
| `TOOL-CHANGES.md` | Empty: the log for a course's own layer. |
| A small example unit | Say `00-start-here` and one history unit. |

### Course: content

`course/**` (units, lessons, `season.yml`, `links.yml`, `course/vocab/`), `vocab/data/`, `vocab/images/`, `vocab/tools/draw_icons.py` (it draws this sample's own pictures), `archive/`.

### Games and slide templates

- **Games:** the engine (every game, activities, timelines, Label it) is in the extension. The words and pictures come from the course's vocab, so a game is about the course's subject with no code.
- **Slide layouts** (`.statement`, `.challenge`, `.card-grid`, `.goal`, ...) are in `styles/revealjs.scss`. The robotics-only ones were removed on 2026-10-27; the rest are general-purpose.
- **Starter files** are in `templates/`. `python chalkline.py new` (or VS Code: Run Task > New slide deck or worksheet) copies one into a unit with the title, unit and next `order:` filled in. A course's own `templates/` folder is used first.
- **Rule for new templates:** if the deck's *design* could serve any subject, its layouts go in the extension and its starter file in `templates/`. If it's one subject's deck, it's content.

## One repository for now

Decided 2026-10-25: no separate `chalkline` repository yet. `quarto add` installs every extension in a repository's `_extensions/` folder, so courses install and update Chalkline straight from this one:

```bash
quarto add insufficientdoubt/project-chalkline      # only _extensions/chalkline is copied
quarto update insufficientdoubt/project-chalkline
```

Why: a split would make testing a change slower (the copy in the sample would be an installed one, so a change means editing in one repository and testing in another, or keeping a second example course), and with a few alpha teachers its benefits (smaller downloads, versions that mean only "a new Chalkline", a clean starter course) are small. A course installs to `_extensions/insufficientdoubt/chalkline/` either way, so splitting later costs each course one `quarto update` from the new address.

Split when other people start changing Chalkline, or when the sample's content changes get in the way of clean releases. Then give the `chalkline` repository a small example course to test in, and the sample only updates.

**Order matters when adding Chalkline to an existing course:** `quarto add` first, then `project: type: chalkline` in `_quarto.yml`. Until it's installed, Quarto doesn't know the project type and `quarto add` stops with "Unsupported project type". A course made from this repository already has it, so `quarto update` just works.

## Order of work

1. ✅ **Gather into one extension, inside this repo.**
2. ✅ **Move Chalkline's styles, PDF layouts and print fonts into the extension**, as a project type (not the custom formats first planned: those would have meant changing `format:` in every page).
3. ✅ **Move `scripts/` into the extension**, with `chalkline.py` and shortcodes instead of Python cells in pages.
4. ✅ **Move the vocab app and the vocab checker into the extension**; add `templates/` and `python chalkline.py new`.
5. ✅ **Check:** full teacher and student renders (all PDF pages identical pixel for pixel to before; changed pages look the same in a browser), the extension under an owner folder, the Mac launcher from a fresh copy, games, vocab pop-ups, the PDF viewer and the vocab app in a browser. Not tested here: the Windows launcher and the GitHub publish workflow (they changed only in paths; the workflow runs on the next push to `main`).
6. ~~Make a separate `chalkline` repository~~ Not for now (see above). Instead: once this branch is merged, tag `v0.1.0` on `main`, so a course can pin a version (`quarto add insufficientdoubt/project-chalkline@v0.1.0`).
7. ✅ **New courses** (2026-10-27): `quarto use template insufficientdoubt/project-chalkline` copies this repository without the sample's content (`.quartoignore`) and installs the extension; `python chalkline.py setup` (run by the first build) adds a starter unit and the course files from `_extensions/chalkline/starter/`. GitHub's "Use this template" isn't used: it would copy everything, sample units included.
8. ~~This sample becomes a course~~ Not needed while it's also where Chalkline lives.
9. **Move the alpha testers** (as in `IDEAS.md`): read each one's `TOOL-CHANGES.md`, pull good changes into Chalkline first, then swap their tool folders for the extension.

## New rules for teachers and AI assistants (after step 8)

Replace "Changing the tool: keep a log" in `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` with:

- **Never edit `_extensions/<owner>/chalkline/`.** `quarto update` overwrites it.
- To change how something looks, edit `brand/_brand.yml`, `brand/styles.scss` or `brand/revealjs.scss`.
- To add a shortcode, filter or tool, put it in `_extensions/my-tools/` and log it in `TOOL-CHANGES.md` (the log stays: it's how good ideas reach Chalkline). Own starter files go in `templates/`.
- Found a bug in Chalkline? Note it in `TOOL-CHANGES.md` and tell John, instead of fixing it in place.

## Later

- **Paths fixed in the code.** The scripts and Lua filters assume `course/units/`, `course/lessons/`, `course/season.yml`, `vocab/data/vocab.csv`, `vocab/app/`. Fine while every Chalkline course uses this layout; if one ever can't, put them in a `chalkline:` block in `_quarto.yml`, with these as defaults.
- **`ui/ui.css`** still has the sample's hex colors (the toolbox, games and activities). Make it read the brand palette like the page and slide styles do.

## Settled

- **Owner:** your own account for now; an organization (free) once someone else helps maintain Chalkline or before sharing it widely.
- **Fonts:** the 17 MB of print fonts stay as they are.
- **Version numbers:** `0.x` during alpha (anything may change), `1.0` when it's stable.
