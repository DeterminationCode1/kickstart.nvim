-- LazyVim: https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/extras/coding/luasnip.lua
-- kickstarter: https://github.com/dam9000/kickstart-modular.nvim/blob/153ec746bd3e796557f3ea9e1105c3aa94930ae4/lua/kickstart/plugins/cmp.lua
-- LuaSnip https://github.com/L3MON4D3/LuaSnip

-- Me: Originally, kickstarter setup luasnippets in the lsp config, but because
-- I switched to blink.cmp and followed LazyVim's setup,  I also decided to put
-- the luasnippet setup in its own file like LazyVim.

return {
  -- disable builtin snippet support
  { 'garymjr/nvim-snippets', enabled = false },

  -- add luasnip
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    -- build = (not LazyVim.is_win()) and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,
    build = (function() -- kickstarter build
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      -- NOTE: I prefer to create my own snippets instead of using predefined ones
      -- {
      --   'rafamadriz/friendly-snippets',
      --   config = function()
      --     require('luasnip.loaders.from_vscode').lazy_load()
      --     require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }
      --   end,
      -- },
    },
    opts = {
      delete_check_events = 'TextChanged',
      -- Don't store snippet history for less overhead
      -- history = false, -- NOTE: LazyVim defaults to true

      -- Allow autotrigger snippets
      enable_autosnippets = true,
      -- For equivalent of UltiSnips visual selection
      -- store_selection_keys = '<Tab>',
      -- Event on which to check for exiting a snippet's region
      -- region_check_events = 'InsertEnter',
      -- delete_check_events = 'InsertLeave',
    },
    -- My own config for luasnip
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.config.set_config(opts)

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
    end,
  },

  -- add snippet_forward action
  -- NOTE: I'm not sure how exactly that is relevant...
  -- {
  --   'L3MON4D3/LuaSnip',
  --   opts = function()
  --     LazyVim.cmp.actions.snippet_forward = function()
  --       if require('luasnip').jumpable(1) then
  --         vim.schedule(function()
  --           require('luasnip').jump(1)
  --         end)
  --         return true
  --       end
  --     end
  --     LazyVim.cmp.actions.snippet_stop = function()
  --       if require('luasnip').expand_or_jumpable() then -- or just jumpable(1) is fine?
  --         require('luasnip').unlink_current()
  --         return true
  --       end
  --     end
  --   end,
  -- },

  -- nvim-cmp integration
  -- {
  --   'hrsh7th/nvim-cmp',
  --   optional = true,
  --   dependencies = { 'saadparwaiz1/cmp_luasnip' },
  --   opts = function(_, opts)
  --     opts.snippet = {
  --       expand = function(args)
  --         require('luasnip').lsp_expand(args.body)
  --       end,
  --     }
  --     table.insert(opts.sources, { name = 'luasnip' })
  --   end,
  --   -- stylua: ignore
  --   keys = {
  --     { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
  --     { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  --   },
  -- },

  -- blink.cmp integration
  {
    'saghen/blink.cmp',
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = 'luasnip',
        -- Me: successfully turn off snippet expansion because tab is nedded for
        -- something else and I did not find out how to change the default <Tab>
        -- keybinding set by blink.cmp...
        active = function(_)
          return false
        end,
        -- I also turned off any default mappings for tab just in case the
        -- default vim.snippet expansion in nivm 11 is also consuming <tab>
        -- in `keymaps.lua`
        --
        -- annoying snippet auto expansion with <Tab> in insert mode
        -- vim.keymap.set({ 'i', 's' }, '<Tab>', '<Tab>', { expr = false, noremap = true }),
      },
    },
  },
}
