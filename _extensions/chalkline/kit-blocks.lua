-- The packet kit's pieces as blocks you write in a printable's .qmd (loaded by filter.lua).
-- In the PDF each block becomes a call to the kit (typst/packet/); on the web it shows its words, and the
-- layout-only ones say the page is laid out for print. Answers (after " | ") print only in the teacher edition.
--
--   ::: {.work-space height="5cm" style="lines" label="Draw it here"}     (height="fill": the rest of the page)
--   :::
--   ::: side-by-side                    two (or three) blocks next to each other: half-width work spaces
--   ::: {.problems cols="2"}            - $3x + 5 = 20$ | 5 | 3x = 15, x = 5      (problem | answer | working)
--   ::: recall                          - Why did Rome need roads? | To move soldiers quickly.
--   ::: {.sequence order="3,1,2"}       - an event, one per line, in the order printed
--   ::: vocab-hunt                      - ¶2 | **un-** _adj._ not able to stay away | unavoidable   (where | clue | word)
--   ::: {.kwl title="Before you read" topic="The Colosseum"}
--   ::: {.venn title="Compare" a="Greek cities" b="Roman cities"}   the "So what?" question inside
--   ::: {.frayer id="ROM-011"}          the word and 中文 from the vocab list; two fit on a page
--   ::: {.cause-effect event="Rome builds aqueducts"}               the "So what?" question inside
--   ::: flow                            the "So what?" question inside
--   ::: {.web topic="Roman engineering" branches="roads, water, buildings, tools, people, problems"}
--   ::: temple
--   ::: {.investigation letter="A" sources="Stele of Hammurabi, Burney Relief"}   (connect question inside, B only)
--   ::: {.picture-answers cols="3"}    - ![](images/a.svg) A | acute      (picture and label | answer)
--   ::: true-false                      - A straight angle is just a line. | F
--   ::: {.panel title="Word bank"}      a box with a title (anything inside)
--   ::: spread                          (empty) in a packet: start this page on a left-hand page (a two-page spread)
--   ::: {.source-card …}  ::: {.test-head …}  ::: short-answer  ::: rubric  ::: command-term  ::: paragraph-chain
--   ::: writing-lines  ::: design-artifact  ::: subunit       history and assessment pages (see each one below)
--   ::: {.page-about name="Venn diagram" uses="comparing two things; before a compare paragraph"}   a hidden note

local M = {}

local function typst(s) return pandoc.RawBlock("typst", s) end
local function str(s) return '"' .. tostring(s):gsub('\\', '\\\\'):gsub('"', '\\"') .. '"' end
local function length(v)        -- "5cm", "40mm", "1.5in" pass; "fill"/"auto" -> auto
  if not v or v == "" or v == "fill" or v == "auto" then return "auto" end
  if v:match("^[%d%.]+%a+$") then return v end
  return "auto"
end

