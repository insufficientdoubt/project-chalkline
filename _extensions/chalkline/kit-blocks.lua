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
local PRINT_ONLY = { kwl = true, venn = true, frayer = true, ["cause-effect"] = true, flow = true, web = true, temple = true,
  ["work-space"] = true, investigation = true }
local NAMES = { kwl = "KWL chart", venn = "Venn diagram", frayer = "Frayer model", ["cause-effect"] = "causes and effects",
  flow = "process flow", web = "concept web", temple = "main idea and details", ["work-space"] = "space to write or draw",
  investigation = "source investigation" }
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
  if PRINT_ONLY[cls] then
    local note = pandoc.Div({ pandoc.Para({ pandoc.Emph({ pandoc.Str("On paper: a " .. NAMES[cls] .. ". Use the PDF version of this page.") }) }) },
      pandoc.Attr("", { "kit-print-only" }))
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
    if cls == "venn" or cls == "kwl" or cls == "spread" or cls == "page-about" then return TYPST[cls](el) end   -- (no #block: a page break may follow)
    return { pandoc.Div(TYPST[cls](el)) }
  end
  if quarto.doc.is_format("html") then return web(el, cls) end
  return nil
end

return M
