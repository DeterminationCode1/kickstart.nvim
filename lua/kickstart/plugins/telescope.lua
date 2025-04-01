-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

-- Kickstarter https://github.com/dam9000/kickstart-modular.nvim/blob/153ec746bd3e796557f3ea9e1105c3aa94930ae4/lua/kickstart/plugins/telescope.lua
return {

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sH', builtin.help_tags, { desc = '[S]earch [H]elp' }) -- Kick original was <leader>sh` but searching hidden is more common
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- Search Files: defaults to search from current working DIR.
      -- Kickstarter originally used: `vim.keymap.set('n','<leader>sf',builtin.find_files, desc = '...')`
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- ============ Me: shortcut for seraching files because it's so common ============
      -- kickstarter telescope normal root dir search.
      -- vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search [F]iles (Shortcut)' })

      -- WARNING: switched to "smart-open.nvim" instead
      --
      -- Me: use telescope-frecency plugin for better ranked search results
      -- You could add theme=ivy as argument to get a different look
      -- vim.keymap.set(
      --   { 'n', 'v' },
      --   '<leader>f',
      --   '<cmd>Telescope frecency workspace=CWD<cr>',
      --   { desc = 'Search [F]iles (Shortcut)', noremap = true, silent = true }
      -- )

      -- Me: switched from telescope-frecency to the telescope plugin
      -- "smart-open" for better search results
      vim.keymap.set('n', '<leader>f', function()
        require('telescope').extensions.smart_open.smart_open {
          -- show_scores = true, -- NOTE: this worked!!
          cwd_only = true,
        }
      end, { noremap = true, silent = true })
      -- ==================== Me: END ====================================================
      vim.keymap.set('n', '<leader>sh', function()
        builtin.find_files { hidden = true }
      end, { desc = '[S]earch [H]idden Files' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Search [S]elect Telescope' })
      -- Search by word:     Searches for the string under your cursor in your current working directory
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- Live grep: Search for a string and get results live as you type, respects .gitignore. Defaults to search from cwd
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- Resume: Opens the previous picker in the identical state (incl. multi selections)
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      -- Note: The default keymap to switch between buffers is <leader><leader>
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Me: search through all todos. Copied from 'Omerxx':
      -- https://github.com/omerxx/dotfiles/blob/fffac07f46987fbb6b3dfef9113fae5875a1332d/nvim/lua/plugins/tele.lua
      -- vim.api.nvim_set_keymap('n', '<space>st', ':TodoTelescope<CR>', { noremap = true }) -- WARN: not sure if working?

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
