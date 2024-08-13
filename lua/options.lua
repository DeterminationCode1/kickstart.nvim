--- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Enable true color support in Neovim
vim.opt.termguicolors = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true -- deafault: commented out.

-- Me: set default tab/shift width and policies
-- NOTE: kickstart uses the vim-sleuth plugin to automatically detect tabstop and shiftwidth
-- I'm not sure if it conflicts with the following settings.
-- But it seems like vim-sleuth will overwrite these settings if it detects a different policies
-- and fall back to these settings otherwise.
vim.opt.tabstop = 4 -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4 -- size of each indent level
vim.opt.expandtab = true -- convert tabs to spaces

-- ME: Concela level automatically renders/hides text in e.g. markdown, latex, json files. Some find it very anoying, but the obsidian.nvim plugin requires it at level 1 or 2 for obsidian like pre-rendering of markdown to work.
vim.opt.conceallevel = 2

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time. See nvim docs https://neovim.io/doc/user/options.html#'timeoutlen'
-- Displays which-key popup sooner
-- Me: I think these low values cause sequences like 'gcO' to fail because gc are quick but
-- O then takes more than 300ms. Then the cursor becomes a small bottom line indicating
-- that an invalid sequence was entered.
vim.opt.timeoutlen = 800 -- Kickstarter default: 300 (to open which-key early). Neovim default: 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Me: Maximum width of text that is being inserted. A longer line will be broken
-- after white space to get this width. A zero value disables this.
-- Recommended by Linkarzu: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/options.lua
vim.opt.textwidth = 80

-- =========== Me: spell checking ===========
-- See `:help spell` for detailed information
-- Enable spell checking
vim.opt.spell = true
-- Set the language for spell checking:
-- See `:help spellang` for more information
-- en: (all) English, en_uk: English UK, en_us, de: German, ...
vim.opt.spelllang = { 'en', 'de' } -- (string or list of strings)

vim.opt.spelloptions = 'camel' -- treat camel case words as separate words

-- Toggle spell checking with leader>ts
vim.keymap.set('n', '<leader>ts', ':set spell!<CR>', { desc = '[T]oggle [S]pell checking' })

-- Shortcut to accept the first suggestion for the word under the cursor
-- `ga` was free. It defaults to 'print ascii val under cursor' but I don't use that.
-- NOTE: Maybe extend the above command to also jump back to the last spelling error with `]s` so
-- your cursors doesn't have to be on the exact word?
vim.keymap.set('n', 'ga', '1z=', { desc = '[G]o spelling: [A]ccept the first suggestion for the word under the cursor' })
-- "DevOps Toolbox" Youtuber used the following handy mapping to quickly fix the
-- last spelling error from insert mode: https://youtu.be/oLpGahrsSGQ?si=eyhGVtNq7O0MrPHp&t=360
vim.keymap.set('i', '<C-l>', '<Esc>[s1z=`]a', { desc = 'Fix last spelling error' }) -- FIX: doesn't work?
-- =========== Me: END ===================

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------
-- Mostly copied from Linkarzu's dotfiles: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua

-- official nvim docs: https://neovim.io/doc/user/fold.html
-- Tip: all fold commands start with z, z looks like a folded paper.
-- Useful commands: za toggle fold, zR unfold all, zM fold all
vim.opt.foldmethod = 'indent'
-- By default nvim folds files you open. Set foldleve to high number to not close them by default.
vim.opt.foldlevel = 99

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set('n', '<CR>', function()
  -- Get the current line number
  local line = vim.fn.line '.'
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify('No fold found', vim.log.levels.INFO)
  else
    vim.cmd 'normal! za'
  end
end, { desc = '[P]Toggle fold' })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has 'nvim-0.10' == 1 then
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ''
  else
    vim.opt.foldmethod = 'indent'
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd 'normal! gg'
  -- Get the total number of lines
  local total_lines = vim.fn.line '$'
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match('^' .. string.rep('#', level) .. '%s') then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd 'normal! za'
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd 'nohlsearch'
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for unfolding markdown headings of level 2 or above
vim.keymap.set('n', '<leader>mfu', function()
  -- Reloads the file to reflect the changes
  vim.cmd 'edit!'
  vim.cmd 'normal! zR' -- Unfold all headings
end, { desc = '[P]Unfold all headings level 2 or above' })

-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set('n', '<leader>mfj', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3, 2, 1 }
end, { desc = '[P]Fold all headings level 1 or above' })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set('n', '<leader>mfk', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3, 2 }
end, { desc = '[P]Fold all headings level 2 or above' })

-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set('n', '<leader>mfl', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3 }
end, { desc = '[P]Fold all headings level 3 or above' })

-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set('n', '<leader>mf;', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4 }
end, { desc = '[P]Fold all headings level 4 or above' })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
