-- Mason and its related plugins to install tools like LSPs, formatters,
-- linters, etc. programmatically.
--
-- Be aware: Kickstart.nvim did not modularize mason into its own file, but
-- rather include it in the `lspconfig.lua` file. The advantage of that was that
-- the lsp servers were deduced from `nvim-lspconfig` and had no longer to be
-- listed in `mason-tool-installer`. But that was actually a bit confusing in
-- the beginning that only LSPs and nothing else was automatically installed...
--
-- In the end, I decided to modularize it into its own file to make it possible
-- to define the `mason-tool-installer` options also in other files like
-- `python.lua`, or `javascript.lua` which was not previously possible.
return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  -- and https://github.com/folke/lazy.nvim/blob/main/CHANGELOG.md#features-19
  opts_extend = { 'ensure_installed' },
  opts = {
    ensure_installed = {
      -- =========== Lua ===========
      'lua_ls', -- LSP
      'stylua', -- Formatter
      'luacheck', -- Linter

      -- =========== CSS ===========
      -- 'tailwindcss', -- Tailwind CSS IntelliSense
      'stylelint', -- Linter

      -- =========== C ===========
      -- Some of these might also apply to cpp
      'clang-format', -- Formatter

      -- ========== Docker ===========
      'hadolint', -- Linter
      -- ========== Kubernetes ===========
      -- 'kube-lint', -- Linter. -- FIX: kube-lint doesn't exist in Mason.

      -- ========== Shell  ===========
      'shfmt', -- Formater
      'shellcheck', -- Linter. only for bash, posix-shell. Doesn't work for zsh.

      -- =========== General Text ===========
      -- Powerful speling checker for your editor. Codespell would be a ligthway alternative.
      -- 'cspell',
      -- 'texlab', -- LaTeX language server
    },
  },
  config = function(_, opts)
    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    vim.notify('Mason is installed and configured. You can run :Mason to check the status of the tools.', vim.log.levels.DEBUG, {
      title = 'Mason',
      timeout = 5000,
    })
    -- print out ensure_installed
    vim.notify(vim.inspect(opts.ensure_installed), vim.log.levels.DEBUG, {
      title = 'Mason',
      timeout = 5000,
    })

    require('mason-tool-installer').setup { ensure_installed = opts.ensure_installed }
  end,
}
