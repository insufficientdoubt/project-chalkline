# Changes to the tool

A log of changes to how Chalkline works or looks (code, styles, settings), as opposed to lesson content. AI assistants add an entry here whenever they change a tool file (see "Changing the tool" in `CLAUDE.md`); you can add entries by hand too.

**Why it matters:** this is design feedback. Send this file to John now and then: useful changes may be built into Chalkline for every teacher.

Newest entries first.

<!-- Entries go below this line. Copy this template:

## YYYY-MM-DD: short title
- **Asked for:** what the teacher wanted, in their words if they gave them.
- **Why:** the reason they gave, or "not given".
- **Changed:** each file and what changed in it.
- **Who it helps:** this course only, or probably every Chalkline course.
- **AI assistant:** which one made the change.
-->

## 2026-11-04: The exemplar deck's slide badge shows which build it is
- **Asked for:** "Can you add the PR number to the slide ID tag so we can see when it's been updated? Like {1.8 v82}. Or is there a better way"
- **Why:** to tell at a glance whether the published deck has the latest changes.
- **Changed:** `_extensions/chalkline/guide/build-stamp.lua` (new, temporary): at render time, the pull request number from the merge commit's message (or the short commit ID) and the time, as a `<meta>` tag. `guide/slide-refs.html`: the badge reads it ("1.8 · #82 · 4 Nov 15:10", the time in the viewer's time zone). `guide/exemplar-slides.qmd`: `filters: [chalkline, build-stamp.lua]`.
- **Who it helps:** this deck, while we edit it together; removed with the badge. The idea (a build stamp on published decks) might help any course that publishes with GitHub.
- **AI assistant:** Claude (Claude Code).

