-- new forked repo: https://github.com/okuuva/auto-save.nvim?tab=readme-ov-file
-- legacy repo. WARNING active development has stopped https://github.com/pocco81/auto-save.nvim
-- rst.. vim.api.nvim_buf_get_name(0))
-- Auto save files
--
-- Update Oct 2024:  the message on save config option was revomed. read the
-- readme to  find alternatives if you want a   message.
--
return {
  -- 'pocco81/auto-save.nvim',
  'okuuva/auto-save.nvim',
  cmd = 'ASToggle', -- optional for lazy loading on command
  event = { 'InsertLeave', 'TextChanged' }, -- optional for lazy loading on event
  config = function()
    require('auto-save').setup {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { -- See :h events
        immediate_save = { 'BufLeave', 'FocusLost' }, -- vim events that trigger an immediate save
        defer_save = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
      },

      -- function that detesmines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'
        -- Buffer must be modifiable. The new auto-save fork checks this by default.

        -- Disable auto-save for all non-normal buffers
        if vim.bo[buf].buftype ~= '' then
          return false
        end

        -- Deactivate auto-save for specific filetypes
        if not utils.not_in(fn.getbufvar(buf, '&filetype'), {}) then
          return false -- can't save
        end

        -- Deactivate auto-save for specific files
        if not utils.not_in(fn.expand '%:t', {
          'auto-save.lua',
        }) then
          return false -- can't save
        end

        return true -- met condition(s), can save
      end,
      -- the new fork of auto-save now treats debounce as: delay after which a pending save is executed
      debounce_delay = 1000, -- Defaults to 1000 ms.
    }

    -- keymap
    vim.api.nvim_set_keymap('n', '<leader>ta', ':ASToggle<CR>', { desc = '[T]oggle [A]uto-save on/off', noremap = true, silent = true })
  end,
}

-- Me: BACKUP of old manually created `condition` function for autosave.
-- The new version just checks for special buffers and is more concise than testing for each buffer
-- type like oil, telescope, etc.

-- condition = function(buf)
--   local fn = vim.fn
--   local utils = require 'auto-save.utils.data'
--
--   -- NOTE: By default auto-save will save all buffers, including non-normal buffers
--   -- like oil, harpoon etc which can cause annying behavior.
--   -- To prevent this, we can add a condition to check if the buffer is a normal buffer
--
--   -- Disable auto-save for all non-normal buffers
--   if vim.bo[buf].buftype ~= '' then
--     return false
--   end
--
--   -- -- Disable Harpoon buffers: https://github.com/ThePrimeagen/harpoon/issues/434#issuecomment-1865689657
--   -- if vim.bo[buf].filetype == 'harpoon' then
--   --   return false
--   -- end
--
--   -- -- Me: Deactivate auto-save for oil.nvim file explorer buffers
--   -- -- get full current buffer path: vim.api.nvim_buf_get_name(0))
--   -- local is_oil_buffer = vim.api.nvim_buf_get_name(buf):sub(0, 4) == 'oil:'
--   -- if is_oil_buffer then
--   -- -- print(is_oil_buffer, vim.api.nvim_buf_get_name(buf):sub(0, 3)) -- DEBUG
--   --   return false
--   -- end
--
--   if
--     -- Buffer must be modifiable
--     fn.getbufvar(buf, '&modifiable') == 1
--     -- Deactivate auto-save for specific filetypes
--     and utils.not_in(fn.getbufvar(buf, '&filetype'), {})
--     -- Deactivate auto-save for specific files
--     and utils.not_in(fn.expand '%:t', {
--       'auto-save.lua',
--     })
--   then
--     return true -- met condition(s), can save
--   end
--   return false -- can't save
-- end,
