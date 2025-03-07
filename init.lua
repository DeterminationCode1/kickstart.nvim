--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- Me: refactor the options into a separate file like the modular kickstart repo
require '.options'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- NOTE:  The kickstarter default was '<Esc><Esc>'.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds to make split navigation easier.
-- NOTE: If you are on MacOS you must deactivate the default Mission Control shortcuts that override ^+arrows.
-- You can find all of them in the System Preferences > Keyboard > Shortcuts > Mission Control
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ================= My keybindings rempas ===============
require 'keymaps'
-- ================= END ==============================
--

-- ================= Autocommands =================
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) textin
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- I move all of my custom autocommands into a separate file
require 'autocommands'
-- ================= END: Autocommands ==============================

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- WARNING: ME: I modified the kickstart original to my liking and moved the whole
  -- comment.nvim plugin config into a separate file in the custom plugins folder.

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- WARNING: Kickstart added gitsigns.nvim partial config here, but also
  -- had a full config in the custom plugins folder. So, I decided to move all the
  -- configuration into the gitigns.lua file in the custom plugins folder.

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

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
        { '<leader>m', group = '[M]arkdown' }, -- me
        { '<leader>mf', group = 'Markdown [F]old' }, -- me
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

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
      vim.api.nvim_set_keymap('n', '<space>st', ':TodoTelescope<CR>', { noremap = true }) -- WARN: not sure if working?

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

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',

      -- Me: required by "markdown_oxide"?
      -- TODO: uninstall if markdown_oxide is removed
      {
        'nvimdev/lspsaga.nvim',
        config = function()
          require('lspsaga').setup {
            -- no breadcumbs at top of buffer
            symbol_in_winbar = {
              enable = false,
            },
          }
        end,
        dependencies = {
          'nvim-treesitter/nvim-treesitter', -- optional
          'nvim-tree/nvim-web-devicons', -- optional
        },
      },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Me: change the lsp gutter symbols
          -- see official docs: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
          local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
          for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- For C. Was listed by kickstarter
        clangd = {},
        -- gopls = {},
        -- Python. Pyright was included by Kickstarter. has a lot more stars than pylsp.
        pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        -- NOTE: I decided to install the typescript-tools.nvim plugin as I work a lot with ts and speed of lsp is important. It's in a separate file

        -- Tailwind CSS
        tailwindcss = {},

        -- Shell scripts: bash sh . to some extend zsh?
        bashls = {},

        -- Markdown
        marksman = {}, -- General markdown sup: reference, linking,
        -- Special function for Personal Knowledge Management (PKM) in  markdown files
        -- Me: markdown oxide is a special LSP for markdown files that is used for
        -- Personal Knowledge Management (PKM) see: https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file#neovim
        markdown_oxide = {
          -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
          -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
          capabilities = vim.tbl_deep_extend(
            'force',
            capabilities,
            {
              workspace = {
                didChangeWatchedFiles = {
                  dynamicRegistration = true,
                },
              },
            }
            -- on_attach = on_attach,
          ),
        },

        -- Toml
        taplo = {},

        -- Me: Docker & docker-compose
        dockerls = {},
        docker_compose_language_service = {},

        -- R statistical language
        r_language_server = {},

        -- Me: Setup OCaml
        ocamllsp = {},

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- The way kickstarter is setup will install all LSP listed automatically. You don't have to include them here again.
        -- =========== Python ===========
        'black', -- formater
        'isort', -- sort imports
        'flake8', -- Linter
        -- 'mypy', -- Type checker

        -- =========== JavaScript etc ===========
        'prettier', -- formatter
        'eslint_d', -- linter. Eslint but in deamonized verson for better performance

        -- =========== CSS ===========
        -- 'tailwindcss', -- Tailwind CSS IntelliSense
        'stylelint', -- Linter

        -- =========== C ===========
        -- Some of these might also apply to cpp
        'clang-format', -- Formatter

        -- =========== Lua ===========
        'stylua', -- Formatter
        'luacheck', -- Linter

        -- ========== Docker ===========
        'hadolint', -- Linter
        -- ========== Kubernetes ===========
        -- 'kube-lint', -- Linter. -- FIX: kube-lint doesn't exist in Mason.

        -- ========== Shell  ===========
        'shfmt', -- Formater
        'shellcheck', -- Linter. only for bash, posix-shell. Doesn't work for zsh.

        -- =========== General Text ===========
        -- Powerful speling checker for your editor. Codespell would be a ligthway alternative.
        'cspell',
        'markdownlint',
        -- 'texlab', -- LaTeX language server

        -- ============ OCaml ==========
        'ocamlformat', -- Formatter
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    -- NOTES: The "<leader>f" keybinding for formatting was removed because I use "format on save"
    -- instead and <leader>f is a valuable well positioned keybinding that's now used for 'search files' in telescope.
    -- keys = {
    --   {
    --     '<leader>f',
    --     function()
    --       require('conform').format { async = true, lsp_fallback = true }
    --     end,
    --     mode = '',
    --     desc = '[F]ormat buffer',
    --   },
    -- },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        ocaml = { 'ocamlformat' }, -- OCaml uses .ml extension

        -- Use the "*" filetype to run formatters on all filetypes.
        -- ['*'] = { 'codespell' }, -- FIX: Not working, causing error.FIX: Not working, causing error.
      },
      formatters = {
        -- This is a way of globally overwitting prettier config rules. It will be applied in all of your projects where prettier is used.
        -- This might be concidered bad practic as different projects often have different style conventions and you should use a loacal
        -- `.prettierrc` file - which is picked yp by conform.nvim
        -- see reddit https://www.reddit.com/r/neovim/comments/19baed2/lazyvim_conform_prettier_configuration_not_working/
        prettier = {
          prepend_args = { '--single-quote', '--print-width 70' },
        },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- ME: Tailwind color preview in completion menu
      'luckasRanarison/tailwind-tools.nvim',
      'onsails/lspkind-nvim',
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        -- dependencies = {
        --   -- `friendly-snippets` contains a variety of premade snippets.
        --   --    See the README about individual language/framework/plugin snippets:
        --   --    https://github.com/rafamadriz/friendly-snippets
        --   {
        --     'rafamadriz/friendly-snippets',
        --     config = function()
        --       -- NOTE: Me: the following line automatically loads all existing snippets for
        --       -- all languages that are supported by the friendly-snippets plugin.
        --       -- Thus, the lazay loading is important to not have startup time increased.
        --       require('luasnip.loaders.from_vscode').lazy_load()

        --       -- ME: The following lines extend the default snippets to other filetypes.
        --       -- Otherwise you could not use html and normal js snippets in a react file.
        --       require('luasnip').filetype_extend('javascriptreact', { 'html', 'javascript' })
        --       require('luasnip').filetype_extend('typescriptreact', { 'html', 'javascript' })

        --       -- FRAMEWORKS: snippets are not laoded by default as only people using theses
        --       -- frameworks would benefit from them. Thus, you must explicitly load them here.
        --       -- Exceptions: There is one exception, react.js is included by default in js/ts
        --       -- and only available in jsx/tsx files. They argue every webdev will use react at
        --       -- some point and making it the default alows for better support.
        --       require('luasnip').filetype_extend('python', { 'django' })

        --       -- TODO: make snippets context aware in a file. eg. html snippets only in jsx return valu but not in whole file.
        --       -- https://github.com/hrsh7th/nvim-cmp/issues/806
        --     end,
        --   },
        -- },
        --   config = function()
        --     -- require('luasnip').log.location()
        --     -- ejmastnak: Somewhere in your Neovim startup, e.g. init.lua
        --     require('luasnip').config.set_config { -- Setting LuaSnip config

        --       -- Enable autotriggered snippets
        --       enable_autosnippets = true,

        --       -- Use Tab (or some other key if you prefer) to trigger visual selection
        --       store_selection_keys = '<Tab>',
        --     }
        --     -- NOTE: me: the following loads my self-written snippets from the
        --     -- snippets folder ~/.config/nvim/LuaSnip/
        --     -- Read this excellent guide for more info: https://ejmastnak.com/tutorials/vim-latex/luasnip/
        --     -- You can either load all snippets at startup or lazy load them per
        --     -- filetype.
        --     --
        --     -- Load all snippets from the nvim/LuaSnip directory at startup
        --     -- require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/LuaSnip/' }

        --     -- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
        --     require('luasnip.loaders.from_lua').lazy_load { paths = { '~/.config/nvim/LuaSnip/' } }
        --     -- Heads up: for text in the repeated node to update as you type (e.g. like in the \end{} field in the above GIF) you must set update_events = 'TextChanged,TextChangedI' in your LuaSnip config. The default update event is InsertLeave, which will update repeated nodes only after leaving insert mode. Repeated nodes are are documented, in passing, in the section :help luasnip-extras.
        --   end,
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      -- ============= me: config luasnip =============
      luasnip.config.set_config {
        -- Don't store snippet history for less overhead
        -- history = false,
        -- Allow autotrigger snippets
        enable_autosnippets = true,
        -- For equivalent of UltiSnips visual selection
        store_selection_keys = '<Tab>',
        -- Event on which to check for exiting a snippet's region
        -- region_check_events = 'InsertEnter',
        -- delete_check_events = 'InsertLeave',
      }

      require('luasnip.loaders.from_lua').lazy_load { paths = { '~/.config/nvim/LuaSnip/' } }
      -- require('luasnip.loaders.from_lua').load { paths = { '~/.config/nvim/LuaSnip/' } }

      vim.keymap.set(
        'n',
        '<Leader>L',
        '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = {"~/.config/nvim/LuaSnip/"}})<CR><Cmd>echo "Snippets refreshed!"<CR>'
      )

      -- set keybinds for both INSERT and VISUAL. Me: this is working.
      -- You can cycle between options, but you can always only see one of them.
      -- vim.api.nvim_set_keymap('i', '<down>', '<Plug>luasnip-next-choice', {})
      -- vim.api.nvim_set_keymap('s', '<down>', '<Plug>luasnip-next-choice', {})
      -- vim.api.nvim_set_keymap('i', '<up>', '<Plug>luasnip-prev-choice', {})
      -- vim.api.nvim_set_keymap('s', '<C-p>', '<Plug>luasnip-prev-choice', {})

      -- Apart from this, there is also a picker (see |luasnip-select_choice| where no
      -- cycling is necessary and any choice can be selected right away, via
      -- `vim.ui.select`.
      vim.keymap.set('i', '<C-down>', '<cmd>lua require("luasnip.extras.select_choice")()<cr>', { desc = 'LuaSnip: Select choice' })

      -- Debug tools: print all available snippets for the current filetype
      -- https://www.reddit.com/r/neovim/comments/109018y/list_all_available_luasnips_snippets_for_a_given/?rdt=42258
      local list_snips = function()
        local ft_list = require('luasnip').available()[vim.o.filetype]
        local ft_snips = {}
        for _, item in pairs(ft_list) do
          ft_snips[item.trigger] = item.name
        end
        print(vim.inspect(ft_snips))
      end

      vim.api.nvim_create_user_command('SnipList', list_snips, {})

      -- ============= END =============

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`

        -- No, but seriously. Please read `:help ins-completion`, it is really good!

        mapping = cmp.mapping.preset.insert {
          -- ME: Debate over best completion keybindings. Seems like `C-Enter`, then `C-Y` are the winners. https://www.reddit.com/r/neovim/comments/1at66dc/what_key_do_you_prefer_to_press_to_accept_an/
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          -- ME: I tried c-y, c-n and the reason I'm switching back to tab is
          -- because one keystroke is faster than two.
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<c-s>'] = cmp.mapping(function() -- kickstarter used <C-l>
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<S-tab>'] = cmp.mapping(function() -- kickstarter used <C-h>. You cannot use s-s because then you could  type
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          {
            name = 'nvim_lsp',
            -- ========= Me: config for markdown oxide =========
            -- see https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file#neovim
            option = {
              markdown_oxide = { keyword_pattern = [[\(\k\| \|\/\|#\)\+]] },
            },
            -- ========= END =========
          },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' }, -- Suggestions based on content of current buffer
        },

        -- ME: Tailwind color preview in completion menu
        formatting = {
          format = require('lspkind').cmp_format {
            before = require('tailwind-tools.cmp').lspkind_format,
          },
        },
      }

      -- Me: Setup Dadbod ui completion
      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = {
          -- { name = 'nvim_lsp' },
          { name = 'luasnip' },
          -- { name = 'path' },
          { name = 'buffer' },
          { name = 'vim-dadbod-completion' }, -- NOTE: this is the important line
        },
      })
    end,
  },

  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --
  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  -- Me: my self implemented colorschemes
  -- All hex colors of catppuccin: https://github.com/catppuccin/catppuccin/blob/main/docs/translation-table.md
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        -- gitsigns = false,
        cmp = true,
        flash = true,
        gitsigns = true,
        headlines = true, -- plugin not installed
        leap = true, -- plugin not installed
        mason = true,
        markdown = true,
        mini = true,
        -- native lsp settings
        noice = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        headlines = false, -- I prefer my own colors
      },
      custom_highlights = function(colors)
        -- me: find nall nvim builting groups with preview with h: highlight-groups
        -- return {
        --   Comment = { fg = colors.flamingo },
        --   TabLineSel = { bg = colors.pink },
        --   CmpBorder = { fg = colors.surface2 },
        --   Pmenu = { bg = colors.none },
        -- }

        -- NOTE: Catputccin integrates with GitSignsAdd, GitSignsChange, GitSignsDelete, GitSignsChangeDelete, GitSignsTopDelete, ... groups but NOT with GitSignsUntracked.
        -- Thus, you need to manually configure it using the nvim builtin api.
        -- param 0 means it's a global highlight group
        -- vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = colors.gray0 }) -- Me: There are gray0 to 2 from dark to light

        -- WARN: using `colors.gray0` didn't work for some reason...
        vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#565970' }) -- Me: There are gray0 to 2 from dark to light

        return {
          -- Make bold text
          ['@markup.strong.markdown_inline'] = { bold = true, fg = colors.white },
          -- ME: find all gitsigns highlight-groups under 'h: gitsigns-highlight-groups'
          GitSignsAdd = { fg = colors.green },
          -- GitSignsChange = { fg = colors.blue },
          GitSignsChange = { fg = '#22a2f7' },
          GitSignsDelete = { fg = colors.red },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- WARNING: The 'todo-comment.nvim' configuration was moved to its own file.

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      --  Me: Important aliases to know!
      --  - b - block: { }, [ ], ( ), < >, etc.
      --  - q - quote: ', ", `, etc.
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          -- Whole buffer. Official helpfile:
          -- https://github.com/echasnovski/mini.ai/blob/9fef1097bca44616133cde6a6769e7aa07d12d7d/doc/mini-ai.txt#L461C5-L469C10
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line '$',
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- see `:help mini.surround` for more information
      --
      -- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - gsd'   - [S]urround [D]elete [']quotes
      -- - gsr)'  - [S]urround [R]eplace [)] [']
      -- Me: You can use textobjects from mini.ai too!
      -- - gsdb   - [S]urround Delete [B]lock. E.g. delete { } or [ ] from { foo: 'bar', baz: 'qux'}
      -- Also
      -- - You can use gsa' in visual mode to surround the selected text with '.
      -- - You can surround more than just words. E.g. gsaap" to surround a paragraph with ".
      -- NOTE: I added a 'g' in front of all surround default mappings because the 's' conflicted
      -- with 'flash.nvim' [s]earch mappings.
      require('mini.surround').setup {
        -- Funy enough, I came up with the same alternative mappings as LazyVim:
        -- https://www.lazyvim.org/extras/coding/mini-surround
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
      }
      -- Me: Some shortcuts for surround
      vim.keymap.set('n', 'gs', '', { desc = 'Surround' })
      -- WARN: it needs the `remap=true` to work. Otherwise RHS will be treated as pure vim commands.
      vim.keymap.set('n', 'gsw', 'gsaiw', { desc = 'Surround a word (Alias/Shortcut for "gsaiw")', remap = true })
      -- same but dnt overwrite the normal clipboard register with ciw
      vim.keymap.set('n', 'gsl', '"ndiwi []()<esc>b"npf)P', { desc = 'Surround: word with markdown [L]ink' })
      -- TODO adopt gsl command to handle selected text parts from visual mode.

      -- Remap adding surrounding to Visual mode selection
      -- vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      -- Make special mapping for "add surrounding for line"
      vim.keymap.set('n', 'gss', 'ys_', { remap = true })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      --  NOTE: ============= All the following mini.nvim configs were added by you. =============

      -- WARNING: MiniFiles explorer is no longer need as it was replaced by the nvim-oil plugin.

      --   require('mini.files').setup {
      --     -- NOTE: Your min.files config is inspired by this reddit post: https://www.reddit.com/r/neovim/comments/1bceiw2/comment/kuhmdp9/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      --
      --     -- Module mappings created only inside explorer.
      --     mappings = {
      --       synchronize = 'w', -- default is `=`
      --       -- open file & close mini-file explorer. Defaults to `L`.
      --       go_in_plus = '<CR>',
      --     },
      --   } -- Maybe Oil.nvim would be better as it's more minimalistic and more like a simple buffer.
      --
      --   vim.api.nvim_create_autocmd('User', {
      --     pattern = 'MiniFilesBufferCreate',
      --     callback = function(args)
      --       local buf_id = args.data.buf_id
      --       -- Tweak left-hand side of mini.file mapping to your liking
      --       -- vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
      --       -- Close MiniFile explorer
      --       vim.keymap.set('n', '-', require('mini.files').close, { buffer = buf_id })
      --       -- vim.keymap.set("n", "o", gio_open, { buffer = buf_id })
      --     end,
      --   })
      --   -- Open MiniFiles explorer
      --   vim.keymap.set('n', '-', function()
      --     require('mini.files').open()
      --   end, { desc = 'Open MinFiles' })
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      -- Treesitter textobjects module. Laod this when treesitter is loaded.
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      ensure_installed = {
        -- Kickstarter default
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'latex',
        'query',
        'vim',
        'vimdoc',
        -- ------ My languages -------------
        -- R
        'r',
        'rnoweb',
        -- end
        'python',
        'javascript',
        'typescript',
        'css',
        'html',
        'json',
        'yaml',
        'toml',
        'dockerfile',
        'gitignore',
        'java',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      -- Modules can be activated here
      -- Me: Incremental selection allows you to select the current node and go up the tree
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          cope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      -- Me: Treesitter textobjects module.
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  -- A game to learn vim relative line number motions https://github.com/ThePrimeagen/vim-be-good
  { 'ThePrimeagen/vim-be-good' },
  {
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
  },
  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
