# The guide's own words and language points

The template and exemplar decks gloss words, show vocab galleries, play games and show language points.
In a new course the course's own lists are empty, so the guide brings its own: `vocab.csv` and
`frames.csv` here (copied from the Chalkline sample's lists; IDs start with `GD-`), with their pictures in
`../images/vocab/` (credits: `../images/vocab/CREDITS.md`).

`scripts/vocab_terms.py` adds them to the words and points the slides can use, after the course's own,
only when the guide is built (teacher site, `chalkline-guide` on). A course's own word with the same name
wins. They never show in the course's vocab app, its Vocab sidebar or its unit games.
