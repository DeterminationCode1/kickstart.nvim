-- https://github.com/R-nvim/R.nvim
-- Easily execute R code in Neovim. It's the current plugin of choice for R used
-- by LazyVim as of Jan 2025.

-- Usage
--
-- You must start R.nvim in the background once you open a R, file. Use a
-- command or set auto_start to 'on startup' in the setup function.
--
-- =========== Run R code from Neovim ===========
-- - <Enter> in normal mode sends the current line to R
-- - <Enter> in visual mode sends the selected text to R
--
-- =========== Hotkeys for common R commands ===========
-- - <localleader>, : inserts a pipe operator %>% or |>
-- - rproj_prioritise can be configured to control how .Rproj files change the behaviour of R.nvim. Amongst other things, this may affect whether <LocalLeader>, inserts |> or %>%.
-- Me: research `|>` vs `%>%` pipe: [url](https://www.tidyverse.org/blog/2023/04/base-vs-magrittr-pipe/)

return {
  'R-nvim/R.nvim',

  -- ME: Setup autosuggestion for R. ADDED by me not LazyVim
  dependencies = {
    {
      'R-nvim/cmp-r',
      config = function()
        -- See "R.nvim" recommendations for configuring cmp_r https://github.com/R-nvim/R.nvim?tab=readme-ov-file#autocompletion
        require('cmp_r').setup {}
      end,
    },
  },
  lazy = false,
  opts = {
    -- Create a table with the options to be passed to setup()
    R_args = { '--quiet', '--no-save' },
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event
        -- of files supported by R.nvim. This is an
        -- opportunity to create mappings local to buffers.
        vim.keymap.set('n', '<Enter>', '<Plug>RDSendLine', { buffer = true })
        vim.keymap.set('v', '<Enter>', '<Plug>RSendSelection', { buffer = true })

        local wk = require 'which-key'
        wk.add {
          buffer = true,
          mode = { 'n', 'v' },
          { '<localleader>a', group = 'all' },
          { '<localleader>b', group = 'between marks' },
          { '<localleader>c', group = 'chunks' },
          { '<localleader>f', group = 'functions' },
          { '<localleader>g', group = 'goto' },
          { '<localleader>i', group = 'install' },
          { '<localleader>k', group = 'knit' },
          { '<localleader>p', group = 'paragraph' },
          { '<localleader>q', group = 'quarto' },
          { '<localleader>r', group = 'r general' },
          { '<localleader>s', group = 'split or send' },
          { '<localleader>t', group = 'terminal' },
          { '<localleader>v', group = 'view' },
        }
      end,
    },
    pdfviewer = '',
  },
  config = function(_, opts)
    -- Check if the environment variable "R_AUTO_START" exists.
    -- If using fish shell, you could put in your config.fish:
    -- alias r "R_AUTO_START=true nvim"
    -- if vim.env.R_AUTO_START == 'true' then
    --   opts.auto_start = 'on startup'
    --   opts.objbr_auto_start = true
    -- end

    -- Me: always auto start R
    opts.auto_start = 'on startup'
    opts.objbr_auto_start = true
    require('r').setup(opts)

    vim.g.rout_follow_colorscheme = true
    require('r').setup(opts)
    require('r.pdf.generic').open = vim.ui.open
  end,
}
