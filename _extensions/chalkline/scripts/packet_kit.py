"""Build the guide's packet samples (the packet kit, typst/packet/) into the teacher site.

The packet kit is Typst: print themes (sky, trail, blueprint) and page layouts for A3-folded packets, with a
teacher edition (answers written into the same pages) and loose sheets (one worksheet printed on its own).
The guide's samples (guide/packet/) use every piece. This script compiles them into the site, next to the
Packet Templates page, and writes what each page is for (the hidden `about()` notes on each page) to
packet-templates.json, which that page lists.

Runs automatically after each full render of the teacher site (`post-render`), and only when the guide is
there. Or by hand:

    python chalkline.py packet-kit            into _site-teacher/ (the guide only exists on the teacher site)

Writes (in the site folder, course/guide/02-chalkline/packet/):
    rome-<theme>.pdf, rome-sky-teacher.pdf                     the Rome sample, 32 pages
    sheet-<name>-sky.pdf                                       loose sheets (a spread on one A3 page)
    printer-test.pdf                                           one page per theme, to print and photocopy
    packet-templates.json                                      every page: its name, uses, pieces and PDF
                                                               (also the example units' pages, from the
                                                               page-about notes in their .qmd files)
"""

import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from extension import EXT, ROOT  # noqa: E402
import build_cache  # noqa: E402  (the publish workflow: reuse PDFs whose sources didn't change)

