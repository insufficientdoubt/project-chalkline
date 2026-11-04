-- TEMPORARY, with slide-refs.html: stamps the deck with which build it is, so the reference badge on each
-- slide can say it ("1.8 · #82 · 4 Nov 15:10"). On the published site, the build runs on the merge commit,
-- whose message names the pull request; otherwise (a direct push, a local preview) the short commit ID.
-- The time is when the deck was rendered. Remove it with slide-refs.html (the deck's `filters:` line too).
local function sh(cmd)
  local f = io.popen(cmd .. " 2>/dev/null")
  if not f then return "" end
  local out = f:read("*a") or ""
  f:close()
  return (out:gsub("%s+$", ""))
end

return {
  {
    Meta = function(meta)
      if not quarto.doc.is_format("revealjs") then return end
      local pr = sh("git log -1 --format=%s"):match("^Merge pull request #(%d+)")
      local tag = pr and ("#" .. pr) or sh("git rev-parse --short HEAD")
      local when = os.date("!%Y-%m-%dT%H:%M:%SZ")
      quarto.doc.include_text("in-header",
        '<meta name="chalkline-build" content="' .. tag:gsub('[<>"&]', "") .. '" data-time="' .. when .. '">')
    end,
  },
}
