-- WARN: not working right now
-- repo https://github.com/chrisgrieser/nvim-recorder
-- Description: Optimizatinos and conviniency hacks for the vim native Macro Recording functionality with 'q', 'qq' '@' but better
-- return {
--   'chrisgrieser/nvim-recorder',
--   dependencies = 'rcarriga/nvim-notify', -- optional
--   setup = function()
--     -- vim.keymap.nnoremap { '<leader>q', '<cmd>lua require("recorder").toggle()<CR>' }
--     -- default values
--     require('recorder').setup {
--       -- Named registers where macros are saved (single lowercase letters only).
--       -- The first register is the default register used as macro-slot after
--       -- startup.
--       slots = { 'a', 'b' },

--       mapping = {
--         startStopRecording = 'gq', -- Defaults to 'q'
--         playMacro = 'Q', -- Defaults to 'Q'
--         switchSlot = '<C-q>', -- Defaults to '<C-q>'
--         editMacro = 'cq', -- Defaults to 'cq'
--         deleteAllMacros = 'dq', -- Defaults to 'dq'
--         yankMacro = 'yq', -- Defaults to 'yq'
--         -- ⚠️ this should be a string you don't use in insert mode during a macro
--         addBreakPoint = '##', -- Defaults to '##'
--       },

--       -- Clears all macros-slots on startup.
--       clear = false,

--       -- Log level used for non-critical notifications; mostly relevant for nvim-notify.
--       -- (Note that by default, nvim-notify does not show the levels `trace` & `debug`.)
--       logLevel = vim.log.levels.INFO, -- :help vim.log.levels

--       -- If enabled, only essential notifications are sent.
--       -- If you do not use a plugin like nvim-notify, set this to `true`
--       -- to remove otherwise annoying messages.
--       lessNotifications = false,

--       -- Use nerdfont icons in the status bar components and keymap descriptions
--       useNerdfontIcons = true,

--       -- Performance optimzations for macros with high count. When `playMacro` is
--       -- triggered with a count higher than the threshold, nvim-recorder
--       -- temporarily changes changes some settings for the duration of the macro.
--       performanceOpts = {
--         countThreshold = 100,
--         lazyredraw = true, -- enable lazyredraw (see `:h lazyredraw`)
--         noSystemClipboard = true, -- remove `+`/`*` from clipboard option
--         autocmdEventsIgnore = { -- temporarily ignore these autocmd events
--           'TextChangedI',
--           'TextChanged',
--           'InsertLeave',
--           'InsertEnter',
--           'InsertCharPre',
--         },
--       },

--       -- [experimental] partially share keymaps with nvim-dap.
--       -- (See README for further explanations.)
--       dapSharedKeymaps = false,
--     }

--     ---- Statusline setup
--     -- Indicates whether you are currently recording. Useful if you are using
--     -- `cmdheight=0`, where recording-status is not visible.
--     require('recorder').recordingStatus()

--     -- Displays non-empty macro-slots (registers) and indicates the selected ones.
--     -- Only displayed when *not* recording. Slots with breakpoints get an extra `#`.
--     require('recorder').displaySlots()
--   end,
-- }
return {}
