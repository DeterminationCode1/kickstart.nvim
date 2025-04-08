-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.
--
-- Me: helpful things to know
-- def hunk: smallest unit of change in a file
-- def stage: add a change to the index (staging area)
-- def index: staging area, where changes are prepared for the next commit

return {
  {
    'lewis6991/gitsigns.nvim',
    -- event = 'LazyFile', -- used by LazyVim
    opts = {
      -- signs = { -- gitsigns defaults
      --   add = { text = '│' },
      --   change = { text = '│' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
      -- signs = { -- LazyVim defaults
      --   add = { text = '▎' },
      --   change = { text = '▎' },
      --   delete = { text = '' },
      --   topdelete = { text = '' },
      --   changedelete = { text = '▎' },
      --   untracked = { text = '▎' },
      -- },
      signs = { -- My signs preferences
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '▎' },
        changedelete = { text = '▎' },
        untracked = { text = '┆' },
      },
      attach_to_untracked = true, -- Me: Defaults to false in both gitsigns and kickstart.
      -- Override the highlight groups to use custom colors
      -- Use your preferred highlight groups or define new ones
      on_attach = function(bufnr) -- zst
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hU', gitsigns.reset_buffer_index, { desc = 'git [U]ndo stage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        -- Use gitsigns.preview_hunk if you prefer a floating window and preview_hunk otherwise
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hB', gitsigns.blame_line, { desc = 'git [b]lame line' }) -- B because b is used for 'select branches' in neogit telescope
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'GitSigns: [T]oggle git show [b]lame line' })
        map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'GitSigns: [T]oggle git show [D]eleted' }) -- Defaults to '<>tD'
        map('n', '<leader>th', gitsigns.toggle_linehl, { desc = 'GitSigns: [T]oggle git show [h]ighlight' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        map({ 'o', 'x' }, 'ah', ':<C-U>Gitsigns select_hunk<CR>')

        -- Me: Highlight groups
        -- -- Catpuccin theme https://github.com/catppuccin/nvim/blob/894efb557728e532aa98b98029d16907a214ec05/lua/catppuccin/groups/integrations/gitsigns.lua
        -- WARNING: Your colorscheme often has an integration to alter gitsigns highlight/signe colors
        -- Or you can write your own highlight groups like GitSignsAdd, GitSignsChange, GitSignsDelete...
        -- or customise in your colorscheme plugin setup the gitsigns highlights. This is what you did for catppuccin
        --
      end,
    },
  },
}
