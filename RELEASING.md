# Releasing Chalkline

For whoever makes Chalkline. Teachers' courses don't get this file.

## The rule: teachers only get releases

`python chalkline.py update` downloads the newest **release**: a version that was tested and published on purpose. It never takes work on `main`, drafts, or test releases (GitHub "pre-releases"). So:

- **Merging to `main` doesn't reach teachers.** Main is the working version: merge finished changes there as usual.
- **A release does.** Make one when a set of changes is tested and ready (below).
- **Testers can opt in:** `python chalkline.py update --pre` (the newest release, test releases included) or `--from main` (unreleased work).

## Version numbers

`MAJOR.MINOR.PATCH`, in `_extensions/chalkline/_extension.yml` (`version:`):

| Change | Example | Bump |
|---|---|---|
| An existing course must change something, or something teachers rely on works differently | a layout retired, a label renamed, a file moved | **MAJOR** (1.4.2 → 2.0.0) |
| New templates, blocks, tools or options; nothing breaks | a new organizer, a new game | **MINOR** (1.4.2 → 1.5.0) |
| Fixes only | a layout bug, a typo in the guide | **PATCH** (1.4.2 → 1.4.3) |

A **test release** adds `-beta.N` (or `-rc.N`): `1.5.0-beta.1`, `1.5.0-beta.2`, then `1.5.0`. It's published as a GitHub **pre-release**, so teachers never get it.

Don't change `version:` in ordinary changes: only `maintainer/release.py` does.

## Every change: a line in the changelog

Whenever a change will be noticed by teachers, add a bullet under `## Unreleased` at the top of `_extensions/chalkline/CHANGELOG.md`, in the same pull request: what changed, in plain words, and **any step an existing course needs** (“In an existing course: …”). Teachers see these lines when they update. Breaking changes start with **Breaking:**.

## Making a release

1. **Test** the version on `main`:
   - `quarto render --profile teacher` and `quarto render`: both clean;
   - a fresh course: copy the repository's files to an empty folder, run `python chalkline.py setup`, then a full build (the starter unit, its packet);
   - updating: in a copy of a course on the previous release, run `python chalkline.py update --from main` and build it;
   - the example packets build, and look right.
2. **Prepare it:** `python maintainer/release.py 1.5.0`. It sets `version:` and turns `## Unreleased` into `## 1.5.0 (date)` in the changelog.
3. **Commit** (`Release v1.5.0`), merge to `main`, then **tag** that commit: `git tag v1.5.0 && git push origin v1.5.0`.
4. **Publish** the release on GitHub (Releases › Draft a new release), with the changelog's notes. For a test release, tick **Set as a pre-release**.

## Never

- Never move, delete or re-use a published tag. If a release has a bug, fix it and release a patch (`1.5.1`).
- Never publish a release that hasn't been through step 1.

## A teacher who needs to go back

`python chalkline.py update --from v1.4.2 --force` puts that version back (the old version is also in their git history).
