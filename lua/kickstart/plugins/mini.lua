-- Kickstart configuration for mini.nvim
-- https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/mini.lua

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

-- Me:  config not related to mini but to text objects
-- alias `dp, cp, yp, vp, qp` to delete, change, yank, select, comment  a paragraph because I do
-- not differentiate between `a` and `i` in the context of a paragraph. It is
-- just a paragraph.
vim.keymap.set('n', 'dp', 'dip', { desc = 'Delete a paragraph' })
vim.keymap.set('n', 'cp', 'cip', { desc = 'Change a paragraph' })
vim.keymap.set('n', 'yp', 'yip', { desc = 'Yank a paragraph' })
vim.keymap.set('n', 'vp', 'vip', { desc = 'Visually select a paragraph' })
vim.keymap.set('n', 'qp', 'qip', { desc = 'Comment a paragraph', remap = true })

-- Word text object.
-- The whitespace around a word is almost always autoformatted anyways
vim.keymap.set('n', 'dw', 'daw', { desc = 'Delete word' })
vim.keymap.set('n', 'cw', 'ciw', { desc = 'Change word' })
vim.keymap.set('n', 'yw', 'yiw', { desc = 'Yank word' })
vim.keymap.set('n', 'vw', 'viw', { desc = 'Visually select word' })
vim.keymap.set('n', 'qw', 'qiw', { desc = 'Comment word', remap = true })

-- Buffer text-object (i.e. global).
-- NOTE: I could also use `gg<motion>G` to select the whole buffer and not
-- depent on `mini.ai` for this.
-- vim.keymap.set('n', 'cg', 'ggcG', { desc = 'Change buffer' })
vim.keymap.set('n', 'dg', 'dag', { desc = 'Delete buffer', remap = true })
vim.keymap.set('n', 'cg', 'cag', { desc = 'Change buffer', remap = true })
vim.keymap.set('n', 'yg', 'yag', { desc = 'Yank buffer', remap = true })
vim.keymap.set('n', 'vg', 'vig', { desc = 'Visually select buffer', remap = true })

-- Argument/Parameter text-object
vim.keymap.set('n', 'do', 'dao', { desc = 'Delete argument/parameter', remap = true })
vim.keymap.set('n', 'co', 'cio', { desc = 'Change argument/parameter', remap = true })
vim.keymap.set('n', 'yo', 'yao', { desc = 'Yank argument/parameter', remap = true })
vim.keymap.set('n', 'vo', 'vao', { desc = 'Visually select argument/parameter', remap = true })
vim.keymap.set('n', 'qo', 'qao', { desc = 'Comment argument/parameter', remap = true })

-- Sentence text-object
vim.keymap.set('n', 'ds', 'das', { desc = 'Delete sentence', remap = true })
vim.keymap.set('n', 'cs', 'cis', { desc = 'Change sentence', remap = true })
vim.keymap.set('n', 'ys', 'yis', { desc = 'Yank sentence', remap = true })
vim.keymap.set('n', 'vs', 'vis', { desc = 'Visually select sentence', remap = true })
vim.keymap.set('n', 'qs', 'qis', { desc = 'Comment sentence', remap = true })

-- Map vim native comment textobject from `gc` to `Q` to avoic conflit with my
-- `g` textobject for buffer i.e. vagc
-- vim.keymap.set('n', 'Q', 'gc', { desc = '(native) Comment textobject' })
-- NOTE: mini.comment's textobject `q` (gc) is by DEFAULT! only mapped to the
-- shortform: vq, cq, dq, yq
vim.keymap.set('n', 'qu', 'qQ', { desc = 'Uncomment a comment object (i.e. consequtive line comments)', remap = true })

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
      local gen_spec = require('mini.ai').gen_spec
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup {
        n_lines = 500,

        -- Table with textobject id as fields, textobject specification as values.
        -- Also use this to disable builtin textobjects. See |MiniAi.config|.
        custom_textobjects = {

          -- =================== remap / turn-off default text-objects ===================
          -- Me: remape default textobject `q` for ', ", `, etc. to better to
          -- reach key because it is one of the most used textobjects.
          -- NOTE: the line below was copy pasted from the official lua/mini/ai.lua file (find it with gd gen_spec)
          -- ['q'] = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
          ['e'] = { { "%b''", '%b""', '%b``' }, '^.().*().$' },
          q = '', -- Turn off q default textobject for quotes

          -- t for Tag is a default textobject in mini.ai
          -- t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          -- =============================================================================

          -- ========================== My custom textobjects =========================
          -- see official :h mini.ai for more information
          -- Tweak argument to be recognized only inside `()` between `;`
          -- a = gen_spec.argument({ brackets = { '%b()' }, separator = ';' }),
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
          d = { '%f[%d]%d+' }, -- digits

          -- ======================= My custom tressitter based textobjects =======================
          -- F = spec_treesitter { a = '@function.outer', i = '@function.inner' }, -- also
          -- y = spec_treesitter { -- NOTE: You could use this to select between
          -- loops and if statements with `y` depending on
          --   a = { '@conditional.outer', '@loop.outer' },
          --   i = { '@conditional.inner', '@loop.inner' },
          -- },
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',
        },
      }

      -- Mini.comment for comment text object?
      -- NOTE: mini.comment's textobject `q` (gc) is by  only mapped to the
      -- shortform: vq, cq, dq, yq
      require('mini.comment').setup {
        -- Options which control module behavior
        options = {
          -- Function to compute custom 'commentstring'
          custom_commentstring = nil,

          -- Whether to ignore blank lines in actions and textobject
          ignore_blank_line = false,

          -- Whether to recognize as comment only lines without indent
          start_of_line = false,

          -- Whether to force single space inner padding for comment parts
          pad_comment_parts = true,
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Toggle comment (like `gcip` - comment inner paragraph) for both
          -- Normal and Visual modes
          comment = '',

          -- Toggle comment on current line
          comment_line = '',

          -- Toggle comment on visual selection
          comment_visual = '',

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          -- NOTE: Me, mini.comment's textobject `q` (gc) is by DEFAULT! only mapped to the
          -- shortform: vq, cq, dq, yq
          textobject = 'Q',
        },

        -- Hook functions to be executed at certain stage of commenting
        hooks = {
          -- Before successful commenting. Does nothing by default.
          pre = function() end,
          -- After successful commenting. Does nothing by default.
          post = function() end,
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
