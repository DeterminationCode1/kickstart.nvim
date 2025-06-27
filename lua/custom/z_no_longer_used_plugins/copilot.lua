-- Plugin

-- FIX: It seems like the copilot.lua plugin cannot be deactivated/toggled like
-- copilot.vim? You can only turn of the auto suggestions but the text seems
-- still to be indexed in sent to external servers... maybe the pulgin can be
-- turned off and on directly via the lazy plugin manager?

return {
  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        -- enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        -- hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = '<Tab>', -- handled by nvim-cmp / blink.cmp. Defaults to <M-l>
          -- next = '<M-]>',
          -- prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      -- NOTE:  the copilot.lua plugin has a built-in command for toggling, but
      -- it triggers no message that informs you about whether copilot was
      -- toggled on or off...
      --
      -- Toggle copilot on and off. These is no default toggle command.
      -- But you can combine `:Copilot enable` and `:Copilot disable` to create a toggle command
      -- and track the state in a variable.
      -- SOURCE: https://www.reddit.com/r/neovim/comments/w2exp5/comment/j1cum3d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      -- Because there doesn't seem to be a way to check if copilot is enabled or not, we have to assume it's enabled by default.
      -- local copilot_on = true
      -- vim.api.nvim_create_user_command('CopilotToggle', function()
      --   if copilot_on then
      --     vim.cmd 'Copilot disable'
      --     print 'Copilot OFF'
      --   else
      --     vim.cmd 'Copilot enable'
      --     print 'Copilot ON'
      --   end
      --   copilot_on = not copilot_on
      -- end, { nargs = 0 })
      -- vim.keymap.set('n', '<leader>tc', '<cmd>CopilotToggle<CR>', { desc = 'Toggle [C]opilot', noremap = true, silent = true })

      -- To toggle auto trigger for the current buffer, use require("copilot.suggestion").toggle_auto_trigger().

      vim.keymap.set('n', '<leader>tc', function()
        require('copilot.suggestion').toggle_auto_trigger()
        vim.notify('Copilot ' .. (require('copilot.suggestion').is_visible() and 'ON' or 'OFF'), { title = 'Copilot' })
      end, { desc = '[C]opilot toggle', noremap = true, silent = true })

      -- Warning: seems the be defect...
      -- vim.keymap.set('n', '<leader>tc', '<cmd>Copilot toggle<CR>', { desc = '[C]opilot toggle', noremap = true, silent = true })
    end,
  },

  -- add ai_accept action
  -- {
  --   'zbirenbaum/copilot.lua',
  --   opts = function()
  --     LazyVim.cmp.actions.ai_accept = function()
  --       if require('copilot.suggestion').is_visible() then
  --         LazyVim.create_undo()
  --         require('copilot.suggestion').accept()
  --         return true
  --       end
  --     end
  --   end,
  -- },

  -- lualine
  -- {
  --   'nvim-lualine/lualine.nvim',
  --   optional = true,
  --   event = 'VeryLazy',
  --   opts = function(_, opts)
  --     table.insert(
  --       opts.sections.lualine_x,
  --       2,
  --       LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
  --         local clients = package.loaded['copilot'] and LazyVim.lsp.get_clients { name = 'copilot', bufnr = 0 } or {}
  --         if #clients > 0 then
  --           local status = require('copilot.api').status.data.status
  --           return (status == 'InProgress' and 'pending') or (status == 'Warning' and 'error') or 'ok'
  --         end
  --       end)
  --     )
  --   end,
  -- },

  -- Me: I don't want copilot to clutter the lsp menu suggestions (if I
  -- understand this correctly)
  -- vim.g.ai_cmp
  --     and {
  --       -- copilot cmp source
  --       {
  --         'hrsh7th/nvim-cmp',
  --         optional = true,
  --         dependencies = { -- this will only be evaluated if nvim-cmp is enabled
  --           {
  --             'zbirenbaum/copilot-cmp',
  --             opts = {},
  --             config = function(_, opts)
  --               local copilot_cmp = require 'copilot_cmp'
  --               copilot_cmp.setup(opts)
  --               -- attach cmp source whenever copilot attaches
  --               -- fixes lazy-loading issues with the copilot cmp source
  --               LazyVim.lsp.on_attach(function()
  --                 copilot_cmp._on_insert_enter {}
  --               end, 'copilot')
  --             end,
  --             specs = {
  --               {
  --                 'hrsh7th/nvim-cmp',
  --                 optional = true,
  --                 ---@param opts cmp.ConfigSchema
  --                 opts = function(_, opts)
  --                   table.insert(opts.sources, 1, {
  --                     name = 'copilot',
  --                     group_index = 1,
  --                     priority = 100,
  --                   })
  --                 end,
  --               },
  --             },
  --           },
  --         },
  --       },
  --       {
  --         'saghen/blink.cmp',
  --         optional = true,
  --         dependencies = { 'giuxtaposition/blink-cmp-copilot' },
  --         opts = {
  --           sources = {
  --             default = { 'copilot' },
  --             providers = {
  --               copilot = {
  --                 name = 'copilot',
  --                 module = 'blink-cmp-copilot',
  --                 kind = 'Copilot',
  --                 score_offset = 100,
  --                 async = true,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     }
  --   or nil,
}
