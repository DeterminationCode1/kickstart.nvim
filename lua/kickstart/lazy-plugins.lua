-- My Docs on lazyloading via `lazy.nvim`:
-- Profile startup time by using `:Lazy profile`
-- official exmaples https://lazy.folke.io/spec/examples
-- official docs https://lazy.folke.io/spec#spec-lazy-loading
--
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- WARNING: ME: I modified the kickstart original to my liking and moved the whole
  -- comment.nvim plugin config into a separate file in the custom plugins folder.

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- WARNING: Kickstart added gitsigns.nvim partial config here, but also
  -- had a full config in the custom plugins folder. So, I decided to move all the
  -- configuration into the gitigns.lua file in the custom plugins folder.

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  -- Which-key: Display keybindings in Neovim
  require 'kickstart.plugins.which-key',

  -- Fuzzy find: Telescope
  require 'kickstart.plugins.telescope',

  -- Me install shell tools: Mason
  require 'kickstart.plugins.mason',

  -- LSP Plugins
  require 'kickstart.plugins.lspconfig',

  -- Autoformatting
  require 'kickstart.plugins.conform',

  -- Snippets
  require 'kickstart.plugins.luasnip',

  -- Code auto-completion
  -- require 'kickstart.plugins.cmp',
  require 'kickstart.plugins.blink',

  -- NOTE:  I extracted the colorscheme plugin into its own file

  -- NOTE: The 'todo-comment.nvim' configuration was moved to its own file.

  -- Mini.nvim various utilities for neovim
  require 'kickstart.plugins.mini',

  -- Treesitter: syntax highlighting and code understanding
  require 'kickstart.plugins.treesitter',

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',

  -- Automatic parentheses, brackets, quotes, etc. pairing
  require 'kickstart.plugins.ultimate-autopair', -- replace autopairs.nvim
  -- require 'kickstart.plugins.neo-tree', -- NOTE: I use `snacks.nvim` picker file explorer instead
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },

  -- My configurations for each programming language like python, javascript, java etc.
  -- This will import all lua files in the directory `lua/languages/`
  { import = 'languages' },
  { import = 'languages.markdown' }, -- because the markdown config was so large I split it into multiple files
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
