"""Build the mini packet in every theme, and a picture of each page:
    python prototypes/packet-kit/build.py            -> prototypes/packet-kit/out/mini-packet-<theme>.pdf
"""
import subprocess
import sys
from pathlib import Path

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


def main():
    OUT.mkdir(exist_ok=True)
    for theme in (sys.argv[1:] or THEMES):
        compile(HERE / "mini-packet.typ", OUT / f"mini-packet-{theme}.pdf", f"theme={theme}")
    if not sys.argv[1:]:
        # loose sheets (no facing pages, no padding), and the printer check
        compile(HERE / "mini-packet.typ", OUT / "mini-packet-sky-loose.pdf", "theme=sky", "booklet=false")
        compile(HERE / "printer-test.typ", OUT / "printer-test.pdf")

if __name__ == "__main__":
    main()
