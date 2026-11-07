"""Update Chalkline: the newest version from GitHub, in place of the one in this course.

    python chalkline.py update               download the newest Chalkline and put it in place
    python chalkline.py update --check       only say whether there is a newer one
    python chalkline.py update --from v1.2   a tag or branch instead of main
    python chalkline.py update --force       even when you have unsaved changes to Chalkline's files

What it replaces (Chalkline's files only, never your course):
    _extensions/chalkline/      the extension (or _extensions/<owner>/chalkline/, wherever this course has it)
    chalkline.py, Start Chalkline.command, Start Chalkline.bat, requirements.txt

Your lessons, vocab, pictures, brand/, _quarto.yml and your own tools (_extensions/my-tools/) are not touched.
Then it lists what's new, from Chalkline's CHANGELOG.md. Run the launcher (or `quarto render`) afterwards: the
first build after an update rebuilds everything.

Why not `quarto update`? A course made by cloning Chalkline or with `quarto use template` has the extension in
_extensions/chalkline/, which `quarto update` doesn't recognise: it would install a second copy beside it.

Anything you changed inside _extensions/chalkline/ is replaced. That's why your own tools belong in
_extensions/my-tools/ (see CLAUDE.md). In a git folder, the update stops if Chalkline's files have changes that
aren't committed, so nothing is lost by surprise; the old version stays in git history.
"""

import io
import json
import shutil
import subprocess
import sys
import tempfile
import urllib.request
import zipfile
from pathlib import Path

from extension import EXT, ROOT  # noqa: E402

REPO = "insufficientdoubt/project-chalkline"
ROOT_FILES = ["chalkline.py", "Start Chalkline.command", "Start Chalkline.bat", "requirements.txt"]


def arg(name, default=None):
    if name in sys.argv:
        i = sys.argv.index(name)
        return sys.argv[i + 1] if i + 1 < len(sys.argv) else default
    return default


def git(*args):
    try:
        return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, timeout=30)
    except (OSError, subprocess.SubprocessError):
        return None


def unsaved_changes():
    """Chalkline's files with changes git hasn't committed (empty if this isn't a git folder)."""
    paths = [str(EXT.relative_to(ROOT))] + [f for f in ROOT_FILES if (ROOT / f).exists()]
    r = git("status", "--porcelain", "--", *paths)
    if r is None or r.returncode != 0:
        return []
    return [line[3:] for line in r.stdout.splitlines() if line.strip()]


def latest_commit(ref):
    """The newest commit on GitHub for ref: (short id, date, message), or None if GitHub can't be reached."""
    url = f"https://api.github.com/repos/{REPO}/commits/{ref}"
    try:
        with urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": "chalkline-update"}), timeout=20) as r:
            c = json.load(r)
        return c["sha"][:7], c["commit"]["committer"]["date"][:10], c["commit"]["message"].splitlines()[0]
    except Exception:   # noqa: BLE001  (offline, rate-limited, …: just say so)
        return None


def download(ref):
    """The repository at ref, unzipped into a temporary folder. Returns the folder with its files."""
    url = f"https://codeload.github.com/{REPO}/zip/{ref}"
    with urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": "chalkline-update"}), timeout=120) as r:
        data = r.read()
    tmp = Path(tempfile.mkdtemp(prefix="chalkline-update-"))
    zipfile.ZipFile(io.BytesIO(data)).extractall(tmp)
    tops = [p for p in tmp.iterdir() if p.is_dir()]
    return tops[0]


def changelog_lines(path):
    return [line.rstrip() for line in path.read_text(encoding="utf-8").splitlines()] if path.exists() else []


def whats_new(old, new):
    """The changelog's new entries: bullets in the new CHANGELOG.md that the old one didn't have."""
    seen = set(old)
    out = []
    for line in new:
        if line.startswith("- ") and line not in seen:
            out.append(line[2:])
    return out


def duplicates():
    """Other copies of Chalkline in this course (for example one `quarto update` installed beside it)."""
    found = list(ROOT.glob("_extensions/chalkline/_extension.yml")) + list(ROOT.glob("_extensions/*/chalkline/_extension.yml"))
    return [p.parent for p in found if p.parent.resolve() != EXT.resolve()]


def main():
    ref = arg("--from", "main")
    head = latest_commit(ref)
    if "--check" in sys.argv:
        if head:
            print(f"update: the newest Chalkline ({ref}) is {head[0]}, {head[1]}: {head[2]}")
            print("update: to get it, run: python chalkline.py update")
        else:
            print("update: couldn't reach GitHub to check (no internet, or try again later)")
        return

    for d in duplicates():
        print(f"update: there's a second copy of Chalkline in {d.relative_to(ROOT).as_posix()}/ "
              "(from `quarto add` or `quarto update`?). Delete that folder: a course needs only one.")

    changed = unsaved_changes()
    if changed and "--force" not in sys.argv:
        print("update: these Chalkline files have changes that aren't committed:")
        for f in changed[:20]:
            print(f"    {f}")
        print("update: the update would replace them. Commit them first (your old version then stays in git\n"
              "        history), move your own tools to _extensions/my-tools/, or run with --force to replace them.")
        sys.exit(1)

    print(f"update: downloading Chalkline ({ref}) from github.com/{REPO} …")
    try:
        src = download(ref)
    except Exception as e:   # noqa: BLE001
        sys.exit(f"update: couldn't download it ({e}). Nothing was changed.")
    new_ext = src / "_extensions" / "chalkline"
    if not (new_ext / "_extension.yml").exists():
        sys.exit("update: the download has no _extensions/chalkline/. Nothing was changed.")

    old_log = changelog_lines(EXT / "CHANGELOG.md")
    # the new extension goes where this course keeps it (_extensions/chalkline/ or _extensions/<owner>/chalkline/)
    staging = EXT.parent / (EXT.name + ".new")
    if staging.exists():
        shutil.rmtree(staging)
    shutil.copytree(new_ext, staging, ignore=shutil.ignore_patterns("__pycache__"))
    shutil.rmtree(EXT)
    staging.rename(EXT)
    updated = [EXT.relative_to(ROOT).as_posix() + "/"]
    for f in ROOT_FILES:
        new = src / f
        if new.exists() and (not (ROOT / f).exists() or (ROOT / f).read_bytes() != new.read_bytes()):
            shutil.copy2(new, ROOT / f)
            updated.append(f)
    shutil.rmtree(src.parent, ignore_errors=True)

    print("update: updated " + ", ".join(updated) + (f" to {head[0]} ({head[1]})" if head else ""))
    news = whats_new(old_log, changelog_lines(EXT / "CHANGELOG.md"))
    if news:
        print("\nWhat's new (from CHANGELOG.md; read it for any steps your course needs):")
        for n in news[:15]:
            print("  • " + (n if len(n) < 160 else n[:157] + "…"))
        if len(news) > 15:
            print(f"  … and {len(news) - 15} more")
    print("\nupdate: now run the launcher (or `quarto render`); the first build rebuilds everything.")
    if (ROOT / "requirements.txt").exists() and "requirements.txt" in updated:
        print("update: requirements.txt changed: also run  pip install -r requirements.txt")


if __name__ == "__main__":
    main()
