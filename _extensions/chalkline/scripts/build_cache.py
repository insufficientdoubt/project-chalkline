"""Remember slide PDFs, slide pictures and packets between builds, so the publish step only redoes what changed.

On only when CHALKLINE_CACHE names a folder (the publish workflow sets it, and keeps the folder between runs
with actions/cache). On a computer it stays off: the launchers' --stale checks already skip what's up to date.

What counts as "changed": the files that went into a thing, hashed (their contents, not their dates, since a
fresh checkout gives every file a new date):
  - everything shared: Chalkline itself (_extensions/), brand/, the _quarto*.yml settings, the vocab data
    and the course's own settings (course/*.yml) - change any of these and everything is redone;
  - and the thing's own sources: a deck's or a unit's folder (its .qmd files, pictures, data).
The rendered pages can't be used for this: they carry the render time (build-stamp.lua).

    key = build_cache.key("slides-pdf", [deck.parent], "teacher")   # None when the cache is off
    if build_cache.restore("slides-pdf", key, pdf): ...             # copied from the cache: nothing to do
    ...make it...
    build_cache.store("slides-pdf", key, pdf)
    build_cache.prune("slides-pdf")                                  # at the end of a full run: forget the rest
"""

import hashlib
import os
import shutil
from pathlib import Path

from extension import ROOT

SHARED = ["_extensions", "brand", "_quarto.yml", "_quarto-teacher.yml", "_quarto-student.yml",
          "vocab/data", "vocab/images", "vocab/config.js", "vocab/schema.yaml", "requirements.txt"]
SKIP_DIRS = {".quarto", "__pycache__", ".git", "node_modules"}
_used = {}       # kind -> keys used in this run (for prune)
_shared = None   # the shared files' hash, worked out once


def folder():
    path = os.environ.get("CHALKLINE_CACHE")
    return (ROOT / path) if path else None


def _files(path):
    path = ROOT / path if not Path(path).is_absolute() else Path(path)
    if path.is_file():
        yield path
    elif path.is_dir():
        for root, dirs, names in os.walk(path):
            dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS and not d.endswith("_files"))
            for n in sorted(names):
                yield Path(root) / n


def _hash(paths, h):
    for path in paths:
        for f in _files(path):
            try:
                rel = f.relative_to(ROOT).as_posix()
            except ValueError:
                rel = f.as_posix()
            h.update(rel.encode() + b"\0")
            with open(f, "rb") as fh:
                for block in iter(lambda: fh.read(1 << 20), b""):
                    h.update(block)
            h.update(b"\0")


def shared():
    global _shared
    if _shared is None:
        h = hashlib.sha256()
        _hash(SHARED + sorted(p.relative_to(ROOT).as_posix() for p in (ROOT / "course").glob("*.yml")), h)
        _shared = h.hexdigest()
    return _shared


def key(kind, paths, extra=""):
    """A name for this thing's inputs, or None when the cache is off."""
    if not folder():
        return None
    h = hashlib.sha256((kind + "\0" + str(extra) + "\0" + shared()).encode())
    _hash(sorted({Path(p).as_posix() for p in paths}), h)
    k = h.hexdigest()[:32]
    _used.setdefault(kind, set()).add(k)
    return k


def restore(kind, k, dest):
    """Copy the remembered file (or folder) to `dest`. True if there was one."""
    if not k:
        return False
    src = folder() / kind / k / "out"
    if not src.exists():
        return False
    dest = Path(dest)
    if dest.exists():
        shutil.rmtree(dest) if dest.is_dir() else dest.unlink()
    dest.parent.mkdir(parents=True, exist_ok=True)
    (shutil.copytree if src.is_dir() else shutil.copy)(src, dest)
    return True


def store(kind, k, src):
    """Remember `src` (a file or a folder) under its key."""
    src = Path(src)
    if not k or not src.exists():
        return
    to = folder() / kind / k
    if to.exists():
        shutil.rmtree(to)
    to.mkdir(parents=True)
    (shutil.copytree if src.is_dir() else shutil.copy)(src, to / "out")


def prune(kind):
    """Forget what this run didn't use, so the cache doesn't keep growing. Only after a full run."""
    base = folder()
    if not base or not (base / kind).exists():
        return
    keep = _used.get(kind, set())
    for d in (base / kind).iterdir():
        if d.name not in keep:
            shutil.rmtree(d, ignore_errors=True)


def note(kind, reused, made):
    if folder() and (reused or made):
        print(f"{kind}: {reused} reused from the last build, {made} made")
