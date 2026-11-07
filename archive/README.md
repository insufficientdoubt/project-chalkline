# Archive

Code that works but is switched off for now. Nothing here runs during a build.

| File | What it did | To turn it back on |
|---|---|---|
| `booklet.py` | Made an A3 fold-in-half booklet PDF (`name-booklet.pdf`) for every worksheet over 2 pages, and added an "A3 booklet" link next to the PDF link. Archived 2026-10-14. | Move it back to `scripts/` and add `- scripts/booklet.py` under `post-render:` in `_quarto.yml`. It worked on single worksheets; it was never tried on packets. |

## Units

`units/` holds the sample course's older demo units, archived 2026-11-06 when the packet kit became the only PDF layout. Their best parts live on as the two example units in Chalkline's guide (`_extensions/chalkline/guide/example-angles/` and `example-rome/`, with slides from the Greece unit in the Rome one). Their printables use the old worksheet and playful layouts, so some will need the packet kit's blocks before they print well again.

| Folder | What it was |
|---|---|
| `units/01-ancient-greece/` | Unit 1: city-states, Greek ideas, review games; Athens vs Sparta, fact cards, a class vote |
| `units/02-ancient-rome/` | Unit 2: the first version of the Rome unit |
| `units/03-gobekli-tepe/` | Unit 3: evidence or guess, animal cards, a T-pillar design challenge |
| `units/04-stem/` | Unit 4: STEM sampler (GeoGebra, PhET, Blockly decks; practice grids from a seed; a playful worksheet) |
| `units/05-angles/` | Unit 5: the first version of the Angles unit |
| `units/vocab/` | Their picture-card word lists (were `course/vocab/`) |
| `units/links.yml` | Their outside links (were in `course/links.yml`) |

**To bring one back:** move its folder back to `course/units/`, its word list to `course/vocab/`, and its links back into `course/links.yml`. The words themselves never left `vocab/data/vocab.csv`.

## The Slide kit deck

`guide/slide-kit-slides.qmd` was the guide's first deck of slide pieces (a sample lesson on the Warring States, in several looks and colour schemes). Archived 2026-11-08: the Template Library (`_extensions/chalkline/guide/templates-slides.qmd`) has every piece it showed, and more. Its pictures, `slide-kit-looks.css` and `drawio/` stay in the guide, because the Template Library and the Exemplar lesson use them. **To bring it back:** move it to `_extensions/chalkline/guide/`.

## The sample course's own content (archived 2026-11-08)

The course now has no units of its own: everything to learn from and copy is in Chalkline's guide (teacher site, **How to use Chalkline**). Archived here:

| Path | What it was |
|---|---|
| `units/00-start-here/` | The Start Here unit's index, the Live boards demo deck (the Template Library has live boards), and the Warring States pictures. Its tour deck and Quick Start moved to the guide (`guide/start/`). |
| `slide-style/` | The first slide-style experiment: its deck, its CSS, the `slide-style/` filter and the toolbox's Slide style tool (`{.styled kind="..."}`), replaced by bilingual slides and the Template Library. |
| `vocab/` | The sample's 52 words, 29 language points and their pictures (`vocab/data/`, `vocab/images/`). |
| `units/season.yml`, `units/links.yml` | The sample's events and outside links. |

**To bring the sample back:** move the folders back where they were (`archive/units/<unit>/` → `course/units/`, `archive/vocab/` → `vocab/`), and the links and events back into `course/links.yml` and `course/season.yml`. The slide-style filter also needs its line back in `_extensions/chalkline/_extension.yml` and the tool's in `filter.lua`.

