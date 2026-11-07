# Chalkline Design Guidance (draft)

Draft, 2026-11-04. Edited in Claude Docs: https://claude.ai/artifact/LBnUDu8tKJD3DUFUiCpVfR

## About this draft

A working draft, not yet in use. It collects what we've decided about slides (from `V1-PLAN.md`, `CLAUDE.md` and the Slide kit work), with the teacher's edits.

- **Where it will live:** `_extensions/chalkline/guide/design-guidance.md`, shown in the teacher site's "How to use Chalkline" section.
- **A course's own copy replaces it:** a `design-guidance.md` in a course replaces Chalkline's completely.
- **Guidance only:** no automatic checks. People and AI assistants read it and follow it.
- **Scope:** slides for now. Printables come later, with the packet layout templates.
- **Under review:** whether an exemplar deck should carry most of this, with a much shorter rules page (see `V1-PLAN.md`).

**Still open** (marked *[Decide]* below):

- [ ] Numbers for the limits: words per sentence, how full is too full, the smallest text size.
- [ ] The fixed places for things on a slide (the table in "Same things in the same places").

## The rules

Read these before making or changing a slide. The sections below explain each one.

1. **One idea per slide.** If a slide does two jobs, make two slides.
    - **Exception: process slides** that run a classroom activity. A well-designed layout that shows a lot is fine here. Examples: a Think-Pair-Share slide that reminds students of the steps and has its timers built in, or instructions for an activity where students are on different steps and need to see the whole process. Timeline and map slides can also show a lot; careful colour coding and type choices keep them clear.
2. **Short and simple.** Short sentences, simple words, one idea per bullet. At most 5 bullets on a slide.
3. **Few type sizes.** Headings, content and small labels only. The second language is 0.8 of its line.
4. **Too full? Shrink the whole slide.** Make the whole slide one size smaller. Never shrink one part on its own.
5. **Key slides in both languages.** Process slides, vocabulary slides and language slides are bilingual. Other content slides don't need to be, and some shouldn't be. Any slide can be made bilingual when teaching needs it.
6. **The primary language depends on the course.** Some courses are as bilingual as possible. Others use one language and give the other as support. Teachers may teach in English or Chinese.
7. **Same things in the same places.** Objectives, timers, vocab and the lesson phase always sit where students expect them.
8. **Pictures carry meaning.** A picture explains something. Never put text over a busy picture.
9. **Readable from the back of the room.** Big enough and with enough contrast, in every colour scheme.
10. **Start from an example slide, build with Chalkline's pieces.** Avoid one-off sizes, colours or positions.
11. **Credit every outside picture and source,** on the deck's credits slide.
12. **Say when a rule can't be kept.** Don't quietly squeeze a slide to make it fit.
13. **Lots of pictures? Ask first.** Offer placeholders first; the teacher chooses who finds the pictures, and when.

## Who the slides are for

Our students are K-12 English learners. Slides in English give scaffolding for key vocabulary. Decks pre-teach key vocabulary and key language points before the content points.

- **Students** read the slides from across a classroom, often in their second language.
- **Teachers and observers** look for the lesson's objectives, the task and the timing at a glance.
- **People and AI assistants** both make slides from this guidance. So each rule is short, concrete and something you can check by looking at the slide.

Good slides here are clear, calm and consistent. They are not decorated. The teacher can always read the source, see why a slide looks the way it does, and change it.

## One idea per slide

A slide has one job: teach one idea, give one task, or ask one question. A student should know what the slide is about within a few seconds. (Process slides are the exception: see rule 1.)

- **Split, don't squeeze.** Two ideas make two slides. Slides cost nothing; a crowded slide costs attention.
- **Short sentences.** Aim for 12 words or fewer. *[Decide: the number]*
- **Simple words.** Use the words students know, plus the unit's key vocabulary. Explain any other hard word, or change it.
- **One idea per bullet.** No bullet runs onto a third line.
- **How full is too full:** more than 5 bullets, more than about 40 words of English, or anything that needs the slide's text made smaller. *[Decide: the limits]* Exceptions: reading activity slides, and slides that show worksheet pages.
- **Details go in the speaker notes,** not on the slide. The teacher says them; the slide shows the key words. A slide can be only a picture or a video, with everything else in the notes.

