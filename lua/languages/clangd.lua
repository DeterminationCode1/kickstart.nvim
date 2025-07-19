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

  -- ======================== formatter =========================
  -- C code seems to be less standardized in how symbols are formatted
  -- than other languages like python. For that reason, kickstart.nvim disabled
  -- formatting (conform.nvim) for C/C++ by default.
  --
  -- WARNING: so check if C/C++ formatting is disabled in your `lua/kickstart/plugins/conform.lua` "on_save" function.
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        objc = { 'clang-format' },
        objcpp = { 'clang-format' },
        cuda = { 'clang-format' },
        proto = { 'clang-format' },
      },
      formatters = {
        clang_format = {
          args = {
            '--style=file',
            '--fallback-style={BasedOnStyle: LLVM, BraceWrapping: { AfterFunction: false, AfterControlStatement: false, AfterEnum: false, AfterStruct: false, AfterClass: false }}',
            '--assume-filename=${INPUT}',
          },
          -- args = { '--style=llvm', '--fallback-style=none', '--assume-filename=${INPUT}' },
        },
      },
      -- formatters = {
      --   clang_format = {
      --     args = {
      --       '--style=llvm',
      --       '--fallback-style=none',
      --       '--assume-filename=${INPUT}',
      --     },
      --     -- args = { '--style=llvm', '--fallback-style=none', '--assume-filename=${INPUT}' },
      --   },
      -- },
    },
  },

  -- ============================== Linting ============================
  -- Me UPDATE: it seems look `clangd` LSP already uses `clang-tidy` for live linting
  -- automatically. If you want more strict `clang-tidy` linging in your code,
  -- make sure you have turned on all `clang-tidy` checks in your config:
  -- - List of clang-tidy checks: https://clang.llvm.org/extra/clang-tidy/checks/list.html
  -- - Reddit post that explained clang-tidy for Neovim: https://www.reddit.com/r/neovim/comments/pxd2og/clangtidy_for_neovim/
  --
  -- Me (Outdated): LazyVim as of May 2025 did not provide a linter recommendation for C/C++.
  -- But this Reddit thread from 2025 suggests clang-tidy is the go to linter to
  -- statically check for "Undefined behavior" in C/C++ code
  -- (https://www.reddit.com/r/C_Programming/comments/1k383vt/what_linters_or_off_the_shelf_coding_standards_to/).
  -- {
  --   'mfussenegger/nvim-lint',
  --   opts = {
  --     linters_by_ft = {
  --       c = { 'clang-tidy' },
  --       cpp = { 'clang-tidy' },
  --       objc = { 'clang-tidy' },
  --       objcpp = { 'clang-tidy' },
  --       cuda = { 'clang-tidy' },
  --       proto = { 'clang-tidy' },
  --     },
  --   },
  -- },

  -- ======================== Install cli tools ========================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'clangd', -- LSP
        'clang-format', -- formatter
        -- 'clang-tidy', -- linter (catch "undefined behavior" in C/C++ code)
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
