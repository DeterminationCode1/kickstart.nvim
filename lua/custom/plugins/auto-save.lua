--repo https://github.com/pocco81/auto-save.nvim
-- rst.. vim.api.nvim_buf_get_name(0))
-- Auto save files
return {
  'pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger auto-save. See :h events
      execution_message = {
        message = function() -- message to print on save
          -- default msg: 'AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S'
          return ('AutoSave: ' .. vim.fn.strftime '%H:%M:%S')
        end,
        dim = 0.50, -- dim the color of `message`. Defaults to 0.18
        cleaning_interval = 500, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgAsea . Defaults to 1250
      },
      -- function that detesmines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'

        -- Me: Deactivate auto-save for oil.nvim file explorer buffers
        -- get full current buffer path: vim.api.nvim_buf_get_name(0))
        local is_oil_buffer = vim.api.nvim_buf_get_name(buf):sub(0, 3) == 'oil:'

        if
          fn.getbufvar(buf, '&modifiable') == 1
          and utils.not_in(fn.getbufvar(buf, '&filetype'), {})
          and utils.not_in(fn.expand '%:t', {
            -- 'plugins.lua',
            -- 'auto-save.lua',
          })
          and not is_oil_buffer
        then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end,
    }

    -- keymap
    vim.api.nvim_set_keymap('n', '<leader>ta', ':ASToggle<CR>', { desc = '[T]oggle [A]uto-save on/off', noremap = true, silent = true })
  end,
}
