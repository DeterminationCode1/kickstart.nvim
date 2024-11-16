-- inspired by https://github.com/catgoose/nvim/blob/main/lua/plugins/comment.lua
--
-- Maybe you need to disable autocammnd? Not sure:   { 'JoosepAlviste/nvim-ts-context-commentstring', opts = { enable_autocmd = false } },
return {
  'numToStr/Comment.nvim',
  config = function()
    local prehook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    -- Line comment motion prefix
    local prefix = 'q' -- defaults to 'gc'
    local block_prefix = 'gb' -- defaults to 'gb'

    require('Comment').setup {
      padding = true,
      sticky = true,
      ignore = '^$',
      toggler = {
        line = prefix .. 'q', -- Defaults to 'gcc'
        block = block_prefix .. 'c', -- Defaults to 'gbc'
      },
      opleader = {
        line = prefix .. '', -- Defaults to 'gc'
        block = block_prefix .. '', -- Defaults to 'gb'
      },
      extra = {
        above = prefix .. 'O', -- Defaul1s to 'gcO'
        below = prefix .. 'o', -- Defaults to 'gco'
        -- For a year I used 'qa' for 'gcA' as it was closer to the original
        -- But many textobject motions like ap am af start with 'a' and thus
        -- cannot be used if 'qa' defaults to 'comment at end of line'
        -- Also, the keyboard positio of 'qe' is a bit better than 'qa' on
        -- the colemak layout.
        eol = prefix .. 'e', -- Defaults to 'gcA'
      },
      mappings = {
        basic = true,
        extra = true,
        extended = false,
      },
      pre_hook = prehook,
      post_hook = nil,
    }
  end,

  event = 'BufReadPre',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
}
