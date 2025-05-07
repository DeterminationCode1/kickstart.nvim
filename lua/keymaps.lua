-- My utility function collection
local my_utils = require 'utils'

-- Find root directory vim:  	root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),

-- =============================================================================
-- ====================== Kickstarter.nvim keymaps =============================
-- =============================================================================

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- NOTE:  The kickstarter default was '<Esc><Esc>'.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds to make split navigation easier.
-- WARN: If you are on MacOS you must deactivate the default Mission Control shortcuts that override ctrl + arrows.
-- You can find all of them in the System Preferences > Keyboard > Shortcuts > Mission Control
--
-- reddit: https://www.reddit.com/r/tmux/comments/s2x8pe/ctrlarrow_key_bindings_not_working_on_mac_works/
--
-- see https://superuser.com/questions/1829146/issue-with-ctrl-arrow-keys-in-neovim-using-putty
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- =================================================================================
-- ====================== End Kickstart.nvim keymaps ===============================
-- =================================================================================

-- =========================== My keybindings rempas ==============================
-- This keymap file contains general purpose keymaps, keymaps closely related to plugins are in the plugin config files.
-- or the init.lua file.

-- map macro recording `q` to `Q` instead because macros are rarely used
-- NOTE: this actually works! Record a macro with `<S-q>` + `register letter` the macro
-- is stored in + then type your macro motions + end the macro recording with
-- `<S-q>` again. call your macro with `@` + `register letter` or `@@` to repeat the last macro.
vim.keymap.set('n', 'Q', 'q', { desc = 'Record macro', noremap = true })

-- Redo convenience
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo last change', noremap = true })

-- vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[W]rite current buffer' })
-- vim.keymap.set('n', '<leader>W', '<cmd>wa<CR>', { desc = '[W]rite all buffers' })
vim.keymap.set('n', '<C-6>', '<C-^>', { desc = 'Switch between last two buffers' })
vim.keymap.set('n', '<leader>c', '<cmd>q<CR>', { desc = '([C]lose) Quite current buffer' })

-- Remap vim's ctrl-6 or ctrl-^ to switch between last two buffers to a more
-- convenient keybinding
--
-- Note: the <leader><leader> keybinding is already used by telescope to switch
-- between buffers.
vim.keymap.set('n', '<leader><leader>', '<C-6>', { desc = 'Switch between last two buffers' })
-- use HL to move to the start or end of a line because 0 and $ are somewhat
-- difficult to reach, especially, shift+4 = $...
vim.keymap.set({ 'n', 'v' }, 'H', '0', { desc = 'Move to the start of the line' })
vim.keymap.set({ 'n', 'v' }, 'L', '$', { desc = 'Move to the end of the line' })

-- ===================== unmap default lsp keymappings from neovim ===============
-- because I only want to have `go refeferences` quickly trigger with `gr`
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')

-- ======================== remap colemak hjkl to neio ========================
-- n is not a big problem. but eio are common keys in vim...
--
-- remap n to the worst of the hjkl colemak positions: j
-- map ei

-- ----------------------- Small utilities for "Insert mode" -----------------------
-- Copy paste from clipboard with the familiar "ctrl+v" command:
-- NOTE: insert mode and normal mode require different keymaps
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true, desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<C-v>', '"*p', { noremap = true, silent = true, desc = 'Paste from system clipboard' })

-- VS-Code: ctrl+backspace to delete the whole line
-- the native Neovim keybinding is <C-u>
vim.keymap.set('i', '<C-BS>', '<C-u>', { desc = 'VS-Code keymap to delete the whole line' })

-- VS-Code: ctrl+enter to move cursor down one line -- WARN: for some reason not working
--
-- vim.keymap.set('i', '<C-Enter>', '<esc>o', { desc = 'VS-Code keymap to go to the next line in insert mode (same as <Esc>o)' })
-- vim.api.nvim_set_keymap('i', '<C-CR>', '<Esc>o', { noremap = true, silent = true }) -- VS-Code: shift+tab to unindent

-- Use the familiar `ctr+b` command in insert mode to make the following text
-- bold in markdown. This command also work in .md files.
-- vim.api.nvim_create_autocmd('File', opts)

-- ===============================================================================================
-- ============================ Markdown and Writing keybindings =================================
-- ===============================================================================================
--
-- NOTE: the remapping for the `gx` command in markdown files is defined in
-- `markview.nvim` because that plugin also patched gx and overwrote the changes
-- I declared in this file.

