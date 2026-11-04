"""The Chalkline guide: a unit on the teacher site, copied in from the extension at build time.

Runs automatically before each render (`pre-render` in the extension's _extension.yml), first of all,
so the other scripts and Quarto see the guide like any other folder in the course.

The guide (the slide templates and how to use them) lives inside Chalkline, in guide/, and updates
with Chalkline. A course never keeps a copy in git: on the teacher site, this script copies guide/ into
course/guide/02-chalkline/ (git-ignored); on the student site, or when the course turns the guide off,
it removes that copy. The teacher's own templates are in course/guide/01-my-templates/, listed above
Chalkline's. They are the teacher's own files: this script never touches them.

Turn the guide off in _quarto.yml (it's on unless you say so):

    chalkline-guide: false

Turning it off only stops the guide being built. Nothing is deleted from Chalkline, and every template
piece (boxes, tiles, timers, the puzzle...) keeps working in the course's own slides.

    python chalkline.py guide --teacher          copy it now, as for the teacher site

Writes (not saved in git):
    course/guide/02-chalkline/                   a copy of guide/, rewritten only where it changed
"""

import os
import shutil
import sys

import yaml

from extension import EXT, ROOT  # noqa: E402  (the course folder, Chalkline)

SOURCE = EXT / "guide"
DEST = ROOT / "course" / "guide" / "02-chalkline"
SKIP = {"README.md", "__pycache__", ".DS_Store"}   # notes for people who change Chalkline, not pages


def guide_on():
    """True unless the course says `chalkline-guide: false` (in _quarto.yml or the teacher profile)."""
    on = True
    for name in ("_quarto.yml", "_quarto-teacher.yml"):
        path = ROOT / name
        if path.exists():
            settings = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
            if "chalkline-guide" in settings:
                on = settings["chalkline-guide"] is not False
    return on


def teacher_site():
    profiles = os.environ.get("QUARTO_PROFILE", "")
    return "teacher" in profiles.split(",") or "--teacher" in sys.argv


def source_files():
    for src in sorted(SOURCE.rglob("*")):
        rel = src.relative_to(SOURCE)
        if src.is_file() and not any(p in SKIP for p in rel.parts):
            yield src, rel


def copy_guide():
    """Copy every file that's new or changed, and remove files that are gone from the guide. Files that
    haven't changed aren't rewritten, so `quarto preview` doesn't reload in a loop."""
    wanted = set()
    changed = 0
    for src, rel in source_files():
        wanted.add(rel)
        dest = DEST / rel
        if not dest.exists() or dest.read_bytes() != src.read_bytes():
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(src.read_bytes())
            changed += 1
    for old in sorted(DEST.rglob("*"), reverse=True):
        rel = old.relative_to(DEST)
        if any(p.endswith("_files") or p.startswith(".quarto") for p in rel.parts):
            continue   # Quarto's own working files during a render
        if old.is_file() and rel not in wanted:
            old.unlink()
            changed += 1
        elif old.is_dir() and not any(old.iterdir()):
            old.rmdir()
    return changed


def main():
    if not SOURCE.is_dir():
        return
    if guide_on() and teacher_site():
        changed = copy_guide()
        if changed:
            print(f"guide.py: copied the Chalkline guide into {DEST.relative_to(ROOT).as_posix()}/ ({changed} file{"s" if changed != 1 else ""} changed)")
    elif DEST.exists():
        shutil.rmtree(DEST)
        print(f"guide.py: removed {DEST.relative_to(ROOT).as_posix()}/ (" +
              ("turned off: chalkline-guide: false" if not guide_on() else "student site: the guide is for teachers") + ")")


if __name__ == "__main__":
    main()
