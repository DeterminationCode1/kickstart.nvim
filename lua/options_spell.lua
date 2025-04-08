-- Also read official Neovim docs:  https://neovim.io/doc/user/spell.html
-- See `:help spell` for detailed information
--
-- supersstmnusttrsffd
--
-- Enable spell checking
vim.opt.spell = true
-- Set the language for spell checking:
-- See `:help spelling` for more information
-- en: (all) English, en_UK: English UK, en_us, de: German, ...
-- vim.opt.spelling = { 'en', 'de' } -- (string or list of strings)
vim.opt.spelllang = { 'en' } -- (string or list of strings)

vim.opt.spelloptions = 'camel' -- treat camel case words as separate words

-- Toggle spell checking with leader>ts
-- BE aware: you cannot add whickey in the options file because lazy-plugins are
-- not loaded yet? Instead, define the group directly in which-key
-- vimk.keymap.set('n', '<leader>ts', '', { desc = '+ spell checking' }) -- for which-key
vim.keymap.set('n', '<leader>tss', ':set spell!<CR>', { desc = '[T]oggle [S]pell checking' })

local fix_last_spelling_error = function()
  -- official nvim docs:  returns bad words in the current line or sentence and move the cursor to
  -- the start of the last bad word
  --
  -- Without argument: The result is the badly spelled word under or after the cursor.
  -- The cursor is moved to the start of the bad word.
  -- When no bad word is found in the cursor line the result is an empty string
  -- and the cursor doesn't move.

  -- my test would for errors 'false' fatal reason again more or why can that be
  -- so
  local badword = vim.fn.spellbadword()[1]

  if badword == '' then
    -- No error under cursor
    vim.notify('No spelling error under cursor. Jumping to previous spelling error...', vim.log.levels.INFO)
    vim.cmd 'normal! [s'

    -- Try again at the new position
    badword = vim.fn.spellbadword()[1]
    if badword == '' then
      vim.notify('No previous spelling error found.', vim.log.levels.INFO)
      return
    end
  else
    vim.notify('Fixing spelling error under cursor: ' .. badword, vim.log.levels.INFO)
  end

  -- Apply first suggestion
  vim.cmd 'normal! 1z='
  vim.notify('Applied first spelling suggestion.', vim.log.levels.INFO)
end

-- Shortcut to accept the first suggestion for the word under the cursor
-- `Ga` was free. It defaults to 'print ASCII val under cursor' but I don't use that.
-- vim.key map.set('n', 'Ga', '1z=', { desk = '[G]o spelling: [A]accept the first suggestion for the word under the cursor' })
vim.keymap.set('n', 'ga', fix_last_spelling_error, { desc = '[G]o spelling: Fix next spelling error' })

-- NOTE: maybe use the function about instead of the first part of the following
-- code. Only the last line is significantly different.
-- TODO: entering normal mode temporarily seems to trigger autoformatted which
-- removes the space at the end of the line.
vim.keymap.set('i', '<C-g>', function()
  -- if the current word has no error jump back
  if not vim.fn.spellbadword()[1] ~= '' then
    -- Jump to the previous spelling error
    vim.cmd 'normal! [s'
  end
  -- fix the current word with the first suggestion
  vim.cmd 'normal! 1z='

  -- Go back to end of line in insert mode
  vim.cmd 'normal! A'
end, { desc = '[G]o spelling: Fix next spelling error' })

-- =======================================================================================
-- ============================ Spell checker ==========================================
-- =======================================================================================

local ns_id = vim.api.nvim_create_namespace 'ghost-spell-suggest'
local ignored_words = {} ---@type string[]
local current_ignore_path = nil

-- ============================================
-- ================ HELPERS ===================
-- ============================================

-- Get root dir of the project (using LSP root or fallback to cwd)
local function get_root_dir()
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end
  return vim.fn.getcwd()
end

