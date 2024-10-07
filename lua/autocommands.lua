-- My custom autocommands for Neovim

-- =================== Espanso ===================
-- Only activate the Espanso text snippet engine when in insert mode.
--
-- Requirements when using Tmux:
--    Make sure you have `focus-events` turned on in your `tmux.conf`. Otherwise the
--    focus events won't be sent to Neovim and Espanso won't be
--    activated / deactivated based on app focus:
--    `set -g focus-events on`

-- deactivate Espanso when leaving insert mode.
-- CmdlineEnter, TermOpen, TermEnter are not needed
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Deactivate espanso when leaving insert mode',
  group = vim.api.nvim_create_augroup('espanso-deactivate', { clear = true }),
  callback = function()
    vim.system({ 'espanso', 'cmd', 'disable' }, { text = true }, function(obj)
      vim.notify('Espanso deactivated', 'debug', { title = 'Espanso' })
    end)
  end,
})

-- deactivate Espanso when the nvim application gains focus, but only if it's
-- not in insert mode.
vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Deactivate espanso when neovim gains focus',
  group = vim.api.nvim_create_augroup('espanso-deactivate-focus', { clear = true }),
  callback = function()
    if vim.api.nvim_get_mode().mode ~= 'i' then
      vim.system({ 'espanso', 'cmd', 'disable' }, { text = true }, function(obj)
        vim.notify('Espanso deactivated', 'debug', { title = 'Espanso' })
      end)
    end
  end,
})

-- activate Espanso when entering insert mode or when nvim is not the active
-- application (focus lost, i.e. another app is in focus).
vim.api.nvim_create_autocmd({ 'InsertEnter', 'FocusLost' }, {
  desc = 'Activate espanso when entering insert mode',
  group = vim.api.nvim_create_augroup('espanso-activate', { clear = true }),
  callback = function()
    vim.system({ 'espanso', 'cmd', 'enable' }, { text = true }, function(obj)
      vim.notify('Espanso activated', 'debug', { title = 'Espanso' })
    end)
  end,
})
-- =================== END - Espanso ===================

-- ================ Capitalize first letter of a sentence ================
-- Capitalize the first letter of a sentence.
--
-- The script was inspired by the David Moody's vim script:  https://davidxmoody.com/2015/vim-auto-capitalisation/

vim.api.nvim_create_autocmd('InsertCharPre', {
  group = vim.api.nvim_create_augroup('capitalize-first-char', { clear = true }),
  pattern = '*', -- Match all filetypes
  -- pattern = {'*.md', '*.txt', '*.yml', '*.yaml'} -- Match specific filetypes if needed
  callback = function()
    -- Define a list of common abbreviations to exclude
    local abbreviations = { 'e.g.', 'i.e.', 'etc.', 'vs.', 'Dr.' } -- 'Mr.', 'Ms.', 'Mrs.'

    -- Get the current line up to the cursor position
    local line = vim.fn.getline('.'):sub(1, vim.fn.col '.' - 1)

    -- Check if the current word matches any of the abbreviations
    local is_abbreviation = false
    for _, abbr in ipairs(abbreviations) do
      if line:match(vim.pesc(abbr) .. '%s*$') then
        is_abbreviation = true
        break
      end
    end

    -- Continue with capitalization only if not an abbreviation
    if not is_abbreviation then
      local pos = vim.fn.search([[\v(%^|[.!?]\_s+|\_^\-\s|\_^title\:\s|\n\n)%#]], 'bcnw')
      if pos ~= 0 then
        -- Convert the character to uppercase
        vim.v.char = string.upper(vim.v.char)
      end
    end
  end,
})
-- ================ END - capitalize ================

-- ================ Remove whitespace - extra rules ================
-- the prettier formatter catches most unnecessary whitespace, but some
-- edge caught are and are removed by this autocmd instead.

-- Custom whitespace cleanup rules that are not handled by the prettier formatter for markdown files
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('cleanup-whitespace', { clear = true }),
  pattern = { '*.md', '*.txt' }, -- Match specific filetypes
  callback = function()
    -- Save the current cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- -- Remove trailing spaces at the end of lines
    -- -- NOTE: This is already done by Prettier
    -- vim.cmd [[%s/\s\+$//e]]

    -- Remove spaces BEFORE punctuation marks: . ! ? , ; :
    -- e.g. "Hello . World" -> "Hello. World"
    --
    -- edge case: code notes in markdown files like `stow .` become `stow.`
    --    workaround: escapee the dot with a backslash. The code will still run
    --    in the terminal, but the space is not removed: `stow \.` -> `stow \.`
    vim.cmd [[silent! %s/\s\+\([.,!?:;]\)/\1/g]]

    -- -- Replace multiple spaces between words with a single space
    -- -- -- NOTE: This is already done by Prettier
    -- vim.cmd [[%s/\s\{2,}/ /g]]

    -- Restore the cursor position after the substitution
    vim.api.nvim_win_set_cursor(0, { row, col })
  end,
})
-- ================ END - remove whitespace ================
