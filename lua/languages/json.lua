-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/json.lua
--
-- All json related configurations based on LazyVim
return {

  -- recommended = function() -- WARN:  LazyVim internal config
  --   return LazyVim.extras.wants {
  --     ft = { 'json', 'jsonc', 'json5' },
  --     root = { '*.json' },
  --   }
  -- end,

  -- add json to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'json', 'json5' } },
  },

  -- yaml schema support
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },

  -- correctly setup lspconfig
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
  -- Formatter - me
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        json5 = { 'prettierd' },
      },
    },
  },
  -- linter
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        json = { 'jsonlint' },
        jsonc = { 'jsonlint' },
        json5 = { 'jsonlint' },
      },
    },
  },
  -- Mason install cli tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'jsonls', -- lsp
        'jsonlint', -- linter
        'prettierd', -- formatter
      },
    },
  },
}