GUIDE = ROOT / "course" / "guide" / "02-chalkline"   # the guide's copy in the course (scripts/guide.py)
THEMES = ["sky", "trail", "blueprint"]
WORKERS = max(1, min(4, (os.cpu_count() or 2) // 2))


def root_path(p):
    return "/" + Path(p).relative_to(ROOT).as_posix()


def inputs():
    """Where the kit and the guide's own lists and pictures are, for Typst (root-relative paths)."""
    return {"kit": root_path(EXT / "typst" / "packet"), "guide": root_path(GUIDE),
            "vocab": root_path(GUIDE / "data" / "vocab.csv"), "frames": root_path(GUIDE / "data" / "frames.csv"),
            "vocab-images": root_path(GUIDE / "images" / "vocab")}


def fonts():
    out = []
    for f in (ROOT / "brand" / "fonts", EXT / "fonts" / "print"):
        if f.exists():
            out += ["--font-path", str(f)]
    return out


def input_args(extra):
    return [a for key, v in {**inputs(), **extra}.items() for a in ("--input", f"{key}={v}")]


def compile_one(job):
    src, pdf, extra = job
    k = build_cache.key("packet-kit", [GUIDE / "packet", GUIDE / "images", GUIDE / "data"], pdf.name)
    if build_cache.restore("packet-kit", k, pdf):
        return pdf, "reused"
    r = subprocess.run(["quarto", "typst", "compile", "--root", str(ROOT), *fonts(), *input_args(extra), str(src), str(pdf)],
                       capture_output=True, text=True)
    if r.returncode != 0 or not pdf.exists():
        return pdf, "FAILED:\n" + (r.stderr or r.stdout)[-2000:]
    if pdf.name.startswith("sheet-"):
        impose(src, pdf, extra)
    build_cache.store("packet-kit", k, pdf)
    return pdf, "made"


def query(src, label, extra):
    """Typst's answer to query(<label>) for a file, as a list (quarto's wrapper prints it on stderr)."""
    r = subprocess.run(["quarto", "typst", "query", "--root", str(ROOT), *fonts(), *input_args(extra), str(src), label, "--field", "value"],
                       capture_output=True, text=True)
    found = [line for line in (r.stdout + "\n" + r.stderr).splitlines() if line.strip().startswith("[")]
    return json.loads(found[0]) if found else []


def impose(src, pdf, extra):
    """A loose sheet: put each spread (two A4 pages) side by side on one A3 landscape page (pymupdf)."""
    import pymupdf as fitz   # (the newer name for fitz)
    starts = set(query(src, "<spread-page>", extra))
    if not starts:
        return
    doc, out = fitz.open(str(pdf)), fitz.open()
    i = 0
    while i < doc.page_count:
        w, h = doc[i].rect.width, doc[i].rect.height
        if (i + 1) in starts and i + 1 < doc.page_count:
            page = out.new_page(width=2 * w, height=h)
            page.show_pdf_page(fitz.Rect(0, 0, w, h), doc, i)
            page.show_pdf_page(fitz.Rect(w, 0, 2 * w, h), doc, i + 1)
            i += 2
        else:
            out.insert_pdf(doc, from_page=i, to_page=i)
            i += 1
    doc.close()
    out.save(str(pdf))


ABOUT = re.compile(r'^::: *\{\.page-about ([^}]*)\}', re.M)
ATTR = re.compile(r'([a-z-]+)="([^"]*)"')


def example_pages():
    """The example units' pages (guide/example-*/): each .qmd's page-about note, and where it starts in the
    unit's packet (generated/packet-pages.json, from the last packet build)."""
    try:
        starts = json.loads((ROOT / "generated" / "packet-pages.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        starts = {}
    out = []
    for index in sorted(GUIDE.glob("example-*/index.qmd")):
        folder = index.parent
        for qmd in sorted(folder.glob("*.qmd")):
            page = starts.get(qmd.relative_to(ROOT).as_posix())
            m = ABOUT.search(qmd.read_text(encoding="utf-8"))
            if not m or not page:
                continue
            a = dict(ATTR.findall(m.group(1)))
            out.append({"name": a.get("name", qmd.stem), "page": page,
                        "uses": [u.strip() for u in a.get("uses", "").split(";") if u.strip()],
                        "pieces": [p.strip() for p in a.get("pieces", "").split(",") if p.strip()],
                        "pdf": f"{folder.name}/{folder.name}-packet.pdf",
                        "sample": "Example: " + folder.name.removeprefix("example-").title()})
    return out


def main():
    in_quarto = "QUARTO_PROJECT_OUTPUT_DIR" in os.environ
    if in_quarto and not os.environ.get("QUARTO_PROJECT_RENDER_ALL"):
        return   # a save in the preview: the samples wait for a full render
    src_dir = GUIDE / "packet"
    if not src_dir.exists():
        return   # no guide here (the student site, or the course turned it off)
    site = ROOT / os.environ.get("QUARTO_PROJECT_OUTPUT_DIR", "_site-teacher")
    out = site / src_dir.relative_to(ROOT)
    if not (site / GUIDE.relative_to(ROOT)).exists():
        return   # the guide wasn't rendered into this site
    out.mkdir(parents=True, exist_ok=True)

    jobs = []
    for theme in THEMES:
        jobs.append((src_dir / "rome.typ", out / f"rome-{theme}.pdf", {"theme": theme}))
    jobs.append((src_dir / "rome.typ", out / "rome-sky-teacher.pdf", {"theme": "sky", "edition": "teacher"}))
    for sheet in sorted((src_dir / "sheets").glob("sheet-*.typ")):
        jobs.append((sheet, out / f"{sheet.stem}-sky.pdf", {"theme": "sky"}))
    jobs.append((src_dir / "printer-test.typ", out / "printer-test.pdf", {}))

    with ThreadPoolExecutor(WORKERS) as pool:
        results = list(pool.map(compile_one, jobs))
    made = sum(1 for _, r in results if r == "made")
    reused = sum(1 for _, r in results if r == "reused")
    for pdf, r in results:
        if r.startswith("FAILED"):
            print(f"packet_kit: couldn't build {pdf.name}: {r}")
    print(f"packet_kit: {made} PDFs made, {reused} reused, into {out.relative_to(ROOT)}")

    # what each page is for, from the hidden notes (the same pages in every theme)
    pages = []
    for sample, pdf in (("rome.typ", "rome-sky.pdf"),):
        for note in query(src_dir / sample, "<template-info>", {"theme": "sky"}):
            pages.append({**note, "pdf": "packet/" + pdf})
    pages += example_pages()
    (out / "packet-templates.json").write_text(json.dumps(pages, ensure_ascii=False, indent=1), encoding="utf-8")
    build_cache.prune("packet-kit")


if __name__ == "__main__":
    main()
