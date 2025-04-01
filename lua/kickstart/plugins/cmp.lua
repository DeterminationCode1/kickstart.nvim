-- Autocompletion
--
-- kickstarter: https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/treesitter.lua
return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- ME: Tailwind color preview in completion menu
      'luckasRanarison/tailwind-tools.nvim',
      'onsails/lspkind-nvim',
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        -- dependencies = {
        --   -- `friendly-snippets` contains a variety of premade snippets.
        --   --    See the README about individual language/framework/plugin snippets:
        --   --    https://github.com/rafamadriz/friendly-snippets
        --   {
        --     'rafamadriz/friendly-snippets',
        --     config = function()
        --       -- NOTE: Me: the following line automatically loads all existing snippets for
        --       -- all languages that are supported by the friendly-snippets plugin.
        --       -- Thus, the lazay loading is important to not have startup time increased.
        --       require('luasnip.loaders.from_vscode').lazy_load()

        --       -- ME: The following lines extend the default snippets to other filetypes.
        --       -- Otherwise you could not use html and normal js snippets in a react file.
        --       require('luasnip').filetype_extend('javascriptreact', { 'html', 'javascript' })
        --       require('luasnip').filetype_extend('typescriptreact', { 'html', 'javascript' })

        --       -- FRAMEWORKS: snippets are not laoded by default as only people using theses
        --       -- frameworks would benefit from them. Thus, you must explicitly load them here.
        --       -- Exceptions: There is one exception, react.js is included by default in js/ts
        --       -- and only available in jsx/tsx files. They argue every webdev will use react at
        --       -- some point and making it the default alows for better support.
        --       require('luasnip').filetype_extend('python', { 'django' })

        --       -- TODO: make snippets context aware in a file. eg. html snippets only in jsx return valu but not in whole file.
        --       -- https://github.com/hrsh7th/nvim-cmp/issues/806
        --     end,
        --   },
        -- },
        --   config = function()
        --     -- require('luasnip').log.location()
        --     -- ejmastnak: Somewhere in your Neovim startup, e.g. init.lua
        --     require('luasnip').config.set_config { -- Setting LuaSnip config

        --       -- Enable autotriggered snippets
        --       enable_autosnippets = true,

        --       -- Use Tab (or some other key if you prefer) to trigger visual selection
        --       store_selection_keys = '<Tab>',
        --     }
        --     -- NOTE: me: the following loads my self-written snippets from the
        --     -- snippets folder ~/.config/nvim/LuaSnip/
        --     -- Read this excellent guide for more info: https://ejmastnak.com/tutorials/vim-latex/luasnip/
        --     -- You can either load all snippets at startup or lazy load them per
        --     -- filetype.
        --     --
        --     -- Load all snippets from the nvim/LuaSnip directory at startup
        --     -- require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/LuaSnip/' }

        --     -- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
        --     require('luasnip.loaders.from_lua').lazy_load { paths = { '~/.config/nvim/LuaSnip/' } }
        --     -- Heads up: for text in the repeated node to update as you type (e.g. like in the \end{} field in the above GIF) you must set update_events = 'TextChanged,TextChangedI' in your LuaSnip config. The default update event is InsertLeave, which will update repeated nodes only after leaving insert mode. Repeated nodes are are documented, in passing, in the section :help luasnip-extras.
        --   end,
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      -- ============= me: config luasnip =============
      luasnip.config.set_config {
        -- Don't store snippet history for less overhead
        -- history = false,
        -- Allow autotrigger snippets
        enable_autosnippets = true,
        -- For equivalent of UltiSnips visual selection
        store_selection_keys = '<Tab>',
        -- Event on which to check for exiting a snippet's region
        -- region_check_events = 'InsertEnter',
        -- delete_check_events = 'InsertLeave',
      }

      require('luasnip.loaders.from_lua').lazy_load { paths = { '~/.config/nvim/LuaSnip/' } }
      -- require('luasnip.loaders.from_lua').load { paths = { '~/.config/nvim/LuaSnip/' } }

      vim.keymap.set(
        'n',
        '<Leader>L',
        '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = {"~/.config/nvim/LuaSnip/"}})<CR><Cmd>echo "Snippets refreshed!"<CR>'
      )

      -- set keybinds for both INSERT and VISUAL. Me: this is working.
      -- You can cycle between options, but you can always only see one of them.
      -- vim.api.nvim_set_keymap('i', '<down>', '<Plug>luasnip-next-choice', {})
      -- vim.api.nvim_set_keymap('s', '<down>', '<Plug>luasnip-next-choice', {})
      -- vim.api.nvim_set_keymap('i', '<up>', '<Plug>luasnip-prev-choice', {})
      -- vim.api.nvim_set_keymap('s', '<C-p>', '<Plug>luasnip-prev-choice', {})

      -- Apart from this, there is also a picker (see |luasnip-select_choice| where no
      -- cycling is necessary and any choice can be selected right away, via
      -- `vim.ui.select`.
      vim.keymap.set('i', '<C-down>', '<cmd>lua require("luasnip.extras.select_choice")()<cr>', { desc = 'LuaSnip: Select choice' })

      -- Debug tools: print all available snippets for the current filetype
      -- https://www.reddit.com/r/neovim/comments/109018y/list_all_available_luasnips_snippets_for_a_given/?rdt=42258
      local list_snips = function()
        local ft_list = require('luasnip').available()[vim.o.filetype]
        local ft_snips = {}
        for _, item in pairs(ft_list) do
          ft_snips[item.trigger] = item.name
        end
        print(vim.inspect(ft_snips))
      end

      vim.api.nvim_create_user_command('SnipList', list_snips, {})

      -- ============= END =============

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`

        -- No, but seriously. Please read `:help ins-completion`, it is really good!

        mapping = cmp.mapping.preset.insert {
          -- ME: Debate over best completion keybindings. Seems like `C-Enter`, then `C-Y` are the winners. https://www.reddit.com/r/neovim/comments/1at66dc/what_key_do_you_prefer_to_press_to_accept_an/
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          -- ME: I tried c-y, c-n and the reason I'm switching back to tab is
          -- because one keystroke is faster than two.
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<c-s>'] = cmp.mapping(function() -- kickstarter used <C-l>
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<S-tab>'] = cmp.mapping(function() -- kickstarter used <C-h>. You cannot use s-s because then you could  type
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          {
            name = 'nvim_lsp',
            -- ========= Me: config for markdown oxide =========
            -- see https://github.com/Feel-ix-343/markdown-oxide?tab=readme-ov-file#neovim
            -- option = {
            --   markdown_oxide = { keyword_pattern = [[\(\k\| \|\/\|#\)\+]] },
            -- },
            -- ========= END =========
          },
          -- ======= me: R autocompletions =======
          -- { name = 'cmp_r' }, -- me:  moved it to languages/r.lua
          -- ========= me end =========
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' }, -- Suggestions based on content of current buffer
        },

        -- ME: Tailwind color preview in completion menu
        formatting = {
          format = require('lspkind').cmp_format {
            before = require('tailwind-tools.cmp').lspkind_format,
          },
        },
      }

      -- Me: Setup Dadbod ui completion
      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = {
          -- { name = 'nvim_lsp' },
          { name = 'luasnip' },
          -- { name = 'path' },
          { name = 'buffer' },
          { name = 'vim-dadbod-completion' }, -- NOTE: this is the important line
        },
      })
    end,
  },
}
