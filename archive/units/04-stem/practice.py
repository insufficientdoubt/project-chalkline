"""Practice worksheets for the STEM unit: problems made from a seed, laid out as a grid of boxes.

The same seed always gives the same problems (so the answer key matches); change the seed at the
top of a worksheet for a new version. Each function returns text for a ```{python} cell with
`#| output: asis`: a raw Typst block for the PDF and a raw HTML block for the web page (each format
ignores the other's block).

    import sys; sys.path.append("course/units/04-stem")
    from practice import times_divide, mixed_review, score_bar
"""
import html
import random
from math import gcd

# ---------------------------------------------------------------- problems

def times_divide(seed, count=30):
    """Multiplication and division, easy to harder: facts, then 2-digit × 1-digit and exact
    division, then 2-digit × 2-digit and 3-digit ÷ 1-digit. Every division comes out exact."""
    rng = random.Random(seed)
    problems = []
    for i in range(count):
        level = 0 if i < count * 0.4 else 1 if i < count * 0.75 else 2
        if i % 2 == 0:   # multiplication
            a, b = [(rng.randint(3, 12), rng.randint(3, 12)), (rng.randint(13, 99), rng.randint(3, 9)),
                    (rng.randint(12, 99), rng.randint(11, 39))][level]
            problems.append({"op": "×", "a": a, "b": b, "answer": a * b, "stack": level > 0})
        else:            # division: made from a multiplication, so it's exact
            q, d = [(rng.randint(3, 12), rng.randint(3, 12)), (rng.randint(11, 25), rng.randint(3, 9)),
                    (rng.randint(21, 199), rng.randint(3, 9))][level]
            problems.append({"op": "÷", "a": q * d, "b": d, "answer": q, "stack": False})
    return problems


def _frac(n, d):
    g = gcd(n, d)
    return n // g, d // g


