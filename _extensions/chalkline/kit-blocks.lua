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
--   ::: {.page-about name="Venn diagram" uses="comparing two things; before a compare paragraph"}   a hidden note

local M = {}

local function typst(s) return pandoc.RawBlock("typst", s) end
local function str(s) return '"' .. tostring(s):gsub('\\', '\\\\'):gsub('"', '\\"') .. '"' end
local function content(blocks)   -- pandoc blocks -> Typst [content]
  local out = pandoc.write(pandoc.Pandoc(blocks), "typst")
  return "[" .. out:gsub("%s+$", "") .. "]"
end
local function inline_content(inlines)
  return content({ pandoc.Plain(inlines) })
end
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
local function tuple(list, f)
  local parts = {}
  for _, x in ipairs(list) do table.insert(parts, f(x)) end
  return "(" .. table.concat(parts, ", ") .. (#parts == 1 and "," or "") .. ")"
end

-- ---------------------------------------------------------------- the PDF: each block as a kit call
local TYPST = {}
TYPST["work-space"] = function(el)
  local a = el.attributes
  return { typst("#kit.work-space(height: " .. length(a.height) .. ", style: " .. str(a.style or "blank") ..
    (a.label and (", label: " .. str(a.label)) or "") .. ")") }
end
TYPST["side-by-side"] = function(el)
  local cols, cells = {}, {}
  for _, b in ipairs(el.content) do
    table.insert(cols, "1fr")
    table.insert(cells, content({ b }))
  end
  return { typst("#grid(columns: (" .. table.concat(cols, ", ") .. "), column-gutter: 5mm, " .. table.concat(cells, ", ") .. ")") }
end
TYPST["problems"] = function(el)
  local list = tuple(items(el), function(p)
    return "(" .. inline_content(p[1]) .. ", " .. (p[2] and inline_content(p[2]) or "none") .. ", " .. (p[3] and inline_content(p[3]) or "none") .. ")"
  end)
  return { typst("#kit.problems(cols: " .. (tonumber(el.attributes.cols) or 2) .. ", surface-style: " .. str(el.attributes.style or "grid") ..
    ", answer: " .. str(el.attributes.answer or "x =") .. ", items: " .. list .. ")") }
end
TYPST["recall"] = function(el)
  local list = tuple(items(el), function(p)
    return "(" .. inline_content(p[1]) .. ", " .. (p[2] and inline_content(p[2]) or "none") .. ")"
  end)
  return { typst("#kit.recall(lines: " .. (tonumber(el.attributes.lines) or 2) .. ", " .. list .. ")") }
end
TYPST["sequence"] = function(el)
  local list = tuple(items(el), function(p) return inline_content(p[1]) end)
  local order = el.attributes.order and ("(" .. el.attributes.order .. ",)") or "none"
  return { typst("#kit.sequence(order: " .. order .. ", " .. list .. ")") }
end
TYPST["vocab-hunt"] = function(el)
  local list = tuple(items(el), function(p)
    local where = p[1] and pandoc.utils.stringify(p[1]) or ""
    return "(" .. str(where) .. ", none, " .. (p[2] and inline_content(p[2]) or "[]") .. (p[3] and (", " .. str(pandoc.utils.stringify(p[3]))) or "") .. ")"
  end)
  return { typst("#kit.vocab-hunt(" .. list .. ")") }
end
TYPST["kwl"] = function(el)
  local a = el.attributes
  return { typst("#org.kwl-landscape(" .. str(a.title or "KWL") .. ", [" .. (a.topic or "") .. "], k-example: [" .. (a["k-example"] or "") ..
    "], w-example: [" .. (a["w-example"] or "") .. "], l-example: [" .. (a["l-example"] or "") .. "])") }
end
TYPST["venn"] = function(el)
  local a = el.attributes
  return { typst("#org.venn-landscape(" .. str(a.title or "Compare") .. ", " .. str(a.a or "A") .. ", " .. str(a.b or "B") ..
    ", a-example: [" .. (a["a-example"] or "") .. "], both-example: [" .. (a["both-example"] or "") .. "], b-example: [" .. (a["b-example"] or "") ..
    "], prompt: " .. content(el.content) .. ")") }
end
TYPST["frayer"] = function(el)
  return { typst("#org.frayer(" .. str(el.attributes.id or "") .. ")") }
end
TYPST["cause-effect"] = function(el)
  local a = el.attributes
  return { typst("#org.cause-effect([" .. (a.event or "") .. "], cause-example: [" .. (a["cause-example"] or "") ..
    "], effect-example: [" .. (a["effect-example"] or "") .. "], prompt: " .. content(el.content) .. ")") }
end
TYPST["flow"] = function(el)
  return { typst("#org.flow(example: [" .. (el.attributes.example or "") .. "], prompt: " .. content(el.content) .. ")") }
end
TYPST["web"] = function(el)
  local a = el.attributes
  return { typst("#org.web([" .. (a.topic or "") .. "], " .. tuple(csv(a.branches), str) .. (a.example and (", example: [" .. a.example .. "]") or "") .. ")") }
end
TYPST["temple"] = function(el)
  local a = el.attributes
  return { typst("#org.temple(main-example: [" .. (a["main-example"] or "") .. "], detail-example: [" .. (a["detail-example"] or "") .. "])") }
end
TYPST["investigation"] = function(el)
  local a = el.attributes
  local connect = #el.content > 0 and content(el.content) or "none"
  return { typst("#hist.investigation(" .. str(a.letter or "A") .. ", " .. tuple(csv(a.sources), str) .. ", connect: " .. connect .. ")") }
end
TYPST["page-about"] = function(el)
  local a = el.attributes
  return { typst("#kit.about(" .. str(a.name or "") .. ", uses: " .. tuple(csv(a.uses), str) .. ", pieces: " .. tuple(csv(a.pieces), str) .. ")") }
end

-- ---------------------------------------------------------------- the web: words, without the answers
local PRINT_ONLY = { kwl = true, venn = true, frayer = true, ["cause-effect"] = true, flow = true, web = true, temple = true,
  ["work-space"] = true, investigation = true }
local NAMES = { kwl = "KWL chart", venn = "Venn diagram", frayer = "Frayer model", ["cause-effect"] = "causes and effects",
  flow = "process flow", web = "concept web", temple = "main idea and details", ["work-space"] = "space to write or draw",
  investigation = "source investigation" }
local function web(el, cls)
  if cls == "page-about" or cls == "work-space" then return {} end   -- (nothing to show on a web page)
  if cls == "side-by-side" then return nil end   -- the blocks inside show one after another
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
  if quarto.doc.is_format("typst") then return TYPST[cls](el) end
  if quarto.doc.is_format("html") then return web(el, cls) end
  return nil
end

return M
