"""Prepare a Chalkline release (for whoever makes Chalkline; not copied into teachers' courses).

    python maintainer/release.py 1.0.0           a release: what teachers get with `python chalkline.py update`
    python maintainer/release.py 1.1.0-beta.1    a test release: only testers get it (`update --pre`)

It only changes two files, and tells you the rest (see RELEASING.md):
    _extensions/chalkline/_extension.yml   version: 1.0.0
    _extensions/chalkline/CHANGELOG.md     "## Unreleased" becomes "## 1.0.0 (date)", and a new empty "## Unreleased" goes on top

It checks that the version is newer than the last one, that "Unreleased" has something in it, and that
you're on main with nothing uncommitted. It never commits, tags, pushes or publishes: those are yours to do.
"""

import datetime
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXT = ROOT / "_extensions" / "chalkline"
VERSION = re.compile(r"^(\d+)\.(\d+)\.(\d+)(?:-(alpha|beta|rc)\.(\d+))?$")


def key(v):
    m = VERSION.match(v)
    if not m:
        return None
    a, b, c, kind, n = m.groups()
    return (int(a), int(b), int(c), 0 if kind else 1, kind or "", int(n or 0))


def git(*args):
    r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True)
    return r.stdout.strip()


def main():
    if len(sys.argv) != 2 or not VERSION.match(sys.argv[1].lstrip("v")):
        sys.exit("usage: python maintainer/release.py 1.0.0   (or 1.1.0-beta.1 for a test release)")
    new = sys.argv[1].lstrip("v")
    pre = "-" in new
    ext_yml = EXT / "_extension.yml"
    text = ext_yml.read_text(encoding="utf-8")
    old = re.search(r"^version:\s*(\S+)", text, re.M).group(1)
    if key(old) and key(new) <= key(old):
        sys.exit(f"release: {new} isn't newer than the current version, {old}.")
    if git("rev-parse", "--abbrev-ref", "HEAD") != "main":
        print("release: warning: you're not on main. Releases are made from main.")
    if git("status", "--porcelain"):
        print("release: warning: there are uncommitted changes. Commit or put them aside first.")

    log_path = EXT / "CHANGELOG.md"
    log = log_path.read_text(encoding="utf-8")
    m = re.search(r"^## Unreleased\s*\n(.*?)(?=^## |\Z)", log, re.M | re.S)
    notes = m.group(1).strip() if m else ""
    if not pre:   # the release after its test releases: their notes too (1.0.0 gathers 1.0.0-beta.1, -beta.2 …)
        betas = re.findall(rf"^## {re.escape(new)}-[^\n]*\n(.*?)(?=^## |\Z)", log, re.M | re.S)
        notes = "\n".join(n for n in [notes] + [b.strip() for b in betas] if n)
    if not m or not notes:
        sys.exit('release: CHANGELOG.md has nothing under "## Unreleased": write what changed first.')
    today = datetime.date.today().isoformat()
    log = log.replace(m.group(0), f"## Unreleased\n\n## {new} ({today})\n\n{notes}\n\n", 1)
    log_path.write_text(log, encoding="utf-8")
    ext_yml.write_text(re.sub(r"^version:\s*\S+", f"version: {new}", text, count=1, flags=re.M), encoding="utf-8")

    print(f"release: Chalkline {old} → {new}" + (" (a test release)" if pre else ""))
    print("release: changed _extensions/chalkline/_extension.yml and CHANGELOG.md. Now:")
    print(f"""
  1. Check the CHANGELOG entry reads well for teachers, then commit:
       git commit -am "Release v{new}"
  2. Get it onto main (merge the pull request), then tag that commit and push the tag:
       git tag v{new} && git push origin v{new}
  3. Publish it on GitHub: Releases › Draft a new release › tag v{new}, title "Chalkline {new}",
     the notes from CHANGELOG.md{" › tick 'Set as a pre-release'" if pre else ""} › Publish.
     (Or: gh release create v{new} --title "Chalkline {new}" --notes-file <notes>{" --prerelease" if pre else ""})
""")
    print("Teachers get it the next time they run `python chalkline.py update`" if not pre
          else "Only testers get it, with `python chalkline.py update --pre`.")


if __name__ == "__main__":
    main()