-- a list's items, each split at " | " into parts (pandoc inlines)
local function items(div)
  local out = {}
  for _, b in ipairs(div.content) do
    if b.t == "BulletList" or b.t == "OrderedList" then
      for _, item in ipairs(b.content) do
        local inl = pandoc.List()
        for _, blk in ipairs(item) do
          if blk.content then inl:extend(blk.content) end
        end
        local parts, cur = {}, pandoc.List()
        for _, x in ipairs(inl) do
          if x.t == "Str" and x.text == "|" then
            while #cur > 0 and (cur[#cur].t == "Space") do cur:remove() end
            table.insert(parts, cur); cur = pandoc.List()
          elseif not (#cur == 0 and x.t == "Space") then
            cur:insert(x)
          end
        end
        table.insert(parts, cur)
        table.insert(out, parts)
      end
    end
  end
  return out
end
local function non_list(div)    -- the div's blocks that aren't the list (a question, an instruction)
  local out = pandoc.List()
  for _, b in ipairs(div.content) do
    if b.t ~= "BulletList" and b.t ~= "OrderedList" then out:insert(b) end
  end
  return out
end
local function csv(v)
  local out = {}
  for p in (v or ""):gmatch("[^,;]+") do table.insert(out, (p:gsub("^%s+", ""):gsub("%s+$", ""))) end
  return out
end

-- ---------------------------------------------------------------- the PDF: each block as a kit call
-- The words stay pandoc content (so shortcodes and spans inside them are still processed by Quarto); only
-- the call around them is raw Typst. Inline pieces: a list of inlines mixing raw Typst and the words.
local function R(s) return pandoc.RawInline("typst", s) end
local function frag(...)                 -- strings (raw Typst) and inline lists, joined into one list
  local out = pandoc.List()
  for _, x in ipairs({ ... }) do
    if type(x) == "string" then out:insert(R(x)) else out:extend(x) end
  end
  return out
end
local function C(inl)                    -- inlines as Typst [content]
  if inl == nil then return frag("none") end
  return frag("[", inl, "]")
end
local function seq(list, f)              -- (a, b, c,) from a list, each item through f
  local out = frag("(")
  for k, x in ipairs(list) do
    if k > 1 then out:insert(R(", ")) end
    out:extend(f(x))
  end
  out:insert(R(#list == 1 and ",)" or ")"))
  return out
end
local function call(inl) return { pandoc.Plain(inl) } end
-- a call whose last argument is the div's blocks: open ... blocks ... close
local function wrap(open, blocks, close)
  local out = pandoc.List({ typst(open) })
  out:extend(blocks)
  out:insert(typst(close or "])"))
  return out
end

local TYPST = {}
local WHOLE   -- the blocks not wrapped in a #block (set below)
TYPST["work-space"] = function(el)
  local a = el.attributes
  return { typst("#kit.work-space(height: " .. length(a.height) .. ", style: " .. str(a.style or "blank") ..
    (a.label and (", label: " .. str(a.label)) or "") .. ")") }
end
TYPST["side-by-side"] = function(el)
  local cols = {}
  for _ in ipairs(el.content) do table.insert(cols, "1fr") end
  local out = pandoc.List({ typst("#grid(columns: (" .. table.concat(cols, ", ") .. "), column-gutter: 5mm, [") })
  for k, b in ipairs(el.content) do
    if k > 1 then out:insert(typst("], [")) end
    out:insert(b)
  end
  out:insert(typst("])"))
  return out
end
TYPST["problems"] = function(el)
  return call(frag("#kit.problems(cols: " .. (tonumber(el.attributes.cols) or 2) .. ", surface-style: " .. str(el.attributes.style or "grid") ..
    ", answer: " .. str(el.attributes.answer or "x =") .. ", items: ",
    seq(items(el), function(p) return frag("(", C(p[1]), ", ", C(p[2]), ", ", C(p[3]), ")") end), ")"))
end
TYPST["recall"] = function(el)
  return call(frag("#kit.recall(lines: " .. (tonumber(el.attributes.lines) or 2) .. ", ",
    seq(items(el), function(p) return frag("(", C(p[1]), ", ", C(p[2]), ")") end), ")"))
end
TYPST["sequence"] = function(el)
  local order = el.attributes.order and ("(" .. el.attributes.order .. ",)") or "none"
  return call(frag("#kit.sequence(order: " .. order .. ", ", seq(items(el), function(p) return C(p[1]) end), ")"))
end
TYPST["vocab-hunt"] = function(el)
  return call(frag("#kit.vocab-hunt(", seq(items(el), function(p)
    local where = p[1] and pandoc.utils.stringify(p[1]) or ""
    return frag("(" .. str(where) .. ", none, ", C(p[2] or pandoc.List()), p[3] and (", " .. str(pandoc.utils.stringify(p[3]))) or "", ")")
  end), ")"))
end
TYPST["picture-answers"] = function(el)   -- - ![](images/a.svg) A | acute
  return call(frag("#kit.picture-answers(cols: " .. (tonumber(el.attributes.cols) or 3) .. ", height: " ..
    (length(el.attributes.height) == "auto" and "32mm" or length(el.attributes.height)) .. ", ",
    seq(items(el), function(p)
      local pic, label = nil, pandoc.List()
      for _, x in ipairs(p[1]) do if x.t == "Image" and not pic then pic = x.src elseif x.t ~= "Image" then label:insert(x) end end
      while #label > 0 and label[1].t == "Space" do label:remove(1) end
      local img = pic and ('[#image(' .. str(pic) .. ', height: 100%, fit: "contain")]') or "[]"
      return frag("(" .. img .. ", ", C(label), ", ", C(p[2]), ")")
    end), ")"))
end
TYPST["true-false"] = function(el)   -- - A straight angle is just a line. | F
  return call(frag("#kit.true-false(", seq(items(el), function(p) return frag("(", C(p[1]), ", ", C(p[2]), ")") end), ")"))
end
TYPST["self-check"] = function(el)   -- ::: {.self-check lesson="true"}, a list of "I can" lines
  local lesson = (el.attributes.lesson == "true") and ", lesson: true" or ""
  return call(frag("#kit.self-check(", seq(items(el), function(p) return C(p[1]) end), lesson .. ")"))
end
TYPST["panel"] = function(el)   -- ::: {.panel title="Word bank"}: a box with a title
  return wrap("#kit.panel(" .. (el.attributes.title and ("title: " .. str(el.attributes.title) .. ", ") or "") .. "[", el.content)
end
TYPST["kwl"] = function(el)
  local a = el.attributes
  return { typst("#org.kwl-landscape(" .. str(a.title or "KWL") .. ", [" .. (a.topic or "") .. "], k-example: [" .. (a["k-example"] or "") ..
    "], w-example: [" .. (a["w-example"] or "") .. "], l-example: [" .. (a["l-example"] or "") .. "])") }
end
TYPST["venn"] = function(el)
  local a = el.attributes
  return wrap("#org.venn-landscape(" .. str(a.title or "Compare") .. ", " .. str(a.a or "A") .. ", " .. str(a.b or "B") ..
    ", a-example: [" .. (a["a-example"] or "") .. "], both-example: [" .. (a["both-example"] or "") .. "], b-example: [" .. (a["b-example"] or "") ..
    "], prompt: [", el.content)
end
TYPST["frayer"] = function(el)
  return { typst("#org.frayer(" .. str(el.attributes.id or "") .. ")") }
end
TYPST["cause-effect"] = function(el)
  local a = el.attributes
  return wrap("#org.cause-effect([" .. (a.event or "") .. "], cause-example: [" .. (a["cause-example"] or "") ..
    "], effect-example: [" .. (a["effect-example"] or "") .. "], prompt: [", el.content)
end
TYPST["flow"] = function(el)
  return wrap("#org.flow(example: [" .. (el.attributes.example or "") .. "], prompt: [", el.content)
end
TYPST["web"] = function(el)
  local a = el.attributes
  local branches = {}
  for _, b in ipairs(csv(a.branches)) do table.insert(branches, str(b)) end
  return { typst("#org.web([" .. (a.topic or "") .. "], (" .. table.concat(branches, ", ") .. (#branches == 1 and "," or "") .. ")" ..
    (a.example and (", example: [" .. a.example .. "]") or "") .. ")") }
end
TYPST["temple"] = function(el)
  local a = el.attributes
  return { typst("#org.temple(main-example: [" .. (a["main-example"] or "") .. "], detail-example: [" .. (a["detail-example"] or "") .. "])") }
end
TYPST["investigation"] = function(el)
  local a = el.attributes
  local sources = {}
  for _, b in ipairs(csv(a.sources)) do table.insert(sources, str(b)) end
  local head = "#hist.investigation(" .. str(a.letter or "A") .. ", (" .. table.concat(sources, ", ") .. (#sources == 1 and "," or "") .. ")"
  if #el.content == 0 then return { typst(head .. ")") } end
  return wrap(head .. ", connect: [", el.content)
end
-- ---------------------------------------------------------------- history and assessment pages (typst/packet/history.typ)
local function has_cjk(inl) return pandoc.utils.stringify(inl):find("[\227-\233][\128-\191][\128-\191]") ~= nil end
local function blocks_of(div, cls)   -- the blocks of the first inner div with this class (or nil)
  for _, b in ipairs(div.content) do
    if b.t == "Div" and b.classes:includes(cls) then return b.content end
  end
  return nil
end
local function paras(blocks)         -- each paragraph's inlines
  local out = {}
  for _, b in ipairs(blocks or {}) do if b.t == "Para" or b.t == "Plain" then table.insert(out, b.content) end end
  return out
end
local function list_items(blocks)    -- items(), for a list given as blocks
  return items(pandoc.Div(blocks or {}))
end
local function nums(v)               -- "400, 30, 850, 590" -> { 400, 30, 850, 590 }
  local out = {}
  for n in (v or ""):gmatch("[%d%.]+") do table.insert(out, tonumber(n)) end
  return out
end
TYPST["subunit"] = function(el)   -- ::: {.subunit number="1.2" title="Investigating sources"}  (empty): a line in the contents
  return { typst("#kit.subunit(" .. str(el.attributes.number or "") .. ", " .. str(el.attributes.title or "") .. ")") }
end
-- ::: {.source-card number="1" region="Babylon" title="…" title-zh="…" size="1215x2000"
--       crop="400,30,850,590" markers="1: 760,175; 2: 612,330" whole="330,20,900,1960"}
-- inside: the picture (![](images/x.jpg){fig-alt="…"}; size= is its width x height in pixels, crop= the part to show,
-- markers= numbered dots on it, whole= a small picture of all of it), the caption (a paragraph), then ::: glance (- What | a stele), ::: look-closely (- Horned crown | 牛角冠 |
-- what it shows | 中文), ::: source-context (English, then 中文), ::: {.source-quote title="…"} (English, then 中文),
-- ::: source-cite (the citation, then the picture credit). Anything else (a panel) goes under the context.
-- Two crops: crop="a,b,c,d / e,f,g,h" and markers="… / …", stacked.
TYPST["source-card"] = function(el)
  local a = el.attributes
  -- the picture: the first image inside (written as ![](images/x.jpg), so Quarto fixes its path in a packet)
  local src
  local rest = pandoc.List()
  for _, b in ipairs(el.content) do
    local found
    if not src and (b.t == "Para" or b.t == "Plain" or b.t == "Figure") then
      pandoc.walk_block(b, { Image = function(img) found = found or img.src end })
    end
    if found then src = found else rest:insert(b) end
  end
  el = pandoc.Div(rest, el.attr)
  a = el.attributes
  a.picture = src or a.picture
  local W, H = (a.size or ""):match("(%d+)%s*[x×]%s*(%d+)")
  W, H = tonumber(W), tonumber(H)
  local function cropped(box, marks, width)
    local c = nums(box)
    local s = width / (c[3] - c[1])
    local img = pandoc.Image({}, a.picture, "", pandoc.Attr("", {}, { width = string.format("%.2fmm", W * s), height = string.format("%.2fmm", H * s) }))
    local ms = {}
    for n, x, y in (marks or ""):gmatch("(%d+)%s*:%s*([%d%.]+)%s*,%s*([%d%.]+)") do table.insert(ms, "(" .. n .. ", " .. x .. ", " .. y .. ")") end
    return frag("hist.crop-content([", { img }, "], " .. W .. ", " .. H .. ", " .. table.concat(c, ", ", 1, 4) .. ", width: " .. width .. "mm, markers: (" .. table.concat(ms, ", ") .. (#ms == 1 and "," or "") .. "))")
  end
  local picture
  if a.picture and W and a.crop then
    local crops, markers = {}, {}
    for c in a.crop:gmatch("[^/]+") do table.insert(crops, c) end
    for m in (a.markers or ""):gmatch("[^/]+") do table.insert(markers, m) end
    if #crops > 1 then
      picture = frag("stack(spacing: 2mm, ")
      for k, c in ipairs(crops) do picture:extend(cropped(c, markers[k], 84)); picture:insert(R(", ")) end
      picture:insert(R(")"))
    elseif a.whole then
      local w = nums(a.whole)
      local s = 15 / (w[3] - w[1])
      local img = pandoc.Image({}, a.picture, "", pandoc.Attr("", {}, { width = string.format("%.2fmm", W * s), height = string.format("%.2fmm", H * s) }))
      picture = frag("grid(columns: (1fr, 15mm), column-gutter: 3mm, align: bottom, ")
      picture:extend(cropped(crops[1], markers[1], 66))
      picture:extend(frag(", [#hist.crop-content([", { img }, "], " .. W .. ", " .. H .. ", " .. table.concat(w, ", ", 1, 4) .. ", width: 15mm) #text(size: 6.5pt)[the whole]])"))
    else
      picture = cropped(crops[1], markers[1], 84)
    end
  elseif a.picture then
    picture = frag("box(width: 84mm, [", { pandoc.Image({}, a.picture, "", pandoc.Attr("", {}, { width = "84mm" })) }, "])")
  end
  local caption
  local extra = pandoc.List()
  for _, b in ipairs(el.content) do
    if (b.t == "Para" or b.t == "Plain") and not caption then caption = b.content
    elseif not (b.t == "Div" and (b.classes:includes("glance") or b.classes:includes("look-closely") or b.classes:includes("source-context")
      or b.classes:includes("source-quote") or b.classes:includes("source-cite"))) then extra:insert(b) end
  end
  local out = frag("#hist.source-card(region: " .. str(a.region or "") .. ", number: " .. (tonumber(a.number) or 1) ..
    ", title: " .. str(a.title or "") .. ", title-zh: " .. str(a["title-zh"] or "") .. ", ")
  if picture then out:insert(R("picture: ")); out:extend(picture); out:insert(R(", ")) end
  if caption then out:extend(frag("caption: ", C(caption), ", ")) end
  out:extend(frag("glance: ", seq(list_items(blocks_of(el, "glance")), function(p) return frag("(", C(p[1]), ", ", C(p[2]), ")") end), ", "))
  local notes = list_items(blocks_of(el, "look-closely"))
  local k = 0   -- the notes are numbered 1, 2, 3, like the markers on the picture
  out:extend(frag("notes: ", seq(notes, function(p) k = k + 1; return frag("(" .. k .. ", ", C(p[1]), ", ", C(p[2] or {}), ", ", C(p[3] or {}), ", ", C(p[4] or {}), ")") end), ", "))
  local ctx = paras(blocks_of(el, "source-context"))
  if ctx[1] then out:extend(frag("context-en: ", C(ctx[1]), ", ")) end
  if ctx[2] then out:extend(frag("context-zh: ", C(ctx[2]), ", ")) end
  local cite = paras(blocks_of(el, "source-cite"))
  if cite[1] then out:extend(frag("citation: ", C(cite[1]), ", ")) end
  if cite[2] then out:extend(frag("credit: ", C(cite[2]), ", ")) end
  local quote
  for _, b in ipairs(el.content) do if b.t == "Div" and b.classes:includes("source-quote") then quote = b end end
  if quote or #extra > 0 then
    out:insert(R("extra: ["))
    local blocks = { pandoc.Plain(out) }
    out = pandoc.List()
    if quote then
      local q = paras(quote.content)
      table.insert(blocks, pandoc.Plain(frag("#hist.quote-box(" .. str(quote.attributes.title or "") .. ", ", C(q[1]), ", ", C(q[2] or {}), ")")))
    end
    for _, b in ipairs(extra) do table.insert(blocks, b) end
    table.insert(blocks, typst("])"))
    return blocks
  end
  out:insert(R(")"))
  return { pandoc.Plain(out) }
end
-- ::: {.test-head title="Early river civilizations" unit="Section 1: …" total="25" minutes="40"}  the instructions inside
TYPST["test-head"] = function(el)
  local a = el.attributes
  return wrap("#hist.assessment-head(" .. str(a.title or "") .. ", " .. str(a.unit or "") .. ", minutes: " .. (tonumber(a.minutes) or 40) ..
    ", total: " .. (tonumber(a.total) or 25) .. ", instructions: [", el.content)
end
-- ::: {.short-answer start="1"}   - [2] What does … mean? | 这是什么意思？ | The answer.   ([2/1]: 2 marks, 1 line)
TYPST["short-answer"] = function(el)
  local n = (tonumber(el.attributes.start) or 1) - 1
  local out = pandoc.List()
  for _, p in ipairs(items(el)) do
    n = n + 1
    local q = p[1]
    local m, lines = 2, "auto"
    if q[1] and q[1].t == "Str" then
      local mm, ll = q[1].text:match("^%[(%d+)/?(%d*)%]$")
      if mm then
        m = tonumber(mm); if ll ~= "" then lines = ll end
        q = pandoc.List(q); q:remove(1); if q[1] and q[1].t == "Space" then q:remove(1) end
      end
    end
    local zh, answer = {}, nil
    if p[2] and has_cjk(p[2]) then zh = p[2]; answer = p[3] else answer = p[2] end
    out:insert(pandoc.Plain(frag("#hist.short-answer(" .. n .. ", ", C(q), ", ", C(zh), ", " .. m .. ", lines: " .. lines ..
      (answer and #answer > 0 and ", answer: " or ""), (answer and #answer > 0) and C(answer) or {}, ")")))
  end
  return out
end
-- ::: {.rubric term="explain" criterion="Criterion A: what each level looks like"}   - 1–2 | what it looks like | an example | target
TYPST["rubric"] = function(el)
  local a = el.attributes
  return call(frag("#hist.rubric(" .. str(a.term or "") .. ", " .. str(a.criterion or "") .. ", ",
    seq(items(el), function(p)
      local target = p[4] and pandoc.utils.stringify(p[4]):lower() == "target"
      return frag("(", C(p[1]), ", ", C(p[2]), ", ", C(p[3] or {}), target and ", true)" or ")")
    end), ")"))
end
-- ::: {.command-term term="explain" zh="解释"}   what it means inside
TYPST["command-term"] = function(el)
  return wrap("#hist.command-term(" .. str(el.attributes.term or "") .. ", " .. str(el.attributes.zh or "") .. ", [", el.content)
end
-- ::: paragraph-chain   - The challenge | floods? drought?
TYPST["paragraph-chain"] = function(el)
  return call(frag("#hist.paragraph-chain(", seq(items(el), function(p) return frag("(", C(p[1]), ", ", C(p[2] or {}), ")") end), ")"))
end
-- ::: {.writing-lines lines="13"}   (empty) lines for a paragraph, with circles to tick each sentence
TYPST["writing-lines"] = function(el)
  return { typst("#hist.writing-lines(n: " .. (tonumber(el.attributes.lines) or 14) .. ")") }
end
-- ::: design-artifact   (empty) the design-your-own-artifact page
TYPST["design-artifact"] = function(el) return { typst("#hist.design-artifact()") } end
TYPST["spread"] = function(el)   -- ::: spread  (empty): in a packet, the next page is a left-hand page
  local out = pandoc.List({ typst("#kit.spread-start()") })
  out:extend(el.content)
  return out
end
TYPST["page-about"] = function(el)
  local a = el.attributes
  local function list(v) local o = {} for _, x in ipairs(csv(v)) do table.insert(o, str(x)) end return "(" .. table.concat(o, ", ") .. (#o == 1 and "," or "") .. ")" end
  return { typst("#kit.about(" .. str(a.name or "") .. ", uses: " .. list(a.uses) .. ", pieces: " .. list(a.pieces) .. ")") }
end

-- ---------------------------------------------------------------- the web: words, without the answers
local SHOWN_PDF = false
local PRINT_ONLY = { ["source-card"] = true, ["design-artifact"] = true, kwl = true, venn = true, frayer = true, ["cause-effect"] = true, flow = true, web = true, temple = true,
  ["work-space"] = true, investigation = true }
local NAMES = { kwl = "KWL chart", venn = "Venn diagram", frayer = "Frayer model", ["cause-effect"] = "causes and effects",
  flow = "process flow", web = "concept web", temple = "main idea and details", ["work-space"] = "space to write or draw",
  investigation = "source investigation", ["source-card"] = "source card", ["design-artifact"] = "design challenge" }
-- The PDF viewer (pdf-viewer/), for a page's own PDF: the same markup as {{< pdf-viewer >}}, which tries the
-- student copy first (on the teacher site) and has pens to write on the page.
local function pdf_viewer(file, title)
  quarto.doc.add_html_dependency({
    name = "pdf-viewer", version = "1.0.0",
    scripts = { { path = "pdf-viewer/pdf-viewer.js", attribs = { type = "module" }, afterBody = true } },
    stylesheets = { "pdf-viewer/pdf-viewer.css" },
    resources = { "pdf-viewer/pdf.min.mjs", "pdf-viewer/pdf.worker.min.mjs", "pdf-viewer/pdf-lib.esm.min.js" },
  })
  local function esc(x) return (x:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")) end
  local student = file:gsub("%.pdf$", "-student.pdf")
  return pandoc.RawBlock("html", '<div class="pdfv pdfv-viewer" data-src="' .. esc(file) .. '" data-title="' .. esc(title) ..
    '" data-layout="viewer" data-page="1" data-prefer="' .. esc(student) .. '" data-ink="true" data-prevent-swipe data-pending style="height:640px">' ..
    '<a class="pdfv-fallback" href="' .. esc(file) .. '">📄 ' .. esc(title) .. ' (PDF)</a></div>')
end
local function frag_web(a, sep, b)   -- inlines a, a separator, inlines b
  local out = pandoc.List(a or {})
  out:insert(pandoc.Str(sep)); out:extend(b or {})
  return out
end
local function web(el, cls)
  if cls == "page-about" or cls == "work-space" then return {} end   -- (nothing to show on a web page)
  if cls == "side-by-side" then return nil end
  if cls == "spread" then return el.content end
  if cls == "panel" then
    local out = pandoc.List()
    if el.attributes.title then out:insert(pandoc.Para({ pandoc.Strong({ pandoc.Str(el.attributes.title) }) })) end
    out:extend(el.content)
    return { pandoc.Div(out, pandoc.Attr("", { "kit-block", "kit-panel", "callout-note" })) }
  end
  if cls == "picture-answers" then
    local cells = pandoc.List()
    for _, p in ipairs(items(el)) do cells:insert(pandoc.Div({ pandoc.Plain(p[1]) }, pandoc.Attr("", { "kit-pic" }))) end
    return { pandoc.Div(cells, pandoc.Attr("", { "kit-block", "kit-picture-answers" }, { style = "display:grid; grid-template-columns: repeat(" .. (tonumber(el.attributes.cols) or 3) .. ", 1fr); gap: 1rem" })) }
  end   -- the blocks inside show one after another
  if cls == "subunit" or cls == "writing-lines" then return {} end
  if cls == "test-head" then
    local out = pandoc.List({ pandoc.Para({ pandoc.Strong({ pandoc.Str(el.attributes.title or "") }), pandoc.Space(),
      pandoc.Str("(" .. (el.attributes.total or "25") .. " marks)") }) })
    out:extend(el.content)
    return { pandoc.Div(out, pandoc.Attr("", { "kit-block", "callout-note" })) }
  end
  if cls == "command-term" then
    local out = pandoc.List({ pandoc.Para({ pandoc.Strong({ pandoc.Str((el.attributes.term or ""):upper() .. " " .. (el.attributes.zh or "")) }) }) })
    out:extend(el.content)
    return { pandoc.Div(out, pandoc.Attr("", { "kit-block", "callout-tip" })) }
  end
  if cls == "short-answer" then   -- the questions (with 中文), their marks; no answers
    local list = {}
    for _, p in ipairs(items(el)) do
      local q = pandoc.List(p[1])
      local first = q[1] and q[1].t == "Str" and q[1].text:match("^%[(%d+)/?%d*%]$")
      if first then q:remove(1); if q[1] and q[1].t == "Space" then q:remove(1) end end
      if p[2] and has_cjk(p[2]) then q:insert(pandoc.LineBreak()); q:insert(pandoc.Span(p[2], pandoc.Attr("", { "zh" }))) end
      if first then q:insert(pandoc.Space()); q:insert(pandoc.Str("[" .. first .. "]")) end
      table.insert(list, { pandoc.Plain(q) })
    end
    return { pandoc.Div({ pandoc.OrderedList(list, pandoc.ListAttributes(tonumber(el.attributes.start) or 1)) }, pandoc.Attr("", { "kit-block" })) }
  end
  if cls == "rubric" then
    local rows = {}
    for _, p in ipairs(items(el)) do
      table.insert(rows, { pandoc.Plain(frag_web(p[1], ": ", p[2])) })
    end
    return { pandoc.Div({ pandoc.Para({ pandoc.Strong({ pandoc.Str(el.attributes.criterion or "Rubric") }) }), pandoc.BulletList(rows) }, pandoc.Attr("", { "kit-block" })) }
  end
  if PRINT_ONLY[cls] then
    -- the page's own PDF (made by the same render; on the teacher site, its student copy)
    local pdf = quarto.doc.input_file and (pandoc.path.split_extension(pandoc.path.filename(quarto.doc.input_file)) .. ".pdf")
    if pdf and (cls == "venn" or cls == "kwl" or cls == "source-card" or cls == "design-artifact") then
      if SHOWN_PDF then return {} end   -- (once a page: the viewer shows all its pages)
      SHOWN_PDF = true
      -- a whole-page organizer: the page itself, in the PDF viewer, with pens to write on it
      local viewer = pdf_viewer(pdf, el.attributes.title or NAMES[cls])
      local note = pandoc.Para({ pandoc.Emph({ pandoc.Str("This page is a " .. NAMES[cls] .. " on paper. Write on it here with the pens, or print it.") }) })
      return { pandoc.Div({ note, viewer }, pandoc.Attr("", { "kit-print-only" })) }
    end
    local said = { pandoc.Str("On paper: a " .. NAMES[cls] .. ". ") }
    if pdf then said[#said + 1] = pandoc.Link({ pandoc.Str("Use the PDF version of this page.") }, pdf)
    else said[#said + 1] = pandoc.Str("Use the PDF version of this page.") end
    local note = pandoc.Div({ pandoc.Para({ pandoc.Emph(said) }) }, pandoc.Attr("", { "kit-print-only" }))
    if #el.content > 0 and cls ~= "work-space" then note.content:extend(el.content) end
    return { note }
  end
  -- lists: keep the first part of each item (the question, the problem, the event); answers stay off the web
  local out = non_list(el)
  local list = {}
  for _, p in ipairs(items(el)) do
    local first = (cls == "vocab-hunt") and (p[2] or p[1]) or p[1]
    table.insert(list, { pandoc.Plain(first) })
  end
  if #list > 0 then
    if cls == "sequence" then out:insert(pandoc.BulletList(list)) else out:insert(pandoc.OrderedList(list)) end
  end
  return { pandoc.Div(out, pandoc.Attr("", { "kit-block", "kit-" .. cls })) }
end

WHOLE = { venn = true, kwl = true, spread = true, ["page-about"] = true, subunit = true, ["source-card"] = true,
  ["design-artifact"] = true, investigation = true, ["test-head"] = true, ["short-answer"] = true }

function M.handles(el)
  for cls in pairs(TYPST) do
    if el.classes:includes(cls) then return cls end
  end
  return nil
end

function M.render(el, cls)
  if quarto.doc.is_format("revealjs") then return nil end   -- slides have their own pieces
  -- one Div around each block's output, so a block inside another (a panel in side-by-side) stays one piece.
  -- Not the whole-page ones (they break the page, which Typst doesn't allow inside the Div's block).
  if quarto.doc.is_format("typst") then
    if WHOLE[cls] then return TYPST[cls](el) end   -- (no #block: a page break may follow, or v(1fr) fills the page)
    return { pandoc.Div(TYPST[cls](el)) }
  end
  if quarto.doc.is_format("html") then return web(el, cls) end
  return nil
end

return M
