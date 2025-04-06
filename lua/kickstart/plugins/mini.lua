-- Kickstart configuration for mini.nvim
--
-- kickstart https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/mini.lua

-- ================================ Backup ================================================
-- WARNING: MiniFiles explorer is no longer need as it was replaced by the nvim-oil plugin.
--   require('mini.files').setup {
--     -- NOTE: Your min.files config is inspired by this reddit post: https://www.reddit.com/r/neovim/comments/1bceiw2/comment/kuhmdp9/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
--
--     -- Module mappings created only inside explorer.
--     mappings = {
--       synchronize = 'w', -- default is `=`
--       -- open file & close mini-file explorer. Defaults to `L`.
--       go_in_plus = '<CR>',
--     },
--   } -- Maybe Oil.nvim would be better as it's more minimalistic and more like a simple buffer.
--
--   vim.api.nvim_create_autocmd('User', {
--     pattern = 'MiniFilesBufferCreate',
--     callback = function(args)
--       local buf_id = args.data.buf_id
--       -- Tweak left-hand side of mini.file mapping to your liking
--       -- vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
--       -- Close MiniFile explorer
--       vim.keymap.set('n', '-', require('mini.files').close, { buffer = buf_id })
--       -- vim.keymap.set("n", "o", gio_open, { buffer = buf_id })
--     end,
--   })
--   -- Open MiniFiles explorer
--   vim.keymap.set('n', '-', function()
--     require('mini.files').open()
--   end, { desc = 'Open MinFiles' })
--   ========================================= End of backup =========================================

return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      --  Me: Important aliases to know!
      --  - b - block: { }, [ ], ( ), < >, etc.
      --  - q - quote: ', ", `, etc.

      -- See LazyVim https://www.lazyvim.org/plugins/coding#miniai
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          -- Whole buffer. Official helpfile:
          -- https://github.com/echasnovski/mini.ai/blob/9fef1097bca44616133cde6a6769e7aa07d12d7d/doc/mini-ai.txt#L461C5-L469C10
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line '$',
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          -- d = { '%f[%d]%d+' }, -- digits
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- see `:help mini.surround` for more information
      --
      -- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - gsd'   - [S]urround [D]elete [']quotes
      -- - gsr)'  - [S]urround [R]eplace [)] [']
      -- Me: You can use textobjects from mini.ai too!
      -- - gsdb   - [S]urround Delete [B]lock. E.g. delete { } or [ ] from { foo: 'bar', baz: 'qux'}
      -- Also
      -- - You can use gsa' in visual mode to surround the selected text with '.
      -- - You can surround more than just words. E.g. gsaap" to surround a paragraph with ".
      -- NOTE: I added a 'g' in front of all surround default mappings because the 's' conflicted
      -- with 'flash.nvim' [s]earch mappings.
      require('mini.surround').setup {
        -- Funy enough, I came up with the same alternative mappings as LazyVim:
        -- https://www.lazyvim.org/extras/coding/mini-surround
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
      }
      -- Me: Some shortcuts for surround
      vim.keymap.set('n', 'gs', '', { desc = 'Surround' })
      -- WARN: it needs the `remap=true` to work. Otherwise RHS will be treated as pure vim commands.
      vim.keymap.set('n', 'gsw', 'gsaiw', { desc = 'Surround a word (Alias/Shortcut for "gsaiw")', remap = true })
      -- same but dnt overwrite the normal clipboard register with ciw
      vim.keymap.set('n', 'gsl', '"ndiwi []()<esc>b"npf)P', { desc = 'Surround: word with markdown [L]ink' })
      -- TODO adopt gsl command to handle selected text parts from visual mode.

      -- Remap adding surrounding to Visual mode selection
      -- vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      -- Make special mapping for "add surrounding for line"
      vim.keymap.set('n', 'gss', 'ys_', { remap = true })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
