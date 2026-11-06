"""Pictures of the built packets, laid out as spreads (cover alone on the right):
    python prototypes/packet-kit/sheets.py [dpi]   -> out/sheet-<theme>.png, and out/spread-<theme>-<n>.png per spread
"""
import glob
import subprocess
import sys
from pathlib import Path

from PIL import Image

OUT = Path(__file__).resolve().parent / "out"
DPI = sys.argv[1] if len(sys.argv) > 1 else "34"

for pdf in sorted(OUT.glob("mini-packet-*.pdf")):
    theme = pdf.stem.replace("mini-packet-", "")
    tmp = OUT / f"_pages-{theme}"
    tmp.mkdir(exist_ok=True)
    for f in tmp.glob("*.png"):
        f.unlink()
    subprocess.run(["pdftoppm", "-r", DPI, "-png", str(pdf), str(tmp / "p")], check=True)
    pages = [Image.open(f) for f in sorted(glob.glob(str(tmp / "p-*.png")))]
    w, h = pages[0].size
    spreads = [[None, pages[0]]] + [pages[i:i + 2] for i in range(1, len(pages), 2)]
    cols, gap = 3, 18
    rows = (len(spreads) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * (2 * w + gap) + gap, rows * (h + gap) + gap), "#6b7280")
    for k, sp in enumerate(spreads):
        x, y = gap + (k % cols) * (2 * w + gap), gap + (k // cols) * (h + gap)
        for j, im in enumerate(sp):
            if im:
                sheet.paste(im, (x + j * w, y))
    sheet.save(OUT / f"sheet-{theme}.png")
    print(OUT / f"sheet-{theme}.png", len(pages), "pages")
