-- tailwind-tools.lua
-- https://github.com/luckasRanarison/tailwind-tools.nvim?tab=readme-ov-file
return {
  'luckasRanarison/tailwind-tools.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- your configuration
  ---@type TailwindTools.Option
  opts = {
    document_color = {
      enabled = true, -- can be toggled by commands
      kind = 'inline', -- "inline" | "foreground" | "background"
      inline_symbol = '󰝤 ', -- only used in inline mode
      debounce = 200, -- in milliseconds, only applied in insert mode
    },
    conceal = {
      enabled = false, -- can be toggled by commands
      min_length = nil, -- only conceal classes exceeding the provided length
      symbol = '󱏿', -- only a single character is allowed
      highlight = { -- extmark highlight options, see :h 'highlight'
        fg = '#38BDF8',
      },
    },
    custom_filetypes = {}, -- see the extension section to learn how it works
  },
  -- keybindings
  keys = {
    { '<leader>tt', '<CMD>TailwindConcealToggle<CR>', { desc = '[T]oggle [T]ailwindCSS conceal' } },
  },
  --
  -- config = function()
  -- WARN: If you want to use the conf function, you must call the setup function first here!

  --   -- vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Oil: Open parent directory' })
  --   vim.keymap.set('n', '<leader>tt', '<CMD>TailwindConcealToggle<CR>', { desc = '[T]oggle [T]ailwindCSS conceal' })
  -- end,
}
