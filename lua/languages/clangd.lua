-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/clangd.lua
--
-- C/C++/Objective-C/CUDA/Protobuf configs
--
-- some more research confirmed clangd seems to be the best LSP server for C/C++
-- as of 2025 https://www.reddit.com/r/C_Programming/comments/1gdo6yo/for_neovim_users_out_there_which_lsp_is_best_for/

return {
  -- recommended = function()
  --   return LazyVim.extras.wants {
  --     ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  --     root = {
  --       '.clangd',
  --       '.clang-tidy',
  --       '.clang-format',
  --       'compile_commands.json',
  --       'compile_flags.txt',
  --       'configure.ac', -- AutoTools
  --     },
  --   }
  -- end,

  -- ======================== treesitter =========================
  -- Add C/C++ to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'c', 'cpp' } },
  },

  -- ======================== Install cli tools ========================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'clangd', -- LSP
        -- 'clang-format', -- formatter
        -- 'clang-tidy', -- linter
        -- 'clang-check', -- linter
        -- 'clang-analyzer', -- linter
        'codelldb', -- debugger
      },
    },
  },

  -- ======================== LSP ============================
  -- https://github.com/p00f/clangd_extensions.nvim
  --
  -- This plugin extends the capabilities of clangd, a language server for
  -- C/C++/Objective-C/CUDA/Protobuf.
  --
  -- I am not sure what exactly it does?
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = '',
          declaration = '',
          expression = '',
          specifier = '',
          statement = '',
          ['template argument'] = '',
        },
        kind_icons = {
          Compound = '',
          Recovery = '',
          TranslationUnit = '',
          PackExpansion = '',
          TemplateTypeParm = '',
          TemplateTemplateParm = '',
          TemplateParamObject = '',
        },
      },
    },
  },

  -- Correctly setup lspconfig for clangd 🚀
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
          },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern(
              'Makefile',
              'configure.ac',
              'configure.in',
              'config.h.in',
              'meson.build',
              'meson_options.txt',
              'build.ninja'
            )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require('lspconfig.util').find_git_ancestor(
              fname
            )
          end,
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          -- local clangd_ext_opts = LazyVim.opts 'clangd_extensions.nvim' -- Original lazyvim
          local clangd_ext_opts = require('utils.init').opts 'clangd_extensions.nvim' -- My lazyvim
          require('clangd_extensions').setup(vim.tbl_deep_extend('force', clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },

  -- ======================== Autocompletion ============================
  -- {
  --   'hrsh7th/nvim-cmp',
  --   -- optional = true,
  --   opts = function(_, opts)
  --     opts.sorting = opts.sorting or {}
  --     opts.sorting.comparators = opts.sorting.comparators or {}
  --     table.insert(opts.sorting.comparators, 1, require 'clangd_extensions.cmp_scores')
  --   end,
  -- },

  -- ======================== Debugging ============================
  {
    'mfussenegger/nvim-dap',
    -- optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- me
      -- optional = true,
      -- opts = { ensure_installed = { 'codelldb' } },
    },
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['codelldb'] then
        require('dap').adapters['codelldb'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'codelldb',
            args = {
              '--port',
              '${port}',
            },
          },
        }
      end
      for _, lang in ipairs { 'c', 'cpp' } do
        dap.configurations[lang] = {
          {
            type = 'codelldb',
            request = 'launch',
            name = 'Launch file',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'codelldb',
            request = 'attach',
            name = 'Attach to process',
            pid = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end,
  },
}