-- See and select markdown "backlinks" in telescope.
--
-- warn: this is not needed  because the builtin `gr`  already does that.
--
-- Either the marksman or the obsidian-oxide lsp servers should profide the
-- backreferences  necessary to find backlinks.
-- vim.keymap.set('n', '<leader>ml', '<cmd>Telescope lsp_reference', { desc = '[M]arkdown back[L]inks' })

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
-- same for query layout: gk
vim.keymap.set('n', 'gk', function()
  vim.cmd 'silent ?^##\\+\\s.*$'
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
-- same for query layout: gj
vim.keymap.set('n', 'gj', function()
  vim.cmd 'silent /^##\\+\\s.*$'
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

-- unmap the default vim keybinding for `ctrl+f` to open fzf as defined in tmux.
-- vim.keymap.del('n', '<C-f>')

-- NOTE: I added theses keybindings to my .zshrc file (or alternatively in tmux.conf) so I can use them outside of nvim as well.
-- TODO: Maybe I will add it for `insert mode` ('i') too. but `C-f` is also nice
-- for inserting footnotes in markdown... Let's see.
vim.keymap.set(
  { 'n', 'i' },
  '<C-f>',
  '<cmd>silent !tmux neww tmux-sessionizer<CR>',
  { desc = 'Fzf through all your projects and open it with tmux. Inspired by Primegan.' }
)

-- -- PROBLEM: alt-shift is already maped to 'assing-node-to-workspace' in window manager.
-- vim.keymap.set(
--   'n',
--   '<M-n>',
--   '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240527_FPV_functional_programming_TUM<CR>',
--   { desc = 'Quick switch to a different project' }
-- )
-- vim.keymap.set(
--   'n',
--   '<M-e>',
--   "<cmd>silent !tmux neww tmux-sessionizer '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Knowledge_Wiki'<CR>",
--   { desc = 'Quick switch to a different project' }
-- )
-- vim.keymap.set(
--   'n',
--   '<M-i>',
--   '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240510_EIST_software_engineering_TUM<CR>',
--   { desc = 'Quick switch to a different project' }
-- )
-- vim.keymap.set(
--   'n',
--   '<A-o>',
--   '<cmd>silent !tmux neww tmux-sessionizer ~/cUni/240425_ADS_algorithm_data_structures_TUM<CR>',
--   { desc = 'Quick switch to a different project' }
-- )

-- Primegan recommends using zz after ctr-D/U to keep cursor at same position no screen easier for eyes.
-- Source: https://youtu.be/KfENDDEpCsI?si=ClLf3MUgszp1c6op&t=242
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
-- vim.keymap.set('n', '<leader>rs', [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Quickly [S]ubsitute word under curser in current buffer.' })

-- Primegan uses this to open nvim builtin file explorer
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- ================= END ==============================

-- NOTE: open .md in Obsidian was moved to `after/ftplugin/markdown.lua`

-- ======================== Zotero ========================
-- Open current citkey under cursor in zotero
--
-- NOTE: at the moment,  your cursor has to be on the citkey directly i.e. `wangInfluencePoliticalIdeology2022` or
-- `@` but not the rest of the citation block like `p. 43` or `pp. 43-45`.
vim.keymap.set('n', '<leader>mz', function()
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
  --
  -- if not word:match '^%[[@%w+[%w%s%-]*%d+[%w%s%-]*%d*%]?$' then
  --   vim.notify('No citkey found under cursor', vim.log.levels.INFO)
  --   return
  -- end

  -- Extract the citkey
  local citkey = word:sub(2, -2)
  -- print out citkey for debugging
  vim.notify('Extracted Citkey: ' .. citkey, vim.log.levels.INFO)
  -- Open the citkey in Zotero
  local zotero_url = 'zotero://select/items/' .. citkey
  -- open zotero://seleck/items/lippert-rasmussenRawlsLuckEgalitarianism
  vim.system({ 'open', zotero_url }, { text = true }, function(obj)
    if obj.code ~= 0 then
      vim.notify('Error opening in Zotero', vim.log.levels.ERROR)
    end
  end)
end, { desc = 'Open [M]arkdown citkey in [Z]otero' })

-- ======================== Execute script file ========================
-- If this is a script, make it executable, and execute it in a split pane on the right
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set('n', '<leader>f.', function()
  local file = vim.fn.expand '%' -- Get the current file name
  local first_line = vim.fn.getline(1) -- Get the first line of the file
  if string.match(first_line, '^#!/') then -- If first line contains shebang
    local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
    vim.cmd('!chmod +x ' .. escaped_file) -- Make the file executable
    vim.cmd 'vsplit' -- Split the window vertically
    vim.cmd('terminal ' .. './' .. escaped_file) -- Open terminal and execute the file
    vim.cmd 'startinsert' -- Enter insert mode, recommended by echasnovski on Reddit
  else
    vim.cmd "echo 'Not a script. Shebang line not found.'"
  end
end, { desc = "Execute current file in terminal (if it's a script)" })

-- ========================= VS-Code ==================================================
-- Open current file in VS-Code (with the same cursor position!)
-- Keymap is only added for the file types listed below.
--
-- Source: Linkarzu and other Reddit users who suggested improvements:
-- https://www.reddit.com/r/neovim/comments/1ai19ux/execute_current_file_script_using_a_keymap_i_use/
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'css', 'html', 'c', 'cpp' },
  callback = function()
    ---@param root_dir string The root directory of the project
    ---@param file_path string The absolute path of the file to open
    ---@param line_number string|integer The line number to open the file at
    ---@param column_number string|integer The column number to open the file at
    local open_in_vscode = function(root_dir, file_path, line_number, column_number)
      -- IMPORTANT: you must open the root project folder in VS-Code first
      -- before opening the specific file, otherwise extensions, plugins or
      -- vs-code tools might not work.
      -- Open VS Code in the project root first
      vim.cmd('silent !code ' .. root_dir)

      -- Then open the file at the correct position
      vim.cmd('silent !code -g ' .. file_path .. ':' .. line_number .. ':' .. column_number)
    end

    vim.keymap.set('n', 'go', function()
      local file_path = vim.fn.expand '%:p' -- Get absolute file path
      local line_number = vim.fn.line '.' -- Get current cursor line
      local column_number = vim.fn.col '.' -- Get current cursor column

      -- Get the project root directory
      local root_dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

      if vim.v.shell_error ~= 0 or root_dir == nil or root_dir == '' then
        vim.notify('No root directory (git repository) found.\n Using CWD.', vim.log.levels.WARN)
        root_dir = vim.fn.getcwd() -- Fallback to current working directory if no git repo found
      end

      -- Check if the file path is not empty
      if file_path == '' then
        vim.notify('No file path found', vim.log.levels.ERROR)
        return
      end

      -- Open in VS Code
      open_in_vscode(root_dir, file_path, line_number, column_number)
    end, { noremap = true, silent = true, buffer = true, desc = 'Open project in VS Code and navigate to file' })
  end,
})
