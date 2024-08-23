-- repo https://github.com/OXY2DEV/markview.nvim
--
-- Render markdown files in a buffer with a live preview
--
-- Alternatives: render-markdown.nvim, seems a bit more mature?
--
--  markdown-preview.nvim

return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    'nvim-treesitter/nvim-treesitter',

    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('markview').setup {
      modes = { 'n', 'i', 'no', 'c' },
      -- Hybridmode: render whole file while in selected mode but not the line of
      -- the cursor
      hybrid_modes = { 'i', 'c' }, -- No longer used: 'n'
      -- This is nice to have
      callbacks = {
        on_enable = function(_, win)
          vim.wo[win].conceallevel = 2
          vim.wo[win].concealcursor = 'nc'
        end,
      },
      -- Create/Configure your own highlight groups. Markview will be added at
      -- the beginning of the group name.
      highlight_groups = {
        {
          group_name = 'Heading1',
          value = { fg = '#f1fc79', bg = '#606430', bold = true },
        },
        {
          group_name = 'Heading2',
          value = { fg = '#37f499', bg = '#16613d', bold = true },
        },
        {
          group_name = 'Heading3',
          value = { fg = '#04d1f9', bg = '#015363', bold = true },
        },
        {
          group_name = 'Heading3Corner',
          value = { fg = '#015363' },
        },
        {
          group_name = 'Heading4',
          value = { fg = '#f16c75', bg = '#602b2e' },
        },
        {
          group_name = 'Heading4Corner',
          value = { fg = '#602b2e' },
        },
        {
          group_name = 'Heading5',
          value = { fg = '#7081d0', bg = '#2c3353' },
        },
        {
          group_name = 'Heading6',
          value = { fg = '#f265b5', bg = '#602848' },
        },
        -- Code block
        {
          group_name = 'CodeBlock',
          value = { bg = '#09090d' },
        },
        -- Inline code
        {
          group_name = 'InlineCode', --MarkviewInlineCode
          value = { bg = '#09090d' },
        },
        -- links
        {
          group_name = 'Hyperlink',
          value = { fg = '#c792ea', underline = true },
        },
        {
          group_name = 'ImageLink',
          value = { fg = '#c792ea', underline = true },
        },
        {
          group_name = 'EmailLink',
          value = { fg = '#c792ea', underline = true },
        },
      },

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
      headings = {
        enable = true,
        -- Number of shift_char to add per level. Or nil.
        shift_width = 1,

        heading_1 = {
          icon = '󰼏  ',
          style = 'icon', -- Either 'simple', 'label', 'icon'
          -- concatenate string lua '[[]]'
          -- icon = '󰎤',

          -- padding_left = ' ',
          -- padding_right = '    ',

          sign = '', -- The sign is  NOT the icon of the heading but a sign in the left column of the editor

          -- Highlight group for the line containing the heading.
          hl = 'MarkviewHeading1',
        },
        heading_2 = {
          style = 'icon', -- Either 'simple', 'label', 'icon'

          -- icon = '② ',

          -- padding_left = ' ',
          -- padding_right = '    ',

          sign = '',

          hl = 'MarkviewHeading2',
        },
        heading_3 = {
          style = 'label',

          icon = '󰎪  ',

          padding_left = ' ',
          padding_right = '             ',
          corner_right = '',
          corner_right_hl = 'Heading3Corner',

          sign = '',

          hl = 'MarkviewHeading3',
        },
        heading_4 = {
          style = 'label',

          icon = '󰎭  ',

          padding_left = ' ',
          padding_right = '     ',
          corner_right = '',
          corner_right_hl = 'Heading4Corner',

          sign = '',

          hl = 'MarkviewHeading4',
        },
        heading_5 = {
          style = 'label',

          icon = '󰎱 ',

          padding_left = ' ',
          padding_right = ' ',

          sign = '',

          hl = 'MarkviewHeading5',
        },
        heading_6 = {
          style = 'label',

          icon = '󰎳',

          padding_left = ' ',
          padding_right = ' ',

          sign = '',

          hl = 'MarkviewHeading6',
        },

        setext_1 = {},
        setext_2 = {},
      },
      -- ============================= Code Blocks =============================
      -- See: https://github.com/OXY2DEV/markview.nvim/wiki/Code-blocks
      code_blocks = {
        enable = true,
        style = 'language',
        icons = true,
        position = nil,
        min_width = 70,

        pad_amount = 2,
        pad_char = ' ',

        language_direction = 'right',
        language_names = {},

        hl = 'MarkviewCodeBlock',

        sign = false, -- Don't show the sign column. Too much clutter
      },
      inline_codes = {
        enable = true,
        corner_left = '', -- Default is ' '
        corner_right = '', -- Default is ' '

        hl = 'MarkviewInlineCode',
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
      -- ============================= Links =============================
      -- See: https://github.com/OXY2DEV/markview.nvim/wiki/Links
      links = {
        enable = true,

        hyperlinks = {
          icon = '󰌷 ',
          hl = 'MarkviewHyperlink',
        },
        images = {
          icon = '󰥶 ',
          hl = 'MarkviewImageLink',
        },
        emails = {},
      },
      -- ============================= Tables =============================
      -- https://github.com/OXY2DEV/markview.nvim/wiki/Block-quotes

      block_quotes = {
        -- NOTE: By default the plugin doensnt allow cutom titles  for callouts
        -- of type `ABSTRACT`, `TODO`, `SUCCESS`, `QUESTION`, `FAILURE`,
        -- `DANGER`. that can be rather confusing.
        callouts = {
          --- From `Obsidian`
          {
            match_string = 'SUMMARY',
            callout_preview = '󱉫 Summary',
            callout_preview_hl = 'MarkviewBlockQuoteNote',

            custom_title = true,
            custom_icon = '󱉫 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteNote',
          },
          {
            match_string = 'ABSTRACT',
            callout_preview = '󱉫 Abstract',
            callout_preview_hl = 'MarkviewBlockQuoteNote',

            custom_title = true,
            custom_icon = '󱉫 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteNote',
          },
          {
            match_string = 'TODO',
            callout_preview = ' Todo',
            callout_preview_hl = 'MarkviewBlockQuoteNote',

            custom_title = true,
            custom_icon = ' ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteNote',
          },
          {
            match_string = 'SUCCESS',
            callout_preview = '󰗠 Success',
            callout_preview_hl = 'MarkviewBlockQuoteOk',

            custom_title = true,
            custom_icon = '󰗠 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteOk',
          },
          {
            match_string = 'QUESTION',
            callout_preview = '󰋗 Question',
            callout_preview_hl = 'MarkviewBlockQuoteWarn',

            custom_title = true,
            custom_icon = '󰋗 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteWarn',
          },
          {
            match_string = 'FAILURE',
            callout_preview = '󰅙 Failure',
            callout_preview_hl = 'MarkviewBlockQuoteError',

            custom_title = true,
            custom_icon = '󰅙 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteError',
          },
          {
            match_string = 'DANGER',
            callout_preview = ' Danger',
            callout_preview_hl = 'MarkviewBlockQuoteError',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteError',
          },
          {
            match_string = 'BUG',
            callout_preview = ' Bug',
            callout_preview_hl = 'MarkviewBlockQuoteError',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteError',
          },
          {
            match_string = 'EXAMPLE',
            callout_preview = '󱖫 Example',
            callout_preview_hl = 'MarkviewBlockQuoteSpecial',

            custom_title = true,
            custom_icon = ' 󱖫 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteSpecial',
          },
          {
            match_string = 'QUOTE',
            callout_preview = ' Quote',
            callout_preview_hl = 'MarkviewBlockQuoteDefault',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteDefault',
          },
          {
            match_string = 'NOTE',
            callout_preview = '󰋽 Note',
            callout_preview_hl = 'MarkviewBlockQuoteNote',

            custom_title = true,
            custom_icon = ' 󰋽 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteNote',
          },
          -- --------------------- Added by me ------------------------
          {
            match_string = 'INFO',
            callout_preview = '󰋽 Info',
            callout_preview_hl = 'MarkviewBlockQuoteNote',

            custom_title = true,
            custom_icon = ' 󰋽 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteNote',
          },
          -- ----------------------- End ------------------------

          {
            match_string = 'TIP',
            callout_preview = ' Tip',
            callout_preview_hl = 'MarkviewBlockQuoteOk',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteOk',
          },
          {
            match_string = 'IMPORTANT',
            callout_preview = ' Important',
            callout_preview_hl = 'MarkviewBlockQuoteSpecial',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteSpecial',
          },
          {
            match_string = 'WARNING',
            callout_preview = ' Warning',
            callout_preview_hl = 'MarkviewBlockQuoteWarn',

            custom_title = true,
            custom_icon = '  ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteWarn',
          },
          {
            match_string = 'CAUTION',
            callout_preview = '󰳦 Caution',
            callout_preview_hl = 'MarkviewBlockQuoteError',

            custom_title = true,
            custom_icon = ' 󰳦 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteError',
          },
          {
            match_string = 'CUSTOM',
            callout_preview = '󰠳 Custom',
            callout_preview_hl = 'MarkviewBlockQuoteWarn',

            custom_title = true,
            custom_icon = ' 󰠳 ',

            border = '▋',
            border_hl = 'MarkviewBlockQuoteWarn',
          },
        },
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
    -- vim.api.nvim_set_hl(0, 'markdownBold', { bold = true, fg = '#ffffff' })
    -- vim.api.nvim_set_hl(0, 'markdownBold', { bold = true, fg = '#ffffff' })
    -- vim.api.nvim_set_hl(0, 'markdownBold', { bold = true, fg = '#ffffff' })
    -- vim.api.nvim_set_hl(0, '@markdown.strong.markdown_inline', { bold = true, fg = '#ffffff' })

    -- =========================================================================
    -- This is to prevent needing to manually refresh the view.
    vim.cmd 'Markview enableAll'
  end,
}
