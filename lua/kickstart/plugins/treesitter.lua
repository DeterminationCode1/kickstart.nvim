-- Treesitter to create a syntax tree for better code understanding and
-- manipulation.
--
-- kickstarter https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/treesitter.lua

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      -- Treesitter textobjects module. Laod this when treesitter is loaded.
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      ensure_installed = {
        -- Kickstarter default
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'latex',
        'query',
        'vim',
        'vimdoc',
        -- ------ My languages -------------
        -- R -- NOTE: moved to languages/r.lua
        -- 'r',
        -- 'rnoweb',
        -- end
        -- --------- Python -------------
        'python',
        'ninja', -- LazyVim recommended to add 'ninja' and 'rst'
        'rst', --  see https://www.lazyvim.org/extras/lang/python
        -- ---------- end -------------
        'javascript',
        'typescript',
        'css',
        'html',
        'json',
        'yaml',
        'toml',
        'dockerfile',
        'gitignore',
        'java',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      -- Modules can be activated here
      -- Me: Incremental selection allows you to select the current node and go up the tree
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          cope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      -- Me: Treesitter textobjects module.
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}
