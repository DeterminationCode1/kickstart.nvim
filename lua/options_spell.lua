-- Also read official Neovim docs:  https://neovim.io/doc/user/spell.html
-- See `:help spell` for detailed information.
--
-- NOTE: some additional plugins in your `lua/languages/markdown/` folder
-- install additional language dictionaries for e.g. "Programming technical terms":
-- - vim-dirtytalk
-- - academic.nvim https://github.com/ficcdaf/academic.nvim/tree/main could be
--   interesting in the future too

-- Enable spell checking
vim.opt.spell = true
-- Set the language for spell checking:
-- See `:help spelling` for more information
-- en: (all) English, en_UK: English UK, en_us, de: German, ...
-- vim.opt.spelling = { 'en', 'de' } -- (string or list of strings)
vim.opt.spelllang = { 'en' } -- (string or list of strings)

vim.opt.spelloptions = 'camel' -- treat camel case words as separate words

-- key code prefix for all spelling related keybindings
local prefix = '<leader>ts'

-- =====================================================================
-- ==================== Basic functionality key maps ====================
-- ===================================================================

-- Toggle spell checking
-- BE aware: you cannot add which-key in the options file because lazy-plugins are
-- not loaded yet? Instead, define the group directly in which-key
-- vimk.keymap.set('n', '<leader>ts', '', { desc = '+ spell checking' }) -- for which-key
vim.keymap.set('n', prefix .. 's', ':set spell!<CR>', { desc = '[T]oggle [S]pell checking' })

-- Add word to the spelling dictionary
-- Neovim's built-in keybinding is `zg`. Now, the word will no longer be marked as wrong
vim.keymap.set('n', prefix .. 'a', 'zg', { desc = '[A]dd good word to dictionary', noremap = true })
-- Add word to the spelling dictionary
-- Neovim's built-in keybinding is `zw`. Now, the word will be marked as incorrect.
vim.keymap.set('n', prefix .. 'b', 'zw', { desc = 'Add [B]ad word to dictionary', noremap = true })
-- Remove word from the spelling dictionary
-- Neovim's built-in keybinding is `zug`. Now, the word will be marked as incorrect.
vim.keymap.set('n', prefix .. 'ua', 'zug', { desc = 'Remove (good) word from dictionary. (Undo the last "add good woord `zg`")', noremap = true })
-- Remove word from the spelling dictionary
-- Neovim's built-in keybinding is `zuw`. Now, the word will be marked as correct.
vim.keymap.set('n', prefix .. 'ub', 'zuw', { desc = 'Delete (bad) word from dictionary. (Undo the last "add bad word `zw`")', noremap = true })

-- ================================================================
-- =================== Fix spelling errors ========================
-- ================================================================

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

    -- FIX: at the moment, the function runs infinitely if only "ignored" words
    -- are remaining because the "badword" is not empty but always the
    -- nex_error() is called because the word is ignored.
    --
    -- possible solutions: parse all spelling error of the whole file first and
    -- track when only ignored words are left. That would also be a foundation
    -- for building a "accept all corrections for similar words" feature.
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
      prompt = 'Accept suggestion (enter), edit manually, "" to ignore, or leave blank to skip:',
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
vim.keymap.set('n', prefix .. 'c', interactive_spellcheck, {
  desc = 'Spell [C]hecker (interactive)',
})

-- Highlight groups
vim.cmd [[highlight SpellGhostText guifg=#01ff00 gui=bold]]
vim.cmd [[highlight SpellBadWord guifg=#cf1d6a gui=bold]]

-- =========================================================
-- ============== Switch between languages ================
-- ========================================================

---@param lang 'en'|'de' supported ISO-2-letter country codes
local sawp_language_snippets_cli = function(lang)
  -- Set snippets to the new language by calling my custom CLI
  --
  -- `:wait()` is needed to make it synchronous
  local result = vim
    .system({
      'snippets_swap_languages',
      lang,
    }, { text = true }, function(result)
      -- print stdout, shows the CLI debug messages. Very helpful.
      -- vim.notify('Snippets language set to ' .. lang .. ': ' .. result.stdout, vim.log.levels.INFO)
    end)
    :wait()

  if result.code ~= 0 then
    vim.notify('Error setting snippets to ' .. lang .. ': ' .. result.stderr, vim.log.levels.ERROR)
    return
  end
end

-- reload my custom Lua snippets
local reload_snippets = function()
  require('luasnip.loaders.from_lua').load { paths = { '~/.config/nvim/LuaSnip/' } }
end

local ALL_MY_LANGUAGES = { 'en', 'de' }

---@param lang 'en'|'de'
local add_spell_language = function(lang)
  -- Add the language to the list of languages
  local current_languages = vim.opt.spelllang:get()
  if not vim.tbl_contains(current_languages, lang) then
    table.insert(current_languages, lang)
    vim.opt.spelllang = current_languages
  end
end

---@param lang 'en'|'de'
local remove_spell_language = function(lang)
  -- Remove the language from the list of languages
  local current_languages = vim.opt.spelllang:get()
  if vim.tbl_contains(current_languages, lang) then
    table.remove(current_languages, vim.fn.index(current_languages, lang))
    vim.opt.spelllang = current_languages
  end
end

-- remove all ALL_MY_LANGUAGES `ALL_MY_LANGUAGES` list.
-- because some special languages like `programming` should always remain
---@param lang 'en'|'de'
local remove_all_spell_languages_besides = function(lang)
  -- Remove all languages from the list of languages
  local current_languages = vim.opt.spelllang:get()

  for _, l in ipairs(ALL_MY_LANGUAGES) do
    if l ~= lang then
      remove_spell_language(l)
    end
  end

  -- Add the language to the list of languages
  add_spell_language(lang)
end

-- Set spelling and snippets to English
vim.keymap.set('n', prefix .. 'e', function()
  -- Set spelling language to English
  -- add_spell_language 'en'
  remove_all_spell_languages_besides 'en'

  -- Set snippets to English by calling my custom CLI
  sawp_language_snippets_cli 'en'

  -- reload my custom Lua snippets
  reload_snippets()

  vim.notify('Snippets language set to English', vim.log.levels.INFO)
end, { desc = 'Set spelling and snippets to [E]nglish' })

-- Set spelling and snippets to German
vim.keymap.set('n', prefix .. 'd', function()
  -- Set spelling language to German
  -- vim.opt.spelllang = { 'de' }
  remove_all_spell_languages_besides 'de'

  -- Set snippets to German by calling my custom CLI
  sawp_language_snippets_cli 'de'

  -- reload my custom Lua snippets
  reload_snippets()

  vim.notify('Snippets language set to German', vim.log.levels.INFO)
end, { desc = 'Set spelling and snippets to [D]eutsch' })
