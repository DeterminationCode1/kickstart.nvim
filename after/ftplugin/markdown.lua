-- https://github.com/hrsh7th/nvim-cmp/issues/666#issuecomment-1000925581

-- Remove buffer source from markdown files in nvim-cmp because it made it
-- difficult to find file suggestions when hitting [[]] in markdown files.

-- -- nvim-cmp
-- local cmp = require 'cmp'
-- local sources = cmp.get_config().sources
-- if not sources then
--   return
-- end

-- for i = #sources, 1, -1 do
--   if sources[i].name == 'buffer' then
--     table.remove(sources, i)
--   end
-- end
-- cmp.setup.buffer { sources = sources }

-- blink.cmp - deactivate buffer source can be do not in the blink.cmp config
-- function see

-- ============================ Markdown Keybindings ============================
-- The here listed keybindings only exist in .md files. they can override
-- pre-existing keybindings in the global keybindings section.

-- Use the familiar `ctr+b` command in insert mode to make the following text
-- bold in markdown. This command also work in .md files.
-- FIX: at the moment the "go back 2 chars" doesn't work. fix it.
vim.keymap.set('i', '<C-b>', function()
  -- insert **
  -- Go back two characters. Feeding the keys <left> directly in the feedkeys
  -- function doesn't work, so I had to resort to normal mode for now.
  -- vim.cmd 'a****<esc><left><left>i' -- doesn't work
end, { noremap = true, silent = true })

-- ==============================================================================
-- ======================== Increase/decrease headings ==========================
-- ==============================================================================
-- -- Increase/decrease heading levels in markdown files. By default the whole
-- buffer is process if you are not in visual mode.
--   g>  → increase one level   (Normal / Visual)
--   g<  → decrease one level
-- markdown_heading_shift.lua
-- ============================================================================

local M_heading = {}

-- Return visual range (inclusive, 1-based) *after* leaving visual mode
local function get_visual_range()
  -- Send <Esc> *now* so marks '< and '> become available
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
  local first = vim.fn.getpos("'<")[2]
  local last = vim.fn.getpos("'>")[2]
  if first > last then
    first, last = last, first
  end
  return first, last
end

---@param delta integer  (+1 = deeper, -1 = shallower)
local function shift(delta)
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()

  -- Decide the line range
  local first, last
  if mode:find '[vV]' then -- any visual mode
    first, last = get_visual_range()
  else -- whole buffer
    first, last = 1, vim.api.nvim_buf_line_count(buf)
  end

  -- Grab the lines
  local lines = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)

  -- Regex: start-of-line optional indent, (#+), optional spaces, the rest
  local pat = '^%s*(#+)%s*(.*)$'

  for i, line in ipairs(lines) do
    local hashes, rest = line:match(pat)
    if hashes then
      local level = #hashes + delta
      if level >= 1 and level <= 7 then
        -- guarantee exactly *one* space before the text
        lines[i] = string.rep('#', level) .. ' ' .. rest
      end
    end
  end

  -- Replace in buffer (keepjumps avoids jumplist pollution)
  vim.cmd 'keepjumps keepmarks silent!' -- keep marks/undo clean
  vim.api.nvim_buf_set_lines(buf, first - 1, last, false, lines)
end

M_heading.increase = function()
  shift(1)
end
M_heading.decrease = function()
  shift(-1)
end

-- Keymaps: works in Normal *and* Visual
vim.keymap.set({ 'n', 'v' }, 'g>', M_heading.increase, { desc = 'Markdown: increase heading level' })
vim.keymap.set({ 'n', 'v' }, 'g<', M_heading.decrease, { desc = 'Markdown: decrease heading level' })

-- return M_heading
-- ================================ end ===========================================

-- ==============================================================================
-- ========================== Open in Obsidian =================================
-- ==============================================================================
-- Open current markdown file in Obsidian
-- See official Obsidian URI documentation:
-- https://help.obsidian.md/Advanced+topics/Using+obsidian+URI#Examples
-- NOTE: maybe use 'goo' as keybinding?
vim.keymap.set('n', 'go', function() -- previously: <leader>mo
  -- Check only .md, .csv .txt, .html files can be opened in Obsidian
  local file_extension = vim.fn.expand '%:e'
  if not (file_extension == 'md' or file_extension == 'csv' or file_extension == 'txt' or file_extension == 'html') then
    vim.notify('Only .md, .csv, .txt or .html files can be opened in Obsidian', vim.log.levels.WARN)
    return
  end

  -- URL Encode function
  -- WARN: In Lua `%` signs in the replacement string must be escaped with
  -- another `%` sign.
  local function obsidian_uri_encode(str)
    return str:gsub(' ', '%%20'):gsub('/', '%%2F')
  end

  -- The params  must be encoded. Eg spaces must be %20 and slashes %2F...
  local currentFile = vim.fn.expand '%:t'
  local vault = 'Knowledge_Wiki'
  local vaultEncoded = obsidian_uri_encode(vault)
  -- local currentFileEncoded = obsidian_uri_encode(currentFile)
  local currentFileEncoded = obsidian_uri_encode(currentFile)

  local obsidian_url = 'obsidian://open?vault=' .. vaultEncoded .. '&file=' .. currentFileEncoded

  -- local currentFilePath = vim.fn.expand '%:p'
  -- local currentFilePathEncoded = url_encode(currentFilePath)
  -- local obsidian_url = 'obsidian://open?path=' .. currentFilePathEncoded --
  -- FIX: obsidian couldn't find the vault from the path... Maybe because it is
  -- in iCloud?

  -- BE AWARE: The format must be: `open "obsidian://open?vault=VaultName&file=FileName"`
  -- Last time it only worked when the URL was in double quotes.
  vim.system({ 'open', obsidian_url }, { text = true }, function(obj)
    vim.notify('Opened in Obsidian', vim.log.levels.INFO)

    if obj.code ~= 0 then
      vim.notify('Error opening in Obsidian', vim.log.levels.ERROR)
      -- debug
      vim.notify('Debug obsidian url:\n\n' .. obsidian_url, vim.log.levels.INFO)
    end
  end)
end, { desc = 'Open current [m]arkdown file in [O]bsidian' })

-- ============================= End ===========================================
