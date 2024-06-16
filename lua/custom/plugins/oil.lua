-- TJ DeVries' oil conifig https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/oil.lua
return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        -- See :help oil-columns
        columns = {
          'icon', -- Me: is on by default
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        keymaps = {
          -- NOTE: Most of the keymaps listed here are the default ones
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          -- Tip: you can also use `:e!` to refresh the buffer instead of `C-l`
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['g.'] = 'actions.toggle_hidden',
        },
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = false, -- Default: false
        },
      }

      -- Open parent directory in current window
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Oil: Open parent directory' })

      -- Open parent directory in floating window
      vim.keymap.set('n', '<space>-', require('oil').toggle_float, { desc = 'Oil: Open parent directory in floating window' })
    end,
  },
}
