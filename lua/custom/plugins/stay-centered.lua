-- https://github.com/arnamak/stay-centered.nvim
--
-- Always center the cursor in the middle of the screen automatically
-- regardless of what you are doing.
--
-- Plugin was recommended by Linkarzu:
-- https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/stay-centered.lua
return {
  {
    'arnamak/stay-centered.nvim',
    opts = function()
      require('stay-centered').setup {
        -- Add any configurations here, like skip_filetypes if needed
        -- skip_filetypes = {"lua", "typescript"},
      }
      -- Define the keymap to toggle the stay-centered plugin
      -- I had to move this keymap here inside, otherwise the plugin started
      -- disabled if I set the keymap outside under "keys"
      vim.keymap.set('n', '<leader>tS', function()
        require('stay-centered').toggle()
        vim.notify('Toggled stay-centered', vim.log.levels.INFO)
      end, { desc = 'Toggle [s]tay-centered.nvim' })
    end,
  },
}
