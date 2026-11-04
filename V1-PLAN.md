# Plan: Chalkline version 1

The next stage, toward a first version. Five pieces of work: **a new intro deck**, **a template deck** inside Chalkline, **an updated sample unit** built from the templates, **a streamlined setup**, and **language support beyond vocab**. Written 2026-10-29; update the status lines as the work moves.

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

**Status:** in progress. **Done 2026-11-04:** the Slide kit deck moved into the extension (`_extensions/chalkline/guide/`) with its pictures, credits and an example handout; `scripts/guide.py` copies it into the teacher site at build time (`course/guide/02-chalkline/`, git-ignored); `chalkline-guide: false` turns it off; teachers' own templates go in `course/guide/01-my-templates/`, listed above. **Next:** design guidance (the teacher's first draft), more template and example slides, the reusable-resources pages, sorting the deck's own CSS into Chalkline pieces, and a few vocab words of the guide's own (the lesson intro's vocab gallery uses this sample's words, so it's empty in other courses). **To check on the first render** (Quarto wasn't available when it was built): the guide shows under "How to use Chalkline" on the teacher site, the work gallery shows the example handout, and the student site shows no empty "My templates" section.

**Now a SIOP exemplar deck (decided 2026-11-04).** The template deck becomes one exemplar lesson as a **2D reveal.js deck**: each column is a lesson phase (Lesson intro, Building background, Input, Strategies, Interaction, Practice and application, Review and assessment), and moving down a column shows other ways to run that phase. The top row is a complete, solid lesson; every option's speaker notes say when to choose it, so teachers make decisions instead of copying. The phases are a usual order, not a rule: teachers repeat, mix or skip them. Neutral content; the interactive slides come from the sample units (Unit 5's angle explorer, polls and quick-fire review, Unit 4's math slides, timelines, review games, live boards). The slide-by-slide outline: [SIOP Exemplar Deck: Slide Outline](https://claude.ai/artifact/ARqYD48fmszB4YwPTxPpQD). The design guidance shrinks to a short rules page beside it (draft: `DESIGN-GUIDANCE-DRAFT.md`).

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
- **Design guidance** (to be written): short rules for people and for AI assistants to read before making new slides, focused on **high-quality slides that work for translanguaging**: one idea per slide, short sentences, room for a second language, pictures that carry meaning, contrast, consistent places for the same things. **Type follows the content's importance, not the space:** a slide uses a few sizes only (headings, content, small labels; the second language at 0.8 of its line), and when a slide is full the whole slide gets one notch smaller instead of shrinking some parts, so nothing is demoted by accident (worked out on the Slide kit's lesson intro). **The teacher writes the first draft** (decided 2026-11-04). It's a plain markdown file that a course can change: Chalkline ships the default in the extension (for example `_extensions/chalkline/guide/design-guidance.md`), and a course's own copy (for example `design-guidance.md` at the project root) overrides it. `CLAUDE.md`, `AGENTS.md` and `GEMINI.md` tell AI assistants to read the course's copy if there is one, otherwise Chalkline's. **Guidance only, no automatic checks** (decided 2026-11-04): checking code would add a lot of work and complexity for little gain.

### How it ships

- **Source:** the deck and its files live in the extension (for example `_extensions/chalkline/guide/`), with its own pictures and `CREDITS.md`. They update with Chalkline.
- **Rendering (decided 2026-11-04):** the guide, including the template deck, shows on the **teacher site** as a unit of its own ("How to use Chalkline"), with a short note on how to turn it off. **None of its files appear in the teacher's repository:** at build time, if the setting is on (for example `chalkline-guide: true` in `_quarto.yml`, on by default), `chalkline.py` copies the guide into a git-ignored folder that Quarto builds like any other unit. Never in the student site.
- **Turning it off** just stops it being built (`chalkline-guide: false`). Nothing is deleted from the extension, so the teacher can turn it back on later.
- **Turning it off hides the example slides, not the templates.** Every piece a template needs to work (layouts, CSS, scripts, shortcodes) is part of Chalkline itself (`styles/` and friends), not of the guide deck. A template copied into the teacher's course keeps working when the guide is off.
- **Teachers add their own templates** in their own course files (for example a `course/templates/` unit), where they are content like any other: theirs to change, and never touched by a Chalkline update. The guide unit lists them in a folder of their own, **above** Chalkline's templates.
- **The deck's own CSS** (looks, the puzzle layout, the style picker): follows from the rule above. What a template needs becomes a Chalkline piece (candidates: the puzzle layout, the draw.io hover script, now copied per unit, lesson phase tags); what only the guide's examples need stays in the guide.
- **Pictures:** keep them small, openly licensed and credited inside the extension.

## 3. An updated sample unit

**Status:** after sections 1 and 2.

