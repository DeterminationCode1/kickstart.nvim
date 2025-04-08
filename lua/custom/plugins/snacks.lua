-- https://github.com/folke/snacks.nvim
-- Linkarzu: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/snacks.lua
--
-- A collection of useful small plugins for neovim provided by the goat folke
--
-- NOTE: run `:checkhealth snacks` to get many helpful checks on your snacks
-- setup

return {

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      -- ======================= Explorer ==============================
      -- Top pickers and explorer_focus
      {
        '<leader>te',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },

      -- ======================= Notifier ============================
      {
        '<leader>tn',
        function()
          Snacks.notifier.show_history()
        end,
        desc = '[N]otification [H]istory: [T]oggle it.',
      },
      -- NOTE: I used `show_history` a lot and `notifer.hide` almost never
      -- {
      --   '<leader>tnc',
      --   function()
      --     Snacks.notifier.hide()
      --   end,
      --   desc = '[N]otification [C]lear: remove notifications on screen',
      -- },
      -- ======================== Lazygit ========================
      {
        'gi',
        function()
          Snacks = require 'snacks'
          Snacks.lazygit.open()
        end,
        desc = 'Open Lazygit',
      },
    },
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          -- Me: deactivate special shortcut mappings on the dashbaord buffer
          -- because it overwrote my default mappings and was annoying
          keys = nil,
        },
      },
      -- sections = { section = 'terminal', cmd = 'fortune -s | cowsay', hl = 'header', padding = 1, indent = 8 } },
      -- Bigfile: turn off expensive calculations when opening very big files to
      -- keep everything smooth.
      -- https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
      bigfile = { -- NOTE: I copied the default config
        enabled = true,
        notify = true, -- show notification when big file detected. default true.
        size = 1.1 * 1024 * 1024, -- 1.1MB. Default 1.5MB
        line_length = 1000, -- average line length (useful for minified files). Default 1000.
      },
      -- Notify: a better vim notification
      -- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
      notifier = {
        enabled = true,
        -- minimum log level to display. TRACE is the lowest
        -- all notifications are stored in history
        -- me: by setting it to INFO,  the DEBUG level notifications are not shown
        level = vim.log.levels.INFO, -- Defaults to vim.log.levels.TRACE
      },

      -- image: se inline eimages in the terminal
      image = {
        enabled = true,
        doc = {
          -- Personally I set this to false, I don't want to render all the
          -- images in the file, only when I hover over them
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = vim.g.neovim_mode == 'skitty' and true or false,
          -- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          -- Sets the size of the image
          -- max_width = 60, -- defaults to 80
          max_width = vim.g.neovim_mode == 'skitty' and 20 or 60, -- me: comment out
          max_height = vim.g.neovim_mode == 'skitty' and 10 or 30, -- me: comment out
          -- max_height = 30, -- defaults to 40
          -- Apparently, all the images that you preview in neovim are converted
          -- to .png and they're cached, original image remains the same, but
          -- the preview you see is a png converted version of that image
          --
          -- Where are the cached images stored?
          -- This path is found in the docs
          -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
          -- For me returns `~/.cache/neobean/snacks/image`
          -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
        },
      },
      -- Lazygit integration for neovim with custom colors
      lazygit = {
        enabled = true,
        -- theme = {
        --   selectedLineBgColor = { bg = 'CursorLine' },
        -- },
        -- With this I make lazygit to use the entire screen, because by default there's
        -- "padding" added around the sides
        -- I asked in LazyGit, folke didn't like it xD xD xD
        -- https://github.com/folke/snacks.nvim/issues/719
        win = {
          -- -- The first option was to use the "dashboard" style, which uses a
          -- -- 0 height and width, see the styles documentation
          -- -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
          -- style = "dashboard",
          -- But I can also explicitly set them, which also works, what the best
          -- way is? Who knows, but it works
          width = 0,
          height = 0,
        },
      },
    },
  },
}
