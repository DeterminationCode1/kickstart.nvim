-- repo https://github.com/nvim-java/nvim-java?tab=readme-ov-file
return {
  'nvim-java/nvim-java',
  dependencies = {
    'nvim-java/lua-async-await',
    'nvim-java/nvim-java-refactor',
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'nvim-java/nvim-java-dap',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    {
      'williamboman/mason.nvim',
      opts = {
        registries = {
          'github:nvim-java/mason-registry',
          'github:mason-org/mason-registry',
        },
      },
    },
  },
  config = function()
    require('java').setup {}
    require('lspconfig').jdtls.setup {}

    -- FIX: .run_app() needs an argument i don't know.
    -- vim.keymap.set('n', '<leader>ja', function()
    --   require('java').runner.built_in.run_app()
    -- end, { desc = 'Run Java app' })

    vim.keymap.set('n', '<leader>ja', '<cmd>JavaRunnerRunMain<CR>', { desc = 'Run Java [A]pp' })

    -- NOTE: maybe set a r for run beforte the jt and ja.
    vim.keymap.set('n', '<leader>jt', function()
      require('java').test.run_current_class()
    end, { desc = 'Run Java Test' })
    vim.keymap.set('n', '<leader>djt', function()
      require('java').test.debug_current_class()
    end, { desc = 'Debug Java Test' })
  end,
}