def mixed_review(seed):
    """Twelve mixed middle-school problems, one per topic. Each has a web version (Markdown with
    $math$) and a PDF version (Typst), and an answer."""
    rng = random.Random(seed)
    out = []

    def add(topic, md, typ, answer):
        out.append({"topic": topic, "md": md, "typ": typ, "answer": answer})

    # Fractions: add two with different denominators
    a, b = rng.choice([(2, 3), (3, 4), (1, 2), (2, 5), (1, 3)]), rng.choice([(1, 4), (1, 6), (3, 8), (1, 5), (5, 6)])
    n, d = _frac(a[0] * b[1] + b[0] * a[1], a[1] * b[1])
    ans = f"{n}/{d}" if n < d else f"{n // d} {n % d}/{d}" if n % d else str(n // d)
    add("Fractions", f"$\\frac{{{a[0]}}}{{{a[1]}}} + \\frac{{{b[0]}}}{{{b[1]}}}$",
        f"${a[0]}/{a[1]} + {b[0]}/{b[1]}$", ans + " (simplest form)")
    # Decimals
    x, y = rng.choice([n for n in range(12, 90) if n % 10]) / 10, rng.randint(2, 9) / 10   # no "2.0"
    add("Decimals", f"${x} \\times {y}$", f"${x} times {y}$", f"{round(x * y, 2)}")
    # Percent
    p, whole = rng.choice([10, 20, 25, 50, 75]), rng.randint(2, 15) * 20   # a multiple of 20: every answer is whole
    add("Percent", f"What is {p}% of {whole}?", f"What is {p}% of {whole}?", f"{p * whole // 100}")
    # Integers
    i1, i2, i3 = rng.randint(-12, -2), rng.randint(5, 15), rng.randint(-9, -2)
    add("Integers", f"${i1} + {i2} - ({i3})$", f"${i1} + {i2} - ({i3})$", f"{i1 + i2 - i3}")
    # Order of operations
    o1, o2, o3, o4 = rng.randint(2, 9), rng.randint(2, 6), rng.randint(6, 12), rng.randint(1, 5)
    add("Order of operations", f"${o1} + {o2} \\times ({o3} - {o4})$", f"${o1} + {o2} times ({o3} - {o4})$",
        f"{o1 + o2 * (o3 - o4)}")
    # Ratio
    r1, r2, k = rng.randint(2, 5), rng.randint(1, 4), rng.randint(2, 5)
    add("Ratios", f"A recipe uses {r1} cups of flour for every {r2} cups of sugar. How much sugar for {r1 * k} cups of flour?",
        f"A recipe uses {r1} cups of flour for every {r2} cups of sugar. How much sugar for {r1 * k} cups of flour?",
        f"{r2 * k} cups")
    # Exponents
    e1, e2 = rng.randint(3, 5), rng.randint(2, 4)
    add("Exponents", f"$2^{{{e1}}} - {e2}^2$", f"$2^{e1} - {e2}^2$", f"{2 ** e1 - e2 ** 2}")
    # Equations
    m, xx, c = rng.randint(2, 7), rng.randint(2, 12), rng.randint(1, 15)
    add("Equations", f"Solve: ${m}x - {c} = {m * xx - c}$", f"Solve: ${m} x - {c} = {m * xx - c}$", f"x = {xx}")
    # Area
    base, height = rng.randint(3, 9) * 2, rng.randint(4, 12)
    add("Area", f"A triangle has a base of {base} cm and a height of {height} cm. What is its area?",
        f"A triangle has a base of {base} cm and a height of {height} cm. What is its area?", f"{base * height // 2} cm²")
    # Mean
    while True:   # five whole numbers whose mean is a whole number
        mean = rng.randint(8, 15)
        nums = [rng.randint(4, 20) for _ in range(4)]
        last = 5 * mean - sum(nums)
        if 2 <= last <= 25:
            nums.append(last)
            break
    add("Mean", "Find the mean: " + ", ".join(map(str, nums)), "Find the mean: " + ", ".join(map(str, nums)), str(mean))
    # Angles
    g1, g2 = rng.randint(30, 80), rng.randint(30, 70)
    add("Angles", f"Two angles of a triangle are {g1}° and {g2}°. What is the third angle?",
        f"Two angles of a triangle are {g1}° and {g2}°. What is the third angle?", f"{180 - g1 - g2}°")
    # Unit rate
    each, items = rng.choice([1.5, 2, 2.5, 3, 4, 1.25]), rng.randint(3, 8)
    total = each * items
    add("Unit rate", f"{items} notebooks cost \\${total:.2f}. How much is one notebook?",
        f"{items} notebooks cost \\${total:.2f}. How much is one notebook?", f"${each:.2f}")
    return out


# ---------------------------------------------------------------- layout: Typst (PDF)

# Colors come from the brand (worksheet-colors, set by the PDF template); these are fallbacks.
_TYP_COLORS = """
  let c = worksheet-colors.get()
  let navy = c.at("navy", default: rgb("#003477"))
  let blue = c.at("blue", default: rgb("#0087ff"))
  let orange = c.at("orange", default: rgb("#ff8c0f"))
"""
TOPIC_COLORS = ["#0087ff", "#d6458f", "#2e9e4f", "#ff8c0f", "#7b4fc9", "#0aa6a6"]


def _typ_num(n):   # a small numbered tab in the top-left corner of a box
    return (f'place(top + left, dx: -2pt, dy: -2pt, box(fill: navy, radius: 3pt, inset: (x: 4pt, y: 2pt), '
            f'text(size: 7.5pt, weight: 700, fill: white)[{n}]))')


def _typ_problem(p, answer):
    show = f'text(size: 15pt, fill: blue, weight: 700)[{p["answer"]}]' if answer else "[]"
    if p["stack"]:   # written in columns: the numbers right-aligned, a line under them
        return (f'align(center + horizon, box(text(size: 15pt, number-width: "tabular")['
                f'#grid(columns: 2, align: right, column-gutter: 4pt, row-gutter: 5pt, [], [{p["a"]}], [{p["op"]}], [{p["b"]}])'
                f'#v(-2pt)#line(length: 3.2em, stroke: 1.2pt + navy)'
                f'#v(1pt)#align(right, {show})]))')
    blank = show if answer else 'box(width: 2.6em, stroke: (bottom: 0.8pt + navy.lighten(40%)))[#v(1.1em)]'
    return (f'align(center + horizon, text(size: 15pt, number-width: "tabular")[{p["a"]} {p["op"]} {p["b"]} = #{blank}])')


def times_divide_typst(problems, columns=5, answers=False, height="1.08in"):
    cells = []
    for n, p in enumerate(problems, 1):
        cells.append(f'box(width: 100%, height: {height}, stroke: 0.8pt + navy.lighten(70%), radius: 6pt, inset: (x: 6pt, y: 9pt))'
                     f'[#{_typ_num(n)} #{_typ_problem(p, answers)}]')
    return ("```{=typst}\n#context {" + _TYP_COLORS +
            f"  grid(columns: ({', '.join(['1fr'] * columns)}), column-gutter: 7pt, row-gutter: 7pt,\n    " +
            ",\n    ".join(cells) + ")\n}\n```\n")


def _typ_prompt(t):
    """A problem that is only math is shown big and centered (display style, so fractions are
    full size); one with words is normal text."""
    if t.startswith("$") and t.endswith("$") and t.count("$") == 2:
        return f'#v(8pt)#align(center, text(size: 17pt)[$display({t[1:-1]})$])'
    return f'#text(size: 12pt)[{t}]'


def mixed_review_typst(problems, columns=3, answers=False, height="1.74in"):
    cells = []
    for n, p in enumerate(problems, 1):
        color = TOPIC_COLORS[(n - 1) % len(TOPIC_COLORS)]
        tag = (f'box(fill: rgb("{color}").lighten(85%), radius: 8pt, inset: (x: 6pt, y: 2.5pt), '
               f'text(size: 7.5pt, weight: 700, fill: rgb("{color}").darken(15%))[{p["topic"].upper()}])')
        # the answer key: the answer on its own line, and each box only as tall as it needs
        ans = (f'#v(4pt)#align(right, text(size: 12pt, weight: 700, fill: blue)[{_typ_text(p["answer"])}])' if answers else "")
        cells.append(
            f'box(width: 100%, height: {"auto" if answers else height}, stroke: 0.8pt + navy.lighten(70%), radius: 8pt, inset: (x: 9pt, y: 8pt))['
            f'#grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon, '
            f'circle(radius: 8pt, fill: navy, align(center + horizon, text(size: 8pt, weight: 700, fill: white)[{n}])), {tag})'
            f'#v(6pt){_typ_prompt(p["typ"])}{ans}]')
    return ("```{=typst}\n#context {" + _TYP_COLORS +
            f"  grid(columns: ({', '.join(['1fr'] * columns)}), column-gutter: 8pt, row-gutter: 8pt,\n    " +
            ",\n    ".join(cells) + ")\n}\n```\n")


def _typ_text(s):   # plain text that's safe inside a Typst [...] block
    return s.replace("\\", "").replace("$", "\\$").replace("#", "\\#").replace("*", "\\*").replace("_", "\\_")


def score_bar(total, directions, timer=True):
    """Directions on the left; Score (and Time) boxes on the right, for the PDF and the web page."""
    typ = ("```{=typst}\n#context {" + _TYP_COLORS +
           "  let pill(body) = box(stroke: 1.2pt + navy, radius: 14pt, inset: (x: 11pt, y: 6pt), text(weight: 700, fill: navy, body))\n"
           f"  grid(columns: (1fr, auto{', auto' if timer else ''}), column-gutter: 8pt, align: horizon,\n"
           f"    text(size: 10.5pt)[*Directions:* {directions}],\n"
           f"    pill[Score #h(2.4em) / {total}]" + (",\n    pill[Time #h(3.2em)]" if timer else "") + ")\n"
           "  v(4pt)\n}\n```\n")
    web = (f'```{{=html}}\n<div class="ws-bar"><p><b>Directions:</b> {html.escape(directions)}</p>'
           f'<span class="ws-pill">Score <i></i> / {total}</span>' + ('<span class="ws-pill">Time <i></i></span>' if timer else "") +
           "</div>\n```\n")
    return typ + web


# ---------------------------------------------------------------- layout: HTML (web page)

WEB_STYLE = """```{=html}
<style>
  .ws-bar { display: flex; align-items: center; gap: 10px; margin: 0 0 14px; }
  .ws-bar p { flex: 1; margin: 0; }
  .ws-pill { padding: 4px 14px; border: 1.5px solid #003477; border-radius: 999px; color: #003477; font-weight: 700; white-space: nowrap; }
  .ws-pill i { display: inline-block; width: 2.4em; }
  .ws-grid { display: grid; gap: 8px; margin: 0 0 1.5em; }
  .ws-box { position: relative; min-height: 92px; padding: 10px 10px 8px; border: 1px solid #c9d3e0; border-radius: 8px;
            display: grid; place-items: center; font-size: 1.15em; font-variant-numeric: tabular-nums; }
  .ws-n { position: absolute; top: -1px; left: -1px; padding: 1px 6px; border-radius: 6px 0 6px 0; background: #003477; color: #fff; font-size: 0.6em; font-weight: 700; }
  .ws-stack { display: grid; grid-template-columns: auto auto; column-gap: 4px; justify-items: end; }
  .ws-stack hr { grid-column: 1 / -1; width: 100%; margin: 2px 0 0; border: 0; border-top: 2px solid #003477; }
  .ws-ans { color: #0087ff; font-weight: 700; }
  .ws-blank { display: inline-block; width: 2.6em; border-bottom: 1px solid #8a97a8; }
  .ws-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
  .ws-card { position: relative; min-height: 150px; padding: 10px 12px; border: 1px solid #c9d3e0; border-radius: 10px; }
  .ws-card .ws-head { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
  .ws-card .ws-num { display: grid; place-items: center; width: 22px; height: 22px; border-radius: 50%; background: #003477; color: #fff; font-size: 0.75em; font-weight: 700; }
  .ws-tag { padding: 1px 9px; border-radius: 999px; font-size: 0.7em; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase; }
  .ws-card .ws-ans { position: absolute; right: 12px; bottom: 8px; }
  @media (max-width: 700px) { .ws-cards { grid-template-columns: 1fr 1fr; } }
</style>
```
"""


def times_divide_html(problems, columns=5, answers=False):
    cells = []
    for n, p in enumerate(problems, 1):
        ans = f'<span class="ws-ans">{p["answer"]}</span>' if answers else ""
        if p["stack"]:
            body = (f'<div class="ws-stack"><span></span><span>{p["a"]}</span><span>{p["op"]}</span><span>{p["b"]}</span><hr>'
                    f'<span></span>{ans or "<span>&nbsp;</span>"}</div>')
        else:
            body = f'<span>{p["a"]} {p["op"]} {p["b"]} = {ans or "<span class=ws-blank>&nbsp;</span>"}</span>'
        cells.append(f'<div class="ws-box"><span class="ws-n">{n}</span>{body}</div>')
    return (f'```{{=html}}\n<div class="ws-grid" style="grid-template-columns: repeat({columns}, 1fr)">' +
            "".join(cells) + "</div>\n```\n")


def mixed_review_web(problems, answers=False):
    """Cards as Markdown (so $math$ works on the web page), shown on the web only."""
    lines = ['::: {.content-visible when-format="html"}', ":::: {.ws-cards}"]
    for n, p in enumerate(problems, 1):
        color = TOPIC_COLORS[(n - 1) % len(TOPIC_COLORS)]
        lines += ["::: {.ws-card}",
                  f'[[{n}]{{.ws-num}} [{p["topic"]}]{{.ws-tag style="background: {color}22; color: {color}"}}]{{.ws-head}}',
                  "", p["md"], ""]
        if answers:
            lines += [f'[{html.escape(p["answer"]).replace("$", "\\$")}]{{.ws-ans}}', ""]
        lines.append(":::")
    lines += ["::::", ":::", ""]
    return "\n".join(lines)
