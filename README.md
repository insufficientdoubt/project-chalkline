# Chalkline sample course

**Chalkline** turns plain-text lesson files into slides, web pages, printable PDFs, unit packets and two websites (a public student site, which families can use too, and a teacher site), all in your school's style. This is a **sample course** to try it with: three history units (Ancient Greece, Ancient Rome and Göbekli Tepe), a STEM sampler unit, a Grade 4 math unit on angles, a 52-word bilingual vocab list, and a slide deck about Chalkline itself.

**See it online:** https://insufficientdoubt.github.io/project-chalkline/ (the teacher version, rebuilt on every push).

> **Beta.** You're one of the first teachers to use this. Note anything confusing or broken, and tell John.

## What's in here

| Part | Where | Look for |
|---|---|---|
| **Start here** | `course/units/00-start-here/` | A short slide deck: what Chalkline does and how to make your own unit |
| **Unit 1: Ancient Greece** | `course/units/01-ancient-greece/` | 2 slide decks, 3 printables (a worksheet, fact cards, a class vote) |
| **Unit 2: Ancient Rome** | `course/units/02-ancient-rome/` | 2 slide decks, 3 printables (a sorting worksheet, Roman numerals, an aqueduct design challenge) |
| **Unit 3: Göbekli Tepe** | `course/units/03-gobekli-tepe/` | 2 slide decks, 3 printables (an evidence-or-guess worksheet, animal fact cards, a T-pillar design challenge) |
| **Unit 4: STEM Sampler** | `course/units/04-stem/` | A sampler for STEM teams: math and block-coding decks with interactives you can drag (geometry, GeoGebra, PhET, Blockly), a math handout and two practice worksheets made from a seed. The interactive pages are in its `embeds/` folder |
| **Unit 5: Angles** | `course/units/05-angles/` | Grade 4 math, from a Chinese lesson plan (旋转与角): a bilingual deck (English and 中文), a class worksheet, homework, and an interactive page where an angle turns from acute to full (its `embeds/` folder) |
| **Vocab** | `vocab/` | 52 words with pictures, 中文 and simple definitions, in the vocab app (sidebar: **History vocab 词汇**) |
| **Appearance** | `brand/` | Colors, fonts and logos for everything |
| **The look of the interactive parts** | `_extensions/chalkline/ui/ui.css` | One set of colors, corners, shadows, buttons, fields and menus for the classroom tools, games, vocab pop-ups, PDF viewer and quick reference. Change a value there and they all follow |
| **Chalkline** | `_extensions/chalkline/`, `chalkline.py` | The tool itself. You don't need to touch these |
| **AI instructions** | `CLAUDE.md` (also `AGENTS.md`, `GEMINI.md`) | Rules any AI assistant should read first; tool changes get logged in `TOOL-CHANGES.md` |

Things to try once the site is open:

- Hover or tap a word with a dotted line on any slide: its vocab card pops up.
- Open a unit page and click **Unit packet (PDF)**: every printable in one file, ready to copy.
- Open a slide deck and press **S** for speaker notes, **T** for the timer.
- In a slide deck, press **W** (or the four-squares button, bottom left) for the classroom tools: name picker, groups, scoreboard, voice level with a noise meter, slide size, traffic light, QR code, stopwatch, dice, music, and the unit's vocab and packet. They float above the slides and stay put when you change slides.
- In the overview, each deck has a **PDF** too.
- **All slides** (sidebar): every unit's decks as rows of slide pictures. Click a slide to open its deck right there. Small, Medium and Large change the picture size. The pictures are made by a full build (they need Chrome or Edge, like the slide PDFs).
- **Terminal > Run Task… > Open student site**: what students and families see, without the answer keys, speaker notes and teacher tools.
- In *From Republic to Empire*, hover the boxes of the infographic: it was made in **draw.io** (`drawio/republic.drawio`), and any draw.io diagram can go in a slide the same way.

## One-time setup

