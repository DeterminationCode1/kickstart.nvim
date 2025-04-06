-- Lazyvim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/python.lua
-- dreams of code: https://www.youtube.com/watch?v=4BnVeOUeZxc&t=710s

-- NOTE:  deleted Layzvim code
--
-- if lazyvim_docs then
--   -- LSP Server to use for Python.
--   -- Set to "basedpyright" to use basedpyright instead of pyright.
--   vim.g.lazyvim_python_lsp = 'pyright'
--   -- Set to "ruff_lsp" to use the old LSP implementation version.
--   vim.g.lazyvim_python_ruff = 'ruff'
-- end

-- local lsp = 'pyright'
-- local ruff = 'ruff'
--
-- {
--   'neovim/nvim-lspconfig',
--   opts = function(_, opts)
--     local servers = { 'pyright', 'basedpyright', 'ruff', ruff, lsp }
--     for _, server in ipairs(servers) do
--       opts.servers[server] = opts.servers[server] or {}
--       opts.servers[server].enabled = server == lsp or server == ruff
--     end
--   end,
-- },

return {
  -- ========================= treesitter =========================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'python', 'ninja', 'rst' } },
  },

  -- ========================= LSP ===============================
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- python lsp for type checking (seems best after pylance which is
        -- VS-Code exclusive)
        basedpyright = {},
        -- rough fast format checker/linter for python

        -- ruff = {
        --   cmd_env = { RUFF_TRACE = 'messages' },
        --   init_options = {
        --     settings = {
        --       logLevel = 'error',
        --     },
        --   },
        --   -- keys = {
        --   --   {
        --   --     '<leader>co',
        --   --     LazyVim.lsp.action['source.organizeImports'],
        --   --     desc = 'Organize Imports',
        --   --   },
        -- },
      },
    },
    -- setup = {
    --   [ruff] = function()
    --     LazyVim.lsp.on_attach(function(client, _)
    --       -- Disable hover in favor of Pyright
    --       client.server_capabilities.hoverProvider = false
    --     end, ruff)
    --   end,
    -- },
  },
  -- ======================== Auto completion ============================
  -- {
  --   'hrsh7th/nvim-cmp',
  --   -- optional = true,
  --   opts = function(_, opts)
  --     opts.auto_brackets = opts.auto_brackets or {}
  --     table.insert(opts.auto_brackets, 'python')
  --   end,
  -- },
  -- ============================= Auto format ============================
  -- added by me
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' }, -- 'flake8', 'mypy'
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      -- configur formatters
      -- formatters = {
      --   -- This is a way of globally overwitting prettier config rules. It will be applied in all of your projects where prettier is used.
      --   prettier = {
      --     prepend_args = { '--single-quote', '--print-width 70' },
      --   },
      -- },
    },
  },
  -- ============================== Linting ============================
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      linters_by_ft = {
        python = { 'ruff' }, --  'mypy', 'flake8'
        -- official example:
        -- python = {"ruff", "mypy"}
      },
    },
  },
  -- ============================= Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'basedpyright', -- lsp
        'ruff', -- lsp, linter, formatter
        'black', -- formatter
        'isort', -- formatter
        'mypy', -- type checker
        -- 'flake8', -- linter. was replaced by ruff
        -- debugpy
      },
    },
  },
  -- ============================== Testing ================================
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = {
      adapters = {
        ['neotest-python'] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- ================================ Debugging ===================================
  -- {
  --   'mfussenegger/nvim-dap',
  --   -- optional = true,
  --   dependencies = {
  --     'mfussenegger/nvim-dap-python',
  --     -- stylua: ignore
  --     keys = {
  --       { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
  --       { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  --     },
  --     config = function()
  --       if vim.fn.has 'win32' == 1 then
  --         require('dap-python').setup(LazyVim.get_pkg_path('debugpy', '/venv/Scripts/pythonw.exe'))
  --       else
  --         require('dap-python').setup(LazyVim.get_pkg_path('debugpy', '/venv/bin/python'))
  --       end
  --     end,
  --   },
  -- },
  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    'jay-babu/mason-nvim-dap.nvim',
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },

  -- Docs: Switch between virtual environments
  --
  -- Use the command `:VenvSelect` to select a virtual environment on your
  -- computer. For example, in my Casity backend project I could choose between
  -- the local `.env` or the global `venv` from `pipx`.
  --
  -- This plugin is also helpful for debugging in case your not certain
  -- which environment is selected.
  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp', -- Use this branch for the new version
    cmd = 'VenvSelect',
    -- enabled = function()
    --   return LazyVim.has 'telescope.nvim'
    -- end,
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = 'python',
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' } },
  },
}
