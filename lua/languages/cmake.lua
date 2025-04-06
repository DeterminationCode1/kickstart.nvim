-- LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/cmake.lua
--
-- CMake configs
return {
  -- recommended = function()
  --   return LazyVim.extras.wants {
  --     ft = 'cmake',
  --     root = { 'CMakePresets.json', 'CTestConfig.cmake', 'cmake' },
  --   }
  -- end,
  -- ======================== Treesitter =========================
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { ensure_installed = { 'cmake' } },
  },
  -- ======================== LSP ============================
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },
  -- ======================== Linting ================================
  {
    'mfussenegger/nvim-lint',
    -- optional = true,
    opts = {
      linters_by_ft = {
        cmake = { 'cmakelint' },
      },
    },
  },
  -- ===================== Install cli tools ============================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'neocmake', -- LSP
        'cmakelang', -- formatter
        'cmakelint', -- linter
      },
    },
  },
  -- ===================== CMake tools ============================
  -- https://github.com/Civitasv/cmake-tools.nvim
  --
  -- The goal of this plugin is to offer a comprehensive, convenient, and powerful workflow for CMake-based projects in Neovim, comparable to the functionality provided by vscode-cmake-tools for Visual Studio Code.
  --
  -- e.g. Run `:CMakeBuild` to build the project, `:CMakeClean` to clean the
  -- build directory, and `:CMakeSelectBuildType` to select the build type from
  -- within Neovim.
  --
  -- NOTE: I think maybe its easier to have a `overseer` task for this instead
  -- of having to type the commands?
  {
    'Civitasv/cmake-tools.nvim',
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          require('lazy').load { plugins = { 'cmake-tools.nvim' } }
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
}
