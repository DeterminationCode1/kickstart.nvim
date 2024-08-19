-- My utility function collection
local my_utils = require 'utils'

-- ================= My keybindings rempas ==============y
-- This fill content was originally in the ~/.config/nvim/init.lua file.
-- But to make it more readable it was moved to this file.
-- This keymap file contains general purpose keymaps, keymaps closely related to plugins are in the plugin config files.
-- or the init.lua file.

-- WARN using 'nvim-recorder' plugin is not working
-- Remap  q 'record macro' to 'gq' as 'q' is used as comment prefix for 'gc'
-- vim.keymap.set('n', 'gq', '', { desc = 'Record macro w nvim-record' })
-- vim.keymap.set('n', 'gq', 'qq', { desc = 'End record macro' })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[W]rite current buffer' })
vim.keymap.set('n', '<leader>W', '<cmd>wa<CR>', { desc = '[W]rite all buffers' })
vim.keymap.set('n', '<C-6>', '<C-^>', { desc = 'Switch between last two buffers' })

-- ===============================================================================================
-- ============================ Markdown and Writing keybindings =================================
-- ===============================================================================================

-- Count the number of words and characters in the current selected text.
vim.keymap.set('v', '<leader>c', function() -- use <leader>cc if
  local char_count = vim.fn.wordcount().visual_chars
  local word_count = vim.fn.wordcount().visual_words
  -- different msg styles. minimalistic was best
  local message = word_count .. ' words' .. '\n' .. char_count .. ' chars'
  -- local message = word_count .. ' Words' .. '\n' .. char_count .. ' Chars'
  -- local message = 'Words: ' .. word_count .. '\nChars: ' .. char_count
  vim.notify(message)
end, { desc = '[C]ount characters and words' })

-- NOTE: if the above word_count script is not working, use https://www.reddit.com/r/neovim/comments/z2tgf5/how_to_show_selected_characterline_count_on/
--
-- local char_and_line_count = function() -- m
--   if visual_str[tostring(vim.fn.mode())] then
--     local ln_beg = vim.fn.line 'v'
--     local ln_end = vim.fn.line '.'

--     local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1

--     return tostring(vim.fn.wordcount().visual_chars) .. ' chars' .. ' / ' .. tostring(lines) .. ' lines'
--   else
--     -- return ''
--     return '[' .. tostring(vim.fn.mode()) .. ']' -- for debugging
--   end
-- end

-- Format bullet points in markdown -- WARN: not working yet
-- vim.keymap.set({ 'n', 'v' }, '<leader>mf', function()
--   -- Get the selected lines
--   local start_pos = vim.fn.getpos "'<"
--   local end_pos = vim.fn.getpos "'>"
--   local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

--   local formatted_lines = {}
--   for _, line in ipairs(lines) do
--     -- Trim leading and trailing whitespaces
--     line = line:gsub('^%s+', ''):gsub('%s+$', '')
--     -- Add proper indentation for bullet points
--     if line:match '^%- %-%s' then
--       line = line:gsub('^%- %-%s', '- ')
--     end
--     table.insert(formatted_lines, line)
--   end
-- end, { desc = 'Format bullet list' })

-- ================================== linkarzu dotfiles tricks =================================
-- source: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua
-- Linkarzu  has very inspiring dotfiles that are optimized for writing in nvim. See his video:
-- "My complete Neovim markdown setup and workflow in 2024",
-- https://www.youtube.com/watch?v=ZqjZJr5x9Z0&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=1

-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
-- Linkarzu used `gk` on querty as keybinding.
vim.keymap.set({ 'n', 'v' }, 'g<up>', function()
  -- `?` - Start a search backwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd 'silent! ?^##\\+\\s.*$'
  -- Clear the search highlight
  vim.cmd 'nohlsearch'
end, { desc = '[P]Go to previous markdown header' })

-- Search DOWN for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
-- Linkarzu used `gj` on querty as keybinding.
vim.keymap.set({ 'n', 'v' }, 'g<down>', function()
  -- `/` - Start a search forwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd 'silent! /^##\\+\\s.*$'
  -- Clear the search highlight
  vim.cmd 'nohlsearch'
end, { desc = '[P]Go to next markdown header' })

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set('v', '<leader>mb', function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos "'<", 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos "'>", 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, '\n'):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match '^%*%*.*%*%*$' then
    vim.notify('Text already bold', vim.log.levels.INFO)
  else
    vim.cmd 'normal 2gsa*'
  end
end, { desc = '[P]BOLD current selection' })

-- Multiline unbold attempt
-- In normal mode, bold the current word under the cursor
-- If already bold, it will unbold the word under the cursor
-- If you're in a multiline bold, it will unbold it only if you're on the
-- first line
vim.keymap.set('n', '<leader>mb', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match '%*' then
    vim.notify('Cursor is on an asterisk, run inside the bold text', vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find '%*%*'
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find '%*%*'
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == '' then
      break
    end
    right_text = right_text .. '\n' .. next_line
    bold_end = right_text:find '%*%*'
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, '\n')
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, '\n')
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match '%*%*[^%*]*$' and after:match '^[^%*]*%*%*'
    if inside_surround then
      vim.cmd 'normal gsd*.'
    else
      vim.cmd 'normal viw'
      vim.cmd 'normal 2gsa*'
    end
    vim.notify('Bolded current word', vim.log.levels.INFO)
  end
