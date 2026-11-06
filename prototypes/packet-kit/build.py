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


def main():
    OUT.mkdir(exist_ok=True)
    for theme in (sys.argv[1:] or THEMES):
        pdf = OUT / f"mini-packet-{theme}.pdf"
        r = subprocess.run(["quarto", "typst", "compile", "--root", str(ROOT),
                            "--font-path", str(ROOT / "brand/fonts"), "--font-path", str(ROOT / "_extensions/chalkline/fonts/print"),
                            "--input", f"theme={theme}", str(HERE / "mini-packet.typ"), str(pdf)], capture_output=True, text=True)
        print(theme, "ok" if r.returncode == 0 else "FAILED")
        if r.stderr.strip():
            print(r.stderr[-3000:])


if __name__ == "__main__":
    main()
