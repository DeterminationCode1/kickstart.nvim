-- Colorscheme plugin: catppuccin
--
-- Configures the colorscheme of neovim and other plugins.
-- Me: Furthermore,  I define my custom highlights via native nvim api here too.

-- NOTE:  Original kickstarter.nvim help text:
--
-- { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   init = function()
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-night'
--
--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- },
-- Me: my self implemented colorschemes
-- All hex colors of catppuccin: https://github.com/catppuccin/catppuccin/blob/main/docs/translation-table.md

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'mocha',
    integrations = {
      -- gitsigns = false,
      cmp = true,
      flash = true,
      gitsigns = true,
      headlines = true, -- plugin not installed
      leap = true, -- plugin not installed
      mason = true,
      markdown = true,
      mini = true,
      -- native lsp settings
      noice = true,
      telescope = true,
      treesitter = true,
      which_key = true,
      headlines = false, -- I prefer my own colors
    },
    custom_highlights = function(colors)
      -- me: find all nvim builtin groups with preview with h: highlight-groups
      -- return {
      --   Comment = { fg = colors.flamingo },
      --   TabLineSel = { bg = colors.pink },
      --   CmpBorder = { fg = colors.surface2 },
      --   Pmenu = { bg = colors.none },
      -- }

      -- NOTE: Catputccin integrates with GitSignsAdd, GitSignsChange, GitSignsDelete, GitSignsChangeDelete, GitSignsTopDelete, ... groups but NOT with GitSignsUntracked.
      -- Thus, you need to manually configure it using the nvim builtin api.
      -- param 0 means it's a global highlight group
      -- vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = colors.gray0 }) -- Me: There are gray0 to 2 from dark to light

      -- WARN: using `colors.gray0` didn't work for some reason...
      vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#565970' }) -- Me: There are gray0 to 2 from dark to light

      vim.api.nvim_set_hl(0, 'markdownH1', {
        fg = '#f1fc79',
        bg = '#606430',
        bold = true,
      })

      return {
        -- TIP: find the highlight group your searching by putting the cursor on
        -- the word and running `:Inspector` command.

        -- ======================== Markdwon Heading ==============================
        -- custome heading colors
        ['@markup.heading.1.markdown'] = { fg = '#f1fc79', bg = '#606430', bold = true },
        ['@markup.heading.2.markdown'] = { fg = '#37f499', bg = '#16613d', bold = true },
        ['@markup.heading.3.markdown'] = { fg = '#04d1f9', bg = '#015363', bold = true },
        ['@markup.heading.4.markdown'] = { fg = '#f16c75', bg = '#602b2e' },
        ['@markup.heading.5.markdown'] = { fg = '#7081d0', bg = '#2c3353' },
        ['@markup.heading.6.markdown'] = { fg = '#f265b5', bg = '#602848' },
        -- Make bold text
        ['@markup.strong.markdown_inline'] = { bold = true, fg = colors.white },
        -- Code block
        ['@markup.raw.block.markdown'] = { bg = '#09090d' },
        -- Inline code
        ['@markup.raw.markdown_inline'] = { bg = '#09090d' },
        -- links
        ['@markup.link.label.markdown_inline'] = { fg = '#c792ea', underline = true },
        -- ['@markup.image_link.markdown'] = { fg = '#c792ea', underline = true },
        -- ['@markup.email_link.markdown'] = { fg = '#c792ea', underline = true },

        -- ======================== Git Signs =====================================
        -- ME: find all gitsigns highlight-groups under 'h: gitsigns-highlight-groups'
        GitSignsAdd = { fg = colors.green },
        -- GitSignsChange = { fg = colors.blue },
        GitSignsChange = { fg = '#22a2f7' },
        GitSignsDelete = { fg = colors.red },
      }
    end,
  },
  init = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
}

-- highlight_groups = {
--   {
--     group_name = 'Heading1',
--     value = { fg = '#f1fc79', bg = '#606430', bold = true },
--   },
--   {
--     group_name = 'Heading2',
--     value = { fg = '#37f499', bg = '#16613d', bold = true },
--   },
--   {
--     group_name = 'Heading3',
--     value = { fg = '#04d1f9', bg = '#015363', bold = true },
--   },
--   {
--     group_name = 'Heading3Corner',
--     value = { fg = '#015363' },
--   },
--   {
--     group_name = 'Heading4',
--     value = { fg = '#f16c75', bg = '#602b2e' },
--   },
--   {
--     group_name = 'Heading4Corner',
--     value = { fg = '#602b2e' },
--   },
--   {
--     group_name = 'Heading5',
--     value = { fg = '#7081d0', bg = '#2c3353' },
--   },
--   {
--     group_name = 'Heading6',
--     value = { fg = '#f265b5', bg = '#602848' },
--   },
--   -- Code block
--   {
--     group_name = 'CodeBlock',
--     value = { bg = '#09090d' },
--   },
--   -- Inline code
--   {
--     group_name = 'InlineCode', --MarkviewInlineCode
--     value = { bg = '#09090d' },
--   },
--   -- links
--   {
--     group_name = 'Hyperlink',
--     value = { fg = '#c792ea', underline = true },
--   },
--   {
--     group_name = 'ImageLink',
--     value = { fg = '#c792ea', underline = true },
--   },
--   {
--     group_name = 'EmailLink',
--     value = { fg = '#c792ea', underline = true },
--   },
-- },
