# History vocab (sample)

A bilingual (English / 简体中文) vocab list for the two sample units, and the vocab app that shows it (on the site under **History vocab** in the sidebar). The app is part of Chalkline: before each build it is copied into `app/` (not saved in git), and `config.js` here sets its title, topic names and links.

- `data/vocab.csv`: the terms. **The source of truth**: slides' vocab pop-ups (`{{< vocab "democracy" >}}`) and the unit vocab cards read it.
- `data/frames.csv`: **language points beyond vocabulary**, one row each, with a `kind`: `grammar` (a pattern like *short adjective + -er + than*, with examples), `phrase` (words that go together: *a quarter turn*), `stem` (a sentence starter: *Today I learned …*), `frame` (a sentence with `___` gaps) or `question` (with its answer frames in `answer_en` / `answer_zh`, several separated by `;`). `function` (agree, compare, explain…) groups them; `units` is the unit numbers that use it, or empty for all year. Put them on slides and printables with `{{< frames "FRM-014, FRM-015" >}}` (one lesson's) or `{{< frames unit=5 >}}` (a unit's). The same rules as vocab: IDs are permanent, 中文 is support, and never on quizzes.
- `images/`: one picture per term, named by ID (`GRC-010.jpg`, or `.svg` for a drawing). Photos are credited in `images/CREDITS.md`. The sample's first pictures are simple drawings made by `tools/draw_icons.py`; replace them with photos where a photo is better (see "Pictures" below).
- `config.js`: the app's title, topic names (in English and 中文) and quick-reference links.
- `schema.yaml`: the column rules. Run `python chalkline.py validate` after editing the CSV.

## Rules

1. **English is the target.** 中文 (`zh`) is support only.
2. **中文 appears in reference materials, never in review materials** (quizzes, flashcards, Kahoots).
3. **`short_def` stands on its own in simple English, 75 characters or fewer.**
4. **IDs are permanent.** Never reuse or renumber one.
5. To add a topic, add a domain (ID prefix) in `schema.yaml` and give it names in `config.js`.

## Pictures

A vocab picture appears in the pop-ups, the vocab app, printed cards and the slide games, often small. It should make the word **clear, distinct and memorable** at a glance.

1. **Look for a real image first.** Many words are best shown by the real thing: a photo of an aqueduct beats any drawing of one. Search, in this order:
   - [Wikimedia Commons](https://commons.wikimedia.org) (history, places, objects; try its *Quality images* and *Featured pictures* first)
   - Museum open access, all free to reuse: [the Met](https://www.metmuseum.org/art/collection/search?showOnly=openAccess), [Smithsonian](https://www.si.edu/openaccess), [Rijksmuseum](https://www.rijksmuseum.nl/en/collection)
   - [Unsplash](https://unsplash.com) and [Pexels](https://www.pexels.com) (modern photos: farming, voting, a quarry)
   - [Openverse](https://openverse.org) (searches many open collections at once)
2. **Check the license on the picture's own page**, not in the search results. Best: public domain, CC0, or the Unsplash or Pexels license (no credit required). Also fine: CC BY and CC BY-SA, with the credit. **Don't use** NC (non-commercial) or ND (no changes: we crop and resize) pictures, or anything without a clear license.
3. **Check the quality.** One clear subject that fills the frame; recognizable when small; sharp and well lit; no watermark, no text in the picture; nothing frightening or unsuitable for children. If the best photo is busy, crop it; if it's still unclear, keep looking.
4. **Prepare it:** crop to 4:3 (landscape, like the drawings), about 800 × 600 pixels, saved as `<ID>.jpg` under 200 KB. Set the `image` column to the file name.
5. **Credit it:** add a row to `images/CREDITS.md` (file, what it is, by, license, source link). If the picture is copied into a unit (`python chalkline.py import-vocab` does this), add the same row to that unit's `images/CREDITS.md`, and to a deck's picture-credits slide if the deck shows it as a photo.
6. **Make an original drawing only when no real image works:** for abstract ideas (*evidence*, *democracy*), or when every open photo is unclear. Keep it simple and bold, like the ones made by `tools/draw_icons.py`. Original drawings need no credit.

## Sources

Facts are from Wikipedia ([CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)), rewritten in simple English. Each term's `ref_url` links to the article it's based on.
