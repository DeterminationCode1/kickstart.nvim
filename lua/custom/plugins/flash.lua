-- source: https://github.com/folke/flash.nvim?tab=readme-ov-file
-- Good reddint comment explaining vertical nav in nvim using c-d/u for general scroling
-- and a search tool like / ? or flash for specific line movement
-- https://www.reddit.com/r/neovim/comments/19a6aur/comment/kiixnev/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash: Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Flash: Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash: Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Flash: Toggle Flash Search" },
    { "<leader>tf", mode = { "n" }, function() require("flash").toggle() end, desc = "Toggle [F]lash Search" },
  },
}
