--[[
Classroom shortcodes. Content files use these plain markers; this file decides
what each one becomes in each output format (slides, web page, PDF, Word).

  {{< lines 3 >}}                        ruled writing lines (gap="0.4in" optional)
  {{< drawing-box label="Side view" >}}  dot-grid drawing area (height="3in" optional;
                                         default fills the rest of the PDF page)
  {{< blank 1.5in >}}                    a fill-in line inside a sentence or heading
  {{< lesson-nav >}}                     on a lesson page: its strand, time, "before this" and "next up"
                                         links (from generated/lessons.json, made by scripts/lessons.py)
  {{< timer 20 >}}                       countdown timer for slides (minutes)
  {{< objectives >}}                     the page's `objectives:` list, as bullets
  {{< pdf "scoring-sheet.pdf" >}}        an outside PDF, next to this file ("/course/..." = from the
                                         project root). In the PDF output its pages
                                         go in as full pages (pages="2-3" picks some); on the web, a
                                         download link and a viewer. Page counts come from
                                         generated/pdf-pages.json (scripts/catalog.py).
  {{< packet >}}                         on a unit page: a download link for the unit packet (all its
                                         printables in one PDF, made by scripts/packets.py). The teacher
                                         site shows two: the teacher edition and the student copy.
                                         Nothing if the unit has no printables.
  {{< vocab "democracy" >}}              a vocab word; hovering shows its vocab card (picture, 中文,
                                         definition, link). Name a term, an "also called" name or an
                                         ID (GRC-003). text="democratic" changes the words shown;
                                         zh=true also prints the 中文 after the word in PDF/Word
                                         (for reference sheets; leave it off on quizzes).
                                         Terms come from vocab/data/vocab.csv
                                         (via scripts/vocab_terms.py). PDF/Word: the word in bold.
  {{< frames "FRM-014, FRM-015" >}}      language points (vocab/data/frames.csv): grammar, phrases,
  {{< frames unit=5 >}}                  stems, frames, questions, each in its own look, grouped and
                                         labelled when mixed. Pick IDs for one lesson, or unit=5 for a
                                         unit's (general=true adds the all-year ones); kind= and
                                         function= filter. 中文 under each line on slides; in PDF/Word
                                         with zh=true (not on quizzes). Questions are formats, shown with
                                         a worked example (examples=false hides it). answers=false, labels=false,
                                         group=false (in the order written).
  {{< frame "FRM-014" >}}                one frame, in the line, in the plain frame look (in a box,
                                         a grid, a table); its 中文 under it (zh=true in PDFs).

  {{< snowman >}}                        slide games (slides only). A random word from the vocab
  {{< picture-reveal >}}                 list, with 🔀 for a new one; unit=1 for one unit's words;
  {{< jeopardy unit=1 >}}                or name a word: {{< snowman "democracy" >}}. Your own
  {{< trivia unit=1 >}}                  word: {{< snowman "Parthenon" hint="..." image="..." >}}.
                                         Your own Jeopardy and quick-fire questions: a ::: div
                                         (see filter.lua). Options: tiles=16 (picture-reveal),
                                         rows=4 teams=2 (jeopardy), count=5 seconds=10 title="..." (trivia).
                                         Any game: words="angle, vertex, side" for these words (a lesson's).
  {{< matching unit=1 >}}                pairs: tap a word, then its meaning (with="picture": its picture)
  {{< memory unit=1 >}}                  pairs: turn over two cards (a word and its picture, or with="meaning")
                                         count=6 pairs. Your own pairs: ::: {.matching} or {.memory} (filter.lua).
  {{< scramble unit=1 >}}                the letters of a word, mixed up (words as for snowman)
  {{< sort unit=1 >}}                    sort words into groups: their topics (one unit) or units
  {{< bingo unit=1 >}}                   bingo: make printable cards (PDF, in the browser), then call
  {{< blitz unit=1 >}}                   Word Blitz, like Kahoot for one player: a picture and four words
                                         (or a word and four pictures), streaks multiply, high scores
  {{< game-picker >}}                    the Review games page: choose any game and unit, and play.
                                         games="blitz,snowman" offers only those (the Play page).
  Games work on slides and on web pages (format: html); in PDFs and Word they're one line.
  {{< slide-wall >}}                     the All slides page: every unit's decks as rows of slide pictures
                                         (made by scripts/slide_pictures.py after a full build)

Quarto's built-in {{< pagebreak >}} also works everywhere.
]]

local function str(x, default)
  if x == nil then return default end
  local s = pandoc.utils.stringify(x)
  if s == "" then return default end
  return s
end

local function html_escape(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function typst_string(s)
  return '"' .. s:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

local included = {}
local function include_once(file)
  if included[file] then return end
  included[file] = true
  quarto.doc.include_file("after-body", quarto.utils.resolve_path(file))
end

-- Vocab terms, loaded once from generated/vocab-terms.json and looked up by ID, term or "also called" name.
local vocab_index, vocab_list, vocab_units
local function vocab_lookup(key)
  if not vocab_index then
    vocab_index, vocab_list, vocab_units = {}, {}, {}
    local path = (quarto.project.directory or ".") .. "/generated/vocab-terms.json"
    local f = io.open(path, "r")
    if not f then
      quarto.log.warning("vocab shortcode: can't read " .. path .. " (run scripts/vocab_terms.py)")
      return nil
    end
    local data = quarto.json.decode(f:read("a"))
    f:close()
    vocab_units = data.units or {}
    for _, t in ipairs(data.terms) do
      table.insert(vocab_list, t)
      for _, k in ipairs({ t.id, t.term, table.unpack(t.aka or {}) }) do
        local lk = k:lower()
        if vocab_index[lk] == nil then vocab_index[lk] = t end
      end
    end
  end
  return vocab_index[key:lower()]
end

-- Slide games (games/): settings for a game from its shortcode. Three ways to choose the words:
--   {{< snowman >}}                     a random word from the whole vocab list (🔀 gives a new one)
--   {{< snowman unit=1 >}}              a random word from unit 1's list (🔀 too)
--   {{< snowman "democracy" >}}         this vocab word: its picture and definition are the hint
--   {{< snowman "Parthenon" hint="A famous temple in Athens" image="images/parthenon.jpg" >}}
--                                       your own word (hint and image optional)
-- No 中文: games are review, and 中文 stays out of review materials.
local games = dofile(quarto.utils.resolve_path("games/games.lua"))

local function game_word(t, up)
  return { word = t.term, hint = t.definition, image = t.image ~= "" and (up .. t.image) or "", example = t.example or "",
           units = t.units or {}, topic = t.topic or "" }
end

local function game_config(args, kwargs, kind)
  local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
  local image = str(kwargs["image"], nil)
  if image and not image:match("^%a+://") then   -- so the picture is copied to the site (the path is from this file)
    quarto.doc.add_resource(pandoc.path.join({ pandoc.path.directory(quarto.doc.input_file), image }))
  end
  local word = str(args[1], nil)
  if word then
    local t = vocab_lookup(word)
    local w = t and game_word(t, up) or { word = word, hint = "", image = "", example = "" }
    w.hint = str(kwargs["hint"], w.hint)
    w.image = image or w.image
    if kind == "picture-reveal" and w.image == "" then
      quarto.log.warning(kind .. ' shortcode: "' .. word .. '" has no picture; add image="..."')
    end
    return { words = { w }, random = false }
  end
  vocab_lookup("")   -- loads the list
  -- words="angle, vertex, side": these words (a lesson's), instead of a unit's or the whole list
  local named = str(kwargs["words"], nil)
  if named then
    local words = {}
    for w in named:gmatch("[^,]+") do
      w = w:match("^%s*(.-)%s*$")
      local t = w ~= "" and vocab_lookup(w)
      if t then
        if kind ~= "picture-reveal" or t.image ~= "" then table.insert(words, game_word(t, up)) end
      elseif w ~= "" then quarto.log.warning(kind .. ' shortcode: "' .. w .. '" is not in vocab/data/vocab.csv') end
    end
    return { words = words, random = true, units = vocab_units, unit = nil, named = true }
  end
  local unit = tonumber(str(kwargs["unit"], ""))
  local words = {}
  for _, t in ipairs(vocab_list or {}) do
    local in_unit = not unit and not t.guide   -- the guide's own words only when named
    for _, u in ipairs(t.units or {}) do
      if u == unit then in_unit = true end
    end
    if in_unit and (kind ~= "picture-reveal" or t.image ~= "") then table.insert(words, game_word(t, up)) end
  end
  if #words == 0 then
    quarto.log.warning(kind .. " shortcode: no vocab words" .. (unit and (" for unit " .. unit) or "") ..
      " (is the unit's list in course/vocab/?)")
  end
  return { words = words, random = true, units = vocab_units, unit = unit }
end

-- Language points beyond vocabulary (vocab/data/frames.csv, read into generated/frames.json before each
-- render): grammar, phrases, sentence stems, frames and questions with answer frames.
--   {{< frames "FRM-014, FRM-015" >}}      these, in this order (one lesson's points)
--   {{< frames unit=5 >}}                  every point for unit 5 (general=true adds the all-year ones)
--   {{< frames function=compare >}}        or kind=grammar, or both; with unit= too; no filter: all of them
-- Each kind has its own look: grammar as a rule with examples, phrases as chips, stems and frames as
-- sentences with gaps (___ and … become write-on lines), questions with their answer frames under them
-- (answers=false hides them). A question is a format to practise (Can you give an example of ___?),
-- not a content question to memorise: its example (a worked use, "Q → A") shows under it as a model;
-- examples=false hides it, examples=true also shows the frames' and stems' examples. Mixed kinds are grouped, with a small label each (labels=false: none;
-- group=false: exactly in the order written). 中文: under each line on slides and web pages (the
-- language switch hides it); in PDFs only with zh=true, never on quizzes. zh=false: none anywhere.
local frames_index, frames_list
local function load_frames()
  if frames_list then return end
  frames_index, frames_list = {}, {}
  local path = (quarto.project.directory or ".") .. "/generated/frames.json"
  local f = io.open(path, "r")
  if not f then
    quarto.log.warning("frames shortcode: can't read " .. path .. " (run scripts/vocab_terms.py)")
    return
  end
  local data = quarto.json.decode(f:read("a"))
  f:close()
  for _, t in ipairs(data.frames or {}) do
    table.insert(frames_list, t)
    frames_index[t.id:upper()] = t
  end
end

-- {{< frame "FRM-014" >}}: one point, in the line, in the plain sentence-frame look ([…]{.bi .frame}):
-- the English with write-on gaps, its 中文 under it (the language switch hides it). For a frame inside a
-- box, a grid or a table, where {{< frames >}}' own strips and labels would be too much. In PDFs and Word
-- the 中文 only with zh=true. A question shows only its question (its answers: {{< frames >}}).
local function frame_inline(args, kwargs)
  load_frames()
  local id = str(args[1], ""):upper()
  local t = frames_index[id]
  if not t then
    quarto.log.warning('frame shortcode: "' .. id .. '" is not in vocab/data/frames.csv')
    return pandoc.Str(id)
  end
  local zh_opt = str(kwargs["zh"], "")
  if quarto.doc.is_format("html") then
    local function gaps(text)
      local e = html_escape(text)
      return (e:gsub("_+", '<span class="gap"></span>'):gsub("……", '<span class="gap"></span>'):gsub("…", '<span class="gap"></span>'))
    end
    if zh_opt ~= "false" and (t.zh or "") ~= "" then
      return pandoc.RawInline("html", '<span class="bil frame bil-stack"><span class="bil-en" lang="en">' .. gaps(t.en) ..
        '</span><span class="bil-zh" lang="zh">' .. gaps(t.zh) .. '</span></span>')
    end
    return pandoc.RawInline("html", '<span class="frame">' .. gaps(t.en) .. '</span>')
  end
  local typst = quarto.doc.is_format("typst")
  local function inl(text)
    local out = pandoc.Inlines({})
    local rest = text:gsub("……", "___"):gsub("…", "___")
    local i = 1
    while true do
      local a1, b1 = rest:find("_+", i)
      for chunk, sp in rest:sub(i, a1 and (a1 - 1) or -1):gmatch("([^ ]*)( ?)") do
        if chunk ~= "" then out:insert(pandoc.Str(chunk)) end
        if sp ~= "" then out:insert(pandoc.Space()) end
      end
      if not a1 then break end
      out:insert(typst and pandoc.RawInline("typst", "#blank(1.1in)") or pandoc.Str("________"))
      i = b1 + 1
    end
    return out
  end
  local out = inl(t.en)
  if zh_opt == "true" and (t.zh or "") ~= "" then out:insert(pandoc.LineBreak()); out:extend(inl(t.zh)) end
  return out
end

local FRAME_GROUPS = {   -- the order groups come in, and their labels
  { kinds = { grammar = true }, en = "Grammar", zh = "语法" },
  { kinds = { phrase = true }, en = "Phrases", zh = "短语" },
  { kinds = { stem = true, frame = true }, en = "Sentence frames", zh = "句型" },
  { kinds = { question = true }, en = "Questions and answers", zh = "问答" },
}

local function frames_shortcode(args, kwargs)
  load_frames()
  -- which points
  local ids = {}
  for _, a in ipairs(args) do
    for w in pandoc.utils.stringify(a):gmatch("[^,%s]+") do table.insert(ids, w:upper()) end
  end
  local function set_of(v)
    local out = nil
    for w in (v or ""):gmatch("[^,%s]+") do out = out or {}; out[w:lower()] = true end
    return out
  end
  local unit = tonumber(str(kwargs["unit"], ""))
  local kinds, funcs = set_of(str(kwargs["kind"], "")), set_of(str(kwargs["function"], ""))
  local general = str(kwargs["general"], "false") == "true"
  local items = {}
  if #ids > 0 then
    for _, id in ipairs(ids) do
      local t = frames_index[id]
      if t then table.insert(items, t) else quarto.log.warning('frames shortcode: "' .. id .. '" is not in vocab/data/frames.csv') end
    end
  else
    for _, t in ipairs(frames_list) do
      local ok = true
      if unit then
        local in_unit = general and #(t.units or {}) == 0
        for _, u in ipairs(t.units or {}) do if u == unit then in_unit = true end end
        ok = in_unit
      end
      if ok and kinds and not kinds[t.kind] then ok = false end
      if ok and funcs and not funcs[t["function"]] then ok = false end
      if ok then table.insert(items, t) end
    end
  end
  if #items == 0 then
    if #ids == 0 then quarto.log.warning("frames shortcode: no language points" .. (unit and (" for unit " .. unit) or "") .. " in vocab/data/frames.csv") end
    return pandoc.Null()
  end
  local html = quarto.doc.is_format("html")
  local zh_opt = str(kwargs["zh"], "")
  local with_zh = (zh_opt == "true") or (html and zh_opt ~= "false")
  local answers = str(kwargs["answers"], "true") ~= "false"
  local ex_opt = str(kwargs["examples"], "")
  local function show_example(t)   -- grammar and questions by default; frames and stems with examples=true
    if ex_opt == "false" then return false end
    if ex_opt == "true" then return true end
    return t.kind == "grammar" or t.kind == "question"
  end
  -- groups (or one list in the order written)
  local groups = {}
  if str(kwargs["group"], "true") == "false" then
    groups = { { label = nil, items = items } }
  else
    for _, g in ipairs(FRAME_GROUPS) do
      local list = {}
      for _, t in ipairs(items) do if g.kinds[t.kind] then table.insert(list, t) end end
      if #list > 0 then table.insert(groups, { label = g, items = list }) end
    end
  end
  local labels = str(kwargs["labels"], #groups > 1 and "true" or "false") == "true"

  if html then
    include_once("frames.html")
    local function gaps(text)   -- ___ and … become write-on lines
      local e = html_escape(text)
      e = e:gsub("_+", '<span class="gap"></span>'):gsub("……", '<span class="gap"></span>'):gsub("…", '<span class="gap"></span>')
      return e
    end
    local function bil(en, zh, cls)
      if with_zh and zh and zh ~= "" then
        return '<span class="bil bil-stack ' .. (cls or "") .. '"><span class="bil-en" lang="en">' .. gaps(en) ..
          '</span><span class="bil-zh" lang="zh">' .. gaps(zh) .. '</span></span>'
      end
      return '<span class="' .. (cls or "") .. '">' .. gaps(en) .. '</span>'
    end
    local out = { '<div class="lang-points">' }
    for _, g in ipairs(groups) do
      table.insert(out, '<div class="lp-group">')
      if labels and g.label then
        table.insert(out, '<p class="lp-label">' .. g.label.en .. (with_zh and (" · " .. g.label.zh) or "") .. "</p>")
      end
      local chips = {}
      for _, t in ipairs(g.items) do
        if t.kind == "phrase" then
          table.insert(chips, '<span class="lp-chip">' .. bil(t.en, t.zh) .. "</span>")
        else
          if #chips > 0 then table.insert(out, '<div class="lp-chips">' .. table.concat(chips) .. "</div>"); chips = {} end
          if t.kind == "grammar" then
            local ex = {}
            for _, e in ipairs(t.examples or {}) do table.insert(ex, html_escape(e)) end
            table.insert(out, '<div class="lp-item lp-grammar">' .. bil(t.en, t.zh, "lp-rule") ..
              (#ex > 0 and ('<span class="lp-examples">' .. table.concat(ex, " · ") .. "</span>") or "") .. "</div>")
          elseif t.kind == "question" then
            local a = {}
            if answers then
              for i, ans in ipairs(t.answers_en or {}) do
                table.insert(a, '<li>' .. bil(ans, (t.answers_zh or {})[i]) .. "</li>")
              end
            end
            local ex = (show_example(t) and (t.examples or {})[1]) and ('<span class="lp-model">e.g. ' .. html_escape(t.examples[1]) .. "</span>") or ""
            table.insert(out, '<div class="lp-item lp-question">' .. bil(t.en, t.zh, "lp-ask") ..
              (#a > 0 and ('<ul class="lp-answers">' .. table.concat(a) .. "</ul>") or "") .. ex .. "</div>")
          else
            local ex = (show_example(t) and (t.examples or {})[1]) and ('<span class="lp-model">e.g. ' .. html_escape(t.examples[1]) .. "</span>") or ""
            table.insert(out, '<div class="lp-item lp-' .. t.kind .. '">' .. bil(t.en, t.zh) .. ex .. "</div>")
          end
        end
      end
      if #chips > 0 then table.insert(out, '<div class="lp-chips">' .. table.concat(chips) .. "</div>") end
      table.insert(out, "</div>")
    end
    table.insert(out, "</div>")
    return pandoc.RawBlock("html", table.concat(out, "\n"))
  end

  -- PDF and Word: plain blocks; gaps are write-on lines in PDFs
  local typst = quarto.doc.is_format("typst")
  local function words(piece, inl)   -- plain text as inlines, keeping its spaces
    for chunk, sp in piece:gmatch("([^ ]*)( ?)") do
      if chunk ~= "" then inl:insert(pandoc.Str(chunk)) end
      if sp ~= "" then inl:insert(pandoc.Space()) end
    end
  end
  local function gap_inlines(text)   -- ___ and … become write-on lines
    local inl = pandoc.Inlines({})
    local rest = text:gsub("……", "___"):gsub("…", "___")
    local i = 1
    while true do
      local s1, e1 = rest:find("_+", i)
      words(rest:sub(i, s1 and (s1 - 1) or -1), inl)
      if not s1 then break end
      inl:insert(typst and pandoc.RawInline("typst", "#blank(1.1in)") or pandoc.Str("________"))
      i = e1 + 1
    end
    return inl
  end
  local function line(en, zh, strong)
    local inl = gap_inlines(en)
    if strong then inl = pandoc.Inlines({ pandoc.Strong(inl) }) end
    if with_zh and zh and zh ~= "" then
      inl:insert(pandoc.LineBreak()); inl:extend(gap_inlines(zh))
    end
    return inl
  end
  local blocks = pandoc.Blocks({})
  for _, g in ipairs(groups) do
    if labels and g.label then
      blocks:insert(pandoc.Para({ pandoc.Strong({ pandoc.Str(g.label.en .. (with_zh and (" · " .. g.label.zh) or "")) }) }))
    end
    local chips = pandoc.Inlines({})
    for _, t in ipairs(g.items) do
      if t.kind == "phrase" then
        if #chips > 0 then chips:insert(pandoc.Space()); chips:insert(pandoc.Str("·")); chips:insert(pandoc.Space()) end
        chips:insert(pandoc.Strong(gap_inlines(t.en)))   -- a phrase and its 中文 on one line
        if with_zh and t.zh and t.zh ~= "" then chips:insert(pandoc.Space()); chips:extend(gap_inlines(t.zh)) end
      else
        if #chips > 0 then blocks:insert(pandoc.Para(chips)); chips = pandoc.Inlines({}) end
        if t.kind == "grammar" then
          local inl = line(t.en, t.zh, true)
          if show_example(t) and #(t.examples or {}) > 0 then inl:insert(pandoc.LineBreak()); inl:insert(pandoc.Emph({ pandoc.Str(table.concat(t.examples, " · ")) })) end
          blocks:insert(pandoc.Para(inl))
        elseif t.kind == "question" then
          blocks:insert(pandoc.Para(line(t.en, t.zh, true)))
          if answers and #(t.answers_en or {}) > 0 then
            local li = {}
            for i, ans in ipairs(t.answers_en) do table.insert(li, { pandoc.Plain(line(ans, (t.answers_zh or {})[i])) }) end
            blocks:insert(pandoc.BulletList(li))
          end
          if show_example(t) and (t.examples or {})[1] then blocks:insert(pandoc.Para({ pandoc.Emph({ pandoc.Str("e.g. " .. t.examples[1]) }) })) end
        else
          blocks:insert(pandoc.Para(line(t.en, t.zh)))
          if show_example(t) and (t.examples or {})[1] then blocks:insert(pandoc.Para({ pandoc.Emph({ pandoc.Str("e.g. " .. t.examples[1]) }) })) end
        end
      end
    end
    if #chips > 0 then blocks:insert(pandoc.Para(chips)) end
  end
  return blocks
end

-- Outside PDFs: page counts from generated/pdf-pages.json, and paths from the project root.
local pdf_page_counts
local function pdf_pages(rel)
  if not pdf_page_counts then
    pdf_page_counts = {}
    local f = io.open((quarto.project.directory or ".") .. "/generated/pdf-pages.json", "r")
    if f then pdf_page_counts = quarto.json.decode(f:read("a")); f:close() end
  end
  return pdf_page_counts[rel]
end

-- "course/units/05-game-day/sheet.pdf" for "sheet.pdf" written in course/units/05-game-day/x.qmd
local function from_project_root(file)
  if file:sub(1, 1) == "/" then return file:sub(2) end   -- already from the project root
  local root = (quarto.project.directory or ""):gsub("\\", "/")
  local doc = (quarto.doc.input_file or ""):gsub("\\", "/")
  local dir = doc:sub(#root + 2):match("^(.*)/") or ""
  local path = (dir ~= "" and (dir .. "/") or "") .. file
  path = path:gsub("/%./", "/")
  while path:find("[^/]+/%.%./") do path = path:gsub("[^/]+/%.%./", "", 1) end
  return path
end

-- "2-3" or "1,4" -> {2, 3} / {1, 4}; nil -> every page
local function page_list(spec, count)
  local pages = {}
  if not spec then
    for i = 1, count do pages[#pages + 1] = i end
    return pages
  end
  for part in spec:gmatch("[^,]+") do
    local a, b = part:match("^%s*(%d+)%s*%-%s*(%d+)%s*$")
    if a then
      for i = tonumber(a), tonumber(b) do pages[#pages + 1] = i end
    elseif part:match("^%s*%d+%s*$") then
      pages[#pages + 1] = tonumber(part)
    end
  end
  return pages
end

-- Unit packets, loaded once from generated/packets.json (written by scripts/catalog.py).
local function packet_for_this_page()
  local f = io.open((quarto.project.directory or ".") .. "/generated/packets.json", "r")
  if not f then return nil end
  local packets = quarto.json.decode(f:read("a"))
  f:close()
  local unit = (quarto.doc.input_file or ""):match("units[/\\]([^/\\]+)[/\\]index%.qmd$")
  return unit and packets[unit]
end

-- Lesson links, loaded once from generated/lessons.json and looked up by source path.
local lesson_nav_data
local function lesson_info()
  if not lesson_nav_data then
    lesson_nav_data = {}
    local path = (quarto.project.directory or ".") .. "/generated/lessons.json"
    local f = io.open(path, "r")
    if not f then
      quarto.log.warning("lesson-nav shortcode: can't read " .. path .. " (run scripts/lessons.py)")
      return nil
    end
    lesson_nav_data = quarto.json.decode(f:read("a"))
    f:close()
  end
  local input = quarto.doc.input_file
  local dir = quarto.project.directory
  if dir and input:sub(1, #dir) == dir then input = input:sub(#dir + 2) end
  return lesson_nav_data[input]
end

local function lesson_links(list)
  local out = pandoc.Inlines({})
  for i, item in ipairs(list) do
    if i > 1 then out:insert(pandoc.Str(" · ")) end
    out:insert(pandoc.Link(item.title, "/" .. item.path))
  end
  return out
end

-- A vocab word's pop-up card (picture, word, 中文, meaning, read-aloud buttons, link to the vocab app),
-- used by {{< vocab >}} and {{< vocab-gallery >}}. Shows on hover, focus or tap (vocab-card.html).
local function vocab_card_html(t, meta)
  include_once("vocab-card.html")
  -- Picture and link paths are from the site root; add the "../" this page needs.
  local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
  local img = t.image ~= "" and ('<span class="vc-pic"><img src="' .. html_escape(up .. t.image) .. '" alt="" loading="lazy"></span>') or ""
  -- Line icons (Lucide, like the classroom tools'): a speaker, and an arrow for the link.
  local function svg(paths)
    return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' .. paths .. '</svg>'
  end
  local SPEAKER = svg('<path d="M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z"/><path d="M16 9a5 5 0 0 1 0 6"/><path d="M19.364 18.364a9 9 0 0 0 0-12.728"/>')
  local ARROW = svg('<path d="M7 7h10v10"/><path d="M7 17 17 7"/>')
  -- Speaker buttons read the word aloud (English, then 中文) with the computer's voices (vocab-card.html).
  local function say(text, lang, label)
    return '<button type="button" class="vc-say" data-lang="' .. lang .. '" data-say="' .. html_escape(text) ..
           '" aria-label="' .. label .. '" title="' .. label .. '">' .. SPEAKER .. '</button>'
  end
  local zh = t.zh ~= "" and ('<span class="vc-zh">' .. html_escape(t.zh) .. say(t.zh, "zh-CN", "Say it in Chinese") .. '</span>') or ""
  return '<span class="vocab-card" role="tooltip">' .. img ..
    '<span class="vc-term">' .. html_escape(t.term) .. say(t.term, "en-US", "Say it in English") .. '</span>' .. zh ..
    '<span class="vc-def">' .. html_escape(t.definition) .. '</span>' ..
    ((t.url or "") ~= "" and ('<a class="vc-link" href="' .. html_escape(up .. t.url) .. '" target="_blank" rel="noopener">' .. html_escape(str(meta and meta["vocab-title"], "Vocab")) .. ARROW .. '</a>') or "") ..
    '</span>'
end

-- {{< vocab-gallery "philosopher, empire, artifact" >}}: the words' pictures and names in a grid; click
-- (or Enter) opens a word's full card. A Cards | Table switch shows them as a table (picture, word,
-- 中文, meaning) instead. unit=1: every word in that unit. view="table": start as a table. The layout
-- follows the room it's given (vocab-gallery.html): as many columns as fit, in even rows; a vertical
-- list when it's narrow; bigger cards when it's wide. cols=4: at most 4 columns. zh=true: 中文 under
-- the words too; zh=false: no 中文 at all (the table and pop-ups have it otherwise). In PDF and Word: a table.
local function vocab_gallery(args, kwargs, meta)
  local names = {}
  for _, a in ipairs(args) do
    for w in pandoc.utils.stringify(a):gmatch("[^,]+") do
      w = w:match("^%s*(.-)%s*$")
      if w ~= "" then table.insert(names, w) end
    end
  end
  local terms = {}
  local unit = tonumber(str(kwargs["unit"], ""))
  if #names == 0 and unit then
    vocab_lookup("")   -- loads the list
    for _, t in ipairs(vocab_list) do
      for _, u in ipairs(t.units or {}) do if u == unit then table.insert(terms, t) break end end
    end
  else
    for _, w in ipairs(names) do
      local t = vocab_lookup(w)
      if t then table.insert(terms, t) else quarto.log.warning('vocab-gallery: "' .. w .. '" is not in vocab/data/vocab.csv') end
    end
  end
  if #terms == 0 then return pandoc.Null() end
  local zh = str(kwargs["zh"], "")          -- "" (the table only), "true" (cards too) or "false" (none)
  local with_zh = zh ~= "false"
  if not quarto.doc.is_format("html") then   -- print: a plain table
    local rows = { "| Word |" .. (with_zh and " 中文 |" or "") .. " Meaning |", "|:--|" .. (with_zh and ":--|" or "") .. ":--|" }
    for _, t in ipairs(terms) do
      table.insert(rows, "| **" .. t.term .. "** |" .. (with_zh and (" " .. t.zh .. " |") or "") .. " " .. t.definition:gsub("|", "\\|") .. " |")
    end
    return pandoc.read(table.concat(rows, "\n"), "markdown").blocks
  end
  include_once("vocab-gallery.html")
  local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
  local n = #terms
  local max_cols = tonumber(str(kwargs["cols"], ""))
  local cols = max_cols or (n <= 5 and n or math.ceil(n / 2))   -- before the script fits it to the room
  local view = str(kwargs["view"], "cards") == "table" and "table" or "cards"
  local function pic(t, cls)
    return t.image ~= "" and ('<span class="' .. cls .. '"><img src="' .. html_escape(up .. t.image) .. '" alt="" loading="lazy"></span>') or ('<span class="' .. cls .. '"></span>')
  end
  local cards, rows = {}, {}
  for _, t in ipairs(terms) do
    table.insert(cards, '<div class="vg-card vocab-term" tabindex="0" role="button" aria-label="' .. html_escape(t.term) .. ': open its card">' ..
      pic(t, "vg-pic") .. '<span class="vg-word">' .. html_escape(t.term) .. '</span>' ..
      ((zh == "true" and t.zh ~= "") and ('<span class="vg-zh">' .. html_escape(t.zh) .. '</span>') or "") ..
      vocab_card_html(t, meta) .. '</div>')
    table.insert(rows, '<tr><td class="vg-tpic">' .. pic(t, "vg-pic") .. '</td><td class="vg-tword">' .. html_escape(t.term) .. '</td>' ..
      (with_zh and ('<td class="vg-tzh">' .. html_escape(t.zh) .. '</td>') or "") ..
      '<td class="vg-tdef">' .. html_escape(t.definition) .. '</td></tr>')
  end
  local function btn(v, label)
    return '<button type="button" data-view="' .. v .. '" aria-pressed="' .. tostring(view == v) .. '">' .. label .. '</button>'
  end
  return pandoc.RawBlock("html",
    '<div class="vocab-gallery" data-view="' .. view .. '"' .. (max_cols and (' data-cols="' .. max_cols .. '"') or "") ..
    ' style="--vg-cols: ' .. cols .. '">' ..
    '<div class="vg-switch" role="group" aria-label="Show the words as">' .. btn("cards", "Cards") .. btn("table", "Table") .. '</div>' ..
    '<div class="vg-cards">' .. table.concat(cards) .. '</div>' ..
    '<table class="vg-table"><tbody>' .. table.concat(rows) .. '</tbody></table></div>')
end


return {
  ["lesson-nav"] = function()
    local info = lesson_info()
    if not info then return pandoc.Null() end
    local rows = pandoc.Blocks({})
    local head = pandoc.Inlines({ pandoc.Link(info.strand, "/" .. info.strand_path) })
    if info.minutes then head:insert(pandoc.Str(" · " .. info.minutes .. " min")) end
    rows:insert(pandoc.Para(head))
    if #info.before > 0 then
      local p = pandoc.Inlines({ pandoc.Strong("Before this: ") })
      p:extend(lesson_links(info.before))
      rows:insert(pandoc.Para(p))
    end
    if #info.next > 0 then
      local p = pandoc.Inlines({ pandoc.Strong("Next up: ") })
      p:extend(lesson_links(info.next))
      rows:insert(pandoc.Para(p))
    end
    return pandoc.Div(rows, pandoc.Attr("", { "lesson-nav" }))
  end,

  ["vocab-gallery"] = vocab_gallery,

  ["frames"] = frames_shortcode,
  ["frame"] = frame_inline,       -- one frame, in the line: {{< frame "FRM-014" >}}

  ["vocab"] = function(args, kwargs, meta)
    local key = str(args[1], "")
    local t = vocab_lookup(key)
    local shown = str(kwargs["text"], t and t.term or key)
    if not t then
      quarto.log.warning('vocab shortcode: "' .. key .. '" is not in vocab/data/vocab.csv')
      return pandoc.Str(shown)
    end
    if not quarto.doc.is_format("html") then
      if str(kwargs["zh"], "false") == "true" and t.zh ~= "" then
        return pandoc.Span({ pandoc.Strong({ pandoc.Str(shown) }), pandoc.Space(), pandoc.Str(t.zh) })
      end
      return pandoc.Strong({ pandoc.Str(shown) })
    end
    return pandoc.RawInline("html", '<span class="vocab-term" tabindex="0">' .. html_escape(shown) .. vocab_card_html(t, meta) .. '</span>')
  end,

  ["pdf"] = function(args, kwargs)
    local file = str(args[1], nil)
    if not file then return pandoc.Null() end
    local rel = from_project_root(file)
    local count = pdf_pages(rel)
    if not count then
      quarto.log.warning('pdf shortcode: no page count for ' .. rel .. ' (is the file there? scripts/catalog.py counts pages before each render)')
      count = 1
    end
    local pages = page_list(str(kwargs["pages"], nil), count)
    local title = str(kwargs["title"], file:match("[^/]+$"))
    if quarto.doc.is_format("typst") then
      local out = {}
      for _, n in ipairs(pages) do
        out[#out + 1] = '#page(margin: 0pt, header: none, footer: none)[#image("/' .. rel ..
          '", page: ' .. n .. ', width: 100%, height: 100%, fit: "contain")]'
      end
      return pandoc.RawBlock("typst", table.concat(out, "\n"))
    end
    local label = "📄 " .. title .. " (PDF, " .. #pages .. " page" .. (#pages == 1 and "" or "s") .. ")"
    local link = pandoc.Para({ pandoc.Link({ pandoc.Str(label) }, file) })   -- a real link, so Quarto copies the file
    if quarto.doc.is_format("html") then
      return pandoc.Blocks({ link, pandoc.RawBlock("html",
        '<iframe class="pdf-embed" src="' .. html_escape(file) .. '" title="' .. html_escape(title) ..
        '" style="width:100%;height:70vh;border:1px solid #c6d0da;border-radius:8px"></iframe>') })
    end
    return link
  end,

  ["packet"] = function()
    local teacher = false
    for _, profile in ipairs(quarto.project.profile or {}) do
      if profile == "teacher" then teacher = true end
    end
    local p = packet_for_this_page()
    if not p or not quarto.doc.is_format("html") then return pandoc.Null() end
    local name = p.pdf:match("[^/]+$")
    local n = #p.files + #(p.extras or {})
    local count = n .. " printable" .. (n == 1 and "" or "s")
    local function button(label, file, classes)
      return pandoc.Link({ pandoc.Str(label) }, file, "", pandoc.Attr("", classes))
    end
    if teacher then   -- both editions (scripts/packets.py writes unit-teacher-packet.pdf next to it)
      local teacher_file = name:gsub("%-packet%.pdf$", "-teacher-packet.pdf")
      local function card(cls, label, note, file)
        return pandoc.Div({ pandoc.Para({ button(label, file, { "btn" }) }),
                            pandoc.Para({ pandoc.Str(note) }) }, pandoc.Attr("", { "packet-card", cls }))
      end
      -- the student copy first: printing it for class is a teacher's first move; the answer keys come second
      return pandoc.Div({
        card("packet-student", "Student copy (PDF)", "No answer keys. Print this one for class. All " .. count .. ".", name),
        card("packet-teacher", "Teacher edition (PDF)", "With answer keys and teacher notes. For you, not for students.", teacher_file),
      }, pandoc.Attr("", { "packet-cards" }))
    end
    return pandoc.Para({ button("Unit packet (PDF)", name, { "btn", "btn-primary", "packet-one" }),
                         pandoc.Span({ pandoc.Str(" · all " .. count .. " in one file, ready to print") },
                                     pandoc.Attr("", { "text-muted" })) })
  end,

  ["lines"] = function(args, kwargs)
    local n = tonumber(str(args[1], "3")) or 3
    local gap = str(kwargs["gap"], nil)
    if quarto.doc.is_format("typst") then
      local extra = gap and (", gap: " .. gap) or ""
      return pandoc.RawBlock("typst", "#answer-lines(" .. n .. extra .. ")")
    elseif quarto.doc.is_format("html") then
      return pandoc.RawBlock("html", '<div class="answer-lines" style="--lines: ' .. n .. '"></div>')
    else
      local blocks = {}
      for _ = 1, n do
        table.insert(blocks, pandoc.Para({ pandoc.Str(string.rep("_", 70)) }))
      end
      return blocks
    end
  end,

  ["blank"] = function(args)
    local width = str(args[1], "1.5in")
    if quarto.doc.is_format("typst") then
      return pandoc.RawInline("typst", "#blank(" .. width .. ")")
    elseif quarto.doc.is_format("html") then
      return pandoc.RawInline("html", '<span class="blank" style="width: ' .. html_escape(width) .. '"></span>')
    end
    return pandoc.Str(string.rep("_", 12))
  end,

  ["drawing-box"] = function(args, kwargs)
    local label = str(kwargs["label"], nil)
    local height = str(kwargs["height"], nil)
    if quarto.doc.is_format("typst") then
      local a = { "height: " .. (height or "1fr") }
      if label then table.insert(a, "label: " .. typst_string(label)) end
      return pandoc.RawBlock("typst", "#drawing-box(" .. table.concat(a, ", ") .. ")")
    elseif quarto.doc.is_format("html") then
      local style = height and (' style="height: ' .. html_escape(height) .. '"') or ""
      local lab = label and ('<span class="drawing-box-label">' .. html_escape(label) .. '</span>') or ""
      return pandoc.RawBlock("html", '<div class="drawing-box"' .. style .. '>' .. lab .. '</div>')
    else
      return pandoc.Para({ pandoc.Emph({ pandoc.Str("[" .. (label or "Drawing space") .. "]") }) })
    end
  end,

  ["objectives"] = function(args, kwargs, meta)
    local list = meta["objectives"]
    if list == nil then return pandoc.Null() end
    local items = {}
    for _, o in ipairs(list) do
      table.insert(items, { pandoc.Plain(pandoc.Inlines(pandoc.utils.stringify(o))) })
    end
    if not quarto.doc.is_format("html") then return pandoc.BulletList(items) end
    return pandoc.Div({ pandoc.Div({ pandoc.Plain({ pandoc.Str("In this unit") }) }, pandoc.Attr("", { "objectives-head" })),
                        pandoc.BulletList(items) }, pandoc.Attr("", { "objectives" }))
  end,

  -- Slide games. See games/games.js for how each one plays.
  ["snowman"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Snowman") end
    return games.div("snowman", game_config(args, kwargs, "snowman"))
  end,

  ["picture-reveal"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Picture reveal") end
    local c = game_config(args, kwargs, "picture-reveal")
    c.tiles = tonumber(str(kwargs["tiles"], "16")) or 16
    return games.div("picture-reveal", c)
  end,

  -- Jeopardy and quick-fire from the vocab list. To write your own questions, use a ::: div
  -- (filter.lua): ::: {.jeopardy} and ::: {.trivia}.
  ["jeopardy"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Jeopardy") end
    local c = game_config({}, kwargs, "jeopardy")
    c.rows = tonumber(str(kwargs["rows"], "4")) or 4
    c.teams = tonumber(str(kwargs["teams"], "2")) or 2   -- 2 to 4 teams take turns; teams=0: no teams
    return games.div("jeopardy", c)
  end,

  ["trivia"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Quick-fire questions") end
    local c = game_config({}, kwargs, "trivia")
    c.count = tonumber(str(kwargs["count"], "5")) or 5
    c.seconds = tonumber(str(kwargs["seconds"], "10")) or 10
    c.title = str(kwargs["title"], "Quick-fire!")
    return games.div("trivia", c)
  end,

  -- Matching (tap a word, then its partner) and Memory (turn over two cards): pairs from the vocab
  -- list. with="meaning" or "picture" chooses each word's partner; count=6 pairs.
  ["matching"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Matching") end
    local c = game_config({}, kwargs, "matching")
    c.count = tonumber(str(kwargs["count"], "6")) or 6
    c.with = str(kwargs["with"], "meaning")
    return games.div("matching", c)
  end,

  ["memory"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Memory") end
    local c = game_config({}, kwargs, "memory")
    c.count = tonumber(str(kwargs["count"], "6")) or 6
    c.with = str(kwargs["with"], "picture")
    return games.div("memory", c)
  end,

  -- Word scramble: the same words as Snowman (random, unit=1, a vocab word, or your own).
  ["scramble"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Word scramble") end
    return games.div("scramble", game_config(args, kwargs, "scramble"))
  end,

  -- Sort it from the vocab list: words from several units go into their units; from one unit
  -- (unit=1), into their topics. Your own groups: ::: {.sort} (filter.lua).
  ["sort"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Sort it") end
    local c = game_config({}, kwargs, "sort")
    c.with = str(kwargs["with"], "words")              -- with="picture": the vocab pictures
    c.feedback = str(kwargs["feedback"], "now")        -- feedback="end": wait for Check
    return games.div("sort", c)
  end,

  -- Bingo: make printable cards (in the browser) before class, then call the words in class.
  ["bingo"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Bingo") end
    local c = game_config({}, kwargs, "bingo")
    c.unit = c.unit or 0
    for _, u in ipairs(vocab_units or {}) do
      if u.unit == c.unit then c.title = u.title end
    end
    return games.div("bingo", c)
  end,

  -- Word Blitz (like Kahoot, for one player): a picture and four words, or a word and four pictures,
  -- against the clock; right answers in a row multiply the points. High scores are kept in the browser.
  -- mode="classic" (20 questions, or 10 for a course with fewer than 20 words; count= changes it) or
  -- mode="survival" (3 lives): the mode it starts on; students can switch. seconds=10,
  -- ask="picture" (choose the word) or ask="word" (choose the picture); both, mixed, if not given.
  ["blitz"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Word Blitz") end
    local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
    local c = game_config({}, kwargs, "blitz")
    c.all = {}   -- every word, for the wrong answers (one of the four comes from another unit)
    if c.named then c.all = c.words
    else for _, t in ipairs(vocab_list or {}) do if not t.guide then table.insert(c.all, game_word(t, up)) end end end
    c.count = tonumber(str(kwargs["count"], ""))   -- nil: games.js decides (20, or 10 for a small course)
    c.seconds = tonumber(str(kwargs["seconds"], "10")) or 10
    c.ask = str(kwargs["ask"], "both")
    c.mode = str(kwargs["mode"], "classic")
    c.title = str(kwargs["title"], "Word Blitz")
    return games.div("blitz", c)
  end,

  -- The Review games page: choose a game and a unit, then play (every vocab word, with its units).
  -- games="blitz,snowman": only those games, the first one chosen at first (the Play page).
  ["game-picker"] = function(args, kwargs)
    if not games.web() then return games.placeholder("Review games") end
    local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
    vocab_lookup("")   -- loads the list
    local words = {}
    for _, t in ipairs(vocab_list or {}) do if not t.guide then table.insert(words, game_word(t, up)) end end
    local only = {}
    for id in str(kwargs and kwargs["games"], ""):gmatch("[%w-]+") do table.insert(only, id) end
    return games.div("picker", { words = words, units = vocab_units, random = true, games = only,
      home = quarto.doc.is_format("revealjs") and (up .. "index.html") or nil })   -- a web page has the sidebar
  end,

  ["slide-wall"] = function()
    if not quarto.doc.is_format("html") then return pandoc.Null() end
    quarto.doc.add_html_dependency({ name = "chalkline-slide-wall", version = "1.0.0",
      stylesheets = { "slide-wall/slide-wall.css" }, scripts = { { path = "slide-wall/slide-wall.js", afterBody = true } } })
    local up = quarto.project.offset and (quarto.project.offset .. "/") or ""
    return pandoc.RawBlock("html", '<div class="slide-wall" data-root="' .. up .. '" data-src="' .. up .. 'slide-pictures.json"></div>')
  end,

  -- {{< timer 6 >}}: a countdown (countdown.html). layout="row": one narrow strip, the instruction on the
  -- left (label="English | 中文"), the time in the middle, the buttons stacked on the right.
  ["timer"] = function(args, kwargs)
    local minutes = tonumber(str(args[1], "5")) or 5
    if quarto.doc.is_format("revealjs") then
      include_once("countdown.html")
      local layout = kwargs and str(kwargs["layout"], "") or ""
      if layout == "row" then
        local label = str(kwargs["label"], "")
        local en, zh = label:match("^(.-)%s*|%s*(.+)$")
        local html = ""
        if en then
          html = '<span class="bil bil-stack"><span class="bil-en" lang="en">' .. html_escape(en) ..
            '</span><span class="bil-zh" lang="zh">' .. html_escape(zh) .. '</span></span>'
        elseif label ~= "" then
          html = html_escape(label)
        end
        return pandoc.RawBlock("html", '<div class="countdown cd-row" data-minutes="' .. minutes .. '">' ..
          '<div class="cd-label">' .. html .. '</div></div>')
      end
      return pandoc.RawBlock("html", '<div class="countdown" data-minutes="' .. minutes .. '"></div>')
    end
    return pandoc.Para({ pandoc.Strong({ pandoc.Str("Timer: " .. minutes .. " minutes") }) })
  end,
}
