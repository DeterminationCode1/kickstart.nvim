-- repo: https://github.com/akinsho/toggleterm.nvim
--
-- Usage
-- - Open the terminal with <c-\>
-- - Close the terminal with <c-\>
-- - Open third terminal with 3<c-\>
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
    -- WARN: open_mapping caused bugs with mapping being set in insert mode. just defint you own mapping instead
    --
    -- mnemonic: open terminal. easier to type than <c-\> or <leader>te
    -- open_mapping = '<leader>o', -- or { [[<c-\>]],
    direction = 'tab', -- Default: 'horizontal'
    -- if  open_mappings should be available in insert mode
    insert_mappings = false, -- Default: true
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    vim.keymap.set({ 'n' }, '<leader>o', '<Cmd>execute v:count . "ToggleTerm"<CR>', {
      desc = 'Toggle Terminal',
      silent = true,
    })
    -- Optional, you can create a different mapping for
    vim.keymap.set('i', '<C-o>', '<Esc><Cmd>ToggleTerm<CR>', {
      desc = 'Toggle Terminal',
      silent = true,
    })

    -- NOTE: Me: this was copy pasted from kickstart init.lua
    --
    -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
    -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
    -- is not what someone will guess without a bit more experience.
    --
    -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
    -- or just use <C-\><C-n> to exit terminal mode
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
}
