-- repo https://github.com/NeogitOrg/neogit
-- Description: Neovim frontend for Git. See `h: neogit` for more info.
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

    -- Originally, I used '<leader>gs', but because it was very often used and
    -- `ge` was never uesed for "go back previous end of word" as the motion "be" is easier.
    -- So I changed it to `ge`. The old <leader>gs is still
    -- available in case you forgot the binding and just remember <leader>g for
    -- 'git'
    vim.keymap.set('n', 'ge', neogit.open, { silent = true, noremap = true, desc = 'Git: Open "Status Menu"' })
    vim.keymap.set('n', '<leader>gs', neogit.open, { silent = true, noremap = true, desc = 'Git: Open "Status Menu"' })

    -- The alias I used before was: git log --all --graph --decorate --oneline
    vim.keymap.set(
      'n',
      '<leader>gl',
      -- Is '--all' better than 'max-count=254'
      neogit.action('log', 'log_all_branches', { '--max-count=254', '--graph', '--decorate', '--color' }), -- '--oneline',
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
    vim.keymap.set(
      'n',
      '<leader>gc',
      neogit.action('commit', 'commit', { '--verbose' }),
      { desc = 'Git: Commit all staged changes with verbose change preview' }
    )
    vim.keymap.set('n', '<leader>gcc', '<cmd>Neogit commit<CR>', { silent = true, noremap = true, desc = 'Git: open "Commit Menu"' })

    -- Stage all and commit
    -- vim.keymap.set('n', '<leader>gC', neogit.action('commit', 'commit', { '--verbose', '--all' }), { desc = 'Git: Stage all and commit' })

    -- Easy git commit all push for small unimportant changes
    vim.keymap.set(
      'n',
      -- INFO: maybe use capital E for safety reasons.
      '<leader>gEx', -- The E is capitalized and has an 'x' for making it less typo prone for safety reasons.
      function()
        -- Stage all changes. Using native git cli
        -- NOTE: :wait is needed to make it synchronous
        vim
          .system({ 'git', 'add', '--all' }, { text = true }, function(obj)
            print(obj.code)
            print(obj.stdout)
            print(obj.stderr)
          end)
          :wait()
        -- Commit all staged changes
        vim
          .system({ 'git', 'commit', '--message=Easy git' }, { text = true }, function(obj)
            print(obj.code)
            print(obj.stdout)
            print(obj.stderr)
          end)
          :wait()

        -- Push to remote
        neogit.action('push', 'to_pushremote', {}) -- FIX:for some reason this doesn't work
        vim.system({ 'git', 'push' }, { text = true }, function(obj)
          print(obj.code)
          print(obj.stdout)
          print(obj.stderr)
        end)
      end,
      { noremap = true, desc = 'Git: [E]asy Commit all changes and push' }
    )

    vim.keymap.set('n', '<leader>gP', '<cmd>Neogit pull<CR>', { silent = true, noremap = true, desc = 'Git: open "Pull Menu"' })

    -- vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<CR>', { silent = true, noremap = true, desc = 'Git: open "Push Menu"' })

    vim.keymap.set('n', '<leader>gp', neogit.action('push', 'to_pushremote', {}), { silent = true, noremap = true, desc = 'Git: push to Remote Origin' })
    vim.keymap.set('n', '<leader>gb', '<cmd>Telescope git_branches<CR>', { silent = true, noremap = true, desc = 'Git: List branches' })

    -- vim.keymap.set('n', '<leader>gB', ':G blame<CR>', { silent = true, noremap = true }) -- Me: I don't use fugitive
    --
    -- BACKUP: using only neogit didn't work for easy git:
    -- Easy git commit all push for small unimportant changes -- FIX: not working.
    -- vim.keymap.set(
    --   'n',
    --   -- INFO: maybe use capital E for safety reasons.
    --   '<leader>ge', -- It's capital for making it less typo prone for safety reasons.
    --   function()
    --     neogit.cli.add { '--all' }
    --     neogit.action('commit', 'commit', { '--verbose', '--all' }) -- allow-empty-message. '--message="Easy commit"'
    --     neogit.action('push', 'to_pushremote', {})
    --   end,
    --   { noremap = true, desc = 'Git: [E]asy Commit all changes and push' }
    -- )
  end,
}
