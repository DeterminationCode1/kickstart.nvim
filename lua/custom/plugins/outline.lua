-- repo https://github.com/hedyhli/outline.nvim
-- inspired by LazyVim outline config https://www.lazyvim.org/extras/editor/outline
return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = { -- Example mapping to toggle outline
    -- TODO: maybe use <leader>to instead and use <leader>o for something more important?
    { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
    -- Your setup opts here
    keymaps = {
      up_and_jump = '<up>',
      down_and_jump = '<down>',
    },
  },
}
