-- https://github.com/jaimecgomezz/here.term -- her
-- hee reason C-C- C-C- , , ., , . ., ;;;
--
-- NOTE: why I use this plugin: I no longer use toggleterm.nvim because the lightweigth here.term is
-- enough for my  one-off terminal commands and for persistent commands  that
-- would require multiple terminals, a plugin like 'overseer.nvim' or comparable
-- task manager seems to make more sense.
--
-- Simply toggle a single terminal instance (that acts like a normal
-- buffer) with a single keybinding
--
-- be aware:  Please make sure you have set the hidden option in your config file or the terminal will be discarded when toggled.
--
--
return {
  'jaimecgomezz/here.term',
  dependencies = {
    -- prevent nested nvim terminal sessions
    { 'willothy/flatten.nvim', config = true, priority = 1001 },
  },
  opts = {
    -- Mappings
    -- Every mapping bellow can be customized by providing your preferred combo, or disabled
    -- entirely by setting them to `nil`.
    --
    -- The minimal mappings used to toggle and kill the terminal. Available in
    -- `normal` and `terminal` mode.
    mappings = {
      -- In wezterm + tmux, C-/ is received as C-_. See https://www.reddit.com/r/neovim/comments/1bh3wkv/comment/kvm8ith/
      toggle = '<C-_>', -- default: '<C-;>'
      kill = '<C-S-,>', -- default: '<C-S-;>'
    },
    -- Additional mappings that I consider useful since you won't have to escape (<C-\><C-n>)
    -- the terminal each time. Available in `terminal` mode.
    -- NOTE:  I don't need them as I already remapped esc in the init.lua file.
    extra_mappings = {
      enable = false, -- Disable them entirely
    },
  },
  -- setup = function()
  -- copy paste from here-term.lua
  --
  -- -- here.term mappings
  -- map({ 'n', 't' }, opts.mappings.toggle, M.toggle_terminal, 'Toggle terminal')
  --
  -- map({ 'n', 't' }, opts.mappings.kill, M.kill_terminal, 'Kill terminal')

  --[[ vim.keymap.set { 'n', '<leader>o', require('here-term').toggle_terminal(), desc = 'Toggle Terminal' } ]]
  -- end,
}