## Type follows importance, not space

The size of text shows how important it is. Students read big text as important and small text as extra, so sizes must follow the content, not the room left on the slide.

- **Three sizes only:** headings, content, and small labels. Chalkline's text roles set them: `.kicker` (small label above a box), `.lead` and `.big` (for the one thing that matters most), `.small` and `.fine` (credits, notes).
- **The second language is 0.8 of its line.** `[English | 中文]{.bi}` does this for you. Never size the second language by hand.
- **When a slide is full, the whole slide gets one size smaller.** Every part shrinks together, so nothing loses importance by accident. Never make one box's text smaller to fit.
- **Still too full one size down?** Split the slide (see "One idea per slide").
- **No hand-set sizes.** No `font-size` on single words or boxes. If a template needs a new size, it becomes a Chalkline piece.

## Two languages: translanguaging

Students use both languages to understand. How much of each a deck uses depends on the course: some are as bilingual as possible, others teach in one language and use the other as support (rules 5 and 6).

**When to use both languages**

- **Both languages:** process slides (instructions, steps, timers), vocabulary and language slides, and anything a student must understand to start a task.
- **One language:** other content slides, in the course's primary language. Add the second language when teaching needs it.
- **Practice in the target language:** sentence frames, model answers, and text students read or write as language practice.
- **Review (quizzes, flashcards, games, tests):** in the target language only, unless the subject is taught bilingually. Math, for example, is taught in both languages, so its review can use both.
- **Write each pair once:** `[English | 中文]{.bi}`. The language switch in the slide's corner changes which one is big. Not every slide needs it.

**Leave room for the second language**

- Plan the key slides for both languages from the start. A full English slide has no room for 中文 later.
- Check a bilingual slide with the second language shown before you call it finished.

**Vocabulary**

- Gloss key words on slides with `{{< vocab "democracy" >}}`: a pop-up with a picture and 中文.
- Show a lesson's focus words together with `{{< vocab-gallery "…" >}}`, usually on the lesson intro.
- Only gloss words from the unit's vocab list. A new key word goes into `vocab/data/vocab.csv` first.

**Sentence frames**

- Give a frame on the first task where students speak or write: *My thinker believed that ___, because ___.*
- One frame per task. Put it where the task is, in the target language, with `[ ]{.gap}` for the blanks.

## Same things in the same places

When things always sit in the same place, students stop searching and start learning. Observers find the objectives at once.

| What | Where | How |
| --- | --- | --- |
| Language switch | Top-right corner | Added by Chalkline on bilingual decks |
| Lesson phase | Top of the slide, as a tag | A phase tag (Do now, Learn, Practice, Discuss, Reflect, Exit ticket) |
| Objectives | Lesson intro, in labelled areas | `.area` with `label="Content objective"` and `label="Language objective"` |
| Focus vocab | Lesson intro, language area | `{{< vocab-gallery >}}` |
| Timer | Bottom of the task box | `{{< timer 5 >}}`, pushed down with `.end` |
| Task steps | Left side, numbered | `.steps` or a numbered list in a `.box` |
| Credits | Last slide | `## [Credits \| 来源]{.bi} {#credits .credits}` |

*[Decide: are these the right places? The phase tags are still to be built.]*

- **Every lesson has the same shape:** a lesson intro with the Do now, then its phases, then an exit ticket.
- **Don't move a fixed thing** to make room. Make the slide smaller or split it.

## Pictures that carry meaning

For language learners, a good picture does half the explaining. Every picture on a slide should help a student understand something.

