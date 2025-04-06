-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript.lua

-- JavaScript, TypeScript, React and other web framework configs
return {
  -- ======================== Treesitter =========================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'javascript',
        'typescript',
      },
    },
  },
  -- ======================== LSP ====================================
  -- Official repo: https://github.com/pmizio/typescript-tools.nvim
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    lazy = true,
    opts = {},
    -- settings = {} -- NOTE: I think settings could be added here
  },
  -- ======================== Formatter =========================
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
  -- ======================== Linter =========================
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      },
    },
  },
  -- ====================== Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        -- 'prettier', -- formatter
        'prettierd', -- formatter. Like prettier by demonizes it to make it faster.
        'eslint_d', -- linter. Eslint but in deamonized verson for better performance
      },
    },
  },
}
