# Chalkline sample course

- Read `README.md` first. Content lives in `course/` and `vocab/`, appearance in `brand/`, Chalkline itself (the tool) in `_extensions/chalkline/`.
- Every slide deck and printable has labels at the top: `title`, `type` (slides, worksheet, checklist, handout, reference, game), `order`, `audience` ([teacher, student]) and `description`. Keep them.
- **Vocab:** `vocab/data/vocab.csv` is the source of truth; run `python chalkline.py validate` after editing it. Follow the rules in `vocab/README.md`: English is the target, 中文 is support; 中文 appears in reference materials, never in review materials (quizzes, flashcards); `short_def` is simple English, 75 characters or fewer; IDs are permanent.
- **Language points beyond vocab** (grammar, phrases, stems, frames, questions with answers) live in `vocab/data/frames.csv` (see `vocab/README.md`), not hand-written on slides: add a row, then use `{{< frames "FRM-014, FRM-015" >}}` (a lesson's points) or `{{< frames unit=5 >}}`. On printables add `zh=true`, except on quizzes and tests.
- **Gloss key vocab:** on slides, write key words as `{{< vocab "democracy" >}}` (a pop-up with picture and 中文). On printables, use `{{< vocab "democracy" zh=true >}}` so the 中文 is printed too, except on quizzes and tests.
- **Making slides: start from the Template Library** (`_extensions/chalkline/guide/templates-slides.qmd`, "How to use Chalkline" on the teacher site): every tested layout, game and activity, in columns by purpose (start a lesson, words, explain, read, watch, tasks, talk, check, games, end, looks). Each slide's notes say what it can be used for and which pieces it's made of. Copy the closest slide and change its words; don't invent a new layout when one there fits. Printables: the guide's **Printable templates** page. Colour schemes: `brand/themes/` (My themes).
- Write for middle-school English learners: short sentences, simple words, one idea per bullet.
- Teacher-only content (answer keys, look-fors) goes inside `::: {.content-visible when-profile="teacher"}`.
- **Pictures:** use files with a clear license, or original drawings. Credit every outside picture in the `CREDITS.md` next to it (`images/CREDITS.md` in a unit, `vocab/images/CREDITS.md` for vocab). Outside *links* (websites, articles) go in `course/links.yml`.
- **Credits slide: do it without being asked.** Every deck that uses outside pictures or sources ends with `## [Credits | 来源]{.bi} {#credits .credits}`, in two columns: `### Pictures` (each outside picture: what it is, by whom, the license, linked to where it came from) and `### Sources` (texts quoted, articles and websites used, with links; leave this column out if there are none). Whenever you add a picture or a source to a deck, add it to that slide too, or add the slide. The Slide kit deck (`_extensions/chalkline/guide/slide-kit-slides.qmd`, in the teacher site's "How to use Chalkline") has an example. Some licenses (CC BY, CC BY-SA) require the credit; for the rest it's still good practice, a good example for students, and respect for the people whose work we use.
- **Vocab pictures: a real photo first, a drawing only when a photo can't show it.** When you add or replace a vocab word's picture, first look for a high-quality real image with an open license: Wikimedia Commons, Unsplash, Pexels, Openverse, or museum open-access collections (the Met, Smithsonian, Rijksmuseum). Most concrete words (temple, aqueduct, gladiator, quarry) are clearer and more memorable as a real photo. Make an original drawing only when no open image shows the idea clearly and distinctly: abstract ideas, or when the photos are blurry, busy or watermarked. The steps and quality checks are in `vocab/README.md` ("Pictures").
- **Emoji:** avoid 🤖, 💩 and 🔒 in slides and pages. The brand font (Source Sans 3) has its own black-and-white versions of them, so they never show in color. Other common emoji are fine.

## Editing printables and slides

Keep the edit loop quick:

1. While working on one worksheet (or deck), re-render **only that file** after each change: `quarto render course/units/<unit>/<file>.qmd` (add `--to typst` to check just the PDF). Don't run a full `quarto render` and don't rebuild packets on every change.
2. When that file is done: save/commit it, then rebuild its unit packet once: `python chalkline.py packets --unit <unit number or folder>`.
3. A full render (`quarto render`) or the launcher's startup check rebuilds everything else (the year packet, slide PDFs).

If `quarto preview` is running, don't run a full `quarto render` at the same time: it empties `_site/` while the preview is serving it.

## Changing the tool (not the content): keep a log

This repo has two kinds of files:

- **Content** (lessons, worksheets, vocab words, pictures): everything in `course/`, plus `vocab/data/` and `vocab/images/`. Change these freely. No log needed.
- **The tool** (how Chalkline works and looks): `_extensions/`, `chalkline.py`, `brand/`, `vocab/config.js`, `vocab/tools/`, `vocab/schema.yaml`, `_quarto*.yml`, `index.qmd`, the `Start Chalkline` launchers, `.quartoignore`, `.vscode/` and `.github/`.

**Whenever you change a tool file, add an entry to the top of `TOOL-CHANGES.md`** (create it if it's missing), in the same change. Use this form:

```markdown
## YYYY-MM-DD: short title
- **Asked for:** what the teacher wanted, in their words if they gave them.
- **Why:** the reason they gave, or "not given".
- **Changed:** each file and what changed in it, in a line or two.
- **Who it helps:** this course only, or probably every Chalkline course.
- **AI assistant:** which one made the change (Claude, Gemini, WorkBuddy, …).
```

Never delete or rewrite earlier entries. These logs are collected as design feedback and may become improvements to Chalkline for everyone, so the reasons matter as much as the changes.

## A teacher's own tools: outside the extension

Teachers copy this project, and Chalkline's extension comes with it (`_extensions/chalkline/`, or `_extensions/<owner>/chalkline/` when installed with `quarto add`). Updating Chalkline (`quarto update`) replaces that whole folder, so anything changed inside it is lost.

- **Put a teacher's own tools outside the Chalkline extension**: shortcodes, filters, scripts, slide tools. Use a separate extension, `_extensions/my-tools/`, loaded from `_quarto.yml`. Then Chalkline can be updated without losing the teacher's custom work.
- **A custom slide tool that should always be at hand:** give it its own menu button next to the teacher toolbox button (bottom-left, **W**), not a new item inside the toolbox menu. Like the toolbox, show it only in the teacher site. It can use the toolbox's shared parts (`window.ChalklineToolbox`, see `toolbox/kit.js`) so it looks and works the same.
- Still log it in `TOOL-CHANGES.md` (above): good custom tools may be built into Chalkline for everyone.
- This repository is where Chalkline itself is made, so here `_extensions/chalkline/` is changed on purpose. In a teacher's copied course, don't change it: note a Chalkline bug in `TOOL-CHANGES.md` instead.
