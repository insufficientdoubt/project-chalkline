# The Chalkline guide

The source of the "How to use Chalkline" section on every course's teacher site:

- `index.qmd`: the front page (the key pages as cards);
- `templates-slides.qmd`: the Template Library, every tested slide layout, game and activity;
- `exemplar-slides.qmd`: the exemplar lesson, a SIOP lesson as a 2D deck (phases across, options down);
- `printables.qmd`, `packet-templates.qmd`: the printable and packet templates;
- `examples/`: three finished units (Angles, Ancient Rome, Mesopotamia), with their packets;
- `samples/`: the small printables the decks show in their galleries;
- `data/`: the guide's own words and language points; `images/`, `drawio/`, `embeds/`: what the decks use;
  `packet/printer-test.typ`: the printer check.

The Slide kit deck it used to have is in `archive/guide/` (the Template Library has all of it).

- **How it gets into a course:** `scripts/guide.py` (the first pre-render step) copies this folder into
  `course/guide/02-chalkline/` for the teacher site, and removes that copy for the student site or when the course
  says `chalkline-guide: false` in `_quarto.yml`. The copy is git-ignored, so a course never keeps these files.
  This README is not copied.
- **Change the guide here**, never in the copy (it's replaced at every build).
- **Everything a template needs to work belongs in Chalkline itself** (`styles/`, the shortcodes, scripts), not
  only in this folder: turning the guide off must never break a template a teacher copied into a lesson. What is
  still only here (`slide-kit-looks.css`, `drawio/`; the palette is now `scheme-picker.html`, on every teacher deck) is waiting to be sorted into
  Chalkline pieces or examples (see `V1-PLAN.md`).
- **Pictures:** small, openly licensed, credited in `images/CREDITS.md` and on the deck's credits slide.
- **Nothing from the sample course:** the guide must work in any course, so it can't rely on the sample's units,
  words or packets. It brings its own words and language points (`data/`), its own worksheets (`samples/`) for the
  work galleries, and its own example units (`examples/`).
- **The draw.io diagram:** after editing `drawio/summary.drawio`, run
  `python chalkline.py drawio _extensions/chalkline/guide/drawio/summary.drawio`.
