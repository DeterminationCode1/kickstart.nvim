-- UndotreeToggle https://github.com/mbbill/undotree
return {
  {
    'mbbill/undotree',
    config = function()
      -- Note: this   plugin just provides the gui for a vim built-in feature
      -- that stores undo history in a tree like structure.
      -- The primegan configured this vim settings like the following:
      -- Activate nvim's built-in feature of pestsisting undo history on disk
      -- It stores history incrementally like git
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
      vim.opt.undofile = true

      -- require('undotree').setup()
      -- Configure it via vim settings as it's a vimscript based plugin
      -- Official link to config options: https://github.com/mbbill/undotree/blob/56c684a805fe948936cda0d1b19505b84ad7e065/plugin/undotree.vim#L27
      -- Otherwise, see :help undotree
      vim.g.undotree_SetFocusWhenToggle = 1

      vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle [U]ndotree' })
    end,
  },
}
