# Plan: Chalkline version 1

The next stage, toward a first version. Three pieces of work, in this order: **a new intro deck**, **a template deck** inside Chalkline, and **an updated sample unit** built from the templates. Written 2026-10-29; update the status lines as the work moves.

## The message

What every piece of version 1 should say, in this order:

1. **Lists first.** Your course's key facts and vocabulary, kept as lists, are the most reusable thing you own. Once a list exists, it becomes cards, glosses, games, quizzes and printables in minutes. (See "lists are the secret" in `IDEAS.md`.)
2. **Reusable elements.** Slides, pages and printables are built from a few plain, named pieces (boxes, tiles, steps, timers, vocab cards, packet galleries), not drawn one by one.
3. **Chalkline keeps everything in order.** One folder per unit; slides, worksheets, packets, vocab and two websites all come from the same files, and stay in step.
4. **Your course is vibe-codable.** The files are plain text that a teacher (or an AI assistant) can read and change in plain words.

**AI can support the process, but this project is about legibility, consistency and teacher control.** The teacher can always read the source, see why something looks the way it does, and change it. Every design choice in version 1 should pass that test.

## 1. The new intro deck

**Status:** to do. Replaces `course/units/00-start-here/slides.qmd` (keep its good slides; see "Reuse" below).

**Where it lives:** only on the project page (this repository's site). It's sample content, so `.quartoignore` already keeps it out of a teacher's new course.

**How it's told:** features one at a time, from a teacher's point of view: what a teacher does on an ordinary day, then what Chalkline does for them. One feature per slide where possible, each with a live example and one line on how to write it.

### Part A: Your materials, in one place

| # | Slide | Shows | Reuse / build |
|---|---|---|---|
| A1 | Your materials are all kept in one place | One folder per unit: slides, worksheets, pictures, vocab | "The usual way" and "The Chalkline way" slides |
| A2 | How slides are written | A slide is text you can read: the source beside the result | "A slide is just text you can read" |
| A3 | Everything is searchable | The site's search finding a word across units, vocab words and packet pages | New: a screenshot or live search (needs the search work in "Decisions") |
| A4 | The tools | The classroom toolbox (W): clock, stopwatch, voice level, traffic light, scoreboard, name picker, groups, dice, QR code, spotlight, whiteboard… and the slide timer | "Classroom tools in every deck" |
| A5 | The vocab sidebar | Opening the Vocab sidebar during a lesson | New example slide |
| A6 | Vocab glossing | `{{< vocab "democracy" >}}`: a pop-up with picture and 中文 | "Vocabulary support, built in" |
| A7 | Vocab you can drop in: the gallery | `{{< vocab-cards unit=1 words="…" >}}` on a slide | Existing shortcode |
| A8 | The packet sidebar | Opening the Packet sidebar during a lesson | New example slide |
| A9 | Packet pages you can drop in: the gallery | `{{< pdf-viewer "…-packet.pdf" layout="gallery" >}}` | Used in the Slide kit and City-States decks |
| A10 | Bilingual slides (optional) | The language controls, boxed and explained | The Slide kit's "This slide is bilingual" slide |
| A11 | Pre-built templates | A few classroom-activity slides from the template deck (section 2) | Links to the template deck |
| A12 | Your course can be themed | The same slide in a few colour schemes and looks | Slide kit's schemes; "It always looks like your school" |

### Part B: One process, many outputs

| # | Slide | Shows | Reuse / build |
|---|---|---|---|
| B1 | Packets are made by the same process | A unit's worksheets become one printed packet | "Packets build themselves" |
| B2 | Student and teacher versions | One file, two editions: answer keys and notes only for the teacher (`content-visible when-profile="teacher"`) | "Two websites from the same files" |
| B3 | One public site for students and families | The student site is the public site; parents use it too (no separate parent build) | "Two websites from the same files"; see "Decisions" below |

### Part C: Vocab and play

| # | Slide | Shows | Reuse / build |
|---|---|---|---|
| C1 | How vocab is stored | One list (`vocab/data/vocab.csv`): a row per word, checked by `python chalkline.py validate` | New; the "lists first" message lands here |
| C2 | The vocab site | The vocab app: every word with its picture and 中文, searchable | New screenshot slide |
| C3 | Interactive activities on slides | Polls, timelines, Label it, sort it | "Try a poll", "So what else can you do?" |
| C4 | Whiteboard games | Snowman, matching, Jeopardy, quick-fire… from the vocab list | Existing games |
| C5 | Games at home | The "Play at home" page (`course/play.qmd`) | New slide |

### Part D: Get started

| # | Slide | Shows | Reuse / build |
|---|---|---|---|
| D1 | Getting started, on one page | The one-page instructions: from an empty computer to your own course | `quick-start.qmd`; "Get your own copy" |
| D2 | The message | The four points above, and "AI supports, you stay in control" | New closing slide |

Then the usual credits slide (`CLAUDE.md`: two columns, pictures and sources).

### Reuse from the current deck

Keep or adapt: "A slide is just text you can read", "Packets build themselves", "Vocabulary support, built in", "Two websites from the same files", "Classroom tools in every deck", "Try a poll", "It always looks like your school", "Get your own copy". Move elsewhere: "How this sample is organized" and "Make your own unit" (to the Chalkline guide, section 2); "Editing with an AI assistant" becomes part of the closing message. Drop: the Athens and Sparta example slide (the template deck shows layouts better).

## 2. The template deck

**Status:** to do. Starts from the Slide kit deck (`course/units/00-start-here/slide-kit-slides.qmd`), which already has most of the activity slides.

**Where it lives:** inside the Chalkline extension, as a reference that every course gets and that updates with Chalkline. It's shown in **a new section of the teacher site: "How to use Chalkline"**, separate from the intro deck.

### What's in it

**Classroom activity templates, all bilingual.** Each one is a ready-to-copy slide with speaker notes that name its pieces:

- Lesson intro + Do now (topic, objective, homework, focus vocab, sentence frames, timer)
- Instructions with a video and a work gallery
- Think-Pair-Share (steps, seating, two timers)
- Easy to hard: chained challenges on one project
- Jigsaw: expert groups as puzzle pieces, with the steps and timers
- Group task, speaking frames, reveal table, cards, big idea, source / meaning / takeaway
- Lesson summary diagram (draw.io)
- Section opener, exit ticket, credits

**Bilingual examples for other kinds of slide**, clearly marked optional: the language controls slide, plus a few non-activity slides in both languages and in English only.

**Reusable resources** (a few pages at the end):

- **Lesson phase tags:** bilingual pills for each phase (Do now, Learn, Practice, Discuss, Reflect, Exit ticket…), ready to copy.
- **Colour sets:** the colour schemes, side by side, with what each is for.
- **Style:** the looks (game, brutal, scroll, dusk…) and when to use them.
- **Brand assets:** logos, fonts and colours from `brand/`, and how to change them.
- **Design guidance** (to be written): short rules for people and for AI assistants to read before making new slides, focused on **high-quality slides that work for translanguaging**: one idea per slide, short sentences, room for a second language, pictures that carry meaning, contrast, consistent places for the same things. **Type follows the content's importance, not the space:** a slide uses a few sizes only (headings, content, small labels; the second language at 0.8 of its line), and when a slide is full the whole slide gets one notch smaller instead of shrinking some parts, so nothing is demoted by accident (worked out on the Slide kit's lesson intro). To be added to `CLAUDE.md` once agreed.