end, { desc = '[P]BOLD toggle bold markers' })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set('v', '<leader>mll', function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd "let @a = getreg('+')"
  -- delete selected text
  vim.cmd 'normal d'
  -- Insert the following in insert mode
  vim.cmd 'startinsert'
  vim.api.nvim_put({ '[]() ' }, 'c', true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd 'normal F[pf('
  -- Copy what's on the "a register back to the clipboard
  vim.cmd "call setreg('+', @a)"
  -- Paste what's on the clipboard
  vim.cmd 'normal p'
  -- Leave me in normal mode or command mode
  vim.cmd 'stopinsert'
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = '[P]Convert to link' })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set('v', '<leader>mlt', function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd "let @a = getreg('+')"
  -- delete selected text
  vim.cmd 'normal d'
  -- Insert the following in insert mode
  vim.cmd 'startinsert'
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, 'c', true, true)
  vim.cmd 'normal F[pf('
  -- Copy what's on the "a register back to the clipboard
  vim.cmd "call setreg('+', @a)"
  -- Paste what's on the clipboard
  vim.cmd 'normal p'
  -- Leave me in normal mode or command mode
  vim.cmd 'stopinsert'
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = '[P]Convert to link (new tab)' })

-- --------------------------------- Linkarzu end ---------------------------------
--
--

-- ====================================================================================================
-- ================================== Primegan keybindings ==========================================
-- ====================================================================================================
-- See Primegan nvim bindings for inspiration: https://github.com/ThePrimeagen/init.lua/blob/249f3b14cc517202c80c6babd0f9ec548351ec71/lua/theprimeagen/remap.lua
-- Me: you use Ctr+Command+ right homerow because you use cmd insteas of alt for window management. Also, ctr+shift is the same as ctr+no shift.
vim.keymap.set(
  'n',
  '<C-f>',
  '<cmd>silent !tmux neww tmux-sessionizer<CR>',
  { desc = 'Fzf through all your projects and open it with tmux. Inspired by Primegan.' }
)

-- PROBLEM: alt-shift is already maped to 'assing-node-to-workspace' in window manager.
vim.keymap.set(
  'n',
  '<M-n>',
  '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240527_FPV_functional_programming_TUM<CR>',
  { desc = 'Quick switch to a different project' }
)
vim.keymap.set(
  'n',
  '<M-e>',
  "<cmd>silent !tmux neww tmux-sessionizer '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Knowledge_Wiki'<CR>",
  { desc = 'Quick switch to a different project' }
)
vim.keymap.set(
  'n',
  '<M-i>',
  '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240510_EIST_software_engineering_TUM<CR>',
  { desc = 'Quick switch to a different project' }
)
vim.keymap.set(
  'n',
  '<A-o>',
  '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240425_ADS_algorithm_data_structures_TUM<CR>',
  { desc = 'Quick switch to a different project' }
)

-- Primegan recommends using zz after ctr-D/U to keep curor at same position no screen easier for eyes. Source: https://youtu.be/KfENDDEpCsI?si=ClLf3MUgszp1c6op&t=242
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<PageUp>', '<PageUp>zz')
vim.keymap.set('n', '<PageDown>', '<PageDown>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
-- In vim it can be very anoying to past because you can only paste once as what you replace will overwrite your current regsitry.
-- A solution is to use the following which delets into the `_` registry and then pastes.
-- Source: https://www.youtube.com/watch?v=qZO9A5F6BZs&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=4
vim.keymap.set('x', '<leader>p', '"_dP', { desc = "[P]aste text but don't loose your copy register" })

-- Error and quickfix navigation. Primegan: noticed he didn' use split and didn't need the C-arrows for split navigation
-- Instead he bound them (originally he used k,j on dvorak) to very useful error and quick fix navigation. First search for something in telescope,
-- then send results to quickfixlist and then navigate it with this binding.
-- He explains it in this video: https://youtu.be/-ybCiHPWKNA?si=nWChMDCoTzSIHF7p&t=2974
vim.keymap.set('n', '<C-Up>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-Down>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>Up', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>Down', '<cmd>lprev<CR>zz')

-- Quick substitution. Primegan a bit modified.
vim.keymap.set('n', '<leader>rs', [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Quickly [S]ubsitute word under curser in current buffer.' })

-- Primegan uses this to open nvim builtin file explorer
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- ================= END ==============================

-- IntelliJ
vim.keymap.set('n', 'gj', function()
  local currentFile = vim.fn.expand '%:p'
  -- local command = 'open -a "IntelliJ IDEA" ' .. currentFile -- This actually works...
  vim.system({ 'idea', currentFile }, { text = true }, function(obj)
    print(obj.code)
    print(obj.stdout)
    print(obj.stderr)
  end)
end, { desc = '[G]o to Intelli[J] - open current file' })

-- ======================== Obsidian ========================
-- Open current markdown file in Obsidian
-- See official Obsidian URI documentation:
-- https://help.obsidian.md/Advanced+topics/Using+obsidian+URI#Examples
-- NOTE: maybe use 'goo' as keybinding?
-- NOTE: it's possible to open a specific heading in the file. Maybe implement
-- that later.
vim.keymap.set('n', '<leader>mo', function()
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
