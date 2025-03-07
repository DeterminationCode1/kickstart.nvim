-- repo: https://github.com/lukas-reineke/headlines.nvim
-- this file is based on Linkarzu dotfiles: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/headlines.lua.old
--
-- Beautify headings in markdown files.
--
-- This already comes installed with lazyvim but I modify the heading colors and
-- also the lines above and below
-- It also adds these { "◉", "○", "✸", "✿" } symbols in headings

-- return {
--   'lukas-reineke/headlines.nvim',
--   dependencies = 'nvim-treesitter/nvim-treesitter',
--   config = function()
--     -- -- Define custom highlight groups using Vimscript
--     --
--     -- NOTE: there is also a native catppuccin theme integration for headlines
--     -- which you can activate in your catppuccin setting with `headlines = true`
--     --
--     -- -- Theme below is Eldritch
--     -- vim.cmd [[highlight Headline1 guibg=#f265b5 guifg=#323449]]
--     -- vim.cmd [[highlight Headline2 guibg=#37f499 guifg=#323449]]
--     -- vim.cmd [[highlight Headline3 guibg=#04d1f9 guifg=#323449]]
--     -- vim.cmd [[highlight Headline4 guibg=#a48cf2 guifg=#323449]]
--     -- vim.cmd [[highlight Headline5 guibg=#f1fc79 guifg=#323449]]
--     -- vim.cmd [[highlight Headline6 guibg=#f7c67f guifg=#323449]]

--     -- -- This is for eldritch as well, dim background
--     -- NOTE: Me: I prefer this schema the most
--     vim.cmd [[highlight Headline1 guifg=#f1fc79 guibg=#606430]]
--     vim.cmd [[highlight Headline2 guifg=#37f499 guibg=#16613d]]
--     vim.cmd [[highlight Headline3 guifg=#04d1f9 guibg=#015363]]
--     vim.cmd [[highlight Headline4 guifg=#f16c75 guibg=#602b2e]]
--     vim.cmd [[highlight Headline5 guifg=#7081d0 guibg=#2c3353]]
--     vim.cmd [[highlight Headline6 guifg=#f265b5 guibg=#602848]]

--     -- -- This is for eldritch as well, strong backround
--     -- vim.cmd([[highlight Headline1 guibg=#f1fc79 guifg=#606430]])
--     -- vim.cmd([[highlight Headline2 guibg=#37f499 guifg=#16613d]])
--     -- vim.cmd([[highlight Headline3 guibg=#04d1f9 guifg=#015363]])
--     -- vim.cmd([[highlight Headline4 guibg=#f16c75 guifg=#602b2e]])
--     -- vim.cmd([[highlight Headline5 guibg=#7081d0 guifg=#2c3353]])
--     -- vim.cmd([[highlight Headline6 guibg=#f265b5 guifg=#602848]])

--     -- -- These were my previous colors, they don't make sense, just something I
--     -- -- used back in Google docs
--     -- vim.cmd([[highlight Headline1 guibg=#295715 guifg=white]])
--     -- vim.cmd([[highlight Headline2 guibg=#8d8200 guifg=white]])
--     -- vim.cmd([[highlight Headline3 guibg=#a56106 guifg=white]])
--     -- vim.cmd([[highlight Headline4 guibg=#7e0000 guifg=white]])
--     -- vim.cmd([[highlight Headline5 guibg=#1e0b7b guifg=white]])
--     -- vim.cmd([[highlight Headline6 guibg=#560b7b guifg=white]])

--     -- Defines the codeblock background color to something darker
--     vim.cmd [[highlight CodeBlock guibg=#09090d]]
--     -- When you add a line of dashes with --- this specifies the color, I'm not
--     -- adding a "guibg" but you can do so if you want to add a background color
--     vim.cmd [[highlight Dash guifg=white]]

--     -- ============================= Extra Config =============================
--     -- This section is NOT a part of the `headlines.nvim` plugin, but a nvim native
--     -- config for customizing headings.
--     -- It was copy pasted from: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/highlights.lua
--     -- Custom highlight settings for markdown headers
--     local color1_bg = '#f265b5'
--     local color2_bg = '#37f499'
--     local color3_bg = '#04d1f9'
--     local color4_bg = '#a48cf2'
--     local color5_bg = '#f1fc79'
--     local color6_bg = '#f7c67f'
--     local color_fg = '#323449'
--     vim.cmd(string.format([[highlight @markup.heading.1.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color1_bg))
--     vim.cmd(string.format([[highlight @markup.heading.2.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color2_bg))
--     vim.cmd(string.format([[highlight @markup.heading.3.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color3_bg))
--     vim.cmd(string.format([[highlight @markup.heading.4.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color4_bg))
--     vim.cmd(string.format([[highlight @markup.heading.5.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color5_bg))
--     vim.cmd(string.format([[highlight @markup.heading.6.markdown cterm=bold gui=bold guifg=%s guibg=%s]], color_fg, color6_bg))
--     -- =========================================================================

--     -- Setup headlines.nvim with the newly defined highlight groups
--     require('headlines').setup {
--       markdown = {
--         -- If set to false, headlines will be a single line and there will be no
--         -- "fat_headline_upper_string" and no "fat_headline_lower_string"
--         fat_headlines = false,
--         --
--         -- Lines added above and below the header line makes it look thicker
--         -- "lower half block" unicode symbol hex:2584
--         -- "upper half block" unicode symbol hex:2580
--         fat_headline_upper_string = '▄',
--         fat_headline_lower_string = '▀',
--         --
--         -- You could add a full block if you really like it thick ;)
--         -- fat_headline_upper_string = "█",
--         -- fat_headline_lower_string = "█",
--         --
--         -- Other set of lower and upper symbols to try
--         -- fat_headline_upper_string = "▃",
--         -- fat_headline_lower_string = "-",
--         --
--         headline_highlights = {
--           'Headline1',
--           'Headline2',
--           'Headline3',
--           'Headline4',
--           'Headline5',
--           'Headline6',
--         },

--         bullets = { '󰎤', '󰎧', '󰎪', '󰎭', '󰎱', '󰎳' },
--         -- bullets = { "󰎤", "󰎧", "󰎪", "󰎮", "󰎰", "󰎵" },
--         -- bullets = { "◉", "○", "✸", "✿" },
--       },
--     }
--   end,
-- }

return {}