### How it ships (to work out)

- **Source:** move the deck and its files into the extension (for example `_extensions/chalkline/guide/`), with its own pictures and `CREDITS.md`.
- **Rendering:** a course's site renders only `course/**` and a few pages, so the extension's deck needs a way in: a render entry in the project type, or `chalkline.py` copying it into the site at build time. Pick the one that keeps a teacher's course free of files they didn't write.
- **The deck's own CSS** (looks, the puzzle layout, the style picker): decide which parts become Chalkline pieces (`styles/`) and which stay examples. Candidates for Chalkline: the puzzle layout, the draw.io hover script (now copied per unit), lesson phase tags.
- **Pictures:** keep them small, openly licensed and credited inside the extension.

## 3. An updated sample unit

**Status:** after sections 1 and 2.

A unit rebuilt from the templates, to show a real unit made the version 1 way: **lists first** (its vocab and key facts in `vocab/data/vocab.csv` and a facts list), then slides from the templates, a packet, glossing, games and the parent view. The Hundred Schools of Thought material (thinkers, pictures, credits) is a ready start; it has no vocab yet, which makes it a good demonstration of starting from the list.

## Order of work

1. Agree on this plan, the design guidance's scope and the open questions.
2. Template deck: move the Slide kit into the extension, add the reusable-resources pages, and add the "How to use Chalkline" section of the teacher site.
3. Intro deck: rebuild in the order above, reusing slides and linking to the template deck.
4. Updated sample unit.
5. Version 1: update `README.md`, the quick start, `CHANGELOG.md` and the release notes.

## Decisions (2026-11-03)

- **No parent site.** There is no separate parent build: the public (student) site serves students and families, since the difference between them is small. **Remove the "For families" page** (`families.qmd`, its navbar link in `_quarto.yml`, the `parent` listing in `catalog.py`, the green "For families" rows on the overview, the `setup.py` entry, and the README and intro-deck text about it). Later, a **syllabus page** may take its place. Still to decide when removing it: whether `audience: [parent]` is dropped from the labels or kept with no effect.
- **Search covers vocab and packets too**, not only pages and slides: each vocab word (English, 中文, short definition) and the text of each packet should be findable from the site's search. To work out: adding vocab entries and packet text to Quarto's search index at build time (for example from `post-render`), so a result opens the vocab card or the right packet page.
- **The Slide style experiment** (`slide-style-slides.qmd`) **is retired once both new decks exist:** the feature demo deck (section 1, which includes the styling feature) and the full template deck with all the lesson templates in one place (section 2).

## Open questions

- **The template deck's home:** which render path (above), and should a course be able to hide or extend it?
- **Design guidance:** who writes the first draft, and does it also become checks (for example a lint for slides that are too full)?
