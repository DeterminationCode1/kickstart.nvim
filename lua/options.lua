--- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

local opt = vim.opt
-- Enable true color support in Neovim
vim.opt.termguicolors = true

-- required by the plugin 'jaimecgomezz/here.term'
vim.opt.hidden = true -- Enable modified buffers in background

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
vim.opt.wrap = true -- wrap lines that are longer than textwidth
-- vim.opt.columns = 100 -- set the width of the editor to 100 columns -- WARN: not working
-- NOTE: you can use `set columns=100` to make nvim think it's in a 100 column
-- wide terminal. this will wrap text at column 100, but the statusline will be
-- smaller too...

-- =========== My Dignostic settings ===========
-- My current config will show the diganostic message only on the cursor line.
vim.diagnostic.config {
  virtual_lines = false, -- show diagnostic messages in the line below the line with the error. Default false.
  virtual_text = { current_line = true }, -- show diagnostic messages in the line with the error. Default false.
}

-- =========== Me: spell checking ===========
-- See `:help spell` for detailed information
-- Enable spell checking
vim.opt.spell = true
-- Set the language for spell checking:
-- See `:help spellang` for more information
-- en: (all) English, en_uk: English UK, en_us, de: German, ...
-- vim.opt.spelllang = { 'en', 'de' } -- (string or list of strings)
vim.opt.spelllang = { 'en' } -- (string or list of strings)

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
------------------------------ Folding section --------------------------------
-------------------------------------------------------------------------------
-- Mostly copied from Linkarzu's dotfiles: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua

-- official nvim docs: https://neovim.io/doc/user/fold.html
-- Tip: all fold commands start with z, z looks like a folded paper.
-- Useful commands: za toggle fold, zR unfold all, zM fold all
--
-- The following settings were extracted from Linkarzu's config function
local M = {}
M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

-- local function set_foldmethod_expr()
--   -- These are lazyvim.org defaults but setting them just in case a file
--   -- doesn't have them set (because he uses LazyVim?)
--   if vim.fn.has 'nvim-0.10' == 1 then
--     vim.opt.foldmethod = 'expr'
--     -- see lazyvim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua
--     vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
--     vim.opt.foldtext = ''
--   else
--     vim.opt.foldmethod = 'indent'
--     vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
--   end
--   vim.opt.foldlevel = 99
-- end

if vim.fn.has 'nvim-0.10' == 1 then
  -- if false then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'v:lua.Foldexpr()'
  vim.opt.foldtext = ''
else
  vim.opt.foldmethod = 'indent'
  vim.opt.foldtext = 'folded...'
end
-- By default nvim folds files you open. Set foldleve to high number to not close them by default.
vim.opt.foldlevel = 99

function Foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return '0'
  end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= '' then
    return '0'
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == '' then
    return '0'
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return '0'
end

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set('n', '<CR>', function()
  -- Get the current line number
  local line = vim.fn.line '.'
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)

  -- ==========================
  -- me: check if its' a link instead eg [link](url) or [[link]]
  -- Then, open the file link in a new buffer
  -- TODO: make the script more resilient to different link formats
  if vim.fn.matchstr(vim.fn.getline(line), '\\[\\[.*\\]\\]') ~= '' then
    -- get the link text
    local link_text = vim.fn.matchstr(vim.fn.getline(line), '\\[\\[.*\\]\\]')
    -- remove the brackets and add the file extension
    link_text = string.sub(link_text, 3, -3) .. '.md'
    -- open the link
    vim.cmd('edit ' .. link_text)
    -- open the link like with gd assuming that an markdown lsp like marksman is
    -- installed
    -- vim.cmd 'normal! gd'
    return
  end
  -- ==========================

  if foldlevel == 0 then
    -- no fold and no link
    vim.notify('No fold or link found', vim.log.levels.INFO)
  else
    vim.cmd 'normal! za'
  end
end, { desc = '[P]Toggle fold (or open link)' })

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
  -- set_foldmethod_expr()
  -- NOTE: Linkarzu called set_foldmethod_expr()
  -- because he wanted to  make sure lazyvim's automatic fold settings
  -- configuration was indeed set. But because you have full control in
  -- kickstarter and don't dynamically change fold settings.  You don't need to
  -- call it.
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
-- Linkarzu keymap: <leader>mfj
vim.keymap.set('n', '<leader>mfn', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3, 2, 1 }
end, { desc = '[P]Fold all headings level 1 or above' })

-- Keymap for folding markdown headings of level 2 or above
-- Linkarzu keymap: <leader>mfk
vim.keymap.set('n', '<leader>mfe', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3, 2 }
end, { desc = '[P]Fold all headings level 2 or above' })

-- Keymap for folding markdown headings of level 3 or above
-- Linkarzu keymap: <leader>mfl
vim.keymap.set('n', '<leader>mfi', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4, 3 }
end, { desc = '[P]Fold all headings level 3 or above' })

-- Keymap for folding markdown headings of level 4 or above
-- Linkarzu keymap: <leader>mfo
vim.keymap.set('n', '<leader>mfo', function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd 'edit!'
  -- Unfold everything first or I had issues
  vim.cmd 'normal! zR'
  fold_markdown_headings { 6, 5, 4 }
end, { desc = '[P]Fold all headings level 4 or above' })

-------------------------------------------------------------------------------
------------------------------ END Folding section ----------------------------
-------------------------------------------------------------------------------
