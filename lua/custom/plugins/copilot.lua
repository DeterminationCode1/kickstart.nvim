-- https://github.com/github/copilot.vim
return {
  'github/copilot.vim',

  config = function()
    -- Tip: all copilot commands use the syntax `:Copilot <command>`

    -- Toggle copilot on and off. These is no default toggle command.
    -- But you can combine `:Copilot enable` and `:Copilot disable` to create a toggle command
    -- and track the state in a variable.
    -- SOURCE: https://www.reddit.com/r/neovim/comments/w2exp5/comment/j1cum3d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    -- Because there doesn't seem to be a way to check if copilot is enabled or not, we have to assume it's enabled by default.
    local copilot_on = true
    vim.api.nvim_create_user_command('CopilotToggle', function()
      if copilot_on then
        vim.cmd 'Copilot disable'
        print 'Copilot OFF'
      else
        vim.cmd 'Copilot enable'
        print 'Copilot ON'
      end
      copilot_on = not copilot_on
    end, { nargs = 0 })

    vim.keymap.set('n', '<leader>tc', '<cmd>CopilotToggle<CR>', { desc = 'Toggle [C]opilot', noremap = true, silent = true })
  end,
}
