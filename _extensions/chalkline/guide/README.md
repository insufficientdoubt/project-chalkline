# The Chalkline guide

The source of the "How to use Chalkline" unit on every course's teacher site: the exemplar lesson (`exemplar-slides.qmd`,
a SIOP lesson as a 2D deck: phases across, options down), the Slide kit deck, their example pictures and worksheets,
and how to use them.

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
- **No vocab words or sample units:** the guide must work in any course, so it can't rely on the sample's vocab list
  or packets. It brings its own worksheets (`samples/angle-hunt.qmd`, `samples/example-handout.qmd`) for the work galleries. (Its vocab
galleries still use this sample's words: in another course they're empty, a known gap.)
- **The draw.io diagram:** after editing `drawio/summary.drawio`, run
  `python chalkline.py drawio _extensions/chalkline/guide/drawio/summary.drawio`.
