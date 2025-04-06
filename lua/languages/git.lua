-- LazyVim https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/extras/lang/git.lua

return {
  -- recommended = {
  --   ft = { 'gitcommit', 'gitconfig', 'gitrebase', 'gitignore', 'gitattributes' },
  -- },
  -- ============================ treesitter ==================================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'git_config', 'gitcommit', 'git_rebase', 'gitignore', 'gitattributes' } },
  },

  -- ============================ Autocompletion ==============================
  -- { -- NOTE:I switched to blink.cmp
  --   'hrsh7th/nvim-cmp',
  --   -- optional = true,
  --   dependencies = {
  --     { 'petertriho/cmp-git', opts = {} },
  --   },
  --   ---@module 'cmp'
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     table.insert(opts.sources, { name = 'git' })
  --   end,
  -- },
}
