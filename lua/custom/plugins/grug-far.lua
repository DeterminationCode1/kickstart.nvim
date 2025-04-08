-- https://github.com/MagicDuck/grug-far.nvim
-- LazyNvim uses this grug-far config: https://www.lazyvim.org/plugins/editor#grug-farnvim
--
-- Grug-far is a plugin to simply search and replace text in your whole code
-- base.
--
-- =============== Usage: ===================================================
--
-- <leader>rs: Start the search and replace with your keybinding
--
-- Once you opened the search and replace window, you can use the following
-- local mappings:
-- TIP: you can remove some of the search results from the replace action by
-- deleting the line manually in preview with `dd`.
-- <leader>r: Replace the current match (me: and ignores any manual changes you
-- added to the bottom match results preview)
-- <leader>s: Sync all shown changes to their original files (me: respecting all
-- the manual adjustments you made in the bottom match results preview window)
-- <leader>l: line sync. Sync only the current line to its original file.
-- <leader>j: on a match preview line will apply its changes and remove it from
-- the preview window and move your cursor to the next match below
-- <leader>k: on a match preview line will apply its changes and remove it from
-- the preview window and move your cursor to the previous match above
--
-- Seeing more context for the match:
-- <leader>o: Preview the file where the match is located but stay in the search
-- buffer
-- <enter>: Open the file where the match is located
--
-- <leader>c: Close the search and replace window
return {
  'MagicDuck/grug-far.nvim',
  opts = { headerMaxWidth = 80 },
  cmd = 'GrugFar',
  keys = {
    { -- I previously used <leader>rs
      '<leader>sr', -- LazyVim uses <leader>sr  (but that is already "resume search" in telescope)
      function()
        local grug = require 'grug-far'
        local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
        grug.open {
          transient = true,
          prefills = {
            -- explanation: pre-populate the search filter config with the file
            -- type the search was called in, e.g. *.md glob when searching from a
            -- .md file.
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        }
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace (Grug-far)',
    },

    -- Launch grug-far with search/replace limited to the  current file
    --
    -- official recipes copy pasted: https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#launch-limiting-searchreplace-to-current-file
    --
    -- INFO: the default recipe didn't work because I use filename with `spaces`
    -- in my markdown files that were not automatically escaped correctly and
    -- cause ripgrep to not find the file.
    {
      '<leader>sR', -- because `sr` is already the default replace, sR is for rare case replaces
      -- sR was also used by LazyVim for `picker search resume` but I never used it
      function()
        local file_path = vim.fn.expand '%'
        -- NOTE: my fix to escape spaces in filenames. Replace spaces with '\ '
        file_path = file_path:gsub(' ', '\\ ')
        require('grug-far').open { prefills = { paths = file_path } }
      end,
      desc = 'Search and Replace in current file ([R]replace in current [F]ile)',
    },
  },

  config = function()
    -- set up grug-far.nvim
    require('grug-far').setup {}

    -- Set <localleader> to `,` because its too risky accidentally hit commands
    -- that replace words in all files if the local leader is `<sapce>`
    -- config docs grug-far: https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    -- WARNING: the localleader must be configured before lazy is started.
    -- vim.g.maplocalleader = ','

    -- Create a buffer local keybinding to open a result location and immediately close grug-far.nvim
    --
    -- official docs recipes: https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#create-a-buffer-local-keybinding-to-open-a-result-location-and-immediately-close-grug-farnvim
    -- me: FIX: doesn't seem to work?
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
      pattern = { 'grug-far' },
      callback = function()
        -- (where <localleader>o and <localleader>c are the default keybindings for Open and Close actions. You will need to change them if you set them to something different)
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-enter>', '<localleader>o<localleader>c', {})
      end,
    })

    -- Launch grug-far with search/replace limited to the  current file
    --
    -- official recipes copy pasted: https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#launch-limiting-searchreplace-to-current-file
    --
    -- INFO: the default recipe didn't work because I use filename with `spaces`
    -- in my markdown files that were not automatically escaped correctly and
    -- cause ripgrep to not find the file.
    -- vim.keymap.set('n', '<leader>rf', function()
    --   local file_path = vim.fn.expand '%'
    --   -- NOTE: my fix to escape spaces in filenames. Replace spaces with '\ '
    --   file_path = file_path:gsub(' ', '\\ ')
    --   require('grug-far').open { prefills = { paths = file_path } }
    -- end, { desc = 'Search and Replace in current file ([R]replace in current [F]ile)' })
  end,
}
