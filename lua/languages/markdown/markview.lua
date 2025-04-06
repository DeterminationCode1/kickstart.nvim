-- repo https://github.com/OXY2DEV/markview.nvim
--
-- Render markdown files in a buffer with a live preview
--
-- Alternatives: render-markdown.nvim, seems a bit more mature?
--
--  markdown-preview.nvim

local custom_gx = require('utils.my-utils.custom-gx').my_gx

return {
  'OXY2DEV/markview.nvim',
  -- lazy = false, -- Recommended
  ft = 'markdown', -- If you decide to lazy-load anyway

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    'nvim-treesitter/nvim-treesitter',

    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('markview').setup {
      preview = {
        modes = { 'n', 'i', 'no', 'c' },
        -- Hybridmode: render whole file while in selected mode but not the line of
        -- the cursor
        hybrid_modes = { 'i', 'c' }, -- No longer used: 'n'
        -- This is nice to have
        -- callbacks = {
        --   on_enable = function(_, win)
        --     vim.wo[win].conceallevel = 2
        --     vim.wo[win].concealcursor = 'nc'
        --   end,
        -- },
      },

      -- Create/Configure your own highlight groups. Markview will be added at
      -- the beginning of the group name.
      highlight_groups = {
        ['MarkviewHeading3Corner'] = { fg = '#015363' },
        ['MarkviewHeading4Corner'] = { fg = '#602b2e' },
      },

      -- ===================================================================
      -- =========================== Markdown =============================
      -- ==================================================================
      markdown = {
        ---------------------------- Headings ----------------------------
        -- See official headings config docs: https://github.com/OXY2DEV/markview.nvim/wiki/Headings
        --
        -- Tip  use style=icon for heading take up full width
        --    use style=label for heading to e as long as content
        --
        -- My favorite eldrich headings
        --     vim.cmd [[highlight Headline1 guifg=#f1fc79 guibg=#606430]]
        --     vim.cmd [[highlight Headline2 guifg=#37f499 guibg=#16613d]]
        --     vim.cmd [[highlight Headline3 guifg=#04d1f9 guibg=#015363]]
        --     vim.cmd [[highlight Headline4 guifg=#f16c75 guibg=#602b2e]]
        --     vim.cmd [[highlight Headline5 guifg=#7081d0 guibg=#2c3353]]
        --     vim.cmd [[highlight Headline6 guifg=#f265b5 guibg=#602848]]
        --
        -- Favorite heading symbols
        --  bullets = { '󰎤 ', '󰎧', '󰎪', '󰎭', '󰎱', '󰎳' },
        --  me, default icons: '󰼏  ', '󰎨  ', '󰼑  ', '󰎲  ', '󰼓  '
        --  me, other icons: '① ', '②', '③', '④', '⑤', '⑥'
        headings = {
          -- NOTE:  since v25, it seems like MarkviewHeadingX automatically
          -- decreases the background color opacity? If you don't like the
          -- change, overwrite the `hl` argument and set it to the raw markdown
          -- highlight group for headings.
          enable = true,
          -- Number of shift_char to add per level. Or nil.
          shift_width = 1,

          heading_1 = {
            icon = '  ', -- icon = '󰼏  ',
            style = 'icon', -- Either 'simple', 'label', 'icon'
            -- icon = '󰎤',

            -- padding_left = ' ',
            -- padding_right = '    ',

            sign = '', -- The sign is  NOT the icon of the heading but a sign in the left column of the editor

            -- Highlight group for the line containing the heading.
            hl = 'MarkviewHeading1',
          },
          heading_2 = {
            style = 'icon', -- Either 'simple', 'label', 'icon'
            icon = '󰼏  ',

            -- padding_left = ' ',
            -- padding_right = '    ',

            sign = '',
            hl = 'MarkviewHeading2',
          },
          heading_3 = {
            style = 'label',
            icon = '󰎧  ', -- icon = '󰎨  ', -- icon = '󰎪  ',

            padding_left = ' ',
            padding_right = '             ',
            corner_right = '',
            corner_right_hl = 'Heading3Corner',

            sign = '',
            hl = 'MarkviewHeading3',
          },
          heading_4 = {
            style = 'label',
            icon = '󰎪  ', -- icon = '󰎭  ',

            padding_left = ' ',
            padding_right = '     ',
            corner_right = '',
            corner_right_hl = 'Heading4Corner',

            sign = '',
            hl = 'MarkviewHeading4',
          },
          heading_5 = {
            style = 'label',

            icon = '󰎭  ', -- icon = '󰎱 ',

            padding_left = ' ',
            padding_right = ' ',

            sign = '',
            hl = 'MarkviewHeading5',
          },
          heading_6 = {
            style = 'label',
            icon = '󰎱  ', -- icon = '󰎳',

            padding_left = ' ',
            padding_right = ' ',

            sign = '',
            hl = 'MarkviewHeading6',
          },
          -- setext_1 = {},
          -- setext_2 = {},
        },

        -- ============================= Code Blocks =============================
        -- See: https://github.com/OXY2DEV/markview.nvim/wiki/Code-blocks
        code_blocks = {
          enable = true,
          style = 'block', -- me: defaults to 'block'
          min_width = 70,

          pad_amount = 2,
          pad_char = ' ',

          -- Overwrite default highlight group with normal color scheme group
          border_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockBorder'
          hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlock'
          info_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockInfo'
          -- label_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockLabel'
          sign_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockSign'
          default = {
            block_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlock'
            pad_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockInfo'
          },
          ['diff'] = {
            pad_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlockInfo'
            block_hl = '@markup.raw.block.markdown', -- me: defaults to 'MarkviewCodeBlock'
          },

          sign = false, -- Don't show the sign column. Too much clutter
        },
        -- ============================= List Items =============================
        -- ses https://github.com/OXY2DEV/markview.nvim/wiki/List-items
        list_items = {
          enable = true,
          -- FIX: a indent_size of 0 prevents all nesting. Same goes for
          -- shift_width. But I want to have no default indent for first level list items.
          shift_width = 1, -- Number of spaces to add per indent level of the list item. Default is 4.
          indent_size = 1, -- The number of spaces to add to the left of the list item marker. Default is 2.

          marker_minus = {
            -- a small dot as a marker
            text = '•',
          },
          marker_plus = {
            text = '•',
          },
          marker_star = {
            text = '•',
          },
          marker_dot = {
            text = '•',
          },
        },

        -- ============================= Block Quotes =============================
        -- block_quotes = {}, -- Create custom callouts if you need to. The
        -- default is enough for me.
        -- ============================= Tables =============================
        -- https://github.com/OXY2DEV/markview.nvim/wiki/Block-quotes
      },

      -- ====================================================================================================
      -- =========================== Markdown Inline Elements ===============================================
      -- ====================================================================================================
      markdown_inline = {

        inline_codes = {
          enable = true,
          hl = '@markup.raw.markdown_inline', -- me: defaults to 'MarkviewCodeBlock'. use nvim default instead.

          padding_left = ' ', -- me: defaults to ' '
          padding_right = ' ', -- me: defaults to ' '
        },
        -- ============================= Links =============================
        -- See: https://github.com/OXY2DEV/markview.nvim/wiki/Links
        -- hyperlinks = {
        --   enable = true,

        -- hyperlinks = {
        --   icon = '󰌷 ',
        --   hl = 'MarkviewHyperlink',
        -- },
        internal_links = {
          default = {
            icon = '', -- No icon for internal links. Default is '󰌷 '
            -- hl = 'MarkviewHyperlink',
          },
        },

        images = {
          enable = true,
          default = {
            icon = '󰥶 ',
            -- hl = 'MarkviewImage', --   hl = 'MarkviewImageLink',
          },
          ['%.svg$'] = { icon = '󰜡 ' },
          ['%.png$'] = { icon = '󰸭 ' },
          ['%.jpg$'] = { icon = '󰈥 ' },
          ['%.gif$'] = { icon = '󰵸 ' },
          ['%.pdf$'] = { icon = ' ' },
          -- Me:  add avif and webp support
          ['%.avif%'] = { icon = '󰥶 ' },
          ['%.webp%'] = { icon = '󰥶 ' },
        },
        --   emails = {},
        -- },
      },
    }

    -- -- ============================= Extra Config =============================
    -- -- This section is NOT a part of the `headlines.nvim` plugin, but a nvim native
    -- -- config for customizing headings.
    -- -- It was copy pasted from: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/highlights.lua
    -- -- Custom highlight settings for markdown headers

    -- Defines the codeblock background color to something darker
    vim.cmd [[highlight CodeBlock guibg=#09090d]]
    -- When you add a line of dashes with --- this specifies the color, I'm not
    -- adding a "guibg" but you can do so if you want to add a background color
    vim.cmd [[highlight Dash guifg=white]]

    -- -- Set bold text in Markdown to thick bold white
    -- -- WARN: This did not work. You need to configure this in your colorscheme
    -- -- custom highlights
    vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', {
      fg = '#f1fc79',
      bg = '#606430',
      bold = true,
    })
    vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', {
      fg = '#37f499',
      bg = '#16613d',
      bold = true,
    })
    -- print 'Setting markdownBold'
    -- vim.api.nvim_set_hl(0, 'markdownBold', { bold = true, fg = '#ffffff' })
    -- vim.api.nvim_set_hl(0, 'markdownBold', { bold = true, fg = '#ffffff' })
    -- vim.api.nvim_set_hl(0, '@markdown.strong.markdown_inline', { bold = true, fg = '#ffffff' })

    -- ============================= fix gx ====================================
    -- delete the gx mapping in markview.nvim
    --
    -- Create an autocmd that removes the keymap set by nvim_buf_set_keymap and
    -- sets my own instead
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MarkviewAttach',
      callback = function(event)
        --- This will have all the data you need.
        local data = event.data

        -- vim.notify("say 'MarkviewAttach' event fired", vim.log.levels.INFO)

        -- delet gx keymap for buffer set by markview.nvim
        -- NOTE: this is necessary, otherwise your gx mapping will not be used
        vim.api.nvim_buf_del_keymap(0, 'n', 'gx')

        -- set gx keymap for buffer
        vim.keymap.set({ 'n', 'x' }, 'gx', function()
          vim.notify('having gx', vim.log.levels.INFO)
          custom_gx()
        end, {
          desc = 'X Open (external) URL under cursor',
        })

        -- Debug message
        -- vim.notify('MarkviewAttach event fired', vim.log.levels.DEBUG, {
        --   title = 'Markview',
        --   timeout = 5000,
        -- })
      end,
    })

    -- =========================================================================
    -- This is to prevent needing to manually refresh the view.
    vim.cmd 'Markview Enable'
  end,
}