1. **Install the programs** (normal installers, defaults are fine):
   - [VS Code](https://code.visualstudio.com/)
   - [Quarto](https://quarto.org/docs/get-started/). Typst for PDFs comes bundled, so you don't need LaTeX.
   - [Python 3](https://www.python.org/downloads/). On Windows, tick **"Add python.exe to PATH"**.
   - [Git](https://git-scm.com/downloads)
   - [Google Chrome](https://www.google.com/chrome/) or Microsoft Edge (already on Windows), for slide PDFs

2. **Get a project onto your computer.** Two choices:
   - **Try this sample** (every example, three history units): in VS Code, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`), choose **Git: Clone**, paste `https://github.com/insufficientdoubt/project-chalkline`, then open the folder.
   - **Start your own course** (no sample content): open a terminal in the folder where you keep your work and run

     ```bash
     quarto use template insufficientdoubt/project-chalkline
     ```

     Answer **Yes** to "Do you trust the authors", **Yes** to "Create a subdirectory", and type a folder name (`my-course`). Quarto copies Chalkline and the course files, but none of this sample's units, vocab or pictures (`.quartoignore` lists what it leaves out). Open the new folder in VS Code. The first time it starts, it adds a starter unit: one slide deck, one handout and four vocab words (`python chalkline.py setup` does the same). Then change `title:` and `school:` in `_quarto.yml`.

3. **Install the extensions.** VS Code will show a pop-up offering to install the recommended extensions (Quarto, Python, Jupyter). Click **Install**. If you miss it, open the Extensions panel and search `@recommended`.

4. **Create a Python environment.** This is a private folder of Python packages just for this project, so it can't clash with anything else on your computer. Open a terminal in VS Code (**Terminal > New Terminal**) and run:

   ```bash
   python -m venv .venv
   ```

   (On a Mac, use `python3` instead of `python` if `python` isn't found.) VS Code will ask whether to use the new environment for this workspace: click **Yes**. Then **close that terminal and open a new one**. The prompt should now start with `(.venv)`, which means the environment is turned on.

5. **Install the Python packages** into that environment:

   ```bash
   pip install -r requirements.txt
   ```

6. **Check that everything is wired up:**

   ```bash
   quarto check
   ```

   You want to see a Python 3 path that includes `.venv`, plus "Jupyter: OK".


## Open the site

**Double-click `Start Chalkline.command`** (Mac) or **`Start Chalkline.bat`** (Windows). The site opens at **http://localhost:4100**, in the **teacher version** (answer keys and teacher notes showing), and updates every time you save a file. Leave the window open while you work; close it to stop. The first time, it installs the Python packages for you and builds the whole site, which takes a few minutes.

In **VS Code**, the site starts by itself when you open the folder (allow "automatic tasks" the first time).

Slide PDFs need **Google Chrome** or **Microsoft Edge** on your computer.

## Editing in VS Code

In VS Code, a `.qmd` file opens in Quarto's *visual editor*: headings, bold, lists and tables look the way they will on the page, and you type as in a word processor. The labels at the top and shortcodes like `{{< vocab "democracy" >}}` show as small grey boxes; leave them as they are. To see the plain text underneath, press **Ctrl+Shift+F4** (Mac: **Cmd+Shift+F4**) or right-click the file and choose **Edit in Source Mode**; the same keys switch back. When you save in visual mode, Quarto may tidy the file's spacing and list layout; the page looks the same.

## Editing with an AI assistant

You can do almost everything here by asking an AI assistant: Claude, Gemini, ChatGPT/Codex, Copilot, Cursor, Tencent WorkBuddy or another one that can open files in a folder.

**First, point it at the rules.** Open this folder in the assistant and start with:

> *Read CLAUDE.md first and follow it.*

`CLAUDE.md` holds the instructions for this course: how the files are organized, the vocab rules (English first, 中文 as support, no Chinese in quizzes), and how to keep editing quick. Many assistants find it on their own; `AGENTS.md` and `GEMINI.md` point there too.

**Then just ask**, in plain words:

- *"Add a slide to the Rome engineering deck about Roman baths, with Chinese glosses on the key words."*
- *"Make the Athens vs Sparta worksheet easier for beginners: shorter questions and a word bank."*
- *"Add 'senator' to the vocab list, with a picture and Chinese."*
- *"Make an interactive timeline of the Roman kings for the Rome deck."*

**If it changes the tool, it keeps a log.** Changing lessons, worksheets and vocab is content: no log. Changing how Chalkline works or looks (its code, styles or settings) is a *tool* change, and the assistant records what it changed and why in `TOOL-CHANGES.md`. Please send that file to John from time to time: it's design feedback, and good ideas can become part of Chalkline for everyone.

## Make your own unit

1. Copy a unit folder, for example `course/units/01-ancient-greece`, and rename it (`03-my-unit`).
2. In its `index.qmd`, change `title`, `short-title`, `unit` and the `objectives`. The unit appears in the sidebar and overview by itself.
3. Edit or replace the slides and printables. Keep the labels at the top of each file: `type:` (slides, worksheet, handout, reference…), `order:` and `audience:` (who sees it: `teacher`, `student`; see "Students, families and teachers" below).
4. Add your words to `vocab/data/vocab.csv` (see `vocab/README.md`), then run `python chalkline.py validate`.
5. To use a unit's words on picture cards, import them: `python chalkline.py import-vocab --unit 3 --title "My Unit" --folder 03-my-unit --ids GRC-001 GRC-002`.

When a worksheet is finished, rebuild its unit packet: `python chalkline.py packets --unit 3`. Packets and slide PDFs don't rebuild on every save, so editing stays quick; the launcher also rebuilds any that are out of date when it starts.

## Everyday commands

Run these in the VS Code terminal, or pick them from **Terminal > Run Task…**.

| What you want | Command |
|---|---|
| Build everything (student site) into `_site/` | `quarto render` |
| Build the teacher site into `_site-teacher/` | `quarto render --profile teacher` |
| Open the student site (port 4101) | `python chalkline.py open student` |
| Rebuild one unit's packet | `python chalkline.py packets --unit 1` |
| Rebuild slide PDFs | `python chalkline.py slides-pdf` |
| Retake the slide pictures for **All slides** | `python chalkline.py slide-pictures` |
| Check the vocab list | `python chalkline.py validate` |
| Start a new slide deck or worksheet from a template | `python chalkline.py new slides 2 "Roman Roads"` (or VS Code: **Run Task… > New slide deck or worksheet**) |
| Make Quizlet / Kahoot / Anki files | `python chalkline.py export-vocab` |
| Update a draw.io diagram's picture after editing it in draw.io | `python chalkline.py drawio` (needs the draw.io app) |

## Unit packets

Every unit's printables (worksheets, checklists, handouts and references) are also built into one **unit packet** PDF, and all packets into a **year packet**: a cover with the objectives and contents, each printable on a new page, page numbers running through. Slide decks, posters and tests are left out. Add `packet: false` to a printable's labels to leave it out too. The teacher site has **both**: a 🔑 **Teacher edition** (answer keys, notes, TEACHER EDITION tab; `unit-teacher-packet.pdf`) and a 🎒 **Student copy** to print for class (`unit-packet.pdf`, the same file as on the student site), each with its own card on the unit page. To add an outside PDF to a packet, save it in the unit folder and list it in the unit's `index.qmd`:

```yaml
packet-extras:
  - file: map.pdf
    title: Map of the Mediterranean
    after: athens-vs-sparta.qmd     # optional
```

## Students, families and teachers

There are two websites, and only two. The **student site** (`quarto render`, into `_site/`) is the one to share with students and families: no answer keys, no speaker notes, no classroom toolbox. The **teacher site** (`quarto render --profile teacher`, into `_site-teacher/`) has everything.

Each file's `audience:` label decides:

- `student`: the file is on the student site. Leave it out (`audience: [teacher]`) and the file is teachers only: the student site leaves it out completely (not in its pages, sidebar or search).

Inside a page, `::: {.content-visible when-profile="teacher"}` shows something only on the teacher site (answer keys, look-fors).

## How the overview finds things

You never edit the overview by hand. Before every render, Chalkline's `catalog.py` reads the labels at the top of each file in `course/` and builds the list: a card for each unit, with a row for each file. These are the labels:

```yaml
---
title: "Game Day Checklist"
type: checklist        # slides, worksheet, checklist, handout, poster, reference, vocab or game
description: "One sentence shown in the overview and on the unit page."
order: 2               # position on the unit page (slides are usually 1)
audience: [teacher, student]   # who sees it: leave out student for teachers only
---
```

The unit comes from the folder the file is in. A file with no `type:` still appears, labeled "Other". Files whose names start with `_` are skipped, which is handy for drafts.

**Who sees what.** Each file's `audience` label decides which sites list it: `student` for the student site (teachers always see everything). On the teacher site's overview, turn on **Who sees it** (next to the type chips): each row shows its audience, and teacher-only rows are striped. The switch is remembered in your browser.

**Outside resources** (a Wikipedia article, an official website) aren't files here, so they're listed in `course/links.yml`. Each one shows its `source` (here, **Wikipedia**) as a badge in the overview; the school's own materials show **School**. Outside links appear in the overview only, not on unit pages.

**Slideshows open in a new tab**, so the overview stays open behind them. This works for any file whose name ends in `slides.qmd` (like `slides.qmd` or `review-slides.qmd`), so name decks that way. To turn it off, add the line `slides-new-tab: false` to `_quarto.yml` (on its own line, not indented).

**Two kinds of search.** The filter box on the overview searches only the table: titles, types, units and descriptions. The search box at the top of the sidebar searches the **full text** of every web page, including every slide and the speaker notes, and jumps straight to the matching slide or section. It doesn't search inside PDFs, but every PDF has a web version with the same text. On the student/public site, teacher-only content isn't searchable because it isn't there. The sidebar search needs a web address (`quarto preview` or a hosted site); it doesn't work on files opened from a folder.

**Season facts** (event dates, team numbers, overtime days) live once in `course/season.yml`. The overview counts down to the next event, and the slides and printables read the same file, so changing a date there updates everything.


## Several outputs from one file

The `format:` list at the top of a `.qmd` file decides what gets built. For example, a printable has:

```yaml
format:
  html: default     # web page
  typst: default    # PDF (A4)
```

Add `docx: default` for a Word file. PDFs are A4; posters set `papersize: a3`. Shared settings live in `_quarto.yml`. For younger students, `layout: playful` gives a printable a kid-friendly look: handwriting fonts, a hand-drawn frame, star or flower numbers and line-art doodles to color; `playful-theme: nature` makes it a green garden page (see `brand/README.md` and **Unit 4 › Garden Times Tables!**).


## Teacher-only content

Wrap anything for teachers' eyes only like this:

```markdown
::: {.content-visible when-profile="teacher"}
The answer is 42.
:::
```

`quarto render` leaves it out. `quarto render --profile teacher` includes it and saves to a separate `_site-teacher/` folder, so the two versions never overwrite each other. Teacher PDFs get an orange **TEACHER EDITION** tab. In slides, `::: notes` blocks are speaker notes (press **S** during a slideshow to see them).


## Shortcuts you can type in any lesson

These come from `_extensions/chalkline/`. Each one looks right on the web page, in the PDF and (where it makes sense) in slides.

| Type this | You get |
|---|---|
| `{{< lines 3 >}}` | 3 ruled writing lines. `gap="0.4in"` changes the spacing. |
| `{{< drawing-box label="Side view" >}}` | A dot-grid box for sketching. Fills the rest of the PDF page unless you add `height="2in"`. |
| `{{< objectives >}}` | The `objectives:` list from the unit's labels, as bullets. |
| `{{< pdf "scoring-sheet.pdf" >}}` | An outside PDF saved next to this file. In the PDF version its pages go in as full pages (`pages="2-3"` picks some); on the web page you get a download link and a viewer. |
| `{{< pdf-viewer "athens-vs-sparta.pdf" >}}` | **On a slide:** a PDF you can page through with ‹ ›, and pens for touch screens (pen, highlighter, **T** for typed text, eraser, undo, clear), and zoom (− 100% +, or Ctrl/⌘ + scroll; drag to move around). The **⬇** button offers: **With my notes** (`…-with-notes.pdf`), **Original**, or **Open in a new tab**. Ink stays on that computer until you press the bin button. ⤢ opens the page large, in a window you can drag and resize. Add `layout="gallery"` to show every page as a thumbnail: tap one to open it large. Works with a worksheet's own PDF (made by the same build) or the unit packet. Slides always show the **student copy**, even on the teacher site (it shows `athens-vs-sparta-student.pdf`, which the teacher build makes), so answer keys never go on the board. To show the teacher edition (for teacher training, say), add `prefer=false`. From `_extensions/chalkline/pdf-viewer/`, which also works on its own in any Quarto project. In PDFs and Word it's just a link. |
| `{{< packet >}}` | On a unit page: the **Unit packet (PDF)** button. Shows nothing if the unit has no printables. |
| `{{< vocab "democracy" >}}` | A vocab word with a dotted underline. Hover (or tap) to see its vocab card: picture, 中文, definition and a link to the vocab app. Use a term, an "also called" name or an ID (`GRC-003`); `text="citizens"` changes the words shown. In PDFs and Word it's just bold; add `zh=true` to also print the 中文 after it (for reference sheets, never quizzes). Terms come straight from `vocab/data/vocab.csv`, read again before every render. |
| `{{< vocab-cards unit=1 words="peninsula, colony" zh=true >}}` | Picture cards side by side, for slides: picture, word and meaning (`zh=true` adds the 中文; leave it off on review slides). Without `words=`, every word in the unit. |
| `{{< vocab-gallery "philosopher, empire, evidence" >}}` | A vocab gallery, for slides and pages: the words' pictures and names in a grid; click one to open its full card (picture, 中文, meaning, read aloud). A **Cards \| Table** switch shows the words as a table instead (picture, word, 中文, meaning). It fits the room it's given: as many columns as fit, in even rows; a vertical list (picture beside word) in a narrow column; bigger cards across a whole slide. Words from any unit; `unit=1` for all of a unit's words, `view="table"` to start as a table, `cols=4` for at most 4 columns, `zh=true` for 中文 under the words too, `zh=false` for none. In PDFs, a table. |
| `{{< word-bank unit=1 "Government: democracy, citizen" "Places: colony" >}}` | A word-bank box, one line per group. |
| `{{< vocab-table unit=1 >}}`, `{{< vocab-list unit=1 >}}` | The unit's words and meanings as a table or a list (`words="..."` for some of them). |
| `{{< fill-in-the-blank unit=1 >}}` | A word bank and numbered meanings to fill in. The answer key shows only in the teacher version. |
| `chalkboard:` in a deck's labels | Draw on any slide: press **C** (or the pen button, bottom left) to draw on the slide, **B** for a blank chalkboard, **Delete** to clear. Copy the three lines from the top of `course/units/01-ancient-greece/city-states-slides.qmd`. |
| `::: {.live-board rooms="wbo"}` … `:::` | A **live board** on a slide: a Padlet wall or a shared whiteboard filling the whole slide, with a small corner card holding the link students open, its QR code and the buttons (`layout="inline"`: the frame with the link under it, for a slide with other things on it; `zoom="0.7"` shows the board smaller so more fits, and Padlet starts at 0.7). Click the QR code for a big one to scan. `src=` is what the frame shows (Padlet: the embed address), `join=` the link students get; `rooms="excalidraw"` or `rooms="wbo"` makes a fresh room link for you (**New room** for the next class). Or leave the links out and click **Edit link** on the slide to paste one. Excalidraw shares only in its own tab, so its slide shows the room's QR code and an **Open the class board** button instead of a frame; WBO and Padlet stay live on the slide. See `course/units/00-start-here/live-boards-slides.qmd`. |
| `{{< timer 20 >}}` | A 20-minute countdown on a slide (see below). In print it just says "Timer: 20 minutes". |
| `{{< pagebreak >}}` | Start a new PDF page. |
| `::: {.keep}` … `:::` | Keeps a question and its writing space together on one PDF page. |
| `::: {.write-in}` … `:::` around a table | Taller table rows, for handwriting. |
| `☐` | A drawn checkbox. |

Poster blocks (used in `course/posters/`):

```markdown
::: {.value word="Respect" zh="尊重" pinyin="zūnzhòng"}
Your teammates, your coaches, your school, and everyone you compete with.
:::

::: {.big-quote zh="偷最好的，发明其余的"}
Steal from the best. Invent the rest.
:::

::: {.steps title="The Ownership Check"}
1. Adapt it
2. Test it
3. Understand it
4. Credit it
:::
```

Poster options are listed in [brand/README.md](brand/README.md).


## Slide timer

Put `{{< timer 20 >}}` on a slide. It has Start/Pause, Reset and +1 min buttons (or press **T**), turns orange at 5 minutes and red at 1 minute, chimes at zero, and keeps running in a small box at the bottom of the screen if you change slides.

## Videos on slides

Put `{{< video https://www.youtube.com/watch?v=... >}}` on a slide (YouTube, including Shorts, or Vimeo). It becomes as big as it can in the room it has, in its own shape, and centered: a normal video is wide (16:9); a YouTube Short (a `youtube.com/shorts/...` link) is tall (9:16). The room is the width of where it sits (the slide, or its column) and the height left there, under the title and above any text below it. So a Short in a narrow column fills the column's height, next to your text. For another shape, add `aspect-ratio="4x3"` (or `"1x1"`, `"9x16"`...). To choose the size yourself, add `width` and/or `height`, for example `{{< video URL width="100%" height="400" >}}`; then it keeps yours.

## Clock and transitions

When a slide has another slide below it (a column of slides: a `#` heading with `##` slides under it), a bouncing **↓** button shows at the bottom of the screen; click it or press ↓. Turn it off for one deck with `down-arrow: false`.

Every slide deck shows the current time in a small **🕒 Clock** window. It starts off the slide, so it covers nothing: in the space beside the slide (above the menu buttons) on a wide screen, or in the top-right corner when the slide fills the screen. It's one of the classroom tools (below): drag it anywhere, or drag its corner to make it bigger; once you have, it stays where you put it. Press **K** (or its ×) to hide it, and **K** again to show it; the choice is remembered on that computer. To leave it closed in one deck, add `clock: false` to its labels. Slides fade from one to the next; that's set under `revealjs:` in `_quarto.yml`.

Press **S** during a slideshow to open speaker view: your notes, the next slide, a clock and an elapsed-time timer, in a separate window for your laptop screen. Speaker notes (`::: notes`) are only in the teacher site: the student site leaves them out, so students can't read them with **S**.

## Classroom tools (scoreboard, voice level, …)

Every slide deck in the **teacher** site has a toolbox (the student site leaves it out): press **W**, or the four-squares button in the bottom-left corner. Each tool opens in its own window **on top of the slides**, not on one slide, so it stays where you put it while you change slides. There are no title bars: the tool itself is what shows. Drag a tool by any empty part of it; point at it and a × appears on its top-right corner (it closes the tool), with a small corner mark at the bottom right: drag that to make it bigger (everything inside grows, so it can fill the board). The tool is its own card: the traffic light is its dark case, the stopwatch one time tile, the scoreboard one card with a band of color for each team, the voice level a card in the level's color, the dice just dice. Buttons you need now and then (the scoreboard's + Team and Reset, the dice's − and +, the QR code's Edit link) show when you point at the tool; on a touch screen they always show. Made narrow, the scoreboard and the voice level stack, to fit in the slide margin; made wide, the traffic light's lights line up side by side.

At the bottom of the menu, **Slides** is a row of icons for running the slides (point at one for its name and key): **View source** (U), and reveal.js's own tools: **Full screen** (F), **All slides** (O), **Speaker view** (S), **Whiteboard** (B) and **Draw on slide** (C). **?** still lists every key the deck knows. **U** shows how the current slide is made (View source, below). They're also in the slide menu (☰ › Tools).

| Tool | What it does |
|---|---|
| 🙋 **Name picker** | Picks a student from your class list. Everyone present gets picked once before anyone is picked again (**Start again** starts a new round). |
| 🧩 **Groups** | Random groups from your class list: **Groups of 4** or **4 groups** (tap to switch, − and + to change the number). No group is bigger than the number you choose, and sizes differ by at most one. |
| 🏆 **Scoreboard** | Points for 1–8 teams. Tap a name to rename it; **+** and **−** change the score; 👑 marks the leader. Point at it for **+ Team**, **− Team**, **Reset** (tap twice: every score back to 0) and 🔔 (the sound on or off). Make it narrow to fit in the slide margin: each team's name moves above its score. |
| 🤫 **Voice level** | 0 Silent, 1 Whisper, 2 Partner talk, 3 Group talk, 4 Presenter. Tap a number. Tap the **microphone** button to add the **noise meter** below it (allow the microphone when asked). The bar shows how loud the room is, in the level's color. The **voice level sets the "too loud" line**: low for Silent, high for Presenter; the level's icon sits on the line. Over the line for a second, the whole window flashes red and beeps (🔔 turns the beep off). It shows how long the class has been quiet and counts the times it went over the line (↺ starts the count again; it carries on into the next deck until then). If the line is too easy or too hard to reach with your microphone, ⚙ changes the **microphone sensitivity** (−3 to +3), which moves every level's line. Nothing is recorded or sent anywhere; ■ or the microphone button turns the microphone off. |
| 📐 **Slide size** | Changes how **this screen** shows the slides, while you watch: the **space around the slide** (slider, 0–30%) and its shape, **Standard** or **Wide (16:9)**. Kept on that computer for every deck, so the board and your laptop can differ. **Reset** goes back to the deck's own size. The deck files and slide PDFs don't change. |
| 🚦 **Traffic light** | Tap red (Stop), yellow (Get ready) or green (Go); tap it again to turn it off. |
| 🔳 **QR code** | A code for this deck **on the student site**, so students open it on a tablet. It never points at the teacher site, which has the answer keys. Set the student site's address once, as `student-site: "https://…/"` in `_quarto.yml`; until then the tool shows no code and says why. Point at it for **Edit link**, a code for any link. |
| ⏱️ **Stopwatch** | Counts up. ▶ starts and pauses, ↺ goes back to 0. It turns dark blue while it runs, so the room can see it's going. |
| 🕒 **Clock** | The time. Open in every deck unless you close it; **K** shows and hides it. |
| 🔦 **Spotlight** | Darkens the screen except a circle, to show the class where to look. Drag the circle (or tap where it should go); the slider or the mouse wheel changes its size. The tool windows stay on top. Close the window to end it; it doesn't come back in the next deck. |
| 🎲 **Dice** | 1–6 dice, straight on the slide. Tap the dice to roll; with more than one, the total shows under them. Point at them for **Roll** and − / + (how many). |
| 📖 **Vocab** | The unit's words, A to Z, in a sidebar at the right edge (**V** opens and closes it), always at hand while students work or talk: just the words, to point at. **Search** finds a word in every unit, by the word, its 中文 or its meaning. The slides move over to make room, with their logo, slide number and buttons, so the sidebar covers nothing; drag its inner edge to make it wider. Tap one for its card beside the list: the picture, the word, 中文, the meaning and an example, with 🔊 to read it aloud (Esc or × closes it). It starts on this deck's unit; the menu picks another unit, or all of them. The words come from `vocab/data/vocab.csv`. |
| 📄 **Packet** | The unit packet as page previews in a sidebar at the left edge (**P** opens and closes it). Like Vocab, the slides move over to make room; drag its inner edge to make it wider. Tap a page to open it large, in the PDF viewer's window (zoom, pens, arrow keys to turn pages). **Answer key** switches to the teacher edition. It starts on this deck's unit; the menu picks another. |
| 💻 **View source** | How **this slide** is made: its part of the deck's `.qmd` file, just as it was typed, with colors and line numbers (**U** opens and closes it). It follows you as you change slides. **Wrap** folds long lines to fit the window (on at first; tap to turn it off, and it stays that way). **Copy** puts it on the clipboard, to start a slide of your own from it. On your own computer, **Open in VS Code** opens the file at that slide. Speaker notes and answer keys show too, so it's only in the teacher site. A slide made by an `include` or a game shows the lines it came from. |
| 🎵 **Music** | Classroom music from YouTube: YouTube's own player (with its play, pause and volume) fills the panel; size it like any tool (YouTube's rules keep it at least 200 × 200 and visible). The first time, paste a link to a song or a playlist. Then **⋯** by the × (or a right-click on the panel's edge) opens a menu: change the song, pick one of your last songs, or **Pop out** the song into its own small YouTube window, which you can minimize while it plays. It keeps playing as you change slides (a new deck brings it back, ready to play). Needs the internet. |

**Class lists** (name picker and groups): choose **+ New class…** in the class menu, type a name for the class (like 7A) and paste the students' names, one on each line (a column copied from a spreadsheet works). Add as many classes as you like and switch between them with the class menu at the top; both tools follow it. **Edit** changes or deletes the current class. **Who's here?** marks students who are away today, so they aren't picked or put in a group; it starts fresh the next day.

**Reset for the next class:** at the bottom of the toolbox menu (**W**). It starts this deck again: every game, poll and timer back to the beginning, and back to the first slide. Two more you can tick: the pen marks on the deck's PDF worksheets, and the toolbox's scores, noise count, stopwatch and picked names. It only shows what the deck has.

Open windows, where they are, the scores, the class lists and the settings are remembered **only in that browser on that computer**, so they come back in the next deck and the next lesson. Names are never uploaded or put in the course files or on the website (each class list shows a note saying so). That also means a class list typed on one computer isn't on another, and clearing the browser's data deletes it: keep your own copy of each list to paste in again. To hide the toolbox in one deck, add `classroom-tools: false` to its labels.

## Slide games

Ten review games for slides, in a calm, plain style. **To play one right now, open Review games in the sidebar** (`course/review-games.qmd`): choose a game along the top and a unit (or all units), and it starts with that unit's vocab; **New word** (or **New board**, **New cards**…) gives a fresh one. It remembers your last choice on that computer, works full screen on the board, and has the toolbox (**W**) like any deck. The `{{< game-picker >}}` shortcode makes it, so you can put it in any deck too.

To put a game in your own slides, see them all in **Unit 1 › Greek Word Games** (`course/units/01-ancient-greece/review-games-slides.qmd`); its speaker notes (**S**) show how each one is written. Copy any slide to make your own. Between classes, **↺ Reset for the next class** in the toolbox menu (**W**) starts every game again. The games keep their own score and don't use the toolbox scoreboard. Like quizzes, they never show 中文.

| Game | How it plays |
|---|---|
| ⛄ **Snowman** | Guess the word one letter at a time (tap the letters, or type them). Each wrong letter melts part of the snowman: 7 wrong letters and it's a puddle. **Hint** shows the picture and meaning. |
| 🖼️ **Picture reveal** | A picture hides under numbered tiles. Open one tile at a time until someone guesses it. |
| 🏆 **Jeopardy** | A board of categories and points, for 2 to 4 teams. The team whose turn it is is highlighted: it chooses a square, answers, and you mark **✓ Right** (it gets the points) or **✗ Wrong**. Then the turn passes on. The scores are under the board: tap a team's **name** to rename it, its **score** to change it, or anywhere else on it to give it the turn; − and + change the number of teams. When every square is used, it shows the winner. Used squares go grey. |
| 🔗 **Matching** | Words on the left, their meanings (or pictures) on the right, mixed up. Tap a word, then its partner: a right pair locks in, in its own color; a wrong pair shakes. It counts the tries. |
| 🃏 **Memory** | Cards face down: each word and its picture (or meaning). Turn over two; a pair stays face up, the others turn back. It counts the turns. |
| 🔤 **Word scramble** | The letters of a word, mixed up. Tap them (or type them) in order; tap a placed letter, or press Backspace, to take it back. **Hint**, **Mix again**, **Show the word**. Words as for Snowman. |
| 🗂️ **Sort it** | Items in a bank and 2–4 groups ("Both" is just another group). Tap an item, then its group. A right item locks in green; a wrong one shakes, goes back to the bank, and **its reason shows**, so students learn why straight away. Items can be words, phrases or **pictures**. Write any sort you like (animals by habitat, fact or opinion, cause or effect), or use the vocab list: one unit's words sort into their topics, several units' into their units, and each word's meaning is its reason (`with="picture"` shows the pictures). `feedback="end"` lets students sort everything first; **Check** then marks each item and shows the reasons. |
| 🎱 **Bingo** | Two steps. **Make cards** (before class): choose the grid (3 × 3 to 5 × 5), a free middle square and the number of cards, then **Download the cards**: a PDF made right there in the browser, two cards on each page, every card different. **Call** (in class): **Next** shows a meaning and its picture; students cross out the word. Type a card's number and **Check** to see whether it really has a full line. A **game code** printed on every card (like `1-3F-7365`) makes the same cards again, on any computer, so you can check cards printed last week; type it into the Call step to bring that game back. Nothing is made when the site is built. |
| ⚡ **Quick-fire** | A question pops up with a timer. Point to a student, who answers out loud. **Show the answer**, then **✓ Right** or **✗ Wrong**. The game counts the score and shows it at the end. |
| 🔥 **Word Blitz** | Like Kahoot, for one player, with a bright cartoon look for primary and middle school (its colors are values at the top of its part of `games.css`, so it can be made calmer for older students). A picture and four words, or a word and four pictures, on four colored buttons; tap one (or press 1–4) before the time runs out. Three answers are from the word's unit and one from another unit. A right answer scores 600 to 1,000 points (the faster, the more), times the **streak**: ×1.2 for two right in a row, ×1.3 for three, ×1.4 for four; then levels, each adding 2,000 points: **STRAIGHT FIRE** from 5 in a row (×1.5), **COLD FIRE** from 10 (×2, everything turns blue) and **SUPERNOVA** from 15 (×2.5, purple). A heat bar along the bottom grows toward the next level; at 4 in a row it shakes and the game turns orange, and from 5 a fire burns along the bottom. A wrong answer, or running out of time, ends the streak. Two modes, each with its own high scores: **Classic** (20 questions, or 10 if the whole course has fewer than 20 vocab words) and **Survival** (3 lives, and a life back at each new level, up to 3; the clock gets a second faster every 5 questions, down to 5 seconds). Every word is asked once before any comes back; a word comes back the other way round (picture or word), and a missed word comes back 3 questions later. At the end, a player with a high score types their name into the **high scores** (the top 10). They're saved **only in that browser on that computer**, so one computer can be a station that students take turns at, or a student can play at home. **Clear the scores** (tap twice) starts a new table. |

**Choosing the words.** Every game can use the vocab list, or words you write yourself:

| Write | You get |
|---|---|
| `{{< snowman >}}` | a random word from the whole vocab list, with a **New word** button |
| `{{< snowman unit=1 >}}` | a random word from unit 1's list (`course/vocab/`), with **New word** |
| `{{< snowman "democracy" >}}` | that vocab word (its picture and meaning are the hint); no New word button |
| `{{< snowman "Parthenon" hint="A temple in Athens" image="images/parthenon-west.jpg" >}}` | your own word, hint and picture; no New word button |

`{{< picture-reveal >}}` works the same way (add `tiles=9` or `tiles=25`). `{{< jeopardy unit=1 >}}` makes a board from a unit's vocab (columns: *What's the word?*, *Picture*, *Fill the gap*) and `{{< trivia unit=1 >}}` asks 5 questions about it (`count=8`, `seconds=15`, `title="..."`). `{{< matching unit=1 >}}` and `{{< memory unit=1 >}}` use 6 pairs (`count=8` for more); `with="picture"` or `with="meaning"` chooses each word's partner (matching shows meanings, memory shows pictures, unless you say). The random ones have a button for a new set. To write your own:

```markdown
::: {.jeopardy}
- **Places**
  - Land with water on three sides | a peninsula
  - This city had the first democracy | Athens
- **Gods**
  - The king of the gods | Zeus
  - The goddess of wisdom | Athena
:::

::: {.trivia title="Greece review" seconds="10"}
- Which city had the first democracy? | Athens
- The Olympic Games honored which god? | Zeus
:::

::: {.matching}
- Zeus | The king of the gods
- Athena | The goddess of wisdom
:::
```

Matching and memory use the same lines: a word, a `|`, then its partner (`::: {.memory}` for the card game). Sort it is written like Jeopardy: each group in **bold**, its items under it. After an item, a `|` and a reason (shown if a student puts it in the wrong group); an item can be a picture, named by its description:

```markdown
::: {.sort}
- **Ocean**
  - Shark | Sharks live and hunt in the sea.
  - ![Octopus](images/octopus.jpg) | Octopuses live on the sea floor.
- **Desert**
  - Camel | Camels can go days without water.
  - Scorpion | Scorpions hide from the sun under rocks.
:::
```

`{{< blitz unit=1 >}}` (Word Blitz) plays with a unit's vocab (`mode="survival"` starts on Survival, students can switch; `count=` changes Classic's number of questions; `seconds=10`, `title="..."`; `ask="picture"` shows only pictures, `ask="word"` only words). `{{< scramble >}}` takes words like `{{< snowman >}}`; `{{< sort unit=1 >}}` and `{{< bingo unit=1 >}}` use a unit's vocab (or every word, with no `unit`). More game ideas, not built yet: `IDEAS.md`.

Each line is the clue or question, a `|`, then the answer. In Jeopardy, each category is a **bold** line, the first clue is worth 100, the next 200, and so on (or set your own with `points="200,400,600"`). `teams="3"` starts with 3 teams; `teams="0"` plays without teams or scores. `seconds="0"` turns the quick-fire timer off. To follow each word with a slide about it, put the games in a column of slides: a `#` heading for the column, then `##` slides under it (press ↓ to go down).

## Play at home (phones and computers)

**Play at home** in the sidebar (`course/play.qmd`) is an ordinary web page, not slides, with the one-player games: Word Blitz, Snowman, Scramble, Memory, Picture reveal and Matching. **Word Blitz** has a phone layout, so a student can play it on a phone; the others are drawn at slide size and scaled to fit, so they're best on a tablet or computer for now.

> **Teachers: this page is off for students until you turn it on.** It's on the teacher site only, so you can try it first. To let students play at home, open `course/play.qmd` and change `audience: [teacher]` to `audience: [teacher, student]` at the top, then publish the student site again. It then shows in the student site's sidebar. High scores stay on each student's own phone or computer.

Any game shortcode works on a web page (`format: html`) as well as on slides; `{{< game-picker games="blitz,snowman" >}}` offers only the games you list.

## Timelines and labelling

Three slide types for history (or any subject), all in **Unit 2 › Rome on a Timeline** (`course/units/02-ancient-rome/rome-timeline-slides.qmd`); its speaker notes show how each is written.

**A timeline to teach with.** One slide holds all the events, each with a date, a title, a photo and some text. A big card shows one event above the timeline: **‹ ›** go through them in order, tapping an event (or dragging along the line) jumps to it, and tapping the card **zooms in** to the whole photo and everything you wrote. Events are sorted by date for you ("509 BC", "AD 80", "1453").

```markdown
::: {.timeline-interactive #rome title="Ancient Rome"}

::: {.event date="509 BC" title="Rome becomes a republic" image="images/senate.jpg" slide="the-republic"}
The Romans send away their last king.     ← the first paragraph is the card's summary

Two consuls lead Rome, for one year each. ← everything shows when you zoom in
:::

::: {.event date="27 BC" title="Augustus, the first emperor" image="images/augustus.jpg"}
...
:::

:::
```

**A timeline across several slides:** give an event `slide="..."` (the id of a slide, from `## The Republic {#the-republic}`). That slide then gets a **timeline strip** along its bottom, by itself, showing where it is in the story. Tap any event on the strip to see its card, then **Go to this slide** or **The timeline** (back to the big one, on that event). The zoomed card on the big timeline gets **Go to this slide** too. Leave a little room at the bottom of those slides for the strip.

**Put it on the timeline (students).** The events without their dates: students drag each one onto the line at its year (or tap it, then tap the line). **Check** marks each one green, or red with its real date and a green dot where it belongs, and says whether the order is right. Write it as a list (or use `::: {.event}` divs):

```markdown
::: {.timeline-activity}
- 509 BC | Rome becomes a republic ![](images/senate.jpg)
- 27 BC | Augustus, the first emperor
:::
```

Options: `tolerance="25"` (years off that still count; the usual is 5% of the timeline), `snap="10"`, `start="600 BC" end="AD 200"`. Plain `::: {.timeline}` is still the simple styled list.

**Label it.** A photo with numbered dots and a bank of labels: students drag each label onto its dot (or tap the label, then the dot). A right label stays, joined to its dot; a wrong one shakes and shows its reason. Each line is the label, a `|`, where its dot goes (`x,y`: percent from the left and from the top), and an optional reason. To find a place, press **L** on the slide and tap the photo: it shows (and copies) the `x,y`.

```markdown
::: {.label-it image="images/pont-du-gard.jpg"}
- Water channel | 40,15 | The water flowed in a covered channel along the very top.
- River | 12,82 | The aqueduct crosses the Gardon River.
:::
```

## More learning activities

Four more, all in **Unit 2 › Rome: Build It, Fill It, Order It** (`course/units/02-ancient-rome/learning-activities-slides.qmd`); its speaker notes show how each is written. Like Label it, each works by dragging **or** by tapping one thing and then where it goes, so they work on boards that drag badly. Write the right answer; the activity mixes it up.

**Build the sentence.** The words of a sentence, mixed up: students tap them in order (or drag them onto the line), then **Check**: words in the right place turn green, the others red. One sentence at a time, with **Next sentence**. Use `/` to keep words together as one tile; the full stop stays at the end. A picture, or a hint after a `|`, is optional.

```markdown
::: {.sentence-builder}
- The Romans / built / long, straight roads. ![](images/via-appia.jpg)
- The Senate / gave / advice / to the consuls. | Who gave advice?
:::
```

**Fill in the blanks.** A text with gaps and a word bank: students drag each word into its gap (or tap the word, then the gap); tapping a filled gap takes its word out. **Check** marks each gap. Put each missing word in `[square brackets]`; `extra="..."` adds wrong words to the bank.

```markdown
::: {.fill-blanks extra="soldiers, temples"}
The Romans built [aqueducts] to carry [water] to their cities.
:::
```

**Put it in order.** Cards to put in order: steps, events, a story. Students drag a card to its place (or tap it, then its new place); **Check** turns the cards in the right place green, and once all are right, each card's reason (after a `|`) shows. When every card has a picture, they sit side by side. `first="Oldest" last="Newest"` changes the words at the ends.

```markdown
::: {.put-in-order}
- Dig a deep trench. | First, the workers dug down about a meter.
- Fill it with big stones. | Big stones made a strong base.
- Put flat stones on top.
:::
```

**Venn diagram.** A Sort it with `layout="venn"` and exactly three groups, in the order left circle, middle ("both"), right circle:

```markdown
::: {.sort layout="venn"}
- **Ancient Greece**
  - The first democracy | Athens had the first democracy.
- **Both**
  - Many gods | Greeks and Romans both prayed to many gods.
- **Ancient Rome**
  - Latin | The Romans spoke Latin. The Greeks spoke Greek.
:::
```

## Quick reference slide

One slide with every link in the unit, for class: put it near the end of a deck.

```markdown
## Quick reference

::: {.quick-ref}
- [Mountains and sea](#/mountains-and-sea)
- [Athens or Sparta?](#/athens-or-sparta)
- [The Olympic Games](greek-ideas-slides.html#/the-olympic-games)
:::
```

The links you list become numbered **Key slides** on the left: any slide in this deck (`#/slide-id`) or another deck (`deck.html#/slide-id`). On the right is **everything in the unit**, built from the overview's list, so it stays up to date by itself: the packet (student copy), every deck, printable and outside link, each in its type's color, with a PDF button. Click a deck, printable or PDF and it opens in a **pop-up** over the slides (with **Open in new tab**, and × or Esc to close it), so you never lose your place. Key slides in this deck just go there; outside sites open in a new tab. Leave out the list and the grid fills the slide. `unit="02-ancient-rome"` shows another unit. Example: the end of *City-States and Democracy*.

## Tap-to-vote polls

Any slide can have a poll that students answer by tapping the board (or you click while counting hands). It needs no server and no student devices. There are three types:

```markdown
::: {.poll type="smileys"}
How confident do you feel?
:::

::: {.poll type="choice" options="Athens | Sparta | Corinth" correct="B"}
Which city-state trained every boy to be a soldier?
:::

::: {.poll type="truefalse" correct="false"}
Athens had a king.
:::
```

- `correct` is optional. On reveal, it outlines the right answer in green.
- Results stay hidden until you click **Show results** (or press **R**). Keys **1–6** also add votes.
- After each tap there's a 1-second pause, so one student can't vote many times in a row. Change it with `cooldown="2"`.
- Votes are saved in that browser, so they survive changing slides or a refresh, until you press **Reset** twice.

To show **every poll in the deck on one page** (with the date and time, ready to screenshot), add this slide, usually at the end:

```markdown
## Poll results {.poll-summary-slide}

::: {.poll-summary}
:::
```

Every deck in `course/units/` ends with an exit-ticket poll.


## Git basics

| What | Command |
|---|---|
| See what changed | `git status` and `git diff` |
| Save a snapshot (a "commit") | `git add .` then `git commit -m "Describe the change"` |
| Upload to GitHub | `git push` |
| Download changes from GitHub | `git pull` |

VS Code's **Source Control** panel (the branch icon on the left) does all of this with buttons, if you prefer.


## Credits

Unit content is written for this sample in simple English, with facts from Wikipedia ([CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)); each vocab word links to the article it's based on. Vocab pictures are original drawings made by `vocab/tools/draw_icons.py`. Photos and paintings in the slides come from Wikimedia Commons (public domain, CC0 or CC BY-SA); each unit's `images/CREDITS.md` lists them, and each deck ends with a picture-credits slide. The classroom tools' line icons are from [Lucide](https://lucide.dev) (ISC licence, in `_extensions/chalkline/ui/`).
