-- Assembly Language Configuration
--
-- LazyVim had no config for assembly as of 2025-04-19, so I added my own by
-- searching through docs and forums. It's very minimalistic as of now, because
-- I do not write much assembly at the moment.

return {

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    -- If your searching for a specific Treesitter parser for your assembly
    -- language, you can search through the list of "all supported languages"
    -- here: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
    opts = { ensure_installed = { 'asm' } },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- Me: I found this server by running `:Mason` and filtering for `Assembly`. It was the only LSP
      servers = {
        -- Me: Assembly language server
        asm_lsp = {},
      },
    },
  },

  -- Formatting
  -- `asmfmt` is a formatter for assembly written in Go: https://github.com/klauspost/asmfmt
  --
  -- TIP: file format / file extension for assembly seems to be `.s`, `.S` or
  -- `.asm`
  -- - I tested how Neovim interprets the file format of all the above extensions with `:echo &filetype`
  --   and all of the above extensions were interpreted as the same file type `asm` in Neovim.
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Conform can also run multiple formatters sequentially
        asm = { 'asmfmt' }, -- 'flake8', 'mypy'
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

  -- Mason: Install CLI tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'asmfmt', -- lsp
        'asmfmt', -- formatter
      },
    },
  },
}
