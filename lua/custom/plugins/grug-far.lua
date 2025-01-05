-- https://github.com/MagicDuck/grug-far.nvim
-- LazyNvim uses this grug-far config: https://www.lazyvim.org/plugins/editor#grug-farnvim
--
-- Grug-far is a plugin to simply search and replace text in your whole code
-- base.
--
-- Usage:
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
    {
      '<leader>rs', -- LazyVim uses <leader>rs  (but that is already "resume search" in telescope)
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
      desc = 'Search and Replace',
    },
  },
}
