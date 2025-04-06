-- See https://github.com/windwp/nvim-ts-autotag
-- A plugin that automatically closes and renames HTML tags
return {
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </. Defaults to false.
      },
      -- Also override individual filetype configs, these take priority.
      -- Empty by default, useful if one of the "opts" global settings
      -- doesn't work well in a specific filetype
      -- per_filetype = {
      --   ['html'] = {
      --     enable_close = false,
      --   },
      -- },
    }
  end,
}

-- -- ====================== Automatic html tag completion =====================
-- -- See https://github.com/windwp/nvim-ts-autotag
-- -- A plugin that automatically closes and renames HTML tags
-- {
--   'windwp/nvim-ts-autotag',
--   opts = {

--     -- Defaults
--     enable_close = true, -- Auto close tags
--     enable_rename = true, -- Auto rename pairs of tags
--     enable_close_on_slash = true, -- Auto close on trailing </. Defaults to false.
--   },
--   -- Also override individual filetype configs, these take priority.
--   -- Empty by default, useful if one of the "opts" global settings
--   -- doesn't work well in a specific filetype
--   -- per_filetype = {
--   --   ['html'] = {
--   --     enable_close = false,
--   --   },
--   -- },
--   -- config = function()
--   --   require('nvim-ts-autotag').setup {
--   -- end,
-- },
