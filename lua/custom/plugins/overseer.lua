-- https://github.com/stevearc/overseer.nvim
--
-- See LazyVim's Overseer config: https://www.lazyvim.org/extras/editor/overseer
--
-- Read `:help overseer` for more information
--
-- Manage common terminal commands/tasks in Neovim
--
-- Official VS-Code tasks docs: https://code.visualstudio.com/docs/debugtest/tasks#_custom-tasks
return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerSaveBundle',
    'OverseerLoadBundle',
    'OverseerDeleteBundle',
    'OverseerRunCmd',
    'OverseerRun',
    'OverseerInfo',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerClearCache',
  },
  opts = {
    dap = false,
    task_list = {
      -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_X and max_X can be a single value or a list of mixed integer/float types.
      -- min_width = 80, -- defaults to 80
      -- max_width = 0.9,
      -- width = nil,
      min_height = 0.6, -- defaults to 90?
      -- max_height = 0.9,
      -- height = nil,
      bindings = {
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
      },
    },
    form = {
      win_opts = {
        winblend = 0,
      },
    },
    confirm = {
      win_opts = {
        winblend = 0,
      },
    },
    task_win = {
      win_opts = {
        winblend = 0,
      },
    },
  },

  -- Default direction. Can be "left", "right", or "bottom"
  direction = 'right',
  -- Set keymap to false to remove default behavior
  -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
  bindings = {
    -- ['?'] = 'ShowHelp',
    -- ['g?'] = 'ShowHelp',
    -- ['<CR>'] = 'RunAction',
    -- ['<C-e>'] = 'Edit',
    -- ['o'] = 'Open',
    -- ['<C-v>'] = 'OpenVsplit',
    -- ['<C-s>'] = 'OpenSplit',
    -- ['<C-f>'] = 'OpenFloat',
    -- ['<C-q>'] = 'OpenQuickFix',
    -- ['p'] = 'TogglePreview',
    -- ['<C-l>'] = 'IncreaseDetail',
    -- ['<C-h>'] = 'DecreaseDetail',
    -- ['L'] = 'IncreaseAllDetail',
    -- ['H'] = 'DecreaseAllDetail',
    -- ['['] = 'DecreaseWidth',
    -- [']'] = 'IncreaseWidth',
    -- ['{'] = 'PrevTask',
    -- ['}'] = 'NextTask',
    -- ['<C-k>'] = 'ScrollOutputUp',
    -- ['<C-j>'] = 'ScrollOutputDown',
    -- ['q'] = 'Close',
  },
  -- stylua: ignore
  keys = {
    -- { "<leader>o", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
    { "<leader>or", "<cmd>OverseerRun<cr>",         desc = "Run task" },
    { "<leader>oo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
    { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
  },
}
