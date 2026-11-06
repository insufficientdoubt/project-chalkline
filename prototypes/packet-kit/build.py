"""Build the mini packet in every theme, and a picture of each page:
    python prototypes/packet-kit/build.py            -> prototypes/packet-kit/out/mini-packet-<theme>.pdf
"""
import json
import subprocess
import sys
from pathlib import Path

from pypdf import PdfReader, PdfWriter, PageObject, Transformation

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "out"
THEMES = ["sky", "trail", "blueprint"]
FONTS = ["--font-path", str(ROOT / "brand/fonts"), "--font-path", str(ROOT / "_extensions/chalkline/fonts/print")]


def compile(src, pdf, *inputs):
    args = [a for i in inputs for a in ("--input", i)]
    r = subprocess.run(["quarto", "typst", "compile", "--root", str(ROOT), *FONTS, *args, str(src), str(pdf)], capture_output=True, text=True)
    print(pdf.name, "ok" if r.returncode == 0 else "FAILED")
    if r.stderr.strip():
        print(r.stderr[-3000:])


def impose(src, pdf, *inputs):
    """A loose sheet: put each spread (its two A4 pages, side by side) on one A3 landscape page, so the
    panorama and the box across the spine still meet. Typst reports where the spreads start (<spread-page>)."""
    args = [a for i in inputs for a in ("--input", i)]
    q = subprocess.run(["quarto", "typst", "query", "--root", str(ROOT), *FONTS, *args, str(src), "<spread-page>", "--field", "value"],
                       capture_output=True, text=True)
    # (quarto's wrapper prints typst's answer on stderr, with a deprecation warning after it)
    found = [l for l in (q.stdout + "\n" + q.stderr).splitlines() if l.strip().startswith("[")]
    starts = set(json.loads(found[0])) if found else set()
    if not starts:
        return
    reader, writer = PdfReader(str(pdf)), PdfWriter()
    i = 0
    while i < len(reader.pages):
        page = reader.pages[i]
        if (i + 1) in starts and i + 1 < len(reader.pages):
            w, h = float(page.mediabox.width), float(page.mediabox.height)
            a3 = PageObject.create_blank_page(width=2 * w, height=h)
            a3.merge_transformed_page(page, Transformation())
            a3.merge_transformed_page(reader.pages[i + 1], Transformation().translate(tx=w, ty=0))
            writer.add_page(a3)
            i += 2
        else:
            writer.add_page(page)
            i += 1
    writer.write(str(pdf))
    print(f"  {pdf.name}: spread(s) on page(s) {sorted(starts)} put on A3")


def main():
    OUT.mkdir(exist_ok=True)
    for theme in (sys.argv[1:] or THEMES):
        compile(HERE / "mini-packet.typ", OUT / f"mini-packet-{theme}.pdf", f"theme={theme}")
    if not sys.argv[1:]:
        # the teacher edition: the same pages with the answers written in
        compile(HERE / "mini-packet.typ", OUT / "mini-packet-sky-teacher.pdf", "theme=sky", "edition=teacher")
        # the second sample: Mesopotamia, rebuilt from a colleague's worksheets
        for theme in THEMES:
            compile(HERE / "mesopotamia.typ", OUT / f"mesopotamia-{theme}.pdf", f"theme={theme}")
        compile(HERE / "mesopotamia.typ", OUT / "mesopotamia-trail-teacher.pdf", "theme=trail", "edition=teacher")
    if not sys.argv[1:]:
        # loose sheets: the same pages, printed on their own (A4; a spread on one A3 page)
        for sheet in sorted((HERE / "sheets").glob("sheet-*.typ")):
            for theme in THEMES:
                pdf = OUT / f"{sheet.stem}-{theme}.pdf"
                compile(sheet, pdf, f"theme={theme}")
                impose(sheet, pdf, f"theme={theme}")
        # the printer check
        compile(HERE / "printer-test.typ", OUT / "printer-test.pdf")

if __name__ == "__main__":
    main()
