-- extend the native capability of gx to open a link in the line it was called.
-- official docs on gx: https://neovim.io/doc/user/various.html#gx
-- TODO: this version cannot open local files. It can only open URLs. fix it
-- WARN: markview.nvim defines an on_attach buff_render keymap for gx that
-- overwrites my personal gx mapping in markdown files. Putting my mapping in
-- the after/ftplugin/markdown.lua file didn't work.
-- A workaround seems to be to fork the plugin and change the keybinding in
-- lua/keymaps.lua to my liking. I'm not sure if the extra logic defined in
-- markdiew.nvim's gx mapping is necessary because of the exmarks it's injecting
-- into the file.
--
-- More research on markview problem :
-- - the gx mapping is patchend in `lua/markview.lua` here and in the same file at the bottom the `open` is mapped to
--   `links.open() https://github.com/OXY2DEV/markview.nvim/blob/b3c0f3caf78518d33a0b5ad8af944a3c70aa0389/lua/markview.lua#L648C1-L649C1
-- - the `links.open()` is defined in `lua/markview/links.lua` https://github.com/OXY2DEV/markview.nvim/blob/b3c0f3caf78518d33a0b5ad8af944a3c70aa0389/lua/markview/links.lua#L267

local M = {}

-- post processing urls function
local post_process = function(url)
  -- remove the ) braked at the end of the pattern
  if url:sub(-1) == ')' then
    url = url:sub(1, -2)
  end
  return url
end

local open_word_under_cursor_in_zotero = function()
  -- Get the word under the cursor
  local word = vim.fn.expand '<cWORD>'
  -- TODO: check if its a cite key. Rather complex, currently not working for
  -- edge cases... Overkill.
  --
  -- Check if the word is a citkey. Allowed formats:
  -- - [@wangInfluencePoliticalIdeology2022]
  -- - [@wangInfluencePoliticalIdeology2022, p. 43]
  -- - [@wangInfluencePoliticalIdeology2022, pp. 43-45]
  -- - [see @wangInfluencePoliticalIdeology2022, pp. 43 demin]
  -- - also allow citkyes like [@wangInfluencePoliticalIdeology2022, p. 43]

  -- Extract the citkey
  local citkey = word:sub(2, -2)

  -- check the citekey starts with @
  if not citkey:match '^@' then
    vim.notify('No citkey found under cursor', vim.log.levels.INFO)
    return
  end
  -- print out citkey for debugging
  vim.notify('Extracted Citkey: ' .. citkey, vim.log.levels.INFO)
  -- Open the citkey in Zotero
  local zotero_url = 'zotero://select/items/' .. citkey
  -- open zotero://select/items/lippert-rasmussenRawlsLuckEgalitarianism
  vim.system({ 'open', zotero_url }, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.notify('Error opening in Zotero', vim.log.levels.ERROR)
    end
  end)
end

M.my_gx = function()
  -- Get the line and cursor position
  local line = vim.fn.getline '.'
  local cursor = vim.fn.getpos '.'
  local cursor_col = cursor[3]
  local urls = {} -- store all extracted URLs here

  -- Get the URLs and file paths in the line.
  -- Possible resources gx can open:
  -- - URLs: http, https, ftp, mailto, file, zotero
  -- - Local files: /, ~, .
  local pattern = [[\v(http|https|ftp|mailto|file|zotero)://\S+|\v(\w+://)?(\w+[-\w]*\.)*\w+[-\w]*\.\w+(/\S*)*|\v(~|/|\.)(/\S*)*]]
  -- another pattern that looks for zotero cite keys in markdown files. i.e. @rawlsTheoryJustice1971
  local pattern_zotero = [[\@[\w\d]+]]
  -- vim.notify('Pattern: ' .. pattern)

  -- -- Use :gmatch to get all URLs in the line
  -- for url in line:gmatch(pattern) do
  --   table.insert(urls, url)
  -- end

  -- Use matchstrpos to get all URL and there position in the line
  local pos = 1
  while true do
    local match, start, finish = unpack(vim.fn.matchstrpos(line, pattern, pos))
    if match == '' then
      -- if no match try Zotero pattern
      -- if markdown file, search for zotero cite keys
      if vim.bo.filetype == 'markdown' then
        open_word_under_cursor_in_zotero()
        local zotero_match, zotero_start, zotero_finish = unpack(vim.fn.matchstrpos(line, pattern_zotero, pos))
        vim.notify('Zotero match: ' .. zotero_match, vim.log.levels.INFO)
        if zotero_match ~= '' then
          -- post process the match
          match = zotero_match
        else
          break
        end
      else
        break
      end
    end
    -- post process the match
    match = post_process(match)

    table.insert(urls, { match = match, start = start, finish = finish })
    pos = finish + 1
  end

  vim.notify('URLs: ' .. vim.inspect(urls))

  local chosen_url = ''

  -- If no URLs or file paths are found, fall back to word under the cursor
  if #urls == 0 then
    local word = vim.fn.expand '<cWORD>'
    if word == '' then
      vim.notify('No URL or resource found in the line', vim.log.levels.INFO)
      return
    end
    vim.notify('No resource found in the line. Defaulting to word under cursor', vim.log.levels.INFO)
    chosen_url = word
    -- vim.ui.open(word)
    -- return
  end

  -- If there's only one URL, open it
  if #urls == 1 then
    chosen_url = urls[1].match
    -- vim.ui.open(urls[1].match)
    -- return
  end

  -- Find the URL under the cursor
  if chosen_url == '' then
    for _, url_info in ipairs(urls) do
      if cursor_col >= url_info.start and cursor_col <= url_info.finish then
        chosen_url = url_info.match
        break
      end
    end
  end

  -- find URL after cursor
  if chosen_url == '' then
    for _, url_info in ipairs(urls) do
      if cursor_col < url_info.start then
        chosen_url = url_info.match
        break
      end
    end
  end

  -- Open the selected URL or path
  vim.ui.open(chosen_url)
end

return M
