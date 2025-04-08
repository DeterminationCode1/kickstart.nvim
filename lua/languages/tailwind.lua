-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/tailwind.lua

return {
  recommended = function()
    -- return LazyVim.extras.wants {
    --   root = {
    --     'tailwind.config.js',
    --     'tailwind.config.cjs',
    --     'tailwind.config.mjs',
    --     'tailwind.config.ts',
    --     'postcss.config.js',
    --     'postcss.config.cjs',
    --     'postcss.config.mjs',
    --     'postcss.config.ts',
    --   },
    -- }
  end,
  -- ================================= LSP ================================
  -- tailwind-tools.nvim already setsup the LSP server

  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       tailwindcss = {
  --         -- exclude a filetype from the default_config
  --         filetypes_exclude = { 'markdown' },
  --         -- add additional filetypes to the default_config
  --         filetypes_include = {},
  --         -- to fully override the default_config, change the below
  --         -- filetypes = {}
  --       },
  --     },
  --     setup = {
  --       tailwindcss = function(_, opts)
  --         -- local tw = LazyVim.lsp.get_raw_config 'tailwindcss'
  --         local tw = require('lazyvim.util.lsp').get_raw_config 'tailwindcss'
  --         opts.filetypes = opts.filetypes or {}

  --         -- Add default filetypes
  --         vim.list_extend(opts.filetypes, tw.default_config.filetypes)

  --         -- Remove excluded filetypes
  --         --- @param ft string
  --         opts.filetypes = vim.tbl_filter(function(ft)
  --           return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
  --         end, opts.filetypes)

  --         -- Additional settings for Phoenix projects
  --         opts.settings = {
  --           tailwindCSS = {
  --             includeLanguages = {
  --               elixir = 'html-eex',
  --               eelixir = 'html-eex',
  --               heex = 'html-eex',
  --             },
  --           },
  --         }

  --         -- Add additional filetypes
  --         vim.list_extend(opts.filetypes, opts.filetypes_include or {})
  --       end,
  --     },
  --   },
  -- },
  -- ========================= Autocomplete ================================
  -- {
  --   'hrsh7th/nvim-cmp',
  --   dependencies = {
  --     'luckasRanarison/tailwind-tools.nvim',
  --     'onsails/lspkind-nvim',
  --     -- { 'roobert/tailwindcss-colorizer-cmp.nvim', opts = {} },
  --   },
  --   opts = function(_, opts)
  --     -- ME: Tailwind color preview in completion menu via tailwind-tools
  --     -- https://github.com/luckasRanarison/tailwind-tools.nvim?tab=readme-ov-file#nvim-cmp
  --     return {
  --       formatting = {
  --         format = require('lspkind').cmp_format {
  --           before = require('tailwind-tools.cmp').lspkind_format,
  --         },
  --       },
  --     }
  --     -- -- original LazyVim kind icon formatter
  --     -- local format_kinds = opts.formatting.format
  --     -- opts.formatting.format = function(entry, item)
  --     --   format_kinds(entry, item) -- add icons
  --     --   return require('tailwindcss-colorizer-cmp').formatter(entry, item)
  --     -- end
  --   end,
  -- },
  -- ======================== Alternative extended LSP ============================
  -- https://github.com/luckasRanarison/tailwind-tools.nvim?tab=readme-ov-file
  --
  -- An unofficial Tailwind CSS integration and tooling for Neovim written in Lua
  -- and JavaScript, leveraging the built-in LSP client, Treesitter, and the NodeJS
  -- plugin host. It is inspired by the official Visual Studio Code extension.
  --
  -- Usage:
  -- TailwindConcealToggle: toggles conceal for all buffers.
  -- TailwindColorToggle: toggles color hints.
  -- TailwindSort(Sync)
  -- In normal mode, TailwindNextClass and TailwindPrevClass can be used with a count to jump through multiple classes at once.
  {
    'luckasRanarison/tailwind-tools.nvim',
    -- LSP nvim-lsp dependency is optional. By my understanding, you can
    -- optionally setup the tailwindcss LSP manually in lspconfig or the alternatively,
    -- the `tailwind-tools` plugin will auto start the default configured LSP itself
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- -@type TailwindTools.Option
    opts = {
      server = {
        override = true, -- setup the server from the plugin if true
        settings = {}, -- shortcut for `settings.tailwindCSS`
        on_attach = function(client, bufnr) end, -- callback triggered when the server attaches to a buffer
      },
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = 'inline', -- "inline" | "foreground" | "background"
        inline_symbol = '󰝤 ', -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = nil, -- only conceal classes exceeding the provided length
        symbol = '󱏿', -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = '#38BDF8',
        },
      },
      cmp = {
        highlight = 'foreground',
      },
      -- custom_filetypes = {}, -- see the extension section to learn how it works
    },
    -- keybindings
    keys = {
      { '<leader>tt', '<CMD>TailwindConcealToggle<CR>', { desc = '[T]oggle [T]ailwindCSS conceal' } },
    },
    --
    -- config = function()
    -- WARN: If you want to use the conf function, you must call the setup function first here!

    --   -- vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Oil: Open parent directory' })
    --   vim.keymap.set('n', '<leader>tt', '<CMD>TailwindConcealToggle<CR>', { desc = '[T]oggle [T]ailwindCSS conceal' })
    -- end,
  },
  -- ========================== Install cli tools ===================================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'tailwindcss', -- lsp
      },
    },
  },
}
