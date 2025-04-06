-- My config for .html files
--
-- NOTE:  as of 2025, LazyVim had NO extras/lang/html.lua file

-- SNIPPETS: are in `nvim/lua/LuaSnip/html.lua`
return {
  -- ========================= Treesitter ==================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'html' },
    },
  },
  -- ========================= LSP =========================
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- LSP Server Settings
      servers = {
        -- html
        html = {
          filetypes = { 'html', 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        },
        -- Emmet:
        -- enables html snippets expansion like `div>p>ul>li*3` or `p.bg-red-500 -> <p class="bg-red-500"></p>`
        emmet_ls = {
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ['bem.enabled'] = true,
              },
            },
          },
        },
      },
    },
  },
  -- =========================== Formatting =========================
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        html = { 'prettierd' },
      },
    },
  },
  -- ============================= Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'html', -- lsp
        'emmet_ls', -- lsp
        'prettierd', -- formatter
      },
    },
  },

  -- ====================== Autoclosing and Renaming HTML Tags ====================
  -- Automatically add closing tags for HTML and JSX
  -- For some reason, Lazyvim https://www.lazyvim.org/plugins/treesitter
  {
    'windwp/nvim-ts-autotag',
    -- event = 'LazyFile',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
