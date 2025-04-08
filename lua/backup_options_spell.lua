local function add_skip_keymap()
  vim.keymap.set('i', '<PageDown>', function()
    vim.notify('⏭️ x Skipping current spelling error.', vim.log.levels.INFO)
    -- Remove ghost text and move to the next error
    -- vim.api.nvim_buf_clear_namespace(text_buffer_id, ns_id, 0, -1)
    -- close current snack.input buffer
    -- vim.cmd 'insert! <C-c>'
    --
    -- remove all content in line,  then hit enter in insert mode
    -- vim.cmd 'insert! <c-u><CR>'
    local ctrl_u = vim.api.nvim_replace_termcodes('<c-u><cr>', true, true, true)
    -- vim.api.nvim_feedkeys('i' .. ctrl_u, 'n', false)
    -- vim.api.nvim_feedkeys('i' .. ctrl_u, 'n', false)

    -- next_error()
  end, { desc = '[S]kip current spelling error on [PageDown]' })
end
-- =========================================================
local ns_id = vim.api.nvim_create_namespace 'ghost-spell-suggest'

-- The function to handle the interactive spell check
local function interactive_spellcheck()
  -- Setup side effects like temporary keybindings
  local function setup_side_effects()
    -- Temporarily bind Ctrl-i to ignore the current word in insert mode
    -- vim.api.nvim_del_keymap('i', '<C-i>') -- remove defauolt ctrl-i mapping
    vim.api.nvim_set_keymap('i', '<C-i>', '<Esc>:lua ignore_error()<CR>', {}) -- { noremap = true, silent = true }
  end

  -- Cleanup side effects like removing temporary keybindings
  local function cleanup_side_effects()
    -- Remove temporary keybinding for Ctrl-i
    vim.api.nvim_del_keymap('i', '<C-i>')
  end

  local function next_error()
    vim.cmd 'normal! ]s'
    local badword = vim.fn.spellbadword()[1]

    if badword == '' then
      vim.notify('✅ Spellcheck complete. No more errors.', vim.log.levels.INFO)
      return
    end

    local suggestions = vim.fn.spellsuggest(badword)
    local top_suggestion = suggestions[1]

    -- Find current position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1 -- Lua index

    -- Clear any previous ghost suggestions
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

    -- Show ghost suggestion directly behind the word
    if top_suggestion then
      vim.api.nvim_buf_set_extmark(0, ns_id, row, col, {
        virt_text = { { top_suggestion, 'SpellGhostText' } }, -- No arrow, just the suggestion
        virt_text_pos = 'overlay', -- Use 'overlay' to position it directly behind the word
      })
    end

    -- Snacks.nvim creates a global _G.Snacks module, so you don't have to
    -- import it. But it is still useful otherwise you do not get
    -- type suggestions
    Snacks = require 'snacks'
    Snacks.input.input({
      prompt = 'Accept suggestion (enter), edit manually, or leave blank to skip:',
      default = top_suggestion or '',
      -- relative = 'editor', -- Use editor as the reference for position
      -- row = math.floor(vim.o.lines / 2) - 5, -- Position 5 lines above center
      -- col = math.floor(vim.o.columns / 2) - 20, -- Position 20 columns to the left of the center
      win = {
        keys = {
          -- Override the default keybindings for this instance
          --<Esc>:lua ignore_error()<CR>
          -- i_ctrl_w = { '<c-w>', '<c-u>', mode = 'i', expr = true }, -- working
          i_ctrl_w = { '<c-w>', ':lua print("Hello from Lua!")', mode = 'i', expr = true }, -- maybe working but silent
        },
      },
    }, function(input)
      -- Remove ghost text
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

      if input == nil then
        vim.notify('❌ Spellcheck cancelled.', vim.log.levels.WARN)
        -- Clean up side effects (remove keybindings)
        -- cleanup_side_effects()
        return
      end

      if input ~= '' then
        -- Replace word under cursor
        vim.cmd('normal! ciw' .. input)
      else
        vim.notify('⏭️ Skipped "' .. badword .. '"', vim.log.levels.INFO)
      end

      next_error()
    end)
  end

  local function main()
    vim.cmd 'normal! gg' -- Start at top of file

    -- Setup side effects (e.g., keybindings) before showing input
    -- setup_side_effects()
    next_error()
  end

  main()
end

-- Function to ignore the current error when Ctrl-i is pressed
function _G.ignore_error()
  vim.notify('⏭️ Ignored current spelling error.', vim.log.levels.INFO)
  -- Remove ghost text and move to the next error
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  -- local next_error = require('options_spell').next_error
  -- next_error()
end

vim.keymap.set('n', '<leader>tsc', interactive_spellcheck, {
  desc = '[S]pell [C]heck Word-style',
})

-- Define the custom highlight group for the green ghost text
-- uniqe hex color code that is not used by catputchin or vscode colors:
-- #00ff00
vim.cmd [[highlight SpellGhostText guifg=#01ff00]] -- Use green color (adjust as needed)