- **Meaning, not decoration.** If the slide works just as well without the picture, leave it out.
- **A real photo first,** a drawing only when a photo can't show the idea (abstract ideas, or when the photos are blurry, busy or watermarked).
- **Open licenses only:** Wikimedia Commons, Unsplash, Pexels, Openverse, museum open-access collections, or original drawings.
- **The picture sits beside the text, not behind it.** Use `.cover .media` so a caption never covers the picture.
- **Show the important part.** Move the crop with `--pic-position`; use `--pic-fit: contain` for drawings that must show whole.
- **Write `fig-alt`** for every picture: what it shows, in a few words.
- **Credit every outside picture** in the unit's `images/CREDITS.md` and on the deck's credits slide.

Many pictures at once take a long time to find. AI assistants offer to use placeholders first (see "Lots of pictures? Ask first" below).

## Readable from the back of the room

A slide is only useful if the student at the back can read it on a projector in daylight.

- **Size:** nothing a student must read is smaller than the content size. Small labels and `.fine` are for credits and notes only. *[Decide: a minimum, for example 24 px on a 1280 × 720 slide]*
- **Contrast:** dark text on light, or light on dark. No text on a busy picture or a mid-tone colour.
- **Check every scheme:** if a deck uses a colour scheme (night, sky, lagoon, sunrise) or a look, check the slide in it.
- **Colour is never the only signal.** Add a word, number or icon too: some students can't tell red from green.
- **Emoji:** avoid 🤖, 💩 and 🔒. The brand font shows them in black and white. Other common emoji are fine.

## Build with Chalkline's pieces

Slides are built from a few named pieces, not drawn one by one. That keeps every deck consistent, readable in the source, and easy to change.

1. **Start from an example slide:** first My templates, then Chalkline's guide (the Template Library). Copy the slide and change its words.
2. **Use the named pieces:** `.columns`, `.box`, `.tiles`, `.steps`, `.chain`, `.area`, `.strip`, timers, vocab galleries, the packet gallery.
3. **Use the text roles** for what words *are*, not where they go: `.kicker`, `.big`, `.lead`, `.pill`, `.small`, `.fine`.
4. **No one-off styling:** no hand-set sizes, colours, positions or `style=` tweaks, except picture crops.
5. **Need something new?** Make it a reusable piece (in `_extensions/my-tools/` in a course) and log it in `TOOL-CHANGES.md`. A good piece may join Chalkline for everyone.
6. **Name the pieces in the speaker notes,** like the Template Library does, so the next person can reuse the slide.

## For AI assistants

AI can help make slides, but the teacher stays in control. Follow these steps every time you make or change a slide.

1. **Read this guidance first.** Use the course's own `design-guidance.md` if there is one; otherwise Chalkline's (`_extensions/chalkline/guide/design-guidance.md`).
2. **Start from an example slide** (My templates, then the Template Library) and keep its structure.
3. **Keep the teacher's words.** Simplify only when asked, or when a rule above needs it, and say what you changed.
4. **Don't add** decoration, extra slides, emoji or pictures nobody asked for.
5. **Say when a rule can't be kept.** If the content doesn't fit, say so and suggest a split. Never shrink text, hide content or move fixed things to make it fit.
6. **Credit every picture and source** you add, without being asked.
7. **Check before you finish:** render only that file (`quarto render <file>.qmd`), look at it with both languages shown, and check it against the rules list.

### Lots of pictures? Ask first

Finding good, openly licensed pictures takes a long time. When a task needs many pictures (a new unit, a vocab list, a picture-heavy deck), don't stop to search for each one as you go.

1. **Offer to do the other work first,** with placeholders where the pictures will go. Each placeholder says what the picture should show, for example *[Picture: a Roman aqueduct, photo]*.
2. **Then let the teacher choose** how the pictures get done:
    - **You find them** while the teacher reviews the content, or
    - **The teacher picks them** themselves, and you fit and credit them.
3. **It's always the teacher's choice.** Ask once at the start, for any picture-heavy work. Don't decide for them.
