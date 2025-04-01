-- repo https://github.com/hedyhli/outline.nvim
-- inspired by LazyVim outline config https://www.lazyvim.org/extras/editor/outline
--
-- Important keyboard shortcuts available in the outline window:
-- - Esc / q: Close the outline window
-- - Enter: Go to symbol location in code
-- - o: peek_location, Jump to symbol under cursor but keep focus on outline window.
-- - Shift + Enter: goto_and_close, Go to symbol location in code and close outline window
-- - Shit + Tab: toggle all folds
-- - K: toggle_preview, Preview location code of the symbol under cursor

return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = { -- Example mapping to toggle outline
    -- TODO: maybe use <leader>to instead and use <leader>o for something more important?
    -- Yes,  decided to use  <leader>o for opening toggleterm instead. ME: now I
    -- am using ctrl-/ for toggeling the terminal and <leader>o for outline
    -- again.
    { '<leader>to', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
    -- Your setup opts here
    keymaps = {
      up_and_jump = '<up>',
      down_and_jump = '<down>',
    },
  },
}
