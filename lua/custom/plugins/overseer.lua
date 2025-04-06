-- Plugin https://github.com/stevearc/overseer.nvim
-- LazyVim: https://www.lazyvim.org/extras/editor/overseer
--
-- Read `:help overseer` for more information
--
-- Manage common terminal commands/tasks in Neovim
--
-- Official VS-Code tasks docs: https://code.visualstudio.com/docs/debugtest/tasks#_custom-tasks

-- Usage
--
-- Create a task template:
--    You can either create a global task template in the overseer plugin config
--    or use VS-Code style tasks.json files in your project's `.vscode` folder.
--
--    At the moment , it seems that the .vscode/tasks.json is better because it's easier for ChatGPT to generate,
--    can be used in other editors, and can be locally added to a project repo
--    (I have not found a way to do that with .lua tasks so far...)
--    UPDATE: I found out how to create project local tasks via lua snippets/shorthand/refresh_snippets.sh
--    nonetheless, I think vs-code style tasks are easier to use and more standardized
--
--    TIP create template: ask ChatGPT to generate the tasks.json file for you - it's quite accurate
--
--    TIP order tasks: the selection menu for the tasks orders them alphabetically, so if
--    you want a certain common task to be at the top of the list, add e.g. "1",
--    "2", ... In front of the task name in the tasks.json file
--
-- Run and manage tasks:
--    First, execute a task template:
--        <leader>or: `:OverseerRun` to execute a task template
--
--    Then, see all your running/executed tasks:
--        <leader>ot: `:OverseerToggle` to open the task list

--
-- Debugging: See which task templates are available (found by Overseer in your project):
--    use :OverseerInfo this command lists all available task templates

-- ============================== Example .vscode/tasks.json ==============================
-- {
--   "version": "2.0.0",
--   "tasks": [
--     {
--       "label": "Run a shell script: Regenerate snippets",
--       "type": "shell",
--       "command": "~/dotfiles/snippets/shorthand/refresh_snippets.sh",
--       "problemMatcher": [],
--       "group": {
--         "kind": "build",
--         "isDefault": true
--       },
--       "presentation": {
--         "echo": true,
--         "reveal": "always",
--         "focus": false,
--         "panel": "shared",
--         "showReuseMessage": true,
--         "clear": true
--       }
--     },
--     {
--       "label": "Add Shorthand snippet (EN)", // Open a file
--       "type": "shell",
--       "command": "nvim",
--       "args": [
--         "--server",
--         "$(NVIM_LISTEN_ADDRESS)",
--         "--remote",
--         "~/dotfiles/snippets/shorthand/shorthand_en.csv"
--       ],
--       "problemMatcher": [],
--       "group": { "kind": "build", "isDefault": true }
--     }
--   ]
-- }

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
    -- { "<leader>o", "<cmd>OverseerToggle<cr>",      desc = "Toggle Overseer (Task list)" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>",      desc = "Toggle Overseer (Task list)" },
    -- { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
    { "<leader>or", "<cmd>OverseerRun<cr>",         desc = "Run task (execute a command)" },
    { "<leader>oo", "<cmd>OverseerRun<cr>",         desc = "Run task (execute a command)" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
  },
}
