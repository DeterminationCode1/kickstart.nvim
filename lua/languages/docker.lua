-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua

return {
  -- recommended = function()
  --   return LazyVim.extras.wants {
  --     ft = 'dockerfile',
  --     root = { 'Dockerfile', 'docker-compose.yml', 'compose.yml', 'docker-compose.yaml', 'compose.yaml' },
  --   }
  -- end,

  -- ======================== treesitter =========================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'dockerfile' } },
  },
  -- ======================== LSP ============================
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  -- ======================== linter =========================
  {
    'mfussenegger/nvim-lint',
    -- optional = true,
    opts = {
      linters_by_ft = {
        dockerfile = { 'hadolint' },
      },
    },
  },
  -- ======================== Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'hadolint', -- linter
        'dockerls', -- LSP
      },
    },
  },
}