-- Returns a table like { ["teh"] = true, ["somthing"] = true }
local function load_ignored_words_for_file()
  local file_path = vim.api.nvim_buf_get_name(0)
  local project_root = vim.fn.getcwd()
  local filename = file_path:gsub(project_root .. '/', ''):gsub('/', '%%')
  local spelling_dir = project_root .. '/.spelling'
  local ignore_file = spelling_dir .. '/' .. filename

  local words = {}
  if vim.fn.filereadable(ignore_file) == 1 then
    for _, line in ipairs(vim.fn.readfile(ignore_file)) do
      words[line] = true
    end
  end
  return words
end

-- Append to ignore file
local function add_to_ignore_file(word)
  local file_path = vim.api.nvim_buf_get_name(0)
  local project_root = vim.fn.getcwd()
  local filename = file_path:gsub(project_root .. '/', ''):gsub('/', '%%')
  local spelling_dir = project_root .. '/.spelling'
  local ignore_file = spelling_dir .. '/' .. filename

  vim.fn.mkdir(spelling_dir, 'p')
  vim.fn.writefile({ word }, ignore_file, 'a') -- Append mode
end

-- Check if a word is part of a URL
local function is_url_in_line(badword)
  local line = vim.fn.getline '.'
  if line:match 'https?://' then
    vim.notify('⏭️ Skipped URL: ' .. badword, vim.log.levels.INFO)
    return true
  end
  return false
end

-- ============================================
-- ============= INTERACTIVE LOGIC ============
-- ============================================

local function interactive_spellcheck()
  local function next_error()
    vim.cmd 'normal! ]s'
    local badword = vim.fn.spellbadword()[1]

    if badword == '' then
      vim.notify('✅ Spellcheck complete. No more errors.', vim.log.levels.INFO)
      return
    end

    local ignored_words_set = load_ignored_words_for_file()
    if is_url_in_line(badword) or ignored_words_set[badword] then
      next_error()
      return
    end

    local suggestions = vim.fn.spellsuggest(badword)
    local top_suggestion = suggestions[1] or 'X'

    local success, err = pcall(function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

      vim.api.nvim_buf_set_extmark(0, ns_id, row, col, {
        end_col = col + #badword,
        hl_group = 'SpellBadWord',
      })

      local ghost_row = row > 0 and row - 1 or row + 1
      vim.api.nvim_buf_set_extmark(0, ns_id, ghost_row, col, {
        virt_text = { { top_suggestion, 'SpellGhostText' } },
        virt_text_pos = 'inline',
      })
    end)

    if not success then
      vim.notify('⚠️ Failed to highlight "' .. badword .. '": ' .. err, vim.log.levels.WARN)
    end

    local Snacks = require 'snacks'
    Snacks.input.input({
      prompt = 'Accept suggestion (enter), edit manually, "i" to ignore, or leave blank to skip:',
      default = top_suggestion,
    }, function(input)
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

      if input == nil then
        vim.notify('❌ Spellcheck cancelled.', vim.log.levels.WARN)
        return
      end

      if input == '' then -- input == 'i' or
        vim.notify('⏭️ Ignored "' .. badword .. '"', vim.log.levels.INFO)
        ignored_words_set[badword] = true
        add_to_ignore_file(badword)
      elseif input ~= '' then
        -- NOTE: I use 'ciW' and not 'ciw' because a bad word can contain an
        -- `'` like `vim'y` or `Neovim's` which could not fixed otherwise.
        vim.cmd('normal! ciW' .. input)
      end

      next_error()
    end)
  end

  local function main()
    vim.keymap.set('i', '<PageDown>', function()
      local ctrl_u = vim.api.nvim_replace_termcodes('<c-u>', true, true, true)
      local enter = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
      vim.api.nvim_feedkeys(ctrl_u .. enter, 'i', false)
    end, { desc = '[S]kip current spelling error on [PageDown]' })

    vim.cmd 'normal! gg'
    next_error()
  end

  main()
end

-- Keymap
vim.keymap.set('n', '<leader>tsa', interactive_spellcheck, {
  desc = 'Spell Checker (interactive)',
})

-- Highlight groups
vim.cmd [[highlight SpellGhostText guifg=#01ff00 gui=bold]]
vim.cmd [[highlight SpellBadWord guifg=#cf1d6a gui=bold]]
