-- https://github.com/jaimecgomezz/here.term
--
-- Simply toggle a single terminal instance (that acts like a normal
-- buffer) with a single keybinding
--
-- be aware:  Please make sure you have set the hidden option in your config file or the terminal will be discarded when toggled.
--
-- NOTE: why I use this plugin: I no longer use toggleterm.nvim because the lightweigth here.term is
-- enough for my  one-off terminal commands and for persistent commands which
-- would require multiple terminals running in parallel, a plugin like 'overseer.nvim' or a comparable
-- task manager seems to make more sense.
--
-- Troubleshooting:
-- - Problem: The 'toggle terminal' keybindings are not created.
--   Solution: The plugin architecture seems to have been changed so that it
--   become necessary to always explicitly set the `opts.mappings.enable = true`
--   entry in the plugin's lua config table. Previously, it had worked without
--   it being stated explicitly.

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
      enable = true,
      -- In wezterm + tmux, C-/ is received as C-_. See https://www.reddit.com/r/neovim/comments/1bh3wkv/comment/kvm8ith/
      toggle = '<C-_>', -- default: '<C-;>'
      -- toggle = '<leader>gy', -- default: '<C-;>'
      kill = '<C-S-,>', -- default: '<C-S-;>'
    },
    -- Additional mappings that I consider useful since you won't have to escape (<C-\><C-n>)
    -- the terminal each time. Available in `terminal` mode.
    -- NOTE:  I don't need them as I already remapped esc in the init.lua file.
    extra_mappings = {
      enable = false, -- Disable them entirely
    },
  },

  -- NOTE: the following  config functdon is working and was helpful for
  -- debugging.
  --
  -- config = function(_, opts)
  --   -- copy paste from here-term.lua
  --   local term = require 'here-term'
  --   term.setup(opts)

  --   print 'here-term setup'
  --   -- here.term mappings
  --   local function map(mode, combo, mapping, desc)
  --     if combo then
  --       vim.keymap.set(mode, combo, mapping, { silent = true, desc = desc })
  --     end
  --   end
  --   -- map({ 'n', 't' }, opts.mappings.toggle, term.toggle_terminal, 'Toggle terminal')

  --   -- map({ 'n', 't' }, opts.mappings.kill, term.kill_terminal, 'Kill terminal')
  -- end,
}
