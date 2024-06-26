-- repo: https://github.com/akinsho/toggleterm.nvim
--
-- Usage
-- - Open the terminal with <c-\>
-- - Close the terminal with <c-\>
-- - Open 3 terminal with 3<c-\>
-- - To use normal vim motions in the terminal, you must first exit terminal mode with
--   <ESC><ESC> as you mapped it to it.
--
-- This is the default config. Found by using gd on requries('toggleterm')
-- local config = {
--   size = 12,
--   shade_filetypes = {},
--   hide_numbers = true,
--   shade_terminals = true,
--   insert_mappings = true,
--   terminal_mappings = true,
--   start_in_insert = true,
--   persist_size = true,
--   persist_mode = true,
--   close_on_exit = true,
--   direction = 'horizontal',
--   shading_factor = constants.shading_amount,
--   shell = vim.o.shell,
--   autochdir = false,
--   auto_scroll = true,
--   winbar = {
--     enabled = false,
--     name_formatter = function(term)
--       return fmt('%d:%s', term.id, term:_display_name())
--     end,
--   },
--   float_opts = {
--     winblend = 0,
--     title_pos = 'left',
--   },
-- }
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    -- mnemonic: open terminal. easier to type than <c-\> or <leader>te
    open_mapping = '<leader>o', -- or { [[<c-\>]],
    direction = 'tab', -- Default: 'horizontal'
    -- if  open_mappings should be available in insert mode
    insert_mappings = false, -- Default: true
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    -- Optional, you can create a different mapping for
    vim.keymap.set('i', '<C-o>', '<Esc><Cmd>ToggleTerm<CR>', {
      desc = 'Toggle Terminal',
      silent = true,
    })
  end,
}

