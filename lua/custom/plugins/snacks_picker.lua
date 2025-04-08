-- find files,  words, keymaps etc. in neovim.
--
-- partly copy pasted from `..editor/snacks_picker.lua` from LazyVim

Snacks = require 'snacks'

return {
  -- desc = 'Fast and modern file picker',
  -- recommended = true,
  {
    'folke/snacks.nvim',
    opts = {
      -- Picker: Telescope replacement
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      picker = {
        enabled = true,
        matcher = {
          frecency = true,
        },
        debug = {
          scores = true, -- show frecency scores in list
        },
        win = {
          input = {
            -- NOTE: by default, hitting `esc` would enter into normal mode and
            -- `q` would quite the search... but I like to have `esc` close the
            -- picker, which has the downside that you cannot use noraml mode
            -- motions that do not start with a modifier key.
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },

              -- Me: scroll in file results list
              -- ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } }, -- default
              -- ['<c-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } }, -- default
              ['<PageUp>'] = { 'list_scroll_up', mode = { 'i', 'n' } }, -- I prefer pageup/page down keys
              ['<PageDown>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
              -- ["G"] = "list_bottom", -- default
              -- ["gg"] = "list_top", -- default
              --
              -- <C-S-g> was unfortunately not recognises by snacks
              ['G'] = { 'list_bottom', mode = { 'i', 'n' } }, -- My workaround for missing normal mode
              ['<C-g>'] = { 'list_top', mode = { 'i', 'n' } }, -- My workaround for missing normal mode

              -- Linkarzu: scroll in code preview. He is used to scrolling like this in LazyGit
              ['J'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['K'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              -- ['H'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
              -- ['L'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 80,
          },
        },
      },
      -- picker = { -- NOTE. layzvim default config
      --   win = {
      --     input = {
      --       keys = {
      --         ['<a-c>'] = {
      --           'toggle_cwd',
      --           mode = { 'n', 'i' },
      --         },
      --       },
      --     },
      --   },
      --   actions = {
      --     ---@param p snacks.Picker
      --     toggle_cwd = function(p)
      --       local root = LazyVim.root { buf = p.input.filter.current_buf, normalize = true }
      --       local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
      --       local current = p:cwd()
      --       p:set_cwd(current == root and cwd or root)
      --       p:find()
      --     end,
      --   },
      -- },
    },
    -- stylua: ignore
    keys = {

      -- Most important ---------------------------------------------
    {
        "<leader>i", 
        function()
          Snacks.picker.smart {
            matcher = {
              history_bonus = true, -- use history bonus for frecency
            }, 
            filter = {
              cwd = true -- only show files from current working directory
            }
          }

          -- Snacks.picker.files {
          --   finder = 'files',
          --   format = 'file',
          --   show_empty = true,
          --   hidden = true, -- search hidden dotfiles
          --   supports_live = true,
          --   -- In case you want to override the layout for this keymap
          --   layout = 'vscode',
          -- }
        end,
        desc = 'Find Files',
        }, 
     {
        "<leader>ff", 
        function()
          -- Snacks.picker.smart {}

          Snacks.picker.git_files {
            finder = 'files',
            format = 'file',
            show_empty = true,
            hidden = true, -- search hidden dotfiles
            supports_live = true,
            -- In case you want to override the layout for this keymap
            -- layout = 'vscode',
          }
        end,
        desc = 'Find Files',
        }, 
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },

      -- Grep -------------------------------------------------------------------
      -- global string search (like `Shift+cmd+f` in VS-Code)
    { '<leader>/', function() Snacks.picker.grep() end, desc = "Grep (root dir)" }, -- global fuzzy search for a string
    { '<leader>sg', function() Snacks.picker.grep() end, desc = "Grep (root dir)" }, -- global fuzzy search for a string
      -- Telescope used `<leader>/` for fuzzy find in current file/buffer
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },


      -- Exact search and replace (handled by grug-far.nivm)
      -- <leader>sr : search and replace in root dir 
      -- <leader>sR : search and replace in current buffer/file

      -- Diagnostics -----------------------------
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

      -- Useful Debugging ------------------------------
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },

      -- New search commands I might integrate into my workflow 
      { "<leader>fr", function () Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },

      -- ============================ Mostly copy pasted pickers from LazyVim ==================
      -- I don't often use the below, but it is interestint to try out once in a while
      --
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- -- NOTE I prfer my `<leader>tn` toggle notifications view in snacks as its easier to copy error messages.
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
      { "<leader>ff", function () Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      -- { "<leader>fr", function () Snacks.picker.recent() end, desc = "Recent" },
      -- { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- Grep
      -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      -- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      -- { "<leader>sw", function () Snacks.picker.grep_word() end, desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      -- { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" }, -- me: not needed
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
  },

  {
    'folke/snacks.nvim',
    opts = function(_, opts)
      if LazyVim.has 'trouble.nvim' then
        return vim.tbl_deep_extend('force', opts or {}, {
          picker = {
            actions = {
              trouble_open = function(...)
                return require('trouble.sources.snacks').actions.trouble_open.action(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ['<a-t>'] = {
                    'trouble_open',
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        })
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function()
      -- local Keys = require('lazyvim.plugins.lsp.keymaps').get()
      -- stylua: ignore
      -- vim.list_extend(Keys, {
      vim.list_extend({}, {
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  -- WARNING: the following block caused startup error
  -- {
  --   'folke/snacks.nvim',
  --   opts = function(_, opts)
  --     table.insert(opts.dashboard.preset.keys, 3, {
  --       icon = ' ',
  --       key = 'p',
  --       desc = 'Projects',
  --       action = ':lua Snacks.picker.projects()',
  --     })
  --   end,
  -- },
  -- {
  --   'goolord/alpha-nvim',
  --   optional = true,
  --   opts = function(_, dashboard)
  --     local button = dashboard.button('p', ' ' .. ' Projects', [[<cmd> lua Snacks.picker.projects() <cr>]])
  --     button.opts.hl = 'AlphaButtons'
  --     button.opts.hl_shortcut = 'AlphaShortcut'
  --     table.insert(dashboard.section.buttons.val, 4, button)
  --   end,
  -- },
  -- {
  --   'echasnovski/mini.starter',
  --   optional = true,
  --   opts = function(_, opts)
  --     local items = {
  --       {
  --         name = 'Projects',
  --         action = [[lua Snacks.picker.projects()]],
  --         section = string.rep(' ', 22) .. 'Telescope',
  --       },
  --     }
  --     vim.list_extend(opts.items, items)
  --   end,
  -- },
  -- {
  --   'nvimdev/dashboard-nvim',
  --   optional = true,
  --   opts = function(_, opts)
  --     if not vim.tbl_get(opts, 'config', 'center') then
  --       return
  --     end
  --     local projects = {
  --       action = 'lua Snacks.picker.projects()',
  --       desc = ' Projects',
  --       icon = ' ',
  --       key = 'p',
  --     }

  --     projects.desc = projects.desc .. string.rep(' ', 43 - #projects.desc)
  --     projects.key_format = '  %s'

  --     table.insert(opts.config.center, 3, projects)
  --   end,
  -- },
  {
    'folke/flash.nvim',
    optional = true,
    specs = {
      {
        'folke/snacks.nvim',
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
                  ['s'] = { 'flash' },
                },
              },
            },
            actions = {
              flash = function(picker)
                require('flash').jump {
                  pattern = '^',
                  label = { after = { 0, 0 } },
                  search = {
                    mode = 'search',
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                }
              end,
            },
          },
        },
      },
    },
  },
}
