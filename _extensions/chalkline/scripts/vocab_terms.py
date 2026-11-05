"""Read every term in vocab/data/vocab.csv for the {{< vocab "democracy" >}} pop-ups.

Runs automatically before each render (`pre-render` in the extension's _extension.yml), so pop-ups always
match the vocab list. Picture and link paths are relative to the site root; the shortcode
adds the "../" a page needs.

Each term also gets the units whose word list (course/vocab/*.yml) has it, and its example
sentence and topic, for the slide games ({{< snowman unit=1 >}} and the others). "units" lists each
unit's number and title, for the Review games page.

Also reads vocab/data/frames.csv, the language points beyond vocabulary (grammar, phrases, stems,
frames and questions), for {{< frames >}}.

Writes:
    generated/vocab-terms.json
    generated/frames.json
"""

import csv
import json
from pathlib import Path

import yaml

from genfile import write_if_changed

from extension import ROOT  # noqa: E402  (the course folder)
SRC = ROOT / "vocab" / "data" / "vocab.csv"
FRAMES = ROOT / "vocab" / "data" / "frames.csv"
FRAMES_OUT = ROOT / "generated" / "frames.json"
OUT = ROOT / "generated" / "vocab-terms.json"
UNITS = ROOT / "course" / "vocab"


def unit_lists():
    """({"democracy": [1], ...}, [{"unit": 1, "title": "Ancient Greece"}, ...]) from each unit's word list."""
    found, units = {}, []
    for path in sorted(UNITS.glob("*.yml")):
        data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        units.append({"unit": data.get("unit"), "title": data.get("unit_title", "")})
        for t in data.get("terms") or []:
            found.setdefault(str(t.get("term", "")).strip().lower(), []).append(data.get("unit"))
    return found, units


def main():
    units, unit_titles = unit_lists()
    terms = []
    with open(SRC, encoding="utf-8", newline="") as f:
        for r in csv.DictReader(f):
            terms.append({
                "id": r["id"],
                "term": r["term_en"],
                "aka": [a.strip() for a in r["aka"].split(";") if a.strip()],
                "zh": r["zh"],                    # shown in pop-ups (reference), never in flashcards or quizzes
                "definition": r["short_def"],
                "image": "vocab/images/" + r["image"] if r["image"] else "",
                "url": "vocab/app/#id=" + r["id"],
                "example": r["example"],
                "topic": r["subdomain"].replace("-", " ").capitalize(),   # "daily-life" -> "Daily life" (Sort it groups)
                "units": units.get(r["term_en"].strip().lower(), []),
            })
    OUT.parent.mkdir(exist_ok=True)
    write_if_changed(OUT, json.dumps({"terms": terms, "units": unit_titles}, ensure_ascii=False, indent=0))
    frames = []
    if FRAMES.exists():
        with open(FRAMES, encoding="utf-8", newline="") as f:
            for r in csv.DictReader(f):
                if not r.get("id"):
                    continue
                split = lambda cell: [a.strip() for a in (cell or "").split(";") if a.strip()]
                frames.append({
                    "id": r["id"], "kind": r.get("kind", "frame"), "en": r.get("en", ""), "zh": r.get("zh", ""),
                    "answers_en": split(r.get("answer_en")), "answers_zh": split(r.get("answer_zh")),
                    "examples": split(r.get("example")) if r.get("kind") == "grammar" else ([r["example"]] if r.get("example") else []),
                    "function": r.get("function", ""),
                    "units": [int(u) for u in split(r.get("units")) if u.isdigit()],   # empty: all year
                })
    write_if_changed(FRAMES_OUT, json.dumps({"frames": frames}, ensure_ascii=False, indent=0))
    print(f"vocab_terms.py: {len(terms)} terms, {len(frames)} frames")


if __name__ == "__main__":
    main()