A unit rebuilt from the templates, to show a real unit made the version 1 way: **lists first** (its vocab and key facts in `vocab/data/vocab.csv` and a facts list), then slides from the templates, a packet, glossing, games and the student site. The Hundred Schools of Thought material (thinkers, pictures, credits) is a ready start; it has no vocab yet, which makes it a good demonstration of starting from the list.

## 4. A streamlined setup

**Status:** to do. The example site must keep working with all its content, while a teacher who starts a course gets none of it.

**Where it is today (since 2026-10-27):** `quarto use template insufficientdoubt/project-chalkline` copies the project without the sample's content (`.quartoignore`), and `python chalkline.py setup`, run on first start, adds a starter unit. That works, but:

- The teacher types a Quarto command and answers three prompts (trust the authors, make a subdirectory, a folder name).
- A plain Git clone (the README's "Try this sample" route) brings every sample unit, with no step to strip the sample out afterwards.
- New pieces must stay out of a teacher's course too: the guide's build-time copy (section 2) needs to be git-ignored in every new course.

**To work out:** one short, obvious path from an empty computer to a teacher's own course, with as few commands and questions as possible. For example: a launcher or `python chalkline.py new` that makes the empty course for them, or a "start my own course" step that removes the sample content from a clone. The quick start (D1) then shows that one path.

## 5. Language support beyond vocab

**Status:** to do. Chalkline supports vocabulary well (the vocab list, glosses, galleries, games). Version 1 adds other ways to support language, built in the same way: lists first, then shortcodes and tools.

- **Language goals: a list of lists.** Sentence frames with response frames, phrases and collocations, conversation starters (and later discussion roles, signal words, question stems, talk moves), each its own list with shared columns (`id`, `zh`, `level`, `units`, `vocab_ids`…), checked by `python chalkline.py validate`, and placed with shortcodes (`{{< frame >}}`, `{{< lang "FRM-001, PHR-004" >}}`, `{{< lang unit=5 >}}`). The full plan is in `IDEAS.md` ("Language goals: a list of lists"); its "To decide" list comes first.
- **Structured conversation tools in the toolbox.** A pop-up classroom tool for **Think-Pair-Share**, plus one or two other common talk structures (for example **Turn and Talk** with A/B partners, and **Numbered Heads Together** or **Inside-Outside Circle**). Each shows its steps one at a time, with a timer for each step and the step's sentence frame. It sits in the toolbox menu next to the timers (the **Time** group, beside the clock and stopwatch), teacher site only, built from the toolbox's shared parts (`toolbox/kit.js`) like the other tools. Later it can take its frames from the language lists above.
- **Where it shows in the exemplar deck:** column 5 (Interaction) uses the talk tools, and the lesson intro's language objective uses the language lists.

## Order of work

1. Agree on this plan, the design guidance's scope and the open questions.
2. Template deck: move the Slide kit into the extension, add the reusable-resources pages, and add the "How to use Chalkline" section of the teacher site.
3. Intro deck: rebuild in the order above, reusing slides and linking to the template deck.
4. Updated sample unit.
5. Streamlined setup (section 4).
6. Language support beyond vocab (section 5): the language lists, then the talk tools. These can start earlier, alongside the exemplar deck, since its Interaction column needs them.
7. Version 1: update `README.md`, the quick start, `CHANGELOG.md` and the release notes.

## Decisions (2026-11-03)

- **No parent site.** There is no separate parent build: the public (student) site serves students and families, since the difference between them is small. **Done 2026-11-03:** the "For families" page is gone, and so is the `parent` audience label: `audience` is now `[teacher, student]` or `[teacher]`. Two sites only: student (public) and teacher. Later, a **syllabus page** may serve families.
- **Search covers vocab and packets too**, not only pages and slides: each vocab word (English, 中文, short definition) and the text of each packet should be findable from the site's search. To work out: adding vocab entries and packet text to Quarto's search index at build time (for example from `post-render`), so a result opens the vocab card or the right packet page.
- **The Slide style experiment** (`slide-style-slides.qmd`) **is retired once both new decks exist:** the feature demo deck (section 1, which includes the styling feature) and the full template deck with all the lesson templates in one place (section 2).

## Decisions (2026-11-04)

- **The guide is a unit on the teacher site, copied in at build time** (see section 2, "How it ships"): no guide files in the teacher's repository; a setting turns it off and back on; turning it off hides the example slides, never the templates themselves.
- **Teachers can add their own templates**, as their own content, listed in their own folder above Chalkline's.
- **Design guidance:** the teacher writes the first draft, as a markdown file. A course's own copy overrides the one in the extension. It's guidance for people and AI assistants only: no automatic checks. A course's copy **replaces** Chalkline's completely (simpler to understand); `chalkline.py` can copy the default in as a starting point.

## Open questions

- **A streamlined setup:** how exactly (see section 4).
