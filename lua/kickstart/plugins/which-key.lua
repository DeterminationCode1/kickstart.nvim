-- which-key: A plugin for displaying keybindings in Neovim
--
-- kickstart https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/treesitter.lua

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        -- -------------- my groups ==================
        { '<leader>m', group = '[M]arkdown' }, -- me
        { '<leader>mf', group = 'Markdown [F]old' }, -- me
        { '<leader>tn', group = '[N]otifications' }, -- me
        { '<leader>n', group = 'Next item' }, -- me
        { '<leader>o', group = 'Overseer' }, -- me
        { '<leader>g', group = 'Git tools' }, -- me
        { '<leader>ts', group = 'Spelling' },
        -- ------------- LazyVim -----------------
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
      }
    end,
  },
}
