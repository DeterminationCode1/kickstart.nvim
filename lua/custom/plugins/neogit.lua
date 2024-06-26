-- repo https://github.com/NeogitOrg/neogit
-- Description: Neovim frontend for Git
-- Keymaps inspired by https://github.com/omerxx/dotfiles/blob/62c1c535fdf0bd33b8ae62e0ac1122db2866492e/nvim/lua/plugins/neogit.lua

-- To understand some of the git keymaps here, you should know what the individual flags mean
--
-- Committing: see `git commit --help | less`
--  -a (--all) to automatically "add" changes from all known files (i.e. all files that are already
--     listed in the index) and to automatically "rm" files in the index
--     that have been removed from the working tree, and then perform the
--     actual commit;
--  -v (--verbose) to show the diff of what would be committed after the commit message is given.
--     To help the user write better commit messages.

return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim', -- optional
  },
  config = function(_, opts)
    -- This contains mainly Neogit but also a bunch of Git settings
    -- like fetching branches with telescope or blaming with fugitive
    local neogit = require 'neogit'
    neogit.setup(opts)

    vim.keymap.set('n', '<leader>gs', neogit.open, { silent = true, noremap = true, desc = 'Git: Open "Status Menu"' })

    -- The alias i used before was: git log --all --graph --decorate --oneline
    vim.keymap.set(
      'n',
      '<leader>gl',
      -- Is '--all' better than 'max-count=254'
      neogit.action('log', 'log_all_branches', { '--max-count=254', '--graph', '--decorate', '--oneline', '--color' }),
      { silent = true, noremap = true, desc = 'Git: log all branches as concise graph' }
    )

    -- Docs neogit: You can skip the popup menu and call actions directly with:
    -- neogit.action({popup}, {action}, {args})                       *neogit.action()*
    --     Call an action without going through the popup interface.
    --     NOTE: Some actions might not play nicely when being invoked this way.
    --           You've been warned. >lua
    --
    -- Example:
    -- Calls the "commit" action from the "commit" popup, with arguments
    -- vim.keymap.set('n', '<leader>gcc', neogit.action('commit', 'commit', { '--verbose', '--all' }))

    -- Commit all staged changes with verbose output
    vim.keymap.set('n', '<leader>gc', neogit.action('commit', 'commit', { '--verbose' }), { desc = 'Git: Commit all staged changes with verbose output' })
    vim.keymap.set('n', '<leader>gcc', '<cmd>Neogit commit<CR>', { silent = true, noremap = true, desc = 'Git: open "Commit Menu"' })

    vim.keymap.set('n', '<leader>gP', '<cmd>Neogit pull<CR>', { silent = true, noremap = true, desc = 'Git: open Pull' })

    vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<CR>', { silent = true, noremap = true, desc = 'Git: open Push' })

    vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', { silent = true, noremap = true, desc = 'Git: List branches' })

    -- vim.keymap.set('n', '<leader>gB', ':G blame<CR>', { silent = true, noremap = true }) -- Me: I don't use fugitive
  end,
}
