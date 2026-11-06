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

