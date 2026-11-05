"""Read every term in vocab/data/vocab.csv for the {{< vocab "democracy" >}} pop-ups.

Runs automatically before each render (`pre-render` in the extension's _extension.yml), so pop-ups always
match the vocab list. Picture and link paths are relative to the site root; the shortcode
adds the "../" a page needs.

Each term also gets the units whose word list (course/vocab/*.yml) has it, and its example
sentence and topic, for the slide games ({{< snowman unit=1 >}} and the others). "units" lists each
unit's number and title, for the Review games page.

Also reads vocab/data/frames.csv, the language points beyond vocabulary (grammar, phrases, stems,
frames and questions), for {{< frames >}}.

The guide's own words and points (guide/data/, copied into course/guide/02-chalkline/ by guide.py on the
teacher site) are added after the course's, marked "guide": the template decks use them, so they work in
a new course too. A course's own word or point with the same name or ID wins.

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
GUIDE = ROOT / "course" / "guide" / "02-chalkline"   # guide.py's copy of the guide (teacher site only)
GUIDE_URL = "course/guide/02-chalkline/"
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


def read_terms(path, units, image_dir, guide=False):
    terms = []
    if not path.exists():
        return terms
    with open(path, encoding="utf-8", newline="") as f:
        for r in csv.DictReader(f):
            t = {
                "id": r["id"],
                "term": r["term_en"],
                "aka": [a.strip() for a in r["aka"].split(";") if a.strip()],
                "zh": r["zh"],                    # shown in pop-ups (reference), never in flashcards or quizzes
                "definition": r["short_def"],
                "image": image_dir + r["image"] if r["image"] else "",
                "url": "" if guide else "vocab/app/#id=" + r["id"],
                "example": r["example"],
                "topic": r["subdomain"].replace("-", " ").capitalize(),   # "daily-life" -> "Daily life" (Sort it groups)
                "units": [] if guide else units.get(r["term_en"].strip().lower(), []),
            }
            if guide:
                t["guide"] = True
            terms.append(t)
    return terms


def main():
    units, unit_titles = unit_lists()
    terms = read_terms(SRC, units, "vocab/images/")
    known = {t["term"].lower() for t in terms} | {t["id"] for t in terms}
    for t in read_terms(GUIDE / "data" / "vocab.csv", units, GUIDE_URL + "images/vocab/", guide=True):
        if t["term"].lower() not in known and t["id"] not in known:
            terms.append(t)
    OUT.parent.mkdir(exist_ok=True)
    write_if_changed(OUT, json.dumps({"terms": terms, "units": unit_titles}, ensure_ascii=False, indent=0))
    frames = []
    for path, guide in ((FRAMES, False), (GUIDE / "data" / "frames.csv", True)):
        if not path.exists():
            continue
        with open(path, encoding="utf-8", newline="") as f:
            for r in csv.DictReader(f):
                if not r.get("id"):
                    continue
                split = lambda cell: [a.strip() for a in (cell or "").split(";") if a.strip()]
                if guide and any(x["id"] == r["id"] for x in frames):
                    continue
                frames.append({
                    "id": r["id"], "kind": r.get("kind", "frame"), "en": r.get("en", ""), "zh": r.get("zh", ""),
                    "answers_en": split(r.get("answer_en")), "answers_zh": split(r.get("answer_zh")),
                    "examples": split(r.get("example")) if r.get("kind") == "grammar" else ([r["example"]] if r.get("example") else []),
                    "function": r.get("function", ""),
                    "units": [int(u) for u in split(r.get("units")) if u.isdigit()],   # empty: all year
                })
                if guide:
                    frames[-1]["guide"] = True
    write_if_changed(FRAMES_OUT, json.dumps({"frames": frames}, ensure_ascii=False, indent=0))
    print(f"vocab_terms.py: {len(terms)} terms, {len(frames)} frames")


if __name__ == "__main__":
    main()
