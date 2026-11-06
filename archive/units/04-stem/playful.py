"""The playful worksheet's problems and layout (layout: playful; the kit is in the PDF template:
doodle(), star-num(), flower-num(), work-box()). Problems come from a seed, so the answer key always
matches. Two themes: "nature" (garden stories, flower numbers) and "robots" (robot stories, stars).

    import sys; sys.path.append("course/units/04-stem")
    from playful import facts, stories, facts_typst, stories_typst, facts_html, stories_html, WEB
"""
import random


def facts(seed, count=12):
    """Times-table facts (2 to 10), no repeats, a few divisions mixed in near the end."""
    rng = random.Random(seed)
    seen, out = set(), []
    while len(out) < count:
        a, b = rng.randint(2, 10), rng.randint(2, 10)
        if (a, b) in seen or a * b < 10:
            continue
        seen.add((a, b))
        if len(out) >= count - 3:
            out.append({"q": f"{a * b} ÷ {a}", "answer": b})
        else:
            out.append({"q": f"{a} × {b}", "answer": a * b})
    return out


def stories(seed, theme="nature"):
    """Three short story problems: one times, one share, one "every minute"."""
    rng = random.Random(seed + 100)
    w, n = rng.randint(3, 6), rng.randint(4, 9)
    k, each = rng.randint(3, 6), rng.randint(3, 8)
    s, m = rng.randint(2, 9), rng.randint(3, 6)
    if theme == "nature":
        return [
            {"q": f"A ladybug has 6 legs. How many legs do {n} ladybugs have?", "answer": f"{6 * n} legs", "doodle": "ladybug"},
            {"q": f"{k * each} seeds are planted equally in {k} pots. How many seeds go in each pot?", "answer": f"{each} seeds", "doodle": "flower"},
            {"q": f"A snail crawls {s} cm every minute. How far does it crawl in {m} minutes?", "answer": f"{s * m} cm", "doodle": "snail"},
        ]
    return [
        {"q": f"Each robot has {w} wheels. How many wheels do {n} robots have?", "answer": f"{w * n} wheels", "doodle": "gear"},
        {"q": f"{k * each} bolts are shared equally by {k} robots. How many bolts does each robot get?", "answer": f"{each} bolts", "doodle": "robot"},
        {"q": f"A robot climbs {s} steps every minute. How many steps does it climb in {m} minutes?", "answer": f"{s * m} steps", "doodle": "star"},
    ]


# ---------------------------------------------------------------- PDF (Typst)

FILLS = ["#ffe08a", "#bfe3ff", "#ffc9de", "#c8f0c4"]   # soft badge colors, in turn


def facts_typst(problems, answers=False, badge="flower-num"):
    cells = []
    for n, p in enumerate(problems, 1):
        ans = (f'text(font: playful-round, size: 20pt, weight: 700, fill: rgb("#0087ff"))[{p["answer"]}]' if answers else "[]")
        cells.append(
            f'block(width: 100%, height: 1.1in, radius: 16pt, inset: (left: 16pt, right: 8pt, y: 8pt), stroke: 1.6pt + rgb("#1F2933"))['
            f'#place(top + left, dx: -26pt, dy: -18pt, {badge}({n}, fill: rgb("{FILLS[(n - 1) % 4]}")))'
            f'#align(center + horizon, grid(columns: 2, column-gutter: 7pt, align: horizon,'
            f' text(font: playful-round, size: 19pt, weight: 600)[#box[{p["q"]} =]],'
            f' box(width: 0.72in, height: 0.5in, radius: 10pt, stroke: (paint: rgb("#8a97a8"), thickness: 1.4pt, dash: "dashed"),'
            f' align(center + horizon, {ans}))))]')
    return "```{=typst}\n#grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt, row-gutter: 12pt,\n  " + ",\n  ".join(cells) + ")\n```\n"


def stories_typst(problems, answers=False, badge="flower-num"):
    rows = []
    for n, p in enumerate(problems, 1):
        ans = (f'#place(bottom + right, text(font: playful-round, size: 16pt, weight: 700, fill: rgb("#0087ff"))[{p["answer"]}])' if answers else "")
        rows.append(
            f'grid(columns: (auto, 1fr, auto), column-gutter: 10pt, align: top,'
            f' {badge}({12 + n}, fill: rgb("{FILLS[n % 4]}")),'
            f' [{p["q"]} #v(2pt) #work-box(height: {"0.5in" if answers else "1.55in"})[#text(size: 11pt, fill: rgb("#8a97a8"))[Draw it or show your work]{ans}]],'
            f' doodle("{p["doodle"]}", width: 0.75in))')
    return "```{=typst}\n#stack(spacing: 12pt,\n  " + ",\n  ".join(rows) + ")\n```\n"


# ---------------------------------------------------------------- web page

WEB = """```{=html}
<style>
  @font-face { font-family: "Patrick Hand"; src: url(fonts/patrick-hand-latin-400-normal.woff2) format("woff2"); }
  @font-face { font-family: "Fredoka"; font-weight: 600; src: url(fonts/fredoka-latin-600-normal.woff2) format("woff2"); }
  .pl { font-family: "Patrick Hand", "Comic Sans MS", cursive; font-size: 1.15rem; }
  .pl-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin: 10px 0 20px; }
  .pl-box { position: relative; display: flex; align-items: center; justify-content: center; gap: 10px; min-height: 92px;
            border: 2px solid #1F2933; border-radius: 16px; font-family: "Fredoka", sans-serif; font-size: 1.6rem; font-weight: 600; }
  .pl-star { position: absolute; top: -10px; left: -10px; width: 34px; height: 34px; display: grid; place-items: center;
             font: 700 0.85rem "Fredoka", sans-serif; border: 2px solid #1F2933; border-radius: 50%; box-shadow: 0 0 0 4px #fff3b0 inset; }
  .pl.nature .pl-box, .pl-story .pl-work { border-color: #3f8f46; }
  .pl-ans { display: inline-grid; place-items: center; width: 70px; height: 44px; border: 2px dashed #8a97a8; border-radius: 10px; color: #0087ff; }
  .pl-story { display: grid; grid-template-columns: 1fr 70px; gap: 10px; align-items: start; margin: 0 0 14px; }
  .pl-work { height: 90px; margin-top: 4px; border: 2px dashed #8a97a8; border-radius: 14px; }
  @media (max-width: 640px) { .pl-grid { grid-template-columns: 1fr 1fr; } }
</style>
```
"""


def facts_html(problems, answers=False):
    cells = "".join(
        f'<div class="pl-box"><span class="pl-star" style="background:{FILLS[(n - 1) % 4]}">{n}</span>'
        f'{p["q"]} = <span class="pl-ans">{p["answer"] if answers else ""}</span></div>'
        for n, p in enumerate(problems, 1))
    return f'```{{=html}}\n<div class="pl pl-grid">{cells}</div>\n```\n'


def stories_html(problems, answers=False):
    shown = lambda p: '<b style="color:#0087ff">' + p["answer"] + "</b>" if answers else ""
    rows = "".join(
        f'<div class="pl-story"><div><b>{12 + n}.</b> {p["q"]}<div class="pl-work">{shown(p)}</div></div></div>'
        for n, p in enumerate(problems, 1))
    return f'```{{=html}}\n<div class="pl">{rows}</div>\n```\n'