## 2026-11-04: Exemplar deck, round 2; vocab pop-up fix; text size; star survey; games and schemes
- **Asked for:** a second list of corrections to the exemplar deck by slide number, plus: "there's a bug where the pop-up card appears over another vocab item, then trying to interact with the pop-up surfaces the other card instead"; "on a slide with only one picture the picture should fill available space"; the live board's "QR code / control panel should be flush with the bottom of the slide… also have a collapse toggle"; "Add a font size increment tool to the slide size tool"; for the self-check, "another version… interactive with clickable star ratings for 1-4 stars… a student can just tap the three of them and the whole thing will beep and then fade so the next kid can do it. Then it will graph the results"; "Make quickfire and jeopardy somewhat responsive to themes. Same for the sorting one."; "Make trail the default style for this deck. Give sky just the faintest suggestion of clouds. Lagoon the background is too strong. Make it more mild. And add a little bit of a light wave pattern in white tracery. Sunrise should also be a little bit of a gradient representing a sunrise. But very mild."
- **Why:** not given (the deck as a model to copy from; the tools for everyday teaching).
- **Changed:**
  - `vocab-gallery.html`, `vocab-card.html`: an open card is raised above the cards after it (each card is its own layer, so later cards covered its pop-up and took its taps); a tap inside an open pop-up keeps it open; the pop-up's sideways position resets properly.
  - `styles/layout.scss`: a picture alone in a column fills the column's width (as tall as the slide allows); hero columns keep their crop.
  - `live-board/live-board.js`, `.css`: the corner card sits flush with the slide's bottom edge, with a fold button that shrinks it to a small "Join" tab (remembered).
  - `toolbox/tools/slide.js`: Text size, A− and A+ (70% to 150%), in the Slide size tool; Reset clears it.
  - `poll.html`, `filter.lua`: a new `::: {.star-survey stars="4"}` (tap 1 to 4 stars per line; when every line is rated it beeps, thanks the student and clears for the next one; Show results graphs each line, with its average). Smiley polls get the same SVG card buttons as true/false. poll.html also loads for a deck with only a star survey.
  - `games/games.css`, `games.js`: on slides, Quick-fire, Jeopardy, Sort it and every game's buttons take the colour scheme's tokens (Quick-fire's colours are mixed into the scheme's dark colour); web pages unchanged.
  - `styles/schemes.scss`: sky with faint clouds near the edges; lagoon at half strength with white wave lines; sunrise with a mild sunrise glow.
  - `guide/slide-kit-looks.css`: trail works as a whole deck's scheme (`slide-scheme: trail`), not only on one slide.
  - `guide/`: the exemplar deck (an intro without a Do now; today on the project calendar; full-screen picture; the reading keeps the current line in the middle with the others grey, and vocab glosses that pop up above the box; bigger jigsaw pictures; drawings for group roles; bilingual talk frames; a classroom map for stations; checklists that cross out; packet-page pictures for the self-check and homework; the star survey; trail as the deck's scheme, and a tip about the palette); `exemplar.css` and `reading-scroll.html` for those pieces; a new printable `self-check.qmd`; new photos and drawings (credited in `images/CREDITS.md` and on the Credits slide).
- **Who it helps:** the vocab pop-up fix, picture filling, live board panel, text size, star survey, poll buttons, games following schemes and the scheme changes: probably every Chalkline course. The guide changes: the exemplar deck.
- **AI assistant:** Claude (Claude Code).

## 2026-11-04: Exemplar deck corrections; footer clear of the ↓; Slide size tool fixed; true/false poll buttons
- **Asked for:** a list of corrections to the exemplar deck by slide number, and two problems on every slide: "there's another character under the 2 in (2 of 3)" and "The slide width tool isn't working." Per slide: press O for the overview (0.1); hero images (1.2, 1.5); a larger picture (1.6, 2.4); the quick-fire game as the review (1.7); "a two-week calendar with due dates for different stages of a PBL… days of the week marked and like a checklist" (1.8); 2.4 bilingual; 2.5 "I don't like these pills. The text looks crowded."; pictures in the word sort (2.6); beside the short reading, "a scrollable reading that advances line by line (and can be bilingual)… with an image on the side" (3.4); "photos or placeholders on every slide" of the timeline (3.6); "nicer buttons. Inline SVG." (3.7); a larger table (4.2); the Slide kit's drum kit slide for easy to hard (4.3); a picture placeholder above "Use it when" (4.5).
- **Why:** not given (making the exemplar deck a model teachers can copy from).
- **Changed:**
  - `_extensions/chalkline/guide/exemplar.css`: the footer label now stops before the bouncing ↓ and wraps to a second line (it had `width: 100%` from Quarto, so it ran under the arrow; that was the "character under the 2"). New pieces: `.column.hero` (a photo filling its column), `.pbl-cal` (two-week project calendar with stages, tickable checklists and due badges), `.compare-rows` (symbol, phrase, example), `.sort-big` (bigger picture cards in a word sort), `.reading-scroll` (line-by-line reading), `.big-table`, and lists in columns fill the column.
  - `_extensions/chalkline/guide/reading-scroll.html` (new, included by the exemplar deck): scrolls a `.reading-scroll` box so each new line sits in the middle.
  - `_extensions/chalkline/toolbox/tools/slide.js`: the Slide size window was too short to show its buttons, and "Wide (16:9)" did nothing on decks that are already 16:9 (like this one). Now the window fits, and the button is **Fill the screen**: it adds width on a wider screen or height on a taller one (16:10 laptops, 4:3 projectors), is greyed out when the deck already has the screen's shape, and follows window resizes.
  - `_extensions/chalkline/ui/ui.css`: a greyed-out look for a disabled button in a `.ui-seg` switch.
  - `_extensions/chalkline/poll.html`: true/false polls get card buttons with a badge drawn in inline SVG (colour, shine, ring, white mark with a shadow) and the word inside the card; a `.poll-tf` class on the poll. Other poll types are unchanged.
  - `_extensions/chalkline/guide/exemplar-slides.qmd`: the slide changes above, a new slide 3.5 (the big wheel reading), and the Credits slide lists the eight new photos. `guide/images/`: eight openly licensed photos (credited in `images/CREDITS.md`), the vocab drawings for vertex, side, ray and rotate, and a new `clockwise.svg`.
- **Who it helps:** the footer fix, Slide size tool and poll buttons: probably every Chalkline course. The new pieces in `exemplar.css` are candidates for Chalkline's slide kit.
- **AI assistant:** Claude (Claude Code).

## 2026-11-04: Live boards fill the slide; Excalidraw shows one board; Padlet zoom
- **Asked for:** "It looks like the one that's embedded and the one that the link goes to are two separate boards. And I would like it to be full screen by default with just a little thing in the corner with the QR code and link and the new room buttons so that we use as much of the screen as possible. No title. Or if there is a title, the title can be on top of the board." And for Padlet: "when I actually post to it, it's too large."
- **Why:** use the whole screen for the board; never show students a board that isn't the shared one.
- **Changed:**
  - `_extensions/chalkline/live-board/live-board.js`: `layout="full"` is the default (the board fills the slide; `layout="inline"` keeps the old frame with the bar under it). Excalidraw (not live in a frame) no longer gets a frame: its slide shows the room's QR code, link and an **Open the class board** button. A new `zoom` setting draws the board bigger and scales it down (Padlet starts at 0.7).
  - `live-board.css`: the full-slide board, the small corner card (QR code, link, buttons), the slide title floating at the top centre, the Excalidraw panel, the zoom.
  - `README.md`, `course/units/00-start-here/live-boards-slides.qmd`: how it works now.
- **Found:** Excalidraw's live sharing can't run inside a frame (excalidraw.com's rule), so an Excalidraw room is never on the slide itself: the class board is the tab you open. WBO and Padlet stay live on the slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-11-04: The exemplar lesson: a SIOP lesson as a 2D deck, first draft
- **Asked for:** "Make the first draft of the exemplar deck and merge it into Main." From the outline agreed in Claude Docs: "a 2d reveal deck ... a couple of options for each phase of a lesson. Teachers shouldn't be blindly copying they should be making decisions according to their students and their content."
- **Why:** step 2 of `V1-PLAN.md`: a solid SIOP pattern for a lesson, with the choices around it, as the main reference for teachers and AI assistants.
- **Changed:**
  - `_extensions/chalkline/guide/exemplar-slides.qmd` (new): one angles lesson (Grade 4, neutral content) in seven columns (Lesson intro, Building background, Input, Strategies, Interaction, Practice and application, Review and assessment). The top slide of each column is the default; the options below each have notes with "When to choose it", the SIOP features they serve, and their pieces. Every slide's footer names its phase. Interactive slides from Units 4 and 5 (angle explorer, sort, label it, put in order, polls, quick-fire, Jeopardy), the Slide kit's templates (lesson intro, Think-Pair-Share, jigsaw), and dashed placeholders for pictures and videos still to find.
  - `guide/exemplar.css` (new): the angle explorer's frame, the `.placeholder` box, the phase label in the footer.
  - `guide/angle-hunt.qmd` (new): the lesson's worksheet, shown in the work galleries.
  - `guide/embeds/` and `guide/images/`: Unit 5's angle explorer and drawings, copied; `images/CREDITS.md` lists them.
  - `guide/index.qmd`, `guide/README.md`: the exemplar comes first; the Slide kit is now second.
- **Found:** not rendered yet (no Quarto where it was written). The vocab galleries use this sample's words, so they're empty in other courses (the known gap).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-11-04: The design guidance draft stays out of new courses
- **Asked for:** "save this draft" (the design guidance, drafted in Claude Docs).
- **Why:** it's a planning file for Chalkline, like `V1-PLAN.md`, not something a new course needs.
- **Changed:** `.quartoignore`: `DESIGN-GUIDANCE-DRAFT.md` added to the planning files a new course leaves out.
- **Who it helps:** this repository only.
- **AI assistant:** Claude.

## 2026-11-04: The Chalkline guide: templates on the teacher site, copied in at build time
- **Asked for:** "The guide files including the templates should appear as a unit on the rendered teacher's site, with a simple note about how to disable them. But none of those files should appear in the teachers repository. So copied at build time if the flag is set." Teachers can add their own templates, "listed in another folder above chalklines". Turning the guide off "just not rendering them", and it hides the example slides, not the templates: "if the template is used in the teacher's course then of course it still works."
- **Why:** step 2 of `V1-PLAN.md`: every course gets Chalkline's templates as a reference that updates with Chalkline, without template files the teacher didn't write in their course.
- **Changed:**
  - `_extensions/chalkline/guide/` (new): the Slide kit deck moved here from `course/units/00-start-here/` with its looks, style picker, draw.io diagram and pictures (pictures the Slide style deck also uses are copied, not moved), `images/CREDITS.md`, a unit page (`index.qmd`, with how to turn it off), an example handout for the work gallery (it used Unit 1's packet, which other courses don't have), and a `README.md` for people who change Chalkline.
  - `_extensions/chalkline/scripts/guide.py` (new), first in `pre-render` in `_extension.yml`: on the teacher site, copies `guide/` into `course/guide/02-chalkline/` (only changed files, so the preview doesn't loop); on the student site or with `chalkline-guide: false`, removes it. `python chalkline.py guide --teacher` runs it by hand.
  - `build_if_needed.py`: runs `guide.py` before Quarto lists the files. `catalog.py`: `course/guide/` isn't listed in the overview; an `index.qmd` with `audience: [teacher]` is left out of the student site. `drawio.py`: skips the guide's copy.
  - `_quarto.yml`: `- auto: course/guide` in the sidebar, and the `chalkline-guide: false` setting, commented. `.gitignore`: `course/guide/02-chalkline/`. `chalkline.py`: the `guide` command in the list.
  - `starter/course/guide/01-my-templates/index.qmd` (new): the teacher's own templates' section, also added to this course.
  - `CLAUDE.md`, `styles/layout.scss`, `CHANGELOG.md`: the deck's new place.
- **Found:** the lesson intro slide's vocab gallery uses this sample's words (philosopher, empire, artifact, evidence), so in another course that area is empty (a warning, not an error). The guide needs a few words of its own, or a gallery that doesn't need the vocab list.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-11-03: A math domain (MTH) in the vocab list
- **Asked for:** "Create a new math unit in chalk line … Also generate a vocabulary list for this unit. It's for grade four."
- **Why:** the vocab list only allowed history topics (GRC, ROM, GBT), so the angle words had nowhere to go.
- **Changed:**
  - `vocab/schema.yaml`: `MTH` added to the ID pattern, with the subdomains `angles` and `measuring`.
  - `vocab/config.js`: names for the new topic (Math 数学) and its subdomains (角, 测量), and an "Angle (Simple English Wikipedia)" quick reference.
  - Content (no log needed, listed for context): Unit 5 `course/units/05-angles/` (bilingual deck, worksheet, homework, an interactive turning-angle page in `embeds/`), 15 words `MTH-001`–`MTH-015`.
- **Found:** the vocab app's name is still "History Vocab" (`vocab-title` in `_quarto.yml`, `title` in `vocab/config.js`, the sidebar's "History vocab 词汇"), which no longer fits a course with a math unit. Not changed: it's the teacher's choice. A course with several subjects may want one vocab app per subject, or a neutral name.
- **Who it helps:** this course only (any course adds its own domains the same way).
- **AI assistant:** Claude.

## 2026-11-03: Live boards: Padlet and shared whiteboards on slides, with a join QR code
- **Asked for:** "add a demo slide with an Excalidraw frame and one for padlet … we need to make it so that the join URL surfaces and we can click to get a QR."
- **Why:** to embed tools like Padlet or a digital whiteboard (no login) in slides, so students can join from their own devices.
- **Changed:**
  - `_extensions/chalkline/live-board/live-board.js` (new): `::: {.live-board}` on a slide becomes a frame with a join bar under it: the link, a small QR code (click it, or Show QR, for a big one over the whole screen; Esc closes), Open ↗, and on the teacher site Edit link (paste a link or a whole embed code; kept in this browser for that slide) and New room. `rooms="excalidraw"` makes Excalidraw room links itself (random room id and key, Excalidraw's own link form); `rooms="wbo"` makes a WBO board. In the slide PDF the frame becomes a big QR code; the PDF and the student site never make rooms of their own.
  - `_extensions/chalkline/live-board/live-board.css` (new): its look, from the design layer (ui/ui.css).
  - `_extensions/chalkline/filter.lua`: loads them (and `toolbox/qrcode.js`) on decks with a live board; marks it as the teacher's on the teacher site; on web pages and in PDFs, a live board is just a line with its link.
  - `README.md`: the live board in the table of things you can write. Content: the demo deck `course/units/00-start-here/live-boards-slides.qmd` and three links in `course/links.yml`.
- **Found:** Excalidraw switches off live sharing when it runs inside a frame (excalidraw.com's own code), so its frame is a board for the teacher alone and the class's room opens in its own tab. WBO (wbo.ophir.dev) stays live inside the frame (tested: a drawing in the slide's frame showed up in another browser). Padlet allows framing; its embed address and its share link are different, hence `src=` and `join=`.
- **Who it helps:** probably every Chalkline course.

## 2026-11-03: No families page, no `parent` audience: two sites only
- **Asked for:** "Drop the parent label and remove the families page now. We only have a student version and a teacher version now."
- **Why:** the public build serves both students and parents, "because the audience difference is barely anything". A families page would eventually be something like a syllabus page anyway.
- **Changed:** `families.qmd` deleted, and taken out of `_quarto.yml` (`render:` and the navbar). `_quarto-student.yml`: its comment says the student site is the public one. `catalog.py`: no `parent` audience, no "For families" chip, green rows or legend on the overview's "Who sees it", and `markdown_family_picks` / `markdown_learning` removed; `blocks.py` and `blocks.lua`: the `learning` and `family-picks` overview parts removed. `styles.scss`: the families row, chip and goals styles removed. `setup.py`: no `families.qmd` rename. `filter.lua`, `slides_pdf.py`, `index.qmd`: comments. Starter files: `audience: [teacher, student]`. `CHANGELOG.md`: how an existing course updates. `CLAUDE.md`, `README.md`, `EXTENSION-PLAN.md`, `V1-PLAN.md`: the two-site rule. Content: every `audience: [teacher, student, parent]` is now `[teacher, student]`; the intro deck no longer mentions the families page.
- **Who it helps:** probably every Chalkline course: one fewer label and page to understand.
- **AI assistant:** Claude.

## 2026-10-30: The vocab gallery fits the room it's given
- **Asked for:** "can you make the layout variable according to the width of the container? If I give them a narrow space I'd love them to be vertical, and if I give them a wide space I'd love them to be able to fill the whole slide."
- **Why:** so one shortcode works in a slide's side column, a box or across the whole slide.
- **Changed:** `_extensions/chalkline/vocab-gallery.html`: a few lines of script choose the columns from the gallery's width (each card at least `--vg-min`, 5em), then even out the rows (8 words in room for 6 make two rows of 4); when only one card fits, the cards become a list with the picture beside the word; pictures keep a 4:3 shape, so they grow with wide cards, and words grow a little too. Cards always have a thin line, so white cards show on a white slide. `cols=` is now a maximum. `_extensions/chalkline/shortcodes.lua`: passes `cols=` on. `README.md`: says so. Checked on whole slides (4 and 8 words), in wide, medium and narrow columns, and on the Slide kit's lesson intro.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-30: A vocab gallery
- **Asked for:** "make a gallery for specified vocab cards/tables. Lua code. Default view is picture+ word in a grid. Click on the card pops up the full vocab card. But a offer a table view as well." Then: put it on the lesson intro slide, and try it with more or fewer words.
- **Why:** not given; the lesson intro's focus words were hand-built boxes, and "at some point, we will probably have to make a better vocab picture injector thing".
- **Changed:** `_extensions/chalkline/shortcodes.lua`: new `{{< vocab-gallery >}}` (words by name from any unit, or `unit=`; options `view`, `cols`, `zh`; a table in PDF and Word); the pop-up card's markup is now one function shared with `{{< vocab >}}`. New `_extensions/chalkline/vocab-gallery.html`: the grid, the table, the Cards \| Table switch, click (or Enter) to open a card; colours, corners and borders from the slide's tokens, so schemes and looks restyle it. `README.md`: the shortcode. Checked on the Slide kit's lesson intro with 3, 4 and 8 words, both views, and in a PDF.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Timer buttons stay big enough to tap
- **Asked for:** "The timer buttons are tiny now. Fix and republish."
- **Why:** a timer made smaller to fit a box (the Slide kit's lesson intro, Think-Pair-Share and jigsaw slides) shrank its Start, Reset and +1 min buttons with it, to about 7px.
- **Changed:** `_extensions/chalkline/countdown.html`: the buttons are never smaller than 16px (in slide pixels); a full-size timer looks the same as before.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: The version 1 plan stays out of new courses
- **Asked for:** "make a planning document for the next stage… Put the planning doc on the main branch."
- **Why:** it's Chalkline's own planning, like `EXTENSION-PLAN.md` and `IDEAS.md`, not something a teacher's new course needs.
- **Changed:** `.quartoignore`: lists `V1-PLAN.md`, so `quarto use template` leaves it out of a new course. The plan itself is `V1-PLAN.md`.
- **Who it helps:** probably every Chalkline course (none of them gets a stray planning file).
- **AI assistant:** Claude.

## 2026-10-29: Classroom routine slides: lesson intro, instructions, Think-Pair-Share, easy to hard, a diagram
- **Asked for:** "Add example slides for these layouts. Instruction slides, TPS, diagram (as draw.io) work gallery... And of course the lesson intro + Do now slide." (from photos of the teacher's own slides)
- **Why:** not given; the Slide kit deck shows what Chalkline's pieces can do.
- **Changed:** `_extensions/chalkline/styles/layout.scss`: a card's picture can show whole (`--pic-fit: contain`, for drawings and icons); a new small square picture for a row, `![](file){.thumb}`, beside a `.num` and its words (a list of tasks or stations). The new slides in the Slide kit deck (`course/units/00-start-here/`) use only existing pieces besides these: the vocab pop-ups, timers (two on one slide), Quarto's video, Chalkline's packet gallery (`pdf-viewer layout="gallery"`), and a draw.io diagram shown like the Rome unit's.
- **Noticed (for Chalkline):** the draw.io hover script (`drawio-live.js` and `.css`) lives in the Rome unit's folder, so this deck needed its own copy; it could be part of Chalkline (a `{{< drawio >}}` shortcode). Making the diagram's picture needs the draw.io desktop app (`python chalkline.py drawio`); without it the SVG here was drawn from the `.drawio` file by a short script, so running `chalkline.py drawio` on a computer with draw.io will redraw it. A local `{{< video file >}}` doesn't size itself to its slide like YouTube and Vimeo links do.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Credits slide with pictures and sources
- **Asked for:** "add credits slide at the end. And add an AI instruction to do that automatically when possible. Maybe two columns - one for photo credits and one for sources links (if any are used)."
- **Why:** "it's good practice, demonstrate a good example to students, and it's free goodwill to show respect to sources."
- **Changed:** `_extensions/chalkline/styles/revealjs.scss`: headings on a `.credits` slide (`### Pictures`, `### Sources`) are small, to match its small print. `CLAUDE.md` (not a tool file, noted here for the reason): AI assistants add or update a deck's two-column credits slide whenever they add a picture or a source. The Slide kit deck got its credits slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: A picture on a card
- **Asked for:** "put a picture on each card in the cards slides" (with real, openly licensed pictures in place of the placeholders).
- **Why:** not given; the Slide kit deck shows what a deck can look like.
- **Changed:** `_extensions/chalkline/styles/layout.scss`: a picture as the first line of a `.box` fills the box's width, at the same height on every card, cropped to fill (`object-fit: cover`). `--pic-height` changes the height and `--pic-position` which part shows, e.g. `![](images/mencius.jpg){fig-alt="Mencius" style="--pic-position: 50% 60%"}`. Checked in the Slide kit deck's seven cards slides (plain, game, brutal, scroll, night, trail, glass).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Scheme backgrounds no longer go blank
- **Asked for:** "could you check that backgrounds are getting applied correctly when switching slides? I noticed that sometimes if you move from a slide with no theme to one with one it still has a blank background."
- **Why:** reveal.js throws away its background layers and makes new, blank ones whenever `Reveal.configure()` or `Reveal.sync()` runs. Chalkline painted the scheme backgrounds into those layers only once, when the deck opened. The toolbox's Slide size tool calls `Reveal.configure()` when a deck opens (for any teacher who has changed the slide size) and while its slider moves, so every slide with a scheme or look of its own (night, sky, lagoon, glass, scroll…) then showed a blank background.
- **Changed:** `_extensions/chalkline/schemes.html`: watches reveal's background layers and paints them again whenever reveal makes new ones (from the slides' classes, so a scheme the style picker put on a slide stays too). Checked in the Slide kit deck with a saved slide size: before, every themed slide was blank; after, all of them have their paper, forwards and backwards, and after `configure()` and `sync()`.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: One language on: it takes the top place
- **Asked for:** "when you select one language only, that language should swap to the dominant position, not stay as a subtitle." And: "A tiny reflow when you switch which one is on top isn't a bad thing."
- **Why:** the goal of the change below was that boxes don't suddenly get half as tall when a language is switched off, not that nothing moves at all.
- **Changed:** `_extensions/chalkline/bilingual/bilingual.css`: the language you show is large and first again; the hidden one stays invisible in the second language's place and size, so boxes keep their height (Slide kit cards: 274px both and EN, 270px 中).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: A hidden language keeps its room on slides
- **Asked for:** "when a language is hidden, it should just be invisible, not absent. That way the page won't reflow and look weird."
- **Why:** switching EN / 中 made everything on the slide jump: the hidden language's lines vanished and the shown one grew.
- **Changed:** `_extensions/chalkline/bilingual/bilingual.js`: marks a deck's `<html>` with `.bi-slides`. `_extensions/chalkline/bilingual/bilingual.css`: on slides the hidden language is `visibility: hidden` (it keeps its space), and the shown one keeps its size and place (⇅ still makes 中文 the large one). Pages that show one language through their labels still leave the other out, as before. The old Slide style experiment (`slide-style/`) is unchanged. Checked in the Slide kit deck: every bilingual line is in the same place in EN, 文A and 中.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Lagoon gets a slight gradient
- **Asked for:** "For the lagoon theme, give the background a slight gradient."
- **Why:** not given.
- **Changed:** `_extensions/chalkline/styles/schemes.scss`: lagoon's slide runs on a diagonal from a lighter turquoise (top left) to a slightly bluer one (bottom right). Its quieter text is a little darker, so it stays readable across the whole gradient (navy text 6:1 or better, quieter text 4.7:1).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Boxes in a row line up again
- **Asked for:** "an alignment issue on the big idea slide?"
- **Why:** the new gap between stacked blocks (two entries down) also applied inside tiles and chains, so every box after the first was pushed down.
- **Changed:** `_extensions/chalkline/styles/layout.scss`: that gap only applies outside tiles, chains and rows. Checked: the first row of every tile row and chain in the Slide kit deck lines up.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: A media layout whose caption never covers the picture
- **Asked for:** "for the media slide layout I noticed that the question would cover the bottom of the video/image." Also, for the Slide kit deck: "a kind of flat modern design with a background image (abstract, something from Unsplash) and semi-transparent tiles", and the scroll look's corner ornament "will overlap with the title text".
- **Why:** the picture was the slide's background, so the caption box sat on top of it.
- **Changed:** `_extensions/chalkline/styles/layout.scss`: `::: {.cover .media}` holds a picture (or video) and its caption; the picture takes all the room the caption leaves. A line holding only an `.absolute` thing (a pinned pill) takes no room.
  - Content: the media slide uses it; the deck's own **glass** scheme (an original abstract background in `images/abstract-glow.jpg`, frosted see-through tiles with `backdrop-filter`) with two slides and a place in the style picker; the scroll look's title moves clear of the corner ornament. Unsplash couldn't be reached from the AI's session, so the background is an original picture; any photo can replace it.
- **Who it helps:** probably every Chalkline course (the media layout).
- **AI assistant:** Claude.

## 2026-10-29: Slide columns with a real gap and equal heights
- **Asked for:** "on the slide with Confucius on government, the spacing looks off. Is this a style issue or something innate to the platform?"
- **Why:** the source box touched the two boxes under it, the gap between those two was smaller than elsewhere, and they had different heights.
- **Changed:** `_extensions/chalkline/styles/layout.scss`:
  - Slide columns are a flex row with the kit's gap, and as tall as the tallest; a box alone in a column fills it. Quarto draws slide columns as inline blocks: no gap but a space's width, always top-aligned, and their top margin is ignored. The top margin stays 0, so decks keep their spacing (checked on every columns slide in two unit decks and the Start-here deck: the columns move a few pixels apart, nothing else).
  - The kit's blocks (boxes, tiles, chains, strips, columns, steps) get a gap when one follows another.
  - A `.row` lines its items up on their text's baseline (a label and its source line); a row with a `.num` still centres.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-29: Night keeps its grid; a scheme's background can be any picture
- **Asked for:** "for the theme that comes from robotics make sure that it kept the background grid. And on the night theme ... make sure that the headline color is something visible." Also a "Songmont hobo" inspired theme with "casually placed short wavy lines on the background ... angled connectors and perfect circles", and a more ornate scroll look "to show off the styling capabilities".
- **Why:** to show teachers what the styling can do.
- **Changed:**
  - `_extensions/chalkline/schemes.html`: paints `--paper-size` too (night's 40px squares were fixed in the code; a whole-slide drawing needs `cover`), paints any slide whose scheme or look gives it its own paper, and offers `ChalklineSchemes.paint(slide)` to tools that change a slide's classes. Before, a scheme picked live drew in the wrong layer, so night lost its grid and a slide's own picture could be covered.
  - `_extensions/chalkline/styles/layout.scss`: new token `--paper-size`.
  - `_extensions/chalkline/styles/schemes.scss`: night's grid a little stronger (0.09 instead of 0.07) and `--paper-size: 40px 40px`. Night's titles are white (18:1); checked on every slide.
  - Content: the deck's own **trail** scheme (cream paper, suede boxes with white stitching, olive zigzags and angled lines, a stitched circle, turquoise beads, turquoise highlight) and a more ornate **scroll** look (paper fibres, a red frame with cloud-curl corners, a brush stroke under the title, a seal, cards on wooden rods) in `slide-kit-looks.css`; two trail slides; trail in the deck's style picker.
- **Who it helps:** probably every Chalkline course (the painting fix and `--paper-size`); the trail scheme and scroll look are this deck's.
- **AI assistant:** Claude.

## 2026-10-29: Colour schemes from the brand colours
- **Asked for:** "Could you make a couple of more color schemes using the brand kit colors as the foundation? You can also have a look at the robotics League repo because I think there's already a good color scheme there."
- **Why:** to show teachers that slides don't have to look bland.
- **Changed:**
  - `_extensions/chalkline/styles/schemes.scss` (new, loaded with every deck): four schemes that only set the slide kit's tokens: **night** (the Robotics League course's "Workshop Night" dark slides with graph paper), **sky**, **lagoon** (turquoise, navy text) and **sunrise** (warm orange paper). Night also recolours Quarto's callouts and code.
  - `_extensions/chalkline/schemes.html` (new): paints a scheme's colour behind the slide (reveal.js draws backgrounds in a separate layer). `filter.lua` adds it to every deck and reads a deck's `slide-scheme:` label.
  - `_extensions/chalkline/styles/revealjs.scss`: Chalkline's slide pieces (titles, bold text, vocab cards, tables, steps, frames, goals, timelines, big numbers) use the tokens instead of fixed brand colours. Same colours as before; checked on a unit deck, pixel for pixel apart from the clock.
  - `_extensions/chalkline/styles/layout.scss`: new tokens `--rule`, `--link`, `--hot-text` (the orange, dark enough for small words: 4.7:1 on white; the bright orange was 2.3:1) and `--paper-image`; slide text, `###` titles and links follow the tokens.
  - `_extension.yml`, `README.md`, `CHANGELOG.md`: load it, a row, an entry.
  - Content: six scheme slides at the end of `00-start-here/slide-kit-slides.qmd`.
- **Who it helps:** probably every Chalkline course. The Robotics League course's 40 or so lines of dark-slide overrides could become `slide-scheme: night` once it has this version of Chalkline.
- **AI assistant:** Claude.

## 2026-10-29: Bilingual text on its own; a slide kit and a second experiment deck
- **Asked for:** "Do the bilingual bit. Then make a second experiment deck using examples + built in layout tools" (content from the slide designs made the day before). "Mark the Lua short codes built yesterday for removal." "If open props/utopia helps, include."
- **Why:** the first experiment had "very detailed context specific styling"; "we're going to need more generic reusable styling so that we have different types of text." Example slides rather than fixed templates, because "we don't know in advance what content the teachers will need" and "our goal is flexibility as a tool."
- **Changed:**
  - `_extensions/chalkline/bilingual/` (new): `bilingual.lua` turns `[English | 中文]{.bi}` into two marked spans anywhere (slides, pages, PDFs); alone in its line it stacks, in a sentence it stays on one line. `bilingual.css` styles only the second language (smaller, lighter), so a title stays a title and a dark box stays dark; `--bi-*` variables change it. `bilingual.js` reads the deck's `bilingual:` labels and adds the language switch to slides (same saved setting as the first experiment's). In HTML the class is `.bil`, because Bootstrap's icons already use `.bi`.
  - `_extensions/chalkline/styles/layout.scss` (new, loaded with every deck): design tokens (colours, radius, shadow, a type scale named like Utopia's), layout pieces `.tiles` (as many columns as boxes) `.chain` `.row` `.cover`, `.box` (`.plain` `.dark` `.accent` `.hot` `.spot`), `.strip`, and text roles `.kicker` `.big` `.lead` `.pill` `.num` `.muted` `.small` `.fine` `.gap`.
  - `_extensions/chalkline/filter.lua`: a `.box` whose first line is a `###` title stays one box (pandoc made it a slide of its own).
  - `_extensions/chalkline/_extension.yml`: loads the two. `README.md`, `CHANGELOG.md`: rows and an entry.
  - Marked **to be removed**: `slide-style/` (all four files) and `toolbox/tools/style.js` (comments at the top; `toolbox.js` comment).
  - Content: new teacher-only deck `00-start-here/slide-kit-slides.qmd` (section, big idea, source and meaning, cards, task, reveal table, media, sentence frames, then the cards in three looks and the big idea dark) and its own looks in `slide-kit-looks.css`. The first experiment deck's description says it will go.
  - Open Props and Utopia: not added. The slide is a fixed size that reveal.js scales, so Utopia's fluid sizes don't apply, and the 20 or so tokens needed are fewer than Open Props would bring in (it would also need copying into the project, since builds work offline). The token names follow theirs, so either can be added later.
- **Who it helps:** probably every Chalkline course (bilingual text); the slide kit is an experiment for now.
- **AI assistant:** Claude. Checked with real renders (Quarto 1.9.17) and screenshots of every slide in a headless browser, in both languages as primary, English only, and a page and a PDF with bilingual text.

## 2026-10-28: Slide style prototype, round 2 (own deck, corner language switch, nothing cut off)
- **Asked for:** "this is an experiment, put it into a side deck"; "don't show the style tool in the toolbox, just pop it up when you go onto those slides"; "some stuff gets cut off"; "Make the language toggles appear in the corner of the slide. Understated. EN / (translate icon) / Zh, and another toggle for which one is primary. Then a 'style...' thing to pop up controls."
- **Why:** "We wont actually ship this capability to live-restyle slides, probably. Live control language, yes, but not color/layout. This is for demo/testing purposes."
- **Changed:**
  - `slide-style/slide-style.js`: a quiet switch in a styled slide's top-right corner: EN · 文A (both) · 中, ⇅ to swap which language is large, and (teacher site) Style… to open the panel. Remembered in this browser for every deck; in both sites; not on one-language slides, the PDF or speaker view's previews.
  - `slide-style/slide-style.css`: the switch's look; 16px side padding on styled slides, because tilted game cards and brutal shadows at the edges were cut off.
  - `toolbox/tools/style.js`: not in the toolbox menu (`menu: false`); opens from Style…, hides when you leave the styled slides and comes back on them, closes for good with its ×. Languages are no longer in it (the corner has them).
  - `toolbox/toolbox.js`: a tool with `menu: false` stays out of the menu; `ChalklineToolbox.open/close/isOpen` so such a tool can open its own panel. `kit.js`, `filter.lua`, `slide-style.lua`: comments.
  - Content: the four experiment slides moved out of `00-start-here/slides.qmd` (back as it was, default slide size) into a new teacher-only deck `00-start-here/slide-style-slides.qmd`.
- **Who it helps:** this course's demo only for now. The corner language switch could become a Chalkline feature for every bilingual course.
- **AI assistant:** Claude. Checked in a mock page in a headless browser (Quarto couldn't be installed in its session), not a real render.

## 2026-10-28: Slide style prototype (restyle a slide without changing its words)
- **Asked for:** slides whose look can be changed (layout, colours, look, language shown and which language is large) without retyping them, with the controls in a pop-up panel; pushed into the Start-here deck as a prototype. Teachers can also add their own colour schemes or card art in their own CSS.
- **Why:** teachers' slides were crowded and each in a different style; bilingual (English and 中文) text should be written once and shown either way.
- **Changed:** new `_extensions/chalkline/slide-style/` (`slide-style.lua` the filter, `slide-style.css` and generated `slide-style-count.css` the looks, `gen-count-css.py` the generator, `slide-style.js` click-to-select and full-screen background); new toolbox tool `toolbox/tools/style.js` ("Slide style", teacher site only, shown only in a deck with styled slides); `_extension.yml` and `filter.lua` load them; `toolbox/toolbox.js` lists the tool; `ui/icons.js` gets a palette icon. Content: three styled slides and an intro slide in `course/units/00-start-here/slides.qmd`, plus `slide-style-teacher.css` (example own schemes: bamboo, scroll) and placeholder pictures in `images/`. That deck is now 1280 x 720.
- **Who it helps:** this deck only for now (other decks are unchanged; nothing happens without `{.styled kind="..."}` on a heading). Probably every Chalkline course if it works out.
- **AI assistant:** Claude. Known gaps: pictures are placeholders; the slide PDF export of styled slides is not tuned (reveal's print layout ignores their fixed-height layout).


## 2026-10-28: A hosting note in the extension (Cloudflare Workers)
- **Asked for:** "Please write concise instructions for the correct and updated process using the MCP to do as much as possible. Include a step for creating a cloudflare account if the user doesn't have one. Once you have that done add this process as a new note inside the chalk line extension on the main project chalk line repository."
- **Why:** "This will facilitate easier setup for users." The Robotics League course went online this way and it works.
- **Changed:**
  - `_extensions/chalkline/HOSTING.md` (new): seven steps; Claude does the files, the account checks and the teacher sign-in (Cloudflare Access, email codes) with the Cloudflare API connector; the teacher makes the account, the token and the GitHub secrets.
  - `_extensions/chalkline/hosting/` (new): `deploy.yml` (builds both sites, checks the secrets, uploads from `main`, uploads the teacher site only once its address asks for a sign-in), `public.jsonc`, `teacher.jsonc`, `teacher-placeholder.jsonc` and the placeholder page. From Robotics League, with general names (`my-course`); the workflow reads the teacher Worker's name from `hosting/teacher.jsonc`.
  - `_extensions/chalkline/README.md`: a row for them. `CHANGELOG.md`: an Unreleased entry.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: No Shortcuts icon in the toolbox menu
- **Asked for:** "What's the shortcuts actually do that we haven't already done?" Then: "Yeah just get rid of the shortcuts icon and then merge the update."
- **Why:** it opens reveal.js's list of keys, which is rarely needed during a lesson. The **?** key still opens it.
- **Changed:**
  - `_extensions/chalkline/toolbox/toolbox.js`: Shortcuts is gone from the Slides row (six icons now).
  - `_extensions/chalkline/ui/icons.js`: the `keyboard` icon, which nothing else used.
  - `README.md`: the Slides row, and that ? still lists the keys.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: Speaker view gets a notes icon
- **Asked for:** "Change speaker view icon to something looking more like notes."
- **Why:** "I think most teachers actually teach by projecting instead of loading the content directly on the display. But it is useful in case they want to do that." The screen icon looked like a projector or display setting; the speaker view is really your notes.
- **Changed:**
  - `_extensions/chalkline/ui/icons.js`: Lucide's `notepad-text` replaces `monitor`, which nothing else used.
  - `_extensions/chalkline/toolbox/toolbox.js`: Speaker view uses it.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: The toolbox menu: Slides as icons, Slide size by Dice
- **Asked for:** "How about just icons only for that row, with functions on hover? And then move slide size up to next to dice."
- **Why:** "I think that's actually a pretty common one when you're accessing the other tools" (Slide size).
- **Changed:**
  - `_extensions/chalkline/toolbox/toolbox.js`: Slides is a row of icon buttons; each has its name and key as a label for screen readers and for the hover tip. Slide size is back under More, after Dice.
  - `_extensions/chalkline/toolbox/toolbox.css`: square icon buttons, and a dark tip above one when you point at it or tab to it. The menu and its tiles are back to their first size (372px wide, 74px tiles): with one row of icons it fits an 800-pixel-high screen with room to spare.
  - `README.md`: the Slides icons.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: The toolbox menu: back to rows, with a shorter bottom
- **Asked for:** "I think the old layout was a bit clearer. Any other ideas?" Then, of the ideas: "yeah show me idea 1".
- **Why:** the columns (entry below) were harder to read than one group per row, top to bottom.
- **Changed:**
  - `_extensions/chalkline/toolbox/toolbox.js`: the groups are rows again, three tiles across, as before the entry below. More is Music and Dice. **Slides** at the bottom is small buttons with their keys, with Slide size and View source in it too.
  - `_extensions/chalkline/toolbox/toolbox.css`: the menu is a little wider (408px) and its tiles and headings a little shorter, so it fits on an 800-pixel-high screen with its footer. The small buttons' styles.
  - `README.md`: the Slides buttons.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: A shorter toolbox menu: for the class, and for you
- **Asked for:** "the tool menu is getting super crowded. Any ideas to make it less messy while still keeping everything discoverable?" Then, after the ideas: "Yeah show me first."
- **Why:** too crowded. On an 800-pixel-high screen the menu ran past the bottom, cutting off its last row and its footer.
- **Changed:**
  - `_extensions/chalkline/toolbox/toolbox.js`: the menu has two parts. For the class: a column for each group, with Dice in People and Music in Attention, so "More" is only for a course's own tools. For you: Slide size, View source and reveal.js's own tools as small buttons with their keys (they replace the Slides tiles).
  - `_extensions/chalkline/toolbox/toolbox.css`: the menu is wider (540px, at most the screen width) and shorter; the styles for the columns and the small buttons; two groups across on a narrow screen.
  - `README.md`: the menu's two parts.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: View source: word wrap
- **Asked for:** "It works. Add word wrap."
- **Why:** not given.
- **Changed:**
  - `_extensions/chalkline/toolbox/tools/source.js`: a **Wrap** button. Long lines fold under their line number. It starts on, and on/off is remembered in this browser (`source-wrap`). The Open in VS Code button is no longer underlined.
  - `README.md`: Wrap, in the View source row.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: View source (U): how any slide is made
- **Asked for:** "a 'view source' tool that would show the source for any slide, with syntax hilighting? So you could quickly see how any slide is made." Then: "yes, build it with U".
- **Why:** to see quickly how a slide is made.
- **Changed:**
  - `_extensions/chalkline/toolbox/source.lua` (new): reads the deck's `.qmd` before Quarto changes it and cuts it where reveal.js starts a slide (headings at the slide level, `---` after an empty line; not inside `:::` blocks or code). Each piece gets its slide's id, using pandoc's own rule. Also the file's full path for Open in VS Code, except on GitHub's build (`CI`).
  - `_extensions/chalkline/toolbox/tools/source.js` (new): the View source tool. It shows the current slide's lines with line numbers and its own small highlighter for headings, `:::` blocks, `{.classes}`, shortcodes, code, bold, links, lists and the labels at the top. It follows slide changes. **Copy**, and **Open in VS Code** (localhost only). Key **U**.
  - `_extensions/chalkline/filter.lua`: puts the source in each teacher deck as JSON (never in the student site: it has the notes and answer keys), and loads the tool.
  - `_extensions/chalkline/toolbox/toolbox.js`: View source under More in the menu.
  - `_extensions/chalkline/ui/icons.js`: Lucide's `code` and `copy` icons.
  - `README.md`, `_extensions/chalkline/CHANGELOG.md`, and the Start Here deck's toolbox list: the new tool.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: Lesson files open in the visual editor
- **Asked for:** "is there a less intimidating editor than vs code?" Then, of the options: "Yes implement visual mode by default."
- **Why:** plain-text markup (`##`, `**`, `:::`) is intimidating for teachers who don't code; the visual editor looks like a word processor.
- **Changed:**
  - `.vscode/settings.json`: `.qmd` files open in Quarto's visual editor (`workbench.editorAssociations`). Ctrl+Shift+F4 (Mac: Cmd+Shift+F4) switches to the plain text and back.
  - `README.md`: an "Editing in VS Code" section: what visual mode shows, how to switch, and that saving may tidy a file's spacing. (Checked in the Quarto extension's source: it writes shortcodes and the labels at the top back exactly as they were.)
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: New courses keep Mingwan's name, logo and colors
- **Asked for:** "include the mingwan colors and brand as default. But leave a stub for switching in generic values. If we want to share this more widely later. Right now mingwan is the only school that's using this so there's no reason not to include our logo."
- **Why:** every Chalkline course is at Mingwan for now. This changes part of the entry below: new courses are still "My Course", but not "Your School".
- **Changed:**
  - `_extensions/chalkline/scripts/setup.py`: a new course gets "My Course" and "Course Vocab" / "Vocab 词汇" but keeps "Mingwan School", the emblem and the colors. The generic swaps ("Your School", the sailboat as logo) are kept as `GENERIC_NAMES`, off until `GENERIC_BRAND = True`.
  - `.quartoignore`: copies the Mingwan emblem again.
  - The Quick Start's step 5: change only "My Course".
- **Who it helps:** this school's courses; the switch is for every Chalkline course later.
- **AI assistant:** Claude.

## 2026-10-27: New courses start as "My Course" at "Your School"
- **Asked for:** "Use My Course and Your School as the starter names."
- **Why:** a new course is a copy of the sample's settings, so it started with the sample's title, school, logo and "History vocab".
- **Changed:**
  - `_extensions/chalkline/scripts/setup.py`: when it adds the starter unit to a new course, it also changes the sample's names: "My Course" (title, teacher title), "Your School" (`school:`, the brand name), "Course Vocab" / "Vocab 词汇", and the sailboat icon instead of the Mingwan emblem as the full logo (`brand/_brand.yml`, `families.qmd`).
  - `.quartoignore`: leaves out the Mingwan emblem (`brand/logos/logo-emblem.png`).
  - The Quick Start's step 5 names "My Course" and "Your School".
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: All slides: every deck as rows of slide pictures
- **Asked for:** "a way to combine all the slide decks for a visual course overview on one page." Of three layouts, (b): "a contact sheet: one row of slide pictures per deck, grouped by unit... Clicking on a slide would take you into that slideshow right?"
- **Why:** to see the whole course at a glance. Quarto has nothing built in for this: listings show one card per page, and reveal.js's overview (press O) shows only one deck.
- **Changed:**
  - `_extensions/chalkline/scripts/slide_pictures.py` (new): after each full render (and for changed decks when the launchers start), opens every unit's decks in Chrome or Edge, shows each slide with all its steps and saves a small picture (`<deck>-pictures/01.jpg`, ...), then writes `slide-pictures.json` at the site root. About 40 seconds and 3 MB for this sample's 160 slides.
  - `_extensions/chalkline/slide-wall/slide-wall.js`, `slide-wall.css` (new) and the `{{< slide-wall >}}` shortcode in `shortcodes.lua`: the page: unit sections, a row of pictures for each deck (title, slide count, PDF), Small / Medium / Large (remembered), a click opens the deck at that slide.
  - `all-slides.qmd` (new) and `_quarto.yml`: the page, in the render list and the sidebar ("All slides").
  - `_extensions/chalkline/_extension.yml`: the new post-render step. `scripts/build_if_needed.py`: the launchers redo out-of-date pictures. `scripts/slides_pdf.py`: `launch()`, shared by both, also tries a Chromium installed by Playwright when there's no Chrome or Edge.
  - `chalkline.py`, `README.md`, the extension's `README.md` and `CHANGELOG.md`.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: New courses without the sample's content, and a starter unit
- **Asked for:** "Can we make it so that there is an initial setup script when the extension is installed that builds a starter unit with one slideshow one hand out? But then I'm still a little bit unsure about how they get the project started... if they start from zero they still have to clone a repo, and then they still get all the demo content... Right?"
- **Why:** cloning (or GitHub's "Use this template") copies every file, so a new teacher got three history units and the STEM sampler to delete. Quarto has no hook that runs on `quarto add`, but `quarto use template` copies a repository *except* what its `.quartoignore` lists, and installs its extensions.
- **Changed:**
  - `.quartoignore` (new): what `quarto use template insufficientdoubt/project-chalkline` leaves out: the sample's units, vocab, pictures and course files, the build folders, the planning files and the publish workflow (it publishes the teacher site, answer keys included).
  - `_extensions/chalkline/starter/` (new): a new course's first unit (`01-first-unit`: the "Welcome to Class" deck and the "Classroom Words" handout), four classroom vocab words with 中文, four sentence frames, and a general `vocab/schema.yaml`, `vocab/config.js`, `course/season.yml`, `course/links.yml` and an empty `TOOL-CHANGES.md`.
  - `_extensions/chalkline/scripts/setup.py` (new): copies any starter file that's missing; the unit only into a course with no units. Never replaces a file.
  - `_extensions/chalkline/scripts/build_if_needed.py`: runs setup first, so the launchers and VS Code set up a new course the first time they start. `chalkline.py`: lists `setup`.
  - `README.md`, `_extensions/chalkline/README.md`, `CHANGELOG.md`, `EXTENSION-PLAN.md` (step 7), the Start here deck: how to start your own course. `CLAUDE.md`: `.quartoignore` is a tool file.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-27: Robotics material out of Chalkline and the sample
- **Asked for:** "The robotic stem stuff shouldn't actually be included in the extension... There's a much better version in the robotics League course." Then: "Yes let's pull the robotic stuff for now."
- **Why:** Chalkline should serve any subject; the robotics League course has the better version, and can be linked or embedded once it's published.
- **Changed:**
  - Content: `course/units/04-stem/linkages-slides.qmd` and its `embeds/lifts.html`, `catapult.html`, `linkage.html` and `images/title-linkages.svg` removed; the unit's description, objectives and credits, the two linkage links in `course/links.yml`, and the Start here catalogue (59 features now, not 63) updated.
  - `_extensions/chalkline/styles/revealjs.scss`: the robotics-only slide styles removed (challenge cards, judges box, role cards, league cards, role badge, example line, CREST table), about 130 lines none of the decks used. The general ones stay (statement, section, closing, big numbers, timeline, steps); `.closing-crest` is now `.closing-kicker`.
  - `_extensions/chalkline/shortcodes.lua`, `scripts/vocab_terms.py`, `scripts/vocab.py`: VEX names and examples made general (`vex_vocab` is `vocab_index`, the example word is "democracy").
  - `_extensions/chalkline/scripts/import_vocab.py`: `--vex` is now `--source`, a history example, and the word lists record `id:` instead of `vex_id:` (the sample's three lists changed to match).
  - `_extensions/chalkline/scripts/catalog.py`: an outside link with no `source:` is shown as "Website", not "Official VEX".
  - `_extensions/chalkline/poll.html`, `README.md`: the poll example asks about Athens and Sparta instead of robot arms.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: A README and changelog inside the Chalkline extension
- **Asked for:** part of running the extension plan ("just run the whole process").
- **Why:** so the instructions (install, update, what's where) and the list of changes go with every copy of the extension.
- **Changed:** new `_extensions/chalkline/README.md` (install with `quarto add insufficientdoubt/project-chalkline`, *before* setting `type: chalkline`; update; never edit the installed folder; what each folder does) and `_extensions/chalkline/CHANGELOG.md` (0.1.0).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: The vocab app and the vocab checker move into the extension; templates for new decks and worksheets (step 4 of the extension plan)
- **Asked for:** "just run the whole process, and update the repo as you complete each step". Templates: "slide templates we build? Not many of those yet, but they're coming."
- **Why:** the vocab app is the same in every course and gets fixes; starter files make a new deck or worksheet quick and consistent.
- **Changed:**
  - `vocab/app/index.html` and `vendor/` moved to `_extensions/chalkline/vocab-app/`. Before each render, `scripts/vocab_app.py` (was `vocab_brand.py`) copies the app into `vocab/app/` (now not saved in git) and fills in the logo from `_brand.yml`; it still writes `brand.css`. The app's leftover "VEX IQ Vocab" title is now "Vocab" (the course's `config.js` sets the real one).
  - `vocab/validate.py` moved to `_extensions/chalkline/scripts/validate_vocab.py`: run `python chalkline.py validate`. `vocab/schema.yaml` stays in the course (it lists the course's own topics and ID prefixes), as does `vocab/tools/draw_icons.py` (it draws this sample's pictures).
  - New `_extensions/chalkline/templates/` (`slides.qmd`, `worksheet.qmd`) and `scripts/new.py`: `python chalkline.py new slides 2 "Roman Roads"` makes `course/units/02-…/roman-roads-slides.qmd` with the title, the next `order:` and the unit filled in. A course's own `templates/` folder is used first.
  - `scripts/blocks.py`, `blocks.lua`: a shortcode error (like a word that isn't in the unit's vocab) now says what's wrong, on the page and in the render log.
  - `.vscode/tasks.json`: "New slide deck or worksheet" (asks kind, unit and title) and "Check the vocab list". `.gitignore`, `README.md`, `CLAUDE.md`, `vocab/README.md`, `vocab/index.html`, `vocab/schema.yaml`, `chalkline.py`, `build_if_needed.py`: the new names and places.
  - Checked: fresh full teacher and student renders (with `vocab/app/` deleted first): same files, all PDFs identical, the vocab app looks the same; both templates render.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Chalkline's scripts move into the extension; pages use shortcodes instead of Python (step 3 of the extension plan)
- **Asked for:** "just run the whole process, and update the repo as you complete each step".
- **Why:** so fixes to the catalog, packets, slide PDFs and other scripts reach every course with `quarto update`.
- **Changed:**
  - `scripts/*.py` moved to `_extensions/chalkline/scripts/`. `import_vex_vocab.py` is now `import_vocab.py` (it works for any course's vocab list). Each script finds the course folder with `extension.py`, wherever the extension is installed.
  - `_extensions/chalkline/_extension.yml`: the pre-render and post-render steps are part of the Chalkline project type, so `_quarto.yml` no longer lists them (a course can still add its own).
  - New `chalkline.py` in the course: one command for Chalkline's scripts (`python chalkline.py packets --unit 3`, `slides-pdf`, `open student`, `export-vocab`, `import-vocab`, `drawio`, `build`), so nobody types the extension's path. The launchers, `.vscode/tasks.json`, `README.md`, `CLAUDE.md` and `vocab/README.md` use it.
  - New shortcodes (`_extensions/chalkline/blocks.lua`, `scripts/blocks.py`): `{{< vocab-cards >}}`, `{{< word-bank >}}`, `{{< vocab-table >}}`, `{{< vocab-list >}}`, `{{< fill-in-the-blank >}}`, `{{< overview ... >}}`, `{{< season-events >}}`. They call the same Python helpers the pages used to call from code cells.
  - Content: 9 lessons, `index.qmd` and `families.qmd` use these shortcodes instead of `import sys; sys.path.append("scripts")` code cells (which would break once the scripts moved). A full build now starts Python 6 times instead of 20.
  - Checked: full teacher and student renders; all 166 PDF pages identical pixel for pixel; screenshots of the 11 changed pages identical (except a matching game, which shuffles on every load); `chalkline.py` commands run.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Chalkline's page, slide and PDF design moves into the extension (step 2 of the extension plan)
- **Asked for:** "start step 2. actually, just run the whole process, and update the repo as you complete each step".
- **Why:** so a fix to how worksheets, slides or pages look reaches every course with `quarto update`, and a school's brand stays the school's.
- **Changed:**
  - Moved into `_extensions/chalkline/`: `brand/styles.scss` and `brand/revealjs.scss` (now `styles/`), `brand/type-colors.html` (`styles/`), `brand/typst/*.typ` (`typst/`), `brand/fonts/print/` (`fonts/print/`).
  - `_extensions/chalkline/_extension.yml`: a Chalkline project type. `project: type: chalkline` in `_quarto.yml` brings in Chalkline's themes, the overview's type colors, the PDF layouts and the PDF fonts, with no paths to the extension (so it works wherever `quarto add` puts it). The course's own settings merge on top; its stylesheets load after Chalkline's.
  - `styles/revealjs.scss`: the colors come from `_brand.yml`'s palette (`$brand-navy`, ...) instead of hex codes typed in; the school's fonts moved out.
  - New `brand/styles.scss` and `brand/revealjs.scss`: only the school's own settings (fonts, the "Source Sans 3" fix). Add overrides here.
  - `typst/typst-template.typ`, `typst-show.typ`: the school's name comes from `school:` in `_quarto.yml` (was typed into the template).
  - `_quarto.yml`: `project: type: chalkline`, `school:`, shorter format settings.
  - New `scripts/extension.py`: finds the course folder and the extension, and gives the PDF settings to builds that can't use the project type. `scripts/packets.py` uses it (packets are built as a book).
  - `.github/workflows/publish.yml`: the Chinese font's new folder. `brand/README.md`, `brand/_brand.yml` and comments: the new places.
  - Checked: full teacher and student renders. Same files; all 166 PDF pages identical pixel for pixel; same CSS rules.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: One Chalkline extension (step 1 of the extension plan)
- **Asked for:** "yes, start step 1" (of `EXTENSION-PLAN.md`: turning Chalkline into a Quarto extension that every course installs).
- **Why:** so a fix reaches every course with `quarto update` instead of being copied by hand. Step 1 gathers the code into one folder first.
- **Changed:**
  - `_extensions/classroom/` renamed `_extensions/chalkline/`; `_extensions/pdf-viewer/` moved inside it as `_extensions/chalkline/pdf-viewer/`.
  - `_extensions/chalkline/_extension.yml`: one manifest (title Chalkline, version 0.1.0) with both shortcode files; the old `pdf-viewer/_extension.yml` is gone.
  - `_extensions/chalkline/filter.lua`, `games/games.lua`: the PDF viewer's files are at `pdf-viewer/…` (was `../pdf-viewer/…`).
  - `_quarto.yml`: `filters: [chalkline]` (was `classroom`).
  - Comments and docs that named the old folders: `README.md`, `brand/README.md`, `brand/styles.scss`, `scripts/catalog.py`, `IDEAS.md`, `pdf-viewer.lua`/`.css`, `course/units/04-stem/embeds/embed.css`.
  - Checked: full teacher and student renders give the same files as before, with the same warnings.
  - `TOOL-CHANGES.md`: the "copy this template" comment had grown around the entries from 2026-10-24 and earlier, hiding them; it wraps only the template again. No entry changed.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: One design layer for everything interactive; PDF viewer and vocab pop-ups restyled to match
- **Asked for:** "How about improving the style of the vocab viewer and pdf viewer to match the menu and stuff. Also I feel like more of this styling work should be global instead of elements by element. What am I missing"
- **Why:** each part had its own colors, corners and buttons, so matching them meant changing each one by hand.
- **Changed:**
  - `_extensions/classroom/ui/ui.css`: now the one design layer. The values (colors, a corner scale, shadows for the page, floating tools and menus) and the shared parts: `.ui-btn`, `.ui-icon-btn`, `.ui-field`, `.ui-select`, `.ui-seg`, `.ui-actions`, `.ui-card`, `.ui-pop`, `.ui-menu-item`, `.ui-label`, `.ui-empty`. Corners are a little rounder everywhere (games too), to match the tools.
  - `_extensions/classroom/filter.lua`: loads `ui.css` on every page and deck, not only decks (the vocab pop-ups and PDF viewer are on pages too). `games/games.lua`: comment.
  - `_extensions/classroom/toolbox/kit.js`: no copy of the button and field styles any more; each tool's web component links `ui.css` inside itself, and draws into its own box so redrawing never removes that link.
  - `_extensions/classroom/toolbox/tools/*.js`, `toolbox.js`, `toolbox.css`: the shared parts (`.ui-btn`, `.ui-field`, `.ui-select`, `.ui-actions`, `.ui-empty`, `.ui-seg`) instead of their own; the values (`var(--ui-…)`) instead of colors and shadows typed in.
  - `_extensions/pdf-viewer/pdf-viewer.css`: takes its values from the design layer (with its own as a fallback, so it still works in any Quarto project): a light grey panel with round corners, round icon buttons without borders, the pens in one white toolbar, a softer page shadow, the Download menu like the other menus, the large window's corner mark like the tools'.
  - `_extensions/classroom/vocab-card.html`, `shortcodes.lua`: the vocab pop-up like the toolbox's word card: the picture in a soft rounded box, a bigger word, 中文 on its own line, round speaker buttons with a line icon instead of the 🔊 emoji, and the design layer's corners and shadow.
  - `README.md`: where the design layer is. `IDEAS.md`: games and the vocab app next.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Every classroom tool redesigned, each a web component in its own file
- **Asked for:** "Let's make the team one a shared rectangle with colored sections instead of a stack of rectangles. Just so it's a bit tighter visually. Other than that it looks good. Go ahead and redesign the rest of them."
- **Why:** to finish the new look (no title bars, the content is the card) and the move to web components for every tool.
- **Changed:**
  - `_extensions/classroom/toolbox/tools/scoreboard.js`: one card with a band of color for each team, instead of separate bars.
  - New tool files in `_extensions/classroom/toolbox/tools/`, each with its own styles: `voice.js` (one card: the level in its color, the levels and microphone in a white strip, the noise meter joining underneath; the card itself flashes red when too loud), `dice.js` (just the dice, a total pill, buttons on pointing), `picker.js` (the name on a big blue tile), `groups.js` (groups as tinted tiles with a colored label), `classes.js` (the class lists both share), `clock.js` (a white pill), `qr.js` (the code, with Edit link on pointing), `slide.js` (a big percentage and a Standard/Wide switch; it still applies the setting in every deck), `spotlight.js`, and `music.js`, `vocab.js`, `packet.js` (moved as they were; YouTube's player is now the card itself; these three stay in the page, without a shadow root, because YouTube's player and the PDF viewer expect that).
  - `_extensions/classroom/toolbox/kit.js`: shared course data and unit menu, the form styles, `changed()` so one tool can tell another to redraw, `active` (no tools in speaker view or pop-ups), and tools without a shadow root.
  - `_extensions/classroom/toolbox/toolbox.js`: now only the frame (panels, menu, layout), about 330 lines instead of 1,200; tools reach their panel through the component.
  - `_extensions/classroom/toolbox/toolbox.css`: only the frame's styles.
  - `_extensions/classroom/filter.lua`: loads every tool file.
  - `README.md`: the toolbox paragraph and table. `IDEAS.md`: next steps.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Classroom tools without title bars; traffic light, stopwatch and scoreboard redesigned as web components
- **Asked for:** "What if we get away from the window card frame and make them look more like tiles or cards... We definitely don't need them to have titles. The content is the message." And: "Are there any standard ways to build this kind of thing that would help give it a little more of a modern structure without bringing in a lot of extra overhead? Or is DIY better?" Agreed plan: no titles, the content is the card, starting with two or three tools; built as web components (no library), one tool at a time.
- **Why:** the windows still looked dated; the tools should look like objects on the board, not windows. Web components seal each tool's styles in, so the slides' styles stop breaking the tools, and give each tool its own small file.
- **Changed:**
  - `_extensions/classroom/toolbox/kit.js` (new): the shared kit (storage, element builder, icons, sounds, the ask-twice button, team colors), the button style (now pills), and `ToolElement`, the base for a tool built as a web component.
  - `_extensions/classroom/toolbox/tools/traffic.js`, `stopwatch.js`, `scoreboard.js` (new): the three tools, moved out of `toolbox.js` and redesigned. The traffic light is its dark case (lights side by side when it's wide); the stopwatch is one time tile that turns dark blue while it runs, with round ▶/⏸ and ↺ buttons; the scoreboard is solid team bars, with its buttons showing when you point at it.
  - `_extensions/classroom/toolbox/toolbox.js`: no title bar; × (and Music's ⋯) on the top-right corner when you point at a tool; a tool marked `free` has no white card around it; tools from `tools/` are added to the menu; dragging and keyboard checks look inside web components; the shared helpers now come from `kit.js`.
  - `_extensions/classroom/toolbox/toolbox.css`: plain white cards with soft shadows, the corner controls, the resize mark only on hover; the old title bar, button, scoreboard, traffic light and stopwatch styles removed.
  - `_extensions/classroom/filter.lua`: loads `kit.js` and the three tools before `toolbox.js`.
  - `_extensions/classroom/ui/icons.js`: play and pause icons.
  - `README.md`: the toolbox paragraph. `IDEAS.md`: the plan for the other tools.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Vocab sidebar: a clean list instead of white pills
- **Asked for:** "Especially the vocab list... the list of white ovoids on grey look a bit like the old iPhone interface. I'd like something clean, modern, legible."
- **Why:** the pills on a grey see-through panel looked dated.
- **Changed:** `_extensions/classroom/toolbox/toolbox.css`: the Vocab and Packet sidebars are solid white; the words are a plain list with thin lines between them, bigger text, and the chosen word marked with a blue bar; a word count above the list; the unit menu is a flat box with its own arrow; the word card has its picture in a soft rounded box, a larger word, round speaker buttons and the example set off with a line; the Packet's pages sit straight on the white, without the grey box. `_extensions/classroom/toolbox/toolbox.js`: the word count, the speaker buttons use a line icon instead of the 🔊 emoji, the unit menu's arrow. `_extensions/classroom/ui/icons.js`: two Lucide icons (chevron-down, arrow-up-right).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: A more modern look for the teacher tools
- **Asked for:** "I still don't love the overall look and feel of the teacher tools. We moved to a more modern design style for the UI. Can you work on updating the design style of the teacher tools to look a bit more modern and nice?"
- **Why:** to match the newer, more polished look of the rest of the interface.
- **Changed:** `_extensions/classroom/toolbox/toolbox.js`: each panel now has a slim header with the tool's icon and name (the × sits in it, and Music's ⋯ too); the clock stays bare with a small grab bar. The W menu is now a grid of tiles in groups (People, Attention, Time, This unit, More), with a tick on open tools and "Close all" / "Reset for the next class…" at the bottom. `_extensions/classroom/toolbox/toolbox.css`: frosted white, slightly see-through panels with rounder corners and softer shadows; one button style for every tool (bigger, white with a border, the main button filled); a small corner mark for resizing; styles for the new menu; tool padding adjusted for the header.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Vocab and Packet in the toolbox: the unit's words and worksheets on any slide
- **Asked for:** "a sidebar that has the entire vocabulary list for the unit ... click on an item to pull up its card ... The second one is a similar thing for the worksheets. Make the unit packet available as a series of preview pages that you can click on to pop out."
- **Why:** "These two features will allow teachers to access the vocabulary and the worksheets on any slide without planning in advance when teaching."
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`:
    - **Vocab** is a sidebar at the right edge (full height until it's dragged) with the unit's words only. Tapping one shows its card beside the list: picture, word, 中文, meaning, example, 🔊, and a link to the vocab app.
    - **Packet** is a sidebar at the left edge with the unit packet's pages. Tapping one opens it large in the PDF viewer's window, and **Answer key** switches to the teacher edition.
    - Both start on the deck's unit and have a unit menu.
    - A tool's `start()` can now set its starting size too.
  - `_extensions/classroom/toolbox/toolbox.css`: the sidebars and the card.
  - `_extensions/classroom/filter.lua`: puts the course's units, packets and vocab words into each teacher deck as JSON, and loads the PDF viewer there.
  - `_extensions/pdf-viewer/pdf-viewer.js`: `window.PdfViewer.start(box)` starts a viewer added later (and a box never starts twice).
  - `scripts/catalog.py`: also writes `generated/units.json`.
  - `_extensions/classroom/ui/icons.js`: book-a and files icons.
  - `README.md`: Vocab and Packet rows. (Content: the Start Here catalogue and toolbox list.)
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Quick reference: links open in a pop-up
- **Asked for:** "Can we make it so clicking on those opens them in a pop-up?"
- **Why:** to show a worksheet or another deck without leaving the slides.
- **Changed:**
  - `_extensions/classroom/quickref.js` (new): on a quick reference slide, decks, printables and PDFs open in a large pop-up over the slides (their name, Open in new tab, ×; Esc or a click outside closes it, without opening reveal's slide overview). Key slides in this deck still go there; outside sites open in a new tab (most refuse to be shown inside another page); Ctrl/Cmd-click is left to the browser.
  - `_extensions/classroom/quickref.css`: the pop-up, above the toolbox.
  - `_extensions/classroom/quickref.lua`: loads it.
  - `_extensions/classroom/toolbox/toolbox.js`: no toolbox in a deck shown inside another page (the pop-up), so its clock and tools don't appear twice.
  - `README.md`: the pop-up, under "Quick reference slide".
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Quick reference slide: every link in a unit
- **Asked for:** "a slide template for a grid of all links + specified instructional slides within a unit... like a 'quick reference' slide for in class use."
- **Why:** one slide to jump from, in class, to any deck, printable or key slide in the unit.
- **Changed:**
  - `_extensions/classroom/quickref.lua` (new): `::: {.quick-ref}` with a list of links becomes numbered "Key slides" (any slide, in this deck or another), beside a grid of everything in the unit (packet student copy, decks, printables, outside links) in the overview's type colors, with PDF buttons and a "this deck" tag. `unit="..."` picks another unit. Other formats get a plain list.
  - `_extensions/classroom/quickref.css` (new): its layout and colors.
  - `_extensions/classroom/filter.lua`: runs it for `.quick-ref` divs.
  - `scripts/catalog.py`: also writes `generated/catalog.json`, which the slide reads, so it's always up to date.
  - `README.md`: "Quick reference slide". (Content: an example at the end of *City-States and Democracy*, and a chip on the Start Here catalogue.)
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: QR codes point at the student site
- **Asked for:** "the qr code teacher tool points at the teacher site, right? it should point at the student link (once student links actually exist...)"
- **Why:** the toolbox only runs on the teacher site, so the QR code showed the teacher site's address, with the answer keys, to students.
- **Changed:**
  - `_extensions/classroom/filter.lua`: gives each deck its path in the site, and the student site's address from a new `student-site:` setting (the older `classroom-tools: qr-site:` still works).
  - `_extensions/classroom/toolbox/toolbox.js`: the QR code is the student site's address plus this deck's path. With no student site set, it shows no code and explains why ("This deck" is greyed out; Edit link still works).
  - `_quarto.yml`: a commented-out `student-site:` line to fill in when the student site is published.
  - `README.md`: the QR row.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Music: just YouTube's player, with a ⋯ menu
- **Asked for:** "maybe it's better to just have the embedded player and use a context menu to change the link".
- **Why:** since the video has to stay visible anyway, YouTube's own controls are enough. That's the smallest, plainest version.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: the Music panel is now only YouTube's player (play, pause, volume, fullscreen are YouTube's own), at 340 × 240, resizable, never under 200 × 200. A **⋯** button by the × (or a right-click on the panel's edge) opens a menu: change the song, the last five songs (by name), and Pop out. Before the first song, the link box sits in the middle of the panel. This replaces the compact strip of big buttons (entry below).
  - `_extensions/classroom/toolbox/toolbox.css`: the player and the menu.
  - `_extensions/classroom/ui/icons.js`: an ellipsis icon. The play, pause, skip and volume-1 icons are removed (nothing uses them now).
  - `README.md`: the Music row.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Music: a compact strip, and Pop out
- **Asked for:** "The music player works, but it's still a bit bulky. Any ideas for how to make a more streamlined version? Or let it get minimized to just a little round icon", then "1 sounds good" (the compact strip), and "can't we just keep playing the YouTube stream but hide the actual video?"
- **Why:** smaller on the board. Hiding the video while YouTube keeps playing breaks YouTube's rules for embedded players (they can't be hidden, smaller than 200 × 200, or used for sound only), so Chalkline doesn't do it. Pop out gets the same result through YouTube itself.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: the Music panel is a short strip (400 × 240 instead of 320 × 400). The video tile is on the left (never under 200 × 200), with the big buttons beside it. The link box and last songs fold away under **Song** (the panel grows only while it's open). **Pop out** opens the song on YouTube in its own small window (which can be minimized) and pauses the one in the panel.
  - `_extensions/classroom/toolbox/toolbox.css`: the strip layout.
  - `README.md`: the Music row.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Music in the toolbox: a small YouTube player with big buttons
- **Asked for:** "a tiny floating YouTube player with oversized controls in the teacher tools for classroom music. Or just a plain embedded YouTube player is fine if it's resizable."
- **Why:** classroom music (clean-up songs, work music) without leaving the slides.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: a **Music** tool. Paste a YouTube link (a song, a Short, or a playlist). Big round buttons play/pause, go back to the start (or the previous song) and skip to the next song in a playlist; big volume down/up buttons show the level. The video shows small above the buttons, because YouTube's rules don't allow hiding it; the panel resizes like the others. It keeps playing across slides. The last four links are one-tap buttons, remembered in this browser. It uses YouTube's own player code (loaded when the tool opens), and a clear message if YouTube can't be reached or won't play a video on other sites.
  - `_extensions/classroom/toolbox/toolbox.css`: its layout, sized to the panel.
  - `_extensions/classroom/ui/icons.js`: Lucide music, play, pause, skip-back, skip-forward and volume-1 icons.
  - `README.md`: the Music row in the tools table.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Two sites, not three: a "For families" page instead of the family site
- **Asked for:** "Do we actually need separate student and family sites? ... should it just be a teacher version and a student/public version", then "Yes, bundle it all".
- **Why:** nothing on the student site is secret from families, so the family site was only a shorter list. The real line is class versus public, which needs password-protected hosting (later). One fewer build, one fewer thing to explain.
- **Changed:**
  - `_quarto-parent.yml` → `_quarto-student.yml`: the student profile, now the default build (`profile: default: student` in `_quarto.yml`). It leaves out any page whose `audience` label leaves out `student` (a teachers-only page), so such pages are not in the student site's pages, sidebar or search. Before, the student site had every page.
  - `scripts/parent_site.py` → `scripts/student_site.py`: tidies the student site after a render (removes the teachers-only stubs and their PDFs, and the vocab app's teacher page).
  - `scripts/catalog.py`: writes the student site's teachers-only list (was: the family site's list). New `markdown_family_picks()` for the families page. The "Who sees it" tag "Families" is now "For families" (listed on that page).
  - `families.qmd` (new): **For families 给家长**, a welcome in English and 中文, the vocab app, each unit's goals, and the files marked `audience: [..., parent]`. In the sidebar (`_quarto.yml`).
  - `index.qmd`: the family-site parts removed.
  - `_extensions/classroom/shortcodes.lua`, `filter.lua`, `scripts/packets.py`, `scripts/build_if_needed.py`, `scripts/open_site.py`, `.vscode/tasks.json`, `.gitignore`, `brand/styles.scss`: the family site's special cases and its "Open family site" task removed.
  - `README.md`: "Students, families and teachers" replaces "Family site".
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: "Who sees it" switch on the teacher overview
- **Asked for:** "a toggleable slide highlight for teachers so that they can see which slides are shared with families/students and which aren't on the overview."
- **Why:** to see at a glance what students and families get, before sharing.
- **Changed:**
  - `scripts/catalog.py`: each overview row carries its audience (Students, Families, or Teachers only, from the file's `audience` label). The teacher site gets a "Who sees it" switch at the end of the type chips. The student site's catalog now keeps only items marked for students, as the family site already did for families, so two teacher-only outside links no longer show there.
  - `brand/styles.scss`: the switch, the audience tags, green rows for the family site, striped rows for teachers only.
  - `index.qmd`: the switch's script (remembered in the browser).
  - `README.md`: "Who sees what".
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Toolbox and speaker notes: teacher site only
- **Asked for:** "The teacher toolkit doesn't go on any parent or student facing site. Neither do speaker notes from the teacher."
- **Why:** they're for the teacher. On the student site, anyone could press S and read the notes, or open the class lists in the toolbox.
- **Changed:**
  - `_extensions/classroom/filter.lua`: the classroom toolbox (and its clock) is added only in the teacher build (`--profile teacher`). `::: notes` divs are removed from every other build. The shared design styles still load for the games on every site.
  - `README.md`: says so under the toolbox and speaker view.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Videos: centered, in their own shape, Shorts full height
- **Asked for:** "It looks like the horizontal videos aren't centered and the vertical videos aren't going as tall as they ought to."
- **Why:** the first version made each video a box as wide as its space, but reveal.js caps embeds at 95% of the slide, so they sat left of center, and a Short in a wide box had black bars. It also took height away for text in the *other* column.
- **Changed:**
  - `_extensions/classroom/video-shape.lua` (new, runs before Quarto turns `{{< video >}}` into a player, while the link is still the author's): marks each video wide (16:9) or tall (9:16, for `youtube.com/shorts/` links); Quarto's `aspect-ratio="9x16"` (ignored on slides) sets it by hand. Videos with their own width/height are left alone.
  - `_extensions/classroom/_extension.yml`: runs it (`at: pre-ast`).
  - `_extensions/classroom/video-fit.html`: each video is now as big as it can be in its own shape, centered in its column or on the slide, with the height measured only in its own column (what's above and below it).
  - `README.md`: "Videos on slides" says how shapes work.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-24: Videos fill their slide
- **Asked for:** "my YouTube videos didn't fill the slide ... Do you have to use an iframe or can {{< video>}} fill the space?"
- **Why:** the videos came out tiny (the browser's default 300 × 150 box), because Quarto gives `{{< video >}}` no size on slides, and its `aspect-ratio` option is ignored there.
- **Changed:**
  - `_extensions/classroom/video-fit.html` (new): on each slide, a YouTube or Vimeo video with no width or height of its own fills the room left: full width (or its column's) and the height under the title and any text. Videos stacked in one place share the height. A video with its own `width`/`height` keeps them.
  - `_extensions/classroom/filter.lua`: adds it to every deck.
  - `README.md`: a "Videos on slides" section.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Unit pages and the rest of the site match the new overview
- **Asked for:** "Make sure the unit pages and everything in that interface matches."
- **Why:** one look across the site, after the overview restyle.
- **Changed:**
  - `brand/styles.scss`:
    - The title banner on every web page is the same card as the overview's header (soft gradient, small breadcrumbs, a short orange rule).
    - Section headings lose the blue band (a short blue bar instead).
    - Callout boxes are rounded cards.
    - Material tables are a rounded card, with one colour per type, the same as the overview (a bar on the left edge, the type in colour). The 📊/📦/🔑/🎒 emoji are gone.
    - The packet cards put the Student copy first in solid green and the Teacher edition in muted orange, with line icons. On the student site, the single "Unit packet" button is green.
  - `_extensions/classroom/shortcodes.lua`:
    - `{{< packet >}}`: no emoji, and the student copy first.
    - `{{< objectives >}}`: a card headed "In this unit", with green ticks (web only; PDFs keep the plain list).
  - `brand/type-colors.html`: tags every table row with its type (`row-t-worksheet`, …), not just slides and packets.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Overview: the student copy is the main packet button
- **Asked for:** "I'd like the student edition to be green and this teacher edition to be that muted Orange ... Teachers first move is to print the student edition and the second move is to reference the one with answer keys (if they ever do). So the UI should reflect those priorities."
- **Why:** printing the student copy is what teachers do most; the answer keys come second.
- **Changed:**
  - `brand/styles.scss`: the Student copy button is solid green; the Teacher edition is the quiet orange outline.
  - `scripts/catalog.py`: the Student copy comes first in each unit's header.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Overview: colour coding back, and a more polished look
- **Asked for:** "I think we still need some level of color highlighting to make it quick for teachers to find the right materials. I just wanted to be a bit more modern and restrained. The whole thing should feel a bit more polished than the default quarto look."
- **Why:** colour helps teachers find the right materials fast; the first restyle was too plain.
- **Changed:**
  - `brand/styles.scss`:
    - Each type has one colour, used three ways: a bar on the row's left edge, the icon tile and the type label. Slides (teal) and packets (orange) stand out most, with solid tiles and orange packet buttons, as before.
    - A new page header replaces Quarto's title banner on the overview: course name, season, counts and the next events as date cards.
    - The teacher-site warning is now a slim notice with a key icon.
    - The Everything table keeps teal and orange bars for slides and packets, and the Categories list is quieter.
    - Sidebar, on every page: slide decks get a small teal presentation icon instead of 📊, and the current page shows as a soft pill.
  - `scripts/catalog.py`: filter chips above the units (All, Slides, Worksheets, …, Outside links, each with its colour and count). The rows say what the chips match. `markdown_season()` builds the new header.
  - `index.qmd`: the chips' script (it shows one kind and hides units with none of it), the teacher notice, and a shorter intro.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: The overview in the new style
- **Asked for:** "Rebuild the overview with the new styles."
- **Why:** not given. (The overview still had the old look: tables, coloured rows and emoji, while the catalogue, tools and games now share one design.)
- **Changed:**
  - `scripts/catalog.py`: the overview builders write cards instead of tables. Each unit is a card with its number, title, description and packet buttons (Teacher edition solid, Student copy outlined). Each document is a row with a line icon for its type, its title and description, and a PDF button; outside links show their source with an outside-link icon. "By type" uses the same cards, "Coming up" shows each event as a small card, and the family site's unit goals are cards too. The Lucide icons are drawn inline (no script). The packet titles lose their 🔑/🎒 emoji (the overview shows a key or a backpack icon instead) and get an `edition` field.
  - `brand/styles.scss`: a new "Overview" section with the same values as `ui.css` (white cards, thin borders, one quiet colour per type). The tabs are a segmented control. The Everything tab's table is restyled, without the coloured rows or emoji.
  - `index.qmd`: the page is wrapped in `.overview`. `README.md`: "builds the table" now describes the cards. A small script shows the Categories filter only on the Everything tab, where it works.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Traffic light shows its lights again
- **Asked for:** "for a teacher tools the traffic light is broken right now."
- **Why:** it was broken: the panel opened, but the lights had no shape or colour.
- **Changed:** `_extensions/classroom/toolbox/toolbox.css`: put back the traffic light's styles (the dark box, the three round lights, the glow on the one that's on, the coloured label). An earlier noise-meter restyle deleted them by mistake.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Fix: the overview crashed on the new "game" type
- **Asked for:** not asked; the teacher site's build failed after the Play at home change.
- **Why:** the overview has an icon and a color for each type, and the new `game` type had neither, so building the overview stopped with `KeyError: 'Game'`.
- **Changed:**
  - `scripts/catalog.py`: an icon for games (Lucide's "gamepad-2").
  - `brand/styles.scss`: a color for games (purple) in the overview and the tables. `_extensions/classroom/quickref.css`: the same color on the quick reference slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Games on web pages, not only slides; a "Play at home" page (teachers only until turned on)
- **Asked for:** "What would it take to make this page, and (some of?) the games mobile friendly? So a kid could play on their phone on the subway." Then: "Why does this need to be a slide at all?" Then: "yes, start with steps 1 and 2. One change - for demo purposes, make the student games page visible on the teacher build, and - let's make it disabled by default on the student page. Add a note that teachers will need to enable the student games page if they want students to play at home."
- **Why:** the games didn't need slides (they use nothing from reveal.js); on a phone, a slide is shrunk to a thin strip.
- **Changed:**
  - `_extensions/classroom/games/games.css`, `activities.css`, `timeline.css`: every rule now starts with `:is(.reveal, .cg-host)` instead of `.reveal`, so the games look the same on slides and on web pages. New: `.cg-host` (the box a game sits in on a page, with the fonts slides would give it), `.cg-fit` (scale-to-fit), Word Blitz's phone layout (container queries, under 620px: one column, smaller pieces), the game menu scrolling sideways on a narrow page, and Word Blitz's hover effects only on devices with a mouse.
  - `_extensions/classroom/games/games.lua`: `web()` (games on any HTML output, not only slides); on a web page each game sits in a `.cg-host` box. `shortcodes.lua`, `filter.lua`: the game shortcodes and ::: divs work on web pages too (PDF and Word still get one line); `{{< game-picker games="blitz,snowman" >}}` offers only those games (no Overview link on a page, which has the sidebar).
  - `_extensions/classroom/games/games.js`: on a web page, games without their own phone layout are drawn at slide size and scaled to fit (`fit`); the picker takes a list of games and remembers its choice separately for that list.
  - `scripts/catalog.py`: a new type, `game` ("Game" in the overview).
  - `_quarto.yml`: **Play at home** in the sidebar. `_quarto-student.yml`: regenerated (the page is left out of the student site).
  - `course/play.qmd` (content): the new page, with `audience: [teacher]` so it's off for students, and a teacher-only note on how to turn it on.
  - `README.md`, `CLAUDE.md` (the `game` type), `IDEAS.md` (next steps: phone layouts for the other games, offline, tests, a shared game kit).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Word Blitz Survival: a life back at each new level
- **Asked for:** "What's the current game logic for recovering lives? Is it just miss 3= die?" Then, of the options: "yes, a life back at each new level."
- **Why:** so a long streak also keeps a Survival run going, not only scores more.
- **Changed:**
  - `_extensions/classroom/games/games.js` (Word Blitz): in Survival, reaching a new level (5, 10 or 15 in a row) gives a life back, up to 3. The heart pops back in the top bar, the level's banner says "+1 life", and the answer line shows a "+1 life" heart. The start screen says "3 lives · win one back at 5, 10 and 15 in a row".
  - `_extensions/classroom/games/games.css`: the heart's pop and the "+1 life" pill.
  - `README.md`, `course/units/01-ancient-greece/review-games-slides.qmd` (content): the rule.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Word Blitz: streak levels (STRAIGHT FIRE, COLD FIRE, SUPERNOVA), a heat bar, a live fire, Classic and Survival
- **Asked for:** "Have a line at the bottom grow from center and get slowly red. At a streak of four it should be slightly shaking. The UI theme turns all oranges and red.. At a streak of five it busts into a flame effect. If you get 10 in a row... Maybe "cold fire". Switch everything to Blue theme. The multiplyer should be flat between 5x streaks ... Then a third tier at 15 correct." Then: "additive multiplier (but tiered- three questions in a row is plus 30%, 4 is + 40%.. Between five questions and nine questions it's a flat 50%, then at [ten] questions its +100%. Then at 15 it's +150%). Expressed as x(mult). classic 20 plus survival mode, go ahead. If there's less than 20 vocabulary words present in the whole course, fallback to 10."
- **Why:** to reward long runs of right answers, and to give a station a fair leaderboard (Classic) and students at home a mode to push (Survival).
- **Changed:**
  - `_extensions/classroom/games/games.js` (Word Blitz only): the multiplier is ×1.2, ×1.3, ×1.4 for 2 to 4 in a row, then ×1.5 (5 to 9), ×2 (10 to 14), ×2.5 (15 and more); reaching a level adds 2,000 points and sweeps its banner across (STRAIGHT FIRE!, COLD FIRE!, SUPERNOVA!). A heat bar along the bottom grows from the middle toward the next level, yellow to red; at 4 in a row it shakes and the game turns orange. From 5, a live fire burns along the bottom, behind the answers: a canvas of soft dots that add up into flames (`blitzFire`, plain JavaScript, no library), in each level's colors, and still for people who ask for less movement. Two modes on the start screen, each with its own high scores: Classic (20 questions, or 10 if the whole course has fewer than 20 words) and Survival (3 lives shown as hearts; a second less every 5 questions, down to 5). Every word is asked once before any comes back; a word comes back the other way round, and a missed word comes back 3 questions later. Survival's stars are for 10, 20 and 30 right.
  - `_extensions/classroom/games/games.css`: a set of colors for each level (orange, red, blue, purple), the game's own frame and background (which change with the level), the heat bar, the fire's layer, the Classic/Survival switch and the hearts; the pieces a little smaller to make room.
  - `_extensions/classroom/shortcodes.lua`: `mode="survival"`; `count` is now only Classic's number of questions (no default: the game decides).
  - `README.md`, `course/units/01-ancient-greece/review-games-slides.qmd` (content): the new rules and modes.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Word Blitz gets a cartoon look (inline SVG pictures); no more Kahoot shapes
- **Asked for:** "Use some inline svgs to make it look even cooler. We're trying to appeal to primary School and Middle School. Although I suppose it can always be re-themed for other ages later. Remove the kahoot shape icons - since this is a single player game on one device, those icons don't mean anything."
- **Why:** to appeal to primary and middle school students; the shapes only matter when many players answer on their own devices.
- **Changed:**
  - `_extensions/classroom/games/games.js` (Word Blitz only): pictures drawn as inline SVG: a badge (a lightning bolt on a spinning starburst, a flame on each side) on the start screen, twinkling sparkles on the panels, the countdown on a spinning starburst, a burning fuse with a spark for the time, a streak meter of five flames that light up (the fifth is the bonus), sparkles that fly out of a right answer, real flames for STRAIGHT FIRE, one to three stars at the end, a trophy for a high score, and gold, silver and bronze medals in the high scores. The four answers are plain colored buttons, without the Kahoot shapes.
  - `_extensions/classroom/games/games.css`: Word Blitz's styles rewritten for the cartoon look: chunky buttons, big outlined words, the panels in purple and blue. Every color is a `--blitz-…` value at the top, and the SVG pictures are colored from there, so another look (calmer, for older students) is a change to those values only. Less movement for people whose computer asks for it (reduced motion).
  - `README.md`: the look, and where to change its colors.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Speed quiz becomes Word Blitz: streaks multiply the points, five in a row is STRAIGHT FIRE
- **Asked for:** "let's change the game rules slightly to favor correct answers over speed a little bit. Sequential correct answers get a multiplier (like 10%? 20%). Five in a row gets a dump of extra points. And a cool effect goes across the screen like "Straightfire". Missing a question resets and multiplier. Give it a cooler name"
- **Why:** to reward getting answers right more than answering fast.
- **Changed:**
  - `_extensions/classroom/games/games.js`: the game is now **Word Blitz** (`wordBlitz`, game id `blitz`). A right answer scores 600 to 1,000 (was 500 to 1,000), times the streak: +20% for each right answer in a row, up to ×2. Every fifth in a row adds 2,000 points and plays STRAIGHT FIRE: a band of flames sweeps across the game, flames rise from the bottom, and a rising chime plays. A wrong answer or running out of time ends the streak. The top bar shows the streak and the next multiplier; each answer shows the multiplier it got; the end screen shows the best streak. A flame icon on the Review games page.
  - `_extensions/classroom/games/games.css`: the streak chip and the fire effect; the class names are now `cg-blitz-…`.
  - `_extensions/classroom/shortcodes.lua`: the shortcode is now `{{< blitz unit=1 >}}` (was `speed-quiz`).
  - `README.md`: the new name, rules and shortcode. `course/review-games.qmd`, `course/units/01-ancient-greece/review-games-slides.qmd` (content): the new name and rules.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Speed quiz, a Kahoot-style review game for one player, with a high-score table
- **Asked for:** "Create a kahoot style review game. Single player. Students are given either a picture and then need to match the correct word (grid of four words - 3 from the same unit as the correct answer, one from another unit if available). Or the opposite - given a word and they need to match the picture. They have a few seconds to answer, and the faster they answer the more points they get if correct. Kahoot does it out of a thousand points ... you can add a high scores table where students can write their name."
- **Why:** "you could have a station where students try this and see who's the winner at the end. Or students can just do it on their own at home."
- **Changed:**
  - `_extensions/classroom/games/games.js`: the new game (`speedQuiz`): a start screen with the high scores, a 3-2-1 countdown, 10 questions (picture → word and word → picture, mixed), four colored answers with Kahoot's shapes, a timer bar, points as in Kahoot (500 to 1,000 for a right answer, more when faster), the right answer shown after each question, and at the end the score and a name box for the top-10 table. The table is kept in the browser (one per unit), with "Clear the scores" (tap twice). Keys 1–4 answer, Enter starts and goes on. Added to the Review games page as **Speed quiz**, which now also passes every word to the games (for the answer from another unit).
  - `_extensions/classroom/games/games.css`: the game's styles; the game tabs on the Review games page a little narrower, so ten fit on one row.
  - `_extensions/classroom/shortcodes.lua`: `{{< speed-quiz unit=1 >}}` (`count`, `seconds`, `ask`, `title`).
  - `README.md`: the game in the games table and the shortcode. `course/review-games.qmd`, `course/units/01-ancient-greece/review-games-slides.qmd` (content): the description, and an example slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: reveal.js's own tools in the classroom tools menu
- **Asked for:** "make reveal.js native slide tools more visible on the slide? I feel like with classroom tools on the surface, teachers wont open the "tools" inside the other menu, and thus wont learn about those features."
- **Why:** so teachers find full screen, the slide overview, speaker view, the chalkboard and the shortcuts, and learn their keys.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: a **Slides** group at the bottom of the menu: Full screen (F), All slides (O), Speaker view (S), Whiteboard (B), Draw on slide (C), Shortcuts (?), each with its key on the tile; a tile shows only if the deck has that tool (no chalkboard, no Whiteboard).
  - `_extensions/classroom/toolbox/toolbox.css`: smaller tiles for that group, so the menu stays short.
  - `_extensions/classroom/ui/icons.js`: six Lucide icons (maximize, layout-grid, monitor, presentation, pen-line, keyboard).
  - `README.md`: the Slides group.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: The slide menu opens over the sidebars
- **Asked for:** "The sidebar and the menu don't play nice. find an easy fix. You can even just close the packet panel if the menu is used, or put the menu on top."
- **Why:** the slide menu (☰) opened under the Packet sidebar.
- **Changed:** `_extensions/classroom/toolbox/toolbox.css`: the slide menu and its shade sit above the tools and sidebars (still under the PDF viewer's large window).
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Reset for the next class works again; smaller W; key badges on the menu tiles
- **Asked for:** "Make the W for the classroom tools smaller, and add V and P hotkey indicators to the vocab and packet items. Also check on the reset menu, I don't think its working correctly".
- **Why:** the W was oversized; the keys weren't shown where you pick the tools; the reset seemed broken.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: Reset with "Toolbox: scores…" ticked stopped halfway with an error (it called a class-list function that moved to `tools/classes.js` in the redesign): the noise count, stopwatch and picked names weren't cleared, it didn't go back to the first slide, and the dialog stayed open. It now uses `classes.js`. Esc closes the Reset dialog (before, it opened the slide overview behind it). A tool's key shows in its menu tile's corner; the clock's K is now its tool key, like V and P.
  - `_extensions/classroom/toolbox/toolbox.css`: the W (and the new tile keys) at 12px: the old rule used `font: … inherit`, which browsers ignore, so the W took the slide's huge font.
  - `_extensions/classroom/toolbox/tools/clock.js`: `key: K`.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Vocab and Packet look like sidebars; V and P; Vocab search, A to Z
- **Asked for:** "these are still styled like windows though. Can you make them styled as sidebars/side panels (so no curves or padding, just full height bars, and a different background color?" Hotkeys "P for packet, V for vocab", "default size a little smaller", and "a search function to vocab... imagine an AP course that has hundreds of words. We'd want to be able to search all units vocabulary." And "the displayed vocab should be in alphabetical order".
- **Why:** they still looked like floating windows; a big course needs to find a word fast.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.css`: sidebars are edge to edge, top to bottom, square, on a light grey with a line where they meet the slides; no shadow; the unit menu and buttons on white; × in the bar's bottom corner.
  - `_extensions/classroom/toolbox/toolbox.js`: no gap around a sidebar; a sidebar saved at an older default width starts at the new one; comments for the new keys (they replace reveal.js's P, previous slide, and V, black screen: ← and B still do those).
  - `_extensions/classroom/toolbox/tools/vocab.js`: V; 200 px wide (was 230); the words A to Z; a search box that looks in every unit (the word first, then 中文, then the meaning from three letters on), showing each match's unit; Esc clears it.
  - `_extensions/classroom/toolbox/tools/packet.js`: P; 190 px wide (was 220).
  - `_extensions/classroom/ui/icons.js`: a search icon (Lucide).
  - `README.md`, `IDEAS.md`: the new keys and search.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-25: Vocab and Packet are sidebars that make room, instead of floating over the slides
- **Asked for:** "the default sizes are a bit too big. Even if I set max spacing, they cant quite fit around the slide... And top-to-bottom covers up my logo, controls, and slide number." Idea: "slide out panels from the side of the screen, activated by hotkey or a toggle, which would automatically resize the slide to make room when they came in." Other tools stay floating.
- **Why:** the two sidebars covered the slide's edges, the logo, the slide number and the controls.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: tools can be `dock: "left"` or `"right"`: a full-height sidebar at that edge that slides in, with its inner edge to drag wider (up to 40% of the screen). The slides' area gets narrower to make room and reveal.js re-fits the slide. One sidebar per side. A tool's own `key` opens and closes it (shown on its menu tile).
  - `_extensions/classroom/toolbox/toolbox.css`: the sidebar styles; the slides (`.reveal`), footer, logo, menu and chalkboard buttons and the toolbox button move over by `--ct-dock-left` / `--ct-dock-right`. The chalkboard's ink layers stay at the screen's edge so the pen draws where it touches (their color buttons move in beside the sidebar).
  - `_extensions/classroom/toolbox/tools/vocab.js`, `packet.js`: docked right (key **]**) and left (key **[**), instead of floating panels placed along the edge.
  - `_extensions/classroom/toolbox/tools/clock.js`: finds the space beside the slide inside the slides' area, so it doesn't sit under a sidebar.
  - `README.md`: the keys and the sidebars. `IDEAS.md`: what's next for the sidebars, and a chalkboard note.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: A nature theme for playful worksheets
- **Asked for:** "Give the playful worksheet a nature theme."
- **Why:** not given.
- **Changed:** `brand/typst/typst-template.typ`: `playful-theme: nature` (a green frame and title, leaves in two corners of the frame and beside headings), eight more doodles to color (leaf, flower, tree, ladybug, butterfly, mushroom, bee, snail) and `flower-num()` (a number in a flower). `brand/typst/typst-show.typ`: passes `playful-theme` through. `brand/README.md` and README updated. The example worksheet became `course/units/04-stem/garden-times-tables.qmd` ("Garden Times Tables!", garden story problems, a garden to color).
- **Who it helps:** probably every Chalkline course with younger students.
- **AI assistant:** Claude.

## 2026-10-23: A playful worksheet layout for younger students
- **Asked for:** worksheets that look "more like" Teachers Pay Teachers primary worksheets: "a certain kind of chalky style", "little line drawings that can be colored", "lots of space for the kids to work", "handwritten style fonts". "Make a playful worksheet. I want to see what it would look like as something more kid friendly."
- **Why:** to make printables more child friendly than the clean, professional worksheet style.
- **Changed:** `brand/typst/typst-template.typ`: a `layout: playful` option (handwriting fonts, a hand-drawn double frame, a dashed "cloud" title, a big Name/Date line, the teacher tab, a gentle footer) and a playful kit for worksheets: `doodle()` (seven line-art doodles drawn for Chalkline: robot, pencil, star, gear, sun, cloud, sparkle), `star-num()` and `work-box()`. `brand/fonts/print/`: Patrick Hand and Fredoka (OFL, with their licences). `brand/README.md` and README document it. Example: `course/units/04-stem/robot-times-tables.qmd` (its problems from `playful.py`).
- **Who it helps:** probably every Chalkline course with younger students.
- **AI assistant:** Claude.

## 2026-10-23: The Start here catalogue matches the new look
- **Asked for:** "make it match, drop the emoji" (the "So what else can you do?" slide).
- **Why:** it kept its own emoji and colored badges after the toolbox, games and activities moved to one design.
- **Changed:** `_extensions/classroom/ui/icons.js`: a microphone icon (for the catalogue's Noise meter chip). The slide itself (content): no emoji, chips and boxes use the shared design values, and the toolbox chips show the toolbox's line icons. IDEAS.md: two intro decks added to the to-do list.
- **Who it helps:** this course (the icon: every Chalkline course).
- **AI assistant:** Claude.

## 2026-10-23: One design for the tools, games and activities; line icons instead of emoji
- **Asked for:** "go with option 1": after comparing the look with Shoelace and Bootstrap, use Chalkline's own design values and a free icon set, to lose the "vibe coded look".
- **Why:** "I was thinking about the vibe coded look." In the test, the frameworks' controls were too small for a board, and Bootstrap clashed with reveal.js (it hid the deck and the tool windows); most of the casual look came from emoji icons and small inconsistencies.
- **Changed:** `_extensions/classroom/ui/ui.css` (new): one set of colors, corners and shadows. `ui/icons.js` (new) and `LUCIDE-LICENSE.txt`: 20 Lucide line icons. `toolbox/toolbox.js`: the menu and the controls (close, check, bell, settings, reset, crown) use the icons; the voice levels keep their emoji (pictures for students). `toolbox.css`, `games/games.css`, `activities.css`, `timeline.css`: buttons, chips, word banks, menus, windows and right/wrong use the shared values. `filter.lua` and `games/games.lua`: load them. README credits and `brand/README.md` updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: The clock starts beside the slide, not on it
- **Asked for:** "move the clock default so it doesn't cover slide content"
- **Why:** at the bottom left, it covered the bottom of full slides.
- **Changed:** `_extensions/classroom/toolbox/toolbox.js`: the clock starts in the empty space beside the slide (left, above the menu buttons; or right) when there's room, or else in the top-right corner, and follows the screen size until it's moved or resized. A clock still at the old default spot moves too. It's a little smaller (128 × 52). README updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Build the sentence, Fill in the blanks, Put it in order, a Venn diagram, and a Spotlight
- **Asked for:** whiteboard learning activities: "build those five" (a sentence builder, fill in the blanks, put it in order, a Venn layout for Sort it, and a spotlight; a screen shade was dropped because fragments already do it).
- **Why:** "Are there any obvious learning activities that work well with interactive whiteboards that we should include?"
- **Changed:** `_extensions/classroom/games/activities.js` and `activities.css` (new): the three activities, each working by drag or by tap-then-tap. `games.lua`: loads them. `timeline.js`: shares its drag helper. `filter.lua`: reads `::: {.sentence-builder}`, `{.fill-blanks}`, `{.put-in-order}` and Sort it's `layout="venn"`. `games.js` and `games.css`: the Venn layout. `toolbox/toolbox.js` and `toolbox.css`: a 🔦 Spotlight tool (not reopened in the next deck). A new demo deck in Unit 2, the Start here catalogue (46 features), README and IDEAS.md updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: The clock is a toolbox tool; see-through grey tool windows
- **Asked for:** "Remember the clock we have on each side? Make it into one of the new teacher tools so we can drag it around. have it always on by default and have it have a gray translucent background. Actually give all of the teacher tools a grey translucent background."
- **Why:** not given (the fixed corner clock couldn't be moved).
- **Changed:** `_extensions/classroom/toolbox/toolbox.js`: a new 🕒 Clock tool, open by default at the top left; closing it (× or **K**) is remembered, and someone who hid the old clock keeps it hidden; **K** shows and hides it; a deck with `clock: false` leaves it closed. `toolbox.css`: every tool window is light grey and see-through (blurred slide behind); the clock's style; the rules that moved the old clock removed. `filter.lua`: no longer adds the old clock; `clock: false` is passed to the toolbox. `_extensions/classroom/clock.html` deleted. README and the Start here slides updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Timelines (to teach with, across slides, and for students) and Label it
- **Asked for:** "A timeline template slide ... for introducing a timeline when teaching. It should have all the events preloaded with photos and allow the speaker to scrub through them chronologically, or to click on any item to pull up more information on it (like a zoom-in function). A timeline activity slide for students where they have to place items correctly on the timeline ... the correct order and they have to slide it to the correct year. A labeling activity slide. Using a photograph students need to drag labels onto the correct region ... do whatever is best practice." And: "An option for a timeline to run across multiple slides ... the timeline can be an automatic insert and then later on you can use the timeline element to click on it and either get the info back from the slides or go directly to the slide."
- **Why:** to teach chronology, and for labelling activities.
- **Changed:**
  - `_extensions/classroom/games/timeline.js` and `timeline.css` (new):
    - **Timeline to teach with:** a big card above the line; ‹ ›, tap or drag along the line; tap the card to zoom in.
    - **Strips:** on slides that events link to. Tap an event for its card, then **Go to this slide** or **The timeline**.
    - **Timeline activity:** drag events onto the line at their year (or tap, then tap the line). Check marks each one (tolerance, snap) and the order.
    - **Label it:** numbered dots on a photo; drag or tap labels on; feedback with reasons; L finds and copies a place. Wide photos use the whole width.
    - Dates like "509 BC", "AD 80" and "c. 9600 BC" are read and sorted; there's no "AD 0".
  - `_extensions/classroom/games/games.js`: shares its helpers (`window.ChalklineGames`) so timeline.js can add games, and starts the games once the page has loaded. `games.lua`: loads timeline.js and timeline.css.
  - `_extensions/classroom/filter.lua`: `::: {.timeline-interactive}` and `::: {.timeline-activity}` (events as `::: {.event}` divs, or a list) and `::: {.label-it}`. A new pass gives each timeline an id and puts a strip on every slide an event links to. Plain `::: {.timeline}` stays the simple styled list.
  - `course/units/02-ancient-rome/rome-timeline-slides.qmd` (new demo deck), `README.md`, the Start-here slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Sort it: a reason for each item, feedback straight away, pictures
- **Asked for:** "Definitely add the option for immediate feedback if the kid gets the answer wrong, a little explanation of why. I think a third group support for both is fine but we'll already have that if we support multiple groups. And yes I want the option for pictures as items." (After: "So we can sort based on characteristics that are not specifically listed in the vocabulary. For example in a biology class sorting animals by habitat.")
- **Why:** to use Sort it for higher-order sorts, with feedback that teaches.
- **Changed:**
  - `_extensions/classroom/games/games.js`: Sort it items can have a reason and a picture.
    - **Feedback straight away** (the usual): a right item locks in green; a wrong one shows red in that group, shakes, goes back to the bank, and its reason shows in a red box. It counts mistakes.
    - `feedback="end"`: the old way, with Check showing up to three reasons.
    - From the vocab: the reason is the word's meaning, and `with="picture"` shows the vocab pictures.
  - `filter.lua`: `::: {.sort}` items can have `![Name](path)` pictures (copied to the site) and `| reason`; `feedback=` on the div. `shortcodes.lua`: `with=` and `feedback=` for `{{< sort >}}`.
  - `games.css`: picture items and the reason box.
  - `README.md`; the Greek Word Games deck: reasons on *Athens or Sparta?*, a new *Greek or Roman?* photo sort, and an updated code box and credits.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Word scramble, Sort it, and Bingo with cards made on demand
- **Asked for:** "add bingo and sort it. Figure out where bingo would live because the process for that is a little different. The teacher would not do that live in class they would prepare it ahead of time and print the cards. Add word scramble." Then, on bingo: "Bingo cards should not be generated at build time ... Can we just use that [the PDF library] to generate printable PDF cards on demand? ... the teacher could reuse the game without regenerating the site. Change the number of cards the number of items etc."
- **Why:** more review games. Bingo needs paper cards, prepared before class.
- **Changed:**
  - `_extensions/classroom/games/games.js`: three new games.
    - **Word scramble:** tap or type the mixed-up letters in order.
    - **Sort it:** a word bank and 2–3 groups; tap a word, then its group; Check; from the vocab, by topic (one unit) or by unit (several).
    - **Bingo**, in two steps. *Make cards*: grid 3–5, free square, number of cards; a PDF made in the browser by pdf-lib when the teacher presses Download (nothing at build time). *Call*: one meaning at a time; check a card by its number for a full line. A game code (unit-grid-free-number) printed on every card makes the same cards again with a repeatable random generator, so any card can be checked on any computer; the game and the words called are saved in the browser.
    - The Review games page lists nine games in a full-width row, with the unit menu under it.
  - `games.css`: styles for the three games and the two-row header. `games.lua`: ships `../pdf-viewer/pdf-lib.esm.min.js` next to `games.js`.
  - `shortcodes.lua`: `{{< scramble >}}`, `{{< sort >}}`, `{{< bingo >}}`; vocab game settings carry the unit list. `filter.lua`: `::: {.sort}` (groups in bold, words under them).
  - `scripts/vocab_terms.py`: each term's topic (its `subdomain`), for Sort it.
  - `README.md`; the Greek Word Games deck (Scramble, Sort it and Bingo sections); the Start-here slide. `IDEAS.md` (new): the game ideas not built yet (Heads up / Taboo, Spin the wheel and others), and next steps for Bingo.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: The calm style for every game; Matching and Memory
- **Asked for:** "apply the calmer style to the game slides too. Oh and let's add a matching game, and memory (the card flipping game)."
- **Why:** to match the Review games page; two more classic review games.
- **Changed:**
  - `_extensions/classroom/games/games.js`: every game uses the calm look: plain-word buttons, with the emoji taken off ("🔀 New word" → "New word"), also on buttons a game adds later. Two new games:
    - **Matching:** words on the left, their meanings or pictures (`with=`) on the right, mixed up. Tap one, then its partner: a right pair locks in, in its own color; a wrong pair shakes. It counts the tries.
    - **Memory:** cards that turn over (3D flip). Each word pairs with its picture or meaning; a pair stays up, a miss turns back after a moment. It counts the turns.
    Both take 6 pairs (`count=`), from random vocab (all or one unit, with **New words** / **New cards**) or written pairs. Both reset with "Reset for the next class". The Review games page lists all six games ("Picture" for short, every label on one line), and its "Unit" label is gone (the menu's "All units" says it).
  - `games.css`: the calm styles now apply to every game; styles for Matching and Memory; a tighter header.
  - `shortcodes.lua`: `{{< matching >}}` and `{{< memory >}}` (`unit=`, `count=`, `with="meaning"|"picture"`). `filter.lua`: `::: {.matching}` and `::: {.memory}` with `word | partner` lines.
  - `README.md`, the Greek Word Games deck (Matching and Memory sections, with code boxes; button names without emoji), the Review games page notes, and the Start-here "what else" slide.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Review games page: a more professional look
- **Asked for:** "Restyle the review games page. It looks very AI/vibe coded (which it is, but still). Give it a more professional look."
- **Why:** the rainbow pills and emoji looked unpolished.
- **Changed:** `_extensions/classroom/games/games.js`, `games.css`:
  - **Header:** one quiet header row. The games are a segmented control (a grey track with the chosen game raised in white) with simple line icons instead of emoji. Next to it are a **Unit** dropdown (it scales to any number of units) and a plain "← Overview" link. Only brand navy is used, with a thin rule under the header.
  - **The games, on this page only:** plain-word buttons (no emoji; Jeopardy's 🔀 becomes "New board") with small corners and thin borders, and navy picture tiles instead of many colors. The game slides in decks keep their playful look.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: A Review games page: any game, any unit
- **Asked for:** "Add a web page called review games. It should allow teachers to select a game and a units and play immediately."
- **Why:** to play a review game without making a deck first.
- **Changed:**
  - `course/review-games.qmd` (new): a one-slide page (no title slide, controls or progress bar) with the game picker. It's listed in the overview under "Whole year", and left out of the family site.
  - `_extensions/classroom/games/games.js`, `games.css`: the picker. A row of games (Snowman, Picture reveal, Jeopardy, Quick-fire), a row of units (All units, then each unit with its number), and the game below, using that unit's vocab. A ⌂ link goes back to the overview. The last choice is remembered in the browser. "Reset for the next class" restarts the current game. Keys typed for a game that has been replaced are ignored.
  - `_extensions/classroom/shortcodes.lua`: `{{< game-picker >}}`; game words now carry their units.
  - `scripts/vocab_terms.py`: `generated/vocab-terms.json` also lists each unit's number and title (from `course/vocab/*.yml`).
  - `_quarto.yml`: "Review games" in the sidebar, under the vocab app. `_quarto-parent.yml`: the overview script added the page to the family site's left-out list.
  - `README.md`; the Start-here "what else" slide links to it.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Jeopardy: scores under the board; rename teams, change scores
- **Asked for:** "visually segregate the score keeping area. Move scores to the bottom and add some space and a decorative line between the scores and the gameplay part. Allow the teacher to change team's names. Allow the teacher to click on the score to manually change it."
- **Why:** the scores above the board looked like part of the game.
- **Changed:** `_extensions/classroom/games/games.js`: the team bar is now under the board, after a divider. Tap a team's name to rename it, tap its score to type a new one (Enter or tapping away keeps it, Esc cancels), or tap the team anywhere else to give it the turn. Names stay when the board is reset. `games.css`: a gold dashed line with "SCORES" between the board and the teams; styles for the name, score and typing box. `README.md` and the Greek Word Games notes: updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Noise meter: the voice level sets the line; a cleaner look
- **Asked for:** "For the noise meter: the target sound level should be set by the voice level instruction. Not a separate slider. Also just put a bit of effort into making it look nicer/more cohesion."
- **Why:** the voice level already says how loud the room should be.
- **Changed:** `_extensions/classroom/toolbox/toolbox.js`: each voice level has a "too loud" line (Silent 22 to Presenter 74 on the meter's 0–100 scale), and picking a level moves it. The "Too loud at" slider is gone. Because microphones differ, ⚙ opens a **microphone sensitivity** setting (−3 to +3, saved) that moves every level's line together. The noise-meter button is a drawn microphone instead of 🔊. `toolbox.css`: the meter uses the level's color, with the track tinted up to the line and red after it, and the level's icon on the line. The status and count are chips, and Start/Stop, beep and ⚙ are small round buttons on one row. The "nearly too loud" color is amber, with no color transition (it flickered into olive). The narrow layout matches. `README.md`: updated.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Reset for the next class
- **Asked for:** "Add a global reset for the deck. Teachers should be able to reset all the games at once when they go to the next class."
- **Why:** to start fresh with the next class.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`, `toolbox.css`: **↺ Reset for the next class…** at the bottom of the toolbox menu. It opens a checklist of what's in the deck: games, poll votes and timers (ticked), pen marks on PDFs and toolbox scores (not ticked), and going back to the first slide (ticked). It sends one `chalkline:reset` event, and the toolbox part resets scores, the noise count, the stopwatch and picked names.
  - `_extensions/classroom/games/games.js`: every game resets on the event (random games get a new word or board).
  - `_extensions/classroom/poll.html`: votes go back to 0 (no "Sure?" needed). `_extensions/classroom/countdown.html`: timers stop and go back to the start.
  - `_extensions/pdf-viewer/pdf-viewer.js`: clears the ink on every page of the deck's PDFs, including viewers on slides not shown yet.
  - `README.md`: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Jeopardy: teams, turns and scores
- **Asked for:** "For the jeopardy game - add support for 2-4 teams and score keeping/ turn taking (highlight the current team)."
- **Why:** not given (Jeopardy is usually played in teams).
- **Changed:** `_extensions/classroom/games/games.js`: a team bar above the board (2 to 4 teams, with − and +). The current team is filled in and marked ▶. After **Show the answer**, **✓ Right +200** or **✗ Wrong** scores the clue and passes the turn; tap a team to give it the turn. A crown marks the leader, a winner card ends the game, and **Play again** restarts it. The clue card covers only the board, so the teams stay visible. Still separate from the toolbox scoreboard. `games.css`: team styles; the squares are a little shorter to make room. `shortcodes.lua`, `filter.lua`: `teams=` (default 2, `0` = no teams). `README.md` and the Greek Word Games deck: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: A ↓ button when there's a slide below
- **Asked for:** "add a down arrow to the slides that have a slide below them." Also "put a code box on the first page which shows the short code that generates the game" (in the Greek Word Games deck: content, no log needed).
- **Why:** a column of slides is easy to miss: the only sign was reveal.js's small corner arrows.
- **Changed:** `_extensions/classroom/down-arrow.html` (new): a bouncing ↓ at the bottom center whenever the slide has one below it. Click it or press ↓; it hides in the overview, speaker-view previews and the slide PDFs. The running timer's small box moves up above it. `_extensions/classroom/filter.lua`: adds it to every deck (`down-arrow: false` turns it off). `README.md`: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: AI instructions: real photos first for vocab pictures
- **Asked for:** "When adding vocabulary, prefer high quality creative Commons or public source images. Wikimedia, unsplash, etc. generate original images when the public source images don't provide a high quality image that is distinct, clear, and memorable ... New one should be reserved for cases where we don't have a good way to illustrate the point."
- **Why:** many vocab words are clearer and more memorable as a real image than as a generated drawing.
- **Changed:** `CLAUDE.md` (which `AGENTS.md` and `GEMINI.md` point to): a rule to look for an open-licensed real image first, and to make a drawing only when none works; picture credits go in `CREDITS.md` (`course/links.yml` is for links). `vocab/README.md`: a "Pictures" section: where to search, which licenses to use or avoid, quality checks, size (4:3, about 800 × 600, under 200 KB) and how to credit. `vocab/images/CREDITS.md` (new): the credits table for vocab pictures. Not tool files, but logged because the rule would suit every course.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Slide games: Snowman, Picture reveal, Jeopardy, Quick-fire
- **Asked for:** "build snowman hangman, picture reveal and jeopardy. Do not integrate these with the group score tools ... Keep them separate. Give teachers the option of having random vocabulary, unit specific vocabulary, or writing the answers in the shortcode directly. If it's random ... a replay button ... If it's not random then it shouldn't have that." Also "a trivia style game ... the teacher would just point to the student and they would answer orally and then reveal the answer and mark it as right or wrong but keep score."
- **Why:** templates for interactive review on the board.
- **Changed:**
  - `_extensions/classroom/games/games.js`, `games.css` (new): the four games. Typed letters go to Snowman, not to the slide shortcuts. 🔀 appears only when the word is random. Quick-fire keeps its own score and has a timer that runs out. No 中文 anywhere (review material).
  - `_extensions/classroom/games/games.lua` (new): shared helpers that turn a game into a `<div>` with its settings, plus a one-line note outside slides.
  - `_extensions/classroom/shortcodes.lua`: `{{< snowman >}}`, `{{< picture-reveal >}}`, `{{< jeopardy >}}` and `{{< trivia >}}`, with random words (all vocab or `unit=N`), a named vocab word, or your own word, hint and image (copied to the site).
  - `_extensions/classroom/filter.lua`: `::: {.jeopardy}` and `::: {.trivia}` with your own clues (`clue | answer` lists).
  - `scripts/vocab_terms.py`: each term now also gets its unit numbers (from `course/vocab/*.yml`) and its example sentence (for "Fill the gap").
  - `_quarto-parent.yml`: the overview script added the new deck to the list kept off the family site (it's for teachers and students).
  - `README.md`: a "Slide games" section.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Toolbox: slide size, voice level with the noise meter, windows without title bars
- **Asked for:** "Try adding the margin tool. We can see how it works and remove later if it sucks." "Merge noise meter and voice level tools into one (set voice level, and optionally enable noise meter). Also make the warning sound louder and add a visual cue flash the whole meter box red when triggered. Like the score box, this needs a vertical version." "For the gadgets ... they don't need the top bar and label. Give them a more modern look with no name and just a light x to close them."
- **Why:** the slide margins are narrow, and the right amount depends on the screen. Fewer, cleaner windows on the board.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: new **Slide size** tool: a slider for the space around the slide (0–30%) and Standard / Wide (16:9), applied live with `Reveal.configure`. It's saved per computer and applied in every deck, even with the window closed. Reset goes back to the deck's own size. **Voice level** now holds the noise meter: 🔊 turns it on (and makes the window taller) or off (and stops the microphone). The alarm is louder (three square-wave beeps) and on by default. An old saved "noise meter" window opens as Voice level. Windows have no title bar: drag any empty part (after 6px, so taps still work), and a light × closes them.
  - `_extensions/classroom/toolbox/toolbox.css`: windows have a small grab bar and a light ×. When it's too loud, a red layer flashes over the whole window. Below 260px wide, the voice level stacks and the noise meter stands up. Styles for Slide size.
  - `README.md`: the tool table and how to move windows.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Toolbox: name picker, groups, a narrow scoreboard, a noise count
- **Asked for:** "name lists and let the teacher add more classes and quickly switch between them. Include a small note saying that this is stored in the browser so no one complains about pipl compliance." "For the group points gadget - add a vertical orientation when it's resized to be narrow. So the group name appears above the score and -/+ buttons. That way it will fit in the margin better." "For the noise meter add a function to count how many times is triggered."
- **Why:** name pickers and group makers need class lists, and the students have no class numbers. Lists must stay off the public site and out of the repo (PIPL). The scoreboard should fit in the slide margin.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js`: two new tools. **Name picker** picks each student present once before anyone twice. **Groups** makes "groups of n" or "n groups" with sizes that differ by at most one. They share class lists: any number of classes, a class menu to switch (both tools follow it), **+ New class…** and **Edit** (paste names one on each line, delete a class), and **Who's here?** to mark students away for the day. The class editor shows a note that names stay only in this browser. **Scoreboard** can now be made as narrow as 150px. **Noise meter** counts the times it went over the line (saved, with Reset). Esc closes the toolbox menu without also opening reveal.js's slide overview.
  - `_extensions/classroom/toolbox/toolbox.css`: styles for the class menu, editor, attendance chips, picker and group cards. Below 250px wide, the scoreboard puts each team's name above its − score +. The noise meter's info row has the count.
  - `README.md`: the new tools, class lists and where they are stored.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Classroom toolbox on every slide deck (scoreboard, voice level, traffic light, noise meter, QR code, stopwatch, dice)
- **Asked for:** classroom-management tools like Classroomscreen's: "Add numbers 2-6" (a points scoreboard as a ClassDojo stand-in, work symbols and a traffic light, a noise meter, a QR code for the current page, a stopwatch and dice). "All of the classroom management ones should be visible across slides not connected to the current slide."
- **Why:** Classroomscreen's classroom-management tools are good, but they live in another tab. ClassDojo can't be built in: it has no public API, and like most sites with a login it can't be shown inside another site.
- **Changed:**
  - `_extensions/classroom/toolbox/toolbox.js` and `toolbox.css` (new): a toolbox button in the bottom-left row of slide icons (or press **W**) opens a menu of 7 tools. Each opens in a window that floats above the slides, so it stays when you change slides (and in fullscreen). Drag by the title bar; drag the corner to resize (contents grow with it, and touch works). Open windows, positions, scores and settings are saved in the browser and come back in the next deck; other tabs update too. Nothing is sent anywhere. The noise meter uses the microphone only after **Start**. Not shown in speaker-view previews or slide PDFs.
  - `_extensions/classroom/toolbox/qrcode.js` and `LICENSE-qrcode.txt` (new): qrcode-generator 2.0.4 (MIT) for the QR code. It loads only when the QR window opens.
  - `_extensions/classroom/filter.lua`: adds the toolbox to every slide deck. `classroom-tools: false` turns it off for a deck; `classroom-tools: {qr-site: "https://…/"}` makes the QR code point to the published site instead of `localhost`.
  - `_quarto.yml`, `brand/README.md`: comments mention the toolbox. `README.md`: a "Classroom tools" section and a line in "Things to try".
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Download button: just the icon
- **Asked for:** "I like the menu but the word download takes up a lot of horizontal space and is breaking some of the layouts. So keep the menu part but make it just the icon on the button."
- **Why:** the word made the button too wide for some layouts.
- **Changed:** `_extensions/pdf-viewer/pdf-viewer.js`, `pdf-viewer.css`: the Download button is the ⬇ icon only (its tooltip still says what it does); the menu with the spelled-out choices is unchanged. `README.md`: wording.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Clearer download buttons in the PDF viewer
- **Asked for:** "Make the buttons for 'download annotated version' and 'download original version' more obvious in their functions."
- **Why:** two icon-only buttons (⬇ and ↗) didn't say what they did; ↗ looked like "download original" but opened a new tab.
- **Changed:** `_extensions/pdf-viewer/pdf-viewer.js`, `pdf-viewer.css`: one **⬇ Download** button (with the word, except in a narrow viewer) opens a menu with the choices spelled out: **With my notes** (saves `<name>-with-notes.pdf`), **Original** (saves the PDF as it is), **Open in a new tab**. Big, easy-to-tap rows; Esc or tapping elsewhere closes it. `pdf-viewer.lua`, `README.md`: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Download a PDF with its ink
- **Asked for:** "How difficult is it to add a download function for the edited PDFs?", then "build it with pdf-lib".
- **Why:** to keep or share a worksheet after writing on it in class.
- **Changed:**
  - `_extensions/pdf-viewer/pdf-lib.esm.min.js` and `LICENSE-pdf-lib.txt` (new): pdf-lib 1.17.1 (MIT), which adds the ink to a copy of the PDF in the browser. It loads only when someone presses Download, so slides don't load any slower.
  - `_extensions/pdf-viewer/pdf-viewer.js`: a ⬇ button in the viewer, the gallery and the large window saves `<name>-annotated.pdf`. Pen and highlighter marks go in as lines (sharp, see-through highlighter); typed English as real text; typed text the built-in PDF fonts can't show (Chinese) as a picture. Rotated pages are handled.
  - `_extensions/pdf-viewer/pdf-viewer.css`: in a narrow viewer the "open in a new tab" button hides to make room (the large window still has it).
  - `_extensions/pdf-viewer/pdf-viewer.lua`, `README.md`: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: Zoom and a text tool in the PDF viewer
- **Asked for:** "Add a zoom function for the viewer. I think it's fine on the classroom display, but a bit tough on the teachers laptop. Also for annotation - add a text tool."
- **Why:** the worksheet is hard to read on a laptop screen.
- **Changed:**
  - `_extensions/pdf-viewer/pdf-viewer.js`: zoom (− 100% + in the viewer's bottom bar and the large window's title bar, 100–400%; Ctrl/⌘ + scroll or a trackpad pinch; + − 0 keys in the large window; tap 100% to fit the page again). Zoomed in, the page scrolls, or drag it with the mouse. A **T** text tool: tap the page, type, Enter; the text is in the last pen's color, saved with the ink, and the eraser and undo remove it. Typing doesn't trigger slide shortcuts.
  - `_extensions/pdf-viewer/pdf-viewer.css`: a scrollable page area, the typing box, zoom buttons; buttons on slides are 40px so everything fits in a narrow column (the title hides when the viewer is narrow).
  - `_extensions/pdf-viewer/pdf-viewer.lua`, `README.md`: documented.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: The online build uses the project's own Chinese font
- **Asked for:** "Why does it need to reinstall the font", after the publish build hung twice on downloading it.
- **Why:** each GitHub build starts on a fresh computer, so it downloaded the Chinese font package from Ubuntu every time; today that download hung and the site didn't update.
- **Changed:** `.github/workflows/publish.yml`: instead of `apt-get install fonts-noto-cjk`, copy `brand/fonts/print/NotoSansSC-*.otf` (already in the project) into the build computer's font folder. Takes about a second, needs no network, and the slide PDFs use the same Chinese font as the worksheets.
- **Who it helps:** probably every Chalkline course that publishes with GitHub Pages.
- **AI assistant:** Claude.

## 2026-10-23: Slides show the student copy of a PDF, even on the teacher site
- **Asked for:** "the slides should always default to showing the Student version. Teachers never need to project the teacher version in a normal context. I can imagine a time like when giving professional development when you might want that but the default behavior would be the Student version."
- **Why:** so answer keys don't end up on the board.
- **Changed:**
  - `scripts/packets.py`: the teacher build also writes a student copy of every printable, `<name>-student.pdf`, next to its teacher edition (one extra Quarto run, alongside the packets). `--unit` and `--stale` work for these too.
  - `_quarto-teacher.yml`: `pdf-viewer: prefer: "{name}-student.pdf"`, so slides on the teacher site show that copy.
  - `_extensions/pdf-viewer/pdf-viewer.lua`, `pdf-viewer.js`: a new project option `pdf-viewer: prefer:` (tried first, falling back to the named file) and `prefer=false` on one shortcode to show the named file as it is (the teacher edition, for training).
  - `README.md`: how it works, and `prefer=false`.
- **Who it helps:** probably every Chalkline course.
- **AI assistant:** Claude.

## 2026-10-23: PDFs on slides (viewer and gallery, with pens), and the chalkboard
- **Asked for:** "Teachers want to embed the worksheet PDF in the reveal.js presentation, so that they can have slides that show the workbook together with in-class instructions or resources." Two ways: a gallery of pages that opens a large popup (draggable, resizable), and a PDF on the slide with on-screen page controls. Both with ink for touch screens, kept until Clear. Plus an example of the built-in chalkboard.
- **Why:** to show the worksheet next to in-class instructions, and write on it with the class.
- **Changed:**
  - `_extensions/pdf-viewer/` (new, a separate extension that works in any Quarto project): `{{< pdf-viewer "file.pdf" >}}` shortcode (`pdf-viewer.lua`); viewer, gallery, popup and pens (`pdf-viewer.js`, `pdf-viewer.css`); pdf.js 4.10.38, legacy build (`pdf.min.mjs`, `pdf.worker.min.mjs`, Apache-2.0, `LICENSE-pdfjs.txt`). The PDF loads when the slide is shown, so a deck can show a PDF made by the same build. Ink is saved per PDF page in the browser's localStorage. If the PDF isn't there (the family site), it says so.
  - `scripts/slides_pdf.py`: waits for PDF viewers to finish drawing before printing a deck.
  - `_extensions/classroom/clock.html`: in decks with the chalkboard on, the clock moves right so it doesn't cover the chalkboard buttons.
  - `README.md`: the new shortcode and the chalkboard in the shortcuts table.
- **Who it helps:** probably every Chalkline course. The `pdf-viewer` extension can be copied into any Quarto project.
- **AI assistant:** Claude.

## 2026-10-15: Vocab pictures and diagrams for a third unit (Göbekli Tepe)
- **Asked for:** "a new unit about that ancient site in Turkey … Göbekli Tepe … in the same style as the other two."
- **Why:** not given.
- **Changed:** `vocab/schema.yaml`: new domain `GBT` (ID pattern and its subdomains). `vocab/config.js`: names for `GBT` in English and 中文, 中文 for the new subdomains, three "Read more" links. `vocab/tools/draw_icons.py`: helpers for a T-pillar, a fox and a ring of pillars; 12 new icons (GBT-001 to GBT-012); two new diagrams (`how-old`, `pillar-parts`); `DIAGRAMS` now says which unit folder each diagram goes in (it used to put every diagram in `02-ancient-rome`).
- **Who it helps:** the domain and icons, this course only. Per-unit diagram folders in `draw_icons.py`, probably every Chalkline course that draws its own diagrams.
- **AI assistant:** Claude.
