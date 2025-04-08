-- LazyVim https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/extras/coding/blink.lua
-- Linkarzu https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua

-- Debugging:
-- Use `:BlinckCmp status` or `:checkhealth` and scroll to the `blink.cmp`
-- section to see which completion sources are enabled and their status.
return {
  -- turn off nvim-cmp
  -- {
  --   'hrsh7th/nvim-cmp',
  --   optional = true,
  --   enabled = false,
  -- },
  {
    'saghen/blink.cmp',
    version = not vim.g.lazyvim_blink_main and '*',
    build = vim.g.lazyvim_blink_main and 'cargo build --release',
    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
    dependencies = {
      -- !Important! Make sure you're using the latest release of LuaSnip
      -- `main` does not work at the moment
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      -- 'rafamadriz/friendly-snippets',
      -- -- add blink.compat to dependencies
      {
        'saghen/blink.compat',
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and '*',
      },
    },
    event = 'InsertEnter',
    -- https://cmp.saghen.dev/recipes.html#disable-per-filetype
    enabled = function()
      local diabled_languages = {
        -- 'lua',
        -- 'markdown',
      }
      return not vim.tbl_contains(diabled_languages, vim.bo.filetype)
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { -- NOTE:defined in the luasnip config
        -- expand = function(snippet, _)
        --   return LazyVim.cmp.expand(snippet)
        -- end,
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          --
          -- WARN: Blink.cmp provides autobrackets but only for lsp elements and not when you
          -- type elsewhere in the buffer... https://www.reddit.com/r/neovim/comments/1jmt2u3/blinkcmp_autopairs_without_lsp_elements/
          -- Alternatives are: mini.pairs, ultimate-autopair
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          -- enabled = vim.g.ai_cmp, -- LazyVim default
          enabled = true,
        },
      },

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        -- Change completion sources based on filetype/treesitter node
        -- official docs https://cmp.saghen.dev/recipes.html#dynamically-picking-providers-by-treesitter-node-filetype
        -- Hint: `enabled` are the `opts.default.sources`

        -- WARN: even though this is copied from the official recopy docs,  it
        -- breaks blink.cmp completions in markdown files completely.
        -- default = function(ctx)
        --   local node = vim.treesitter.get_node()
        --   if vim.bo.filetype == 'markdown' then
        --     vim.notify 'Blink.cmp: markdown buf'
        --     return { 'lsp', 'path' }
        --   elseif node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
        --     vim.notify 'Blink.cmp: comment buf'
        --     return { 'buffer', 'snippets' }
        --   else
        --     return { 'lsp', 'path', 'snippets', 'buffer' }
        --   end
        -- end,

        default = { 'lsp', 'path', 'snippets', 'buffer' }, -- original LazyVim
        -- NOTE: this is a workaround for turning off blink.cmp in markdown...
        -- min_keyword_length = function()
        --   return vim.bo.filetype == 'markdown' and 3 or 0
        -- end,

        per_filetype = {
          -- sql = { 'dadbod', 'buffer' },
          -- markdown = { 'lsp', 'path' },
        },

        providers = {
          lsp = {
            name = 'lsp',
            enabled = true,
            module = 'blink.cmp.sources.lsp',
            kind = 'LSP',
            min_keyword_length = 2,
            score_offset = 90, -- the higher the number, the higher the priority
          },
          buffer = {
            name = 'Buffer',
            enabled = true,
            max_items = 3,
            module = 'blink.cmp.sources.buffer',
            min_keyword_length = 3,
            score_offset = 30, -- the higher the number, the higher the priority
          },
          snippets = {
            name = 'snippets',
            enabled = true,
            max_items = 15,
            min_keyword_length = 2,
            module = 'blink.cmp.sources.snippets',
            score_offset = 20, -- the higher the number, the higher the priority
          },
        },
      },

      -- blink menu in the neovim commandline `: `
      cmdline = {
        enabled = false, -- LazyVim default is false
      },

      -- WARNING: breaks neovim terminal as of Apr 2025
      --
      -- term = {
      --   enabled = true,
      --   keymap = { preset = 'inherit' }, -- Inherits from top level `keymap` config when not set
      --   sources = {},
      --   completion = {
      --     trigger = {
      --       show_on_blocked_trigger_characters = {},
      --       show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
      --     },
      --     -- Inherits from top level config options when not set
      --     list = {
      --       selection = {
      --         -- When `true`, will automatically select the first item in the completion list
      --         preselect = nil,
      --         -- When `true`, inserts the completion item automatically when selecting it
      --         auto_insert = nil,
      --       },
      --     },
      --     -- Whether to automatically show the window when new completion items are available
      --     menu = { auto_show = true },
      --     -- Displays a preview of the selected item on the current line
      --     ghost_text = { enabled = nil },
      --   },
      -- },

      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend('force', { name = source, module = 'blink.compat.source' }, opts.sources.providers[source] or {})
        if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- add ai_accept to <Tab> key
      -- if not opts.keymap['<Tab>'] then
      --   if opts.keymap.preset == 'super-tab' then -- super-tab
      --     opts.keymap['<Tab>'] = {
      --       require('blink.cmp.keymap.presets')['super-tab']['<Tab>'][1],
      --       LazyVim.cmp.map { 'snippet_forward', 'ai_accept' },
      --       'fallback',
      --     }
      --   else -- other presets
      --     opts.keymap['<Tab>'] = {
      --       LazyVim.cmp.map { 'snippet_forward', 'ai_accept' },
      --       'fallback',
      --     }
      --   end
      -- end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              -- item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      -- -- My source change -- WARNING still seems a bit buggy... Sometimes it
      -- -- works sometimes it doesn't ...
      -- opts.sources.default = function(ctx)
      --   local success, node = pcall(vim.treesitter.get_node)
      --   if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
      --     vim.notify 'Blink.cmp: comment buf'
      --     return { 'buffer' }
      --   elseif vim.bo.filetype == 'markdown' then
      --     vim.notify 'Blink.cmp: markdown buf'
      --     return { 'lsp', 'path' }
      --   else
      --     vim.notify 'Blink.cmp: default buf'
      --     return { 'lsp', 'path', 'snippets', 'buffer' }
      --   end
      -- end

      require('blink.cmp').setup(opts)
    end,
  },

  -- add icons
  {
    'saghen/blink.cmp',
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      -- opts.appearance.kind_icons = vim.tbl_extend('force', opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
    end,
  },

  -- -- add dictionary
  -- -- see Linkarzu https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua
  --
  -- -- NOTE: I was getting annoyed but the constant popup of the dictionary
  -- {
  --   'saghen/blink.cmp',
  --   dependencies = {
  --     { 'Kaiser-Yang/blink-cmp-dictionary', dependencies = { 'nvim-lua/plenary.nvim' } },
  --   },
  --   opts = {
  --     sources = {
  --       default = { 'dictionary' },
  --       providers = {
  --         dictionary = {
  --           -- https://github.com/Kaiser-Yang/blink-cmp-dictionary
  --           -- In macOS to get started with a dictionary:
  --           -- cp /usr/share/dict/words ~/dotfiles/nvim/.config/dictionaries/words.txt
  --           --
  --           -- NOTE: For the word definitions make sure "wn" is installed
  --           -- brew install wordnet
  --           module = 'blink-cmp-dictionary',
  --           name = 'Dict',
  --           score_offset = 20, -- the higher the number, the higher the priority
  --           -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
  --           enabled = true,
  --           max_items = 8,
  --           min_keyword_length = 3,
  --           opts = {
  --             -- -- The dictionary by default now uses fzf, make sure to have it
  --             -- -- installed
  --             -- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
  --             --
  --             -- Do not specify a file, just the path, and in the path you need to
  --             -- have your .txt files
  --             dictionary_directories = { vim.fn.expand '~/dotfiles/nvim/.config/dictionaries/' }, -- default Linkarzu ~/github/dotfiles-latest/dictionaries
  --             -- Notice I'm also adding the words I add to the spell dictionary
  --             dictionary_files = {
  --               vim.fn.expand '~/dotfiles/nvim/.config/nvim/spell/en.utf-8.add',
  --               vim.fn.expand '~/dotfiles/nvim/.config/nvim/spell/de.utf-8.add',
  --               -- vim.fn.expand '~/github/dotfiles-latest/neovim/neobean/spell/en.utf-8.add',
  --               -- vim.fn.expand '~/github/dotfiles-latest/neovim/neobean/spell/es.utf-8.add',
  --             },
  --             -- NOTE.see official docs on how to use different dictionaries based on filetype:
  --             -- https://github.com/Kaiser-Yang/blink-cmp-dictionary?tab=readme-ov-file#how-to-use-different-dictionaries-for-different-filetypes

  --             -- --  NOTE: To disable the definitions uncomment this section below
  --             --
  --             -- separate_output = function(output)
  --             --   local items = {}
  --             --   for line in output:gmatch("[^\r\n]+") do
  --             --     table.insert(items, {
  --             --       label = line,
  --             --       insert_text = line,
  --             --       documentation = nil,
  --             --     })
  --             --   end
  --             --   return items
  --             -- end,
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },

  -- lazydev
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  -- catppuccin support
  {
    'catppuccin',
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
