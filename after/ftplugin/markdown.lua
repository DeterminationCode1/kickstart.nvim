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
-- markdown_heading_shift.lua
local M_heading = {}

-- returns (firstLine, lastLine) 1‑based, inclusive
local function get_visual_lines()
  local p1 = vim.fn.getpos("'<")[2] -- line number of '<
  local p2 = vim.fn.getpos("'>")[2] -- line number of '>
  if p1 > p2 then
    p1, p2 = p2, p1
  end
  return p1, p2
end

---@param delta integer  +1 to increase, ‑1 to decrease
local function shift(delta)
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode() -- current Vim mode
  local first, last

  if mode:match '[Vv]' then -- any visual mode
    first, last = get_visual_lines()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false) -- exit visual safely
  else -- normal -> whole file
    first, last = 1, vim.api.nvim_buf_line_count(buf)
  end

  -- Grab slice
  local slice = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)

  -- Transform headings
  local pat = '^%s*(#+)(%s?.*)$' -- allow missing space after #'s
  for i, line in ipairs(slice) do
    local hashes, rest = line:match(pat)
    if hashes then
      local lvl = #hashes + delta
      lvl = math.max(1, math.min(7, lvl)) -- clamp 1…7
      slice[i] = string.rep('#', lvl) .. rest
    end
  end

  -- Write back
  vim.api.nvim_buf_set_lines(buf, first - 1, last, false, slice)
end

function M_heading.increase()
  shift(1)
end
function M_heading.decrease()
  shift(-1)
end

-- Expose as user commands
-- vim.api.nvim_create_user_command("IncreaseMdHeading", M_heading.increase, { range = false })
-- vim.api.nvim_create_user_command("DecreaseMdHeading", M_heading.decrease, { range = false })

-- Optional keymaps: g> to increase, g< to decrease
vim.keymap.set({ 'n', 'v' }, 'g>', M_heading.increase, { desc = 'Increase MD heading level' })
vim.keymap.set({ 'n', 'v' }, 'g<', M_heading.decrease, { desc = 'Decrease MD heading level' })

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
