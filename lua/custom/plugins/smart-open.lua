-- https://github.com/danielfalk/smart-open.nvim
--
-- The keybindings are in the init.lua file together with the other telscope
-- kickstarter keybindings.
return {
  'danielfalk/smart-open.nvim',
  branch = '0.2.x',
  config = function()
    require('telescope').load_extension 'smart_open'

    -- Configure the smart_open extension
    -- see https://github.com/danielfalk/smart-open.nvim?tab=readme-ov-file#configuration
    -- require('telescope').setup {
    --   extensions = {
    --     smart_open = {
    --       -- match_algorithm = 'fzf',
    --       -- disable_devicons = false,
    --       show_scores = true, -- Show the scores for each entry. Default: false
    --     },
    --   },
    -- }
  end,

  dependencies = {
    'kkharji/sqlite.lua',
    -- Only required if using match_algorithm fzf
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { 'nvim-telescope/telescope-fzy-native.nvim' },
  },
}
