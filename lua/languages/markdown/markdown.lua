-- Lazyvim https://www.lazyvim.org/extras/lang/markdown

-- ================================= Backup =====================================
-- Me: lsp-config dependency required by "markdown_oxide"?
-- TODO: uninstall if markdown_oxide is removed
-- {
--   'nvimdev/lspsaga.nvim',
--   config = function()
--     require('lspsaga').setup {
--       -- no breadcumbs at top of buffer
--       symbol_in_winbar = {
--         enable = false,
--       },
--     }
--   end,
--   dependencies = {
--     'nvim-treesitter/nvim-treesitter', -- optional
--     'nvim-tree/nvim-web-devicons', -- optional
--   },
-- },

return {
  -- ============================== LSP ================================
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- LSP Server Settings
      servers = {
        -- Markdown LSP. General markdown sup: reference, linking,
        marksman = {},

        -- Special function for Personal Knowledge Management (PKM) in  markdown files
        -- Me: markdown oxide is a special LSP for markdown files that is used for
        -- Personal Knowledge Management (PKM) see: https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file#neovim
        --
        markdown_oxide = {
          -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
          -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
          -- capabilities = vim.tbl_deep_extend(
          --   'force',
          --   vim.lsp.protocol.make_client_capabilities(),
          --   {
          --     workspace = {
          --       didChangeWatchedFiles = {
          --         dynamicRegistration = true,
          --       },
          --     },
          --   }
          --   -- on_attach = on_attach,
          -- ),
        },
        -- markdown_oxide = {},

        -- grammar checker lsp for markdown
        -- homepage: https://writewithharper.com/docs/integrations/neovim
        -- Linkarzu video: https://youtu.be/3p2n2-eiuZw?si=RNLeXRypaNdIpea7&t=1098
        -- harper_ls = {
        --   -- NOTE: to quickly turn harper on and off, set `enabled = false` in the
        --   -- config below and restart the lsp with `:LspRestart harper_ls`.
        --   enabled = false,
        --   filetypes = { 'markdown' },
        --   settings = {

        --     ['harper-ls'] = {

        --       -- userDictPath = '~/dotfiles/nvim/.config/harper/global_dict.txt', -- path to your global dictionary
        --       userDictPath = '~/dotfiles/nvim/.config/nvim/spell/en.utf-8.add', -- path to your global dictionary
        --       -- fileDictPath = '~/dotfiles/nvim/.config/harper/', -- path to your file-specific dictionary

        --       -- Setting the following linters to false reduces the he number of false positives drastically
        --       linters = {
        --         SpellCheck = false,
        --         SentenceCapitalization = false, -- set to false to avoid a lot of false positives
        --       },
        --       isolateEnglish = true,
        --       markdown = {
        --         IgnoreLinkTitle = true, -- [ignore this part]() [[and-also-this-part]]
        --       },
        --     },
        --   },
        -- },
      },
    },
  },
  -- =============================== Formatting ============================
  -- https://www.lazyvim.org/extras/lang/markdown#conformnvim-optional
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        markdown = { 'prettierd', 'markdownlint-cli2' }, -- 'markdownlint-cli2', markdown-toc
        ['markdown.mdx'] = { 'prettierd', 'markdownlint-cli2' }, -- markdown-toc
      },
      -- formatters = {
      --   ['markdownlint-cli2'] = {
      --     condition = function(_, ctx)
      --       local diag = vim.tbl_filter(function(d)
      --         return d.source == 'markdownlint'
      --       end, vim.diagnostic.get(ctx.buf))
      --       return #diag > 0
      --     end,
      --   },
      -- },
    },
  },
  -- ============================== Linting ============================
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        markdown = { 'markdownlint-cli2' }, -- markdownlint-cli2
      },
    },
  },

  -- ============================= preview markdown - Plugin ===============
  -- repo https://github.com/iamcco/markdown-preview.nvim
  -- Preview markdown files from nvim in the browser
  -- Funfact: The auto-generated website of the markdown file seems to be done with Next.js
  --
  -- You can install with or without yarn/npm
  -- Stand of 2024-08-01 you chose to use yarn/npm instead of building from source
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,

    config = function()
      -- Toggle the markdown preview (<leader>mp would also be okay -> more space for other mappings on `m`)
      -- NOTE: maybe `<leader>m` would be better
      vim.keymap.set('n', '<leader>mp', '<CMD>MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'Markdown Preview: Toggle' })

      vim.cmd [[do FileType]]
    end,
  },
  -- ============================= Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'marksman', -- lsp
        -- 'harper_ls', -- lsp for grammar checking
        'markdown_oxide', -- lsp
        'prettierd', -- formatter
        'markdownlint', -- linter
        'markdownlint-cli2', -- linter
        'markdown-toc',
      },
    },
  },
}
