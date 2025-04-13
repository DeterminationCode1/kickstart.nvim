-- https://github.com/psliwka/vim-dirtytalk
--
-- A language dictionary called "programming" that contains a lot of technical terms for spell checking in
-- Neovim.
--
--  academic.nvim https://github.com/ficcdaf/academic.nvim/tree/main could be
--  interesting in the future too
--
-- NOTE: most of my spelling related settings are in `options_spell.lua` file
return {
  'psliwka/vim-dirtytalk',
  build = ':DirtytalkUpdate',
  config = function()
    -- get current opt.spelllang
    local spelllang = vim.opt.spelllang:get()
    -- add dirtytalk to the list
    table.insert(spelllang, 'programming')
    -- set the new opt.spelllang
    vim.opt.spelllang = spelllang
  end,
}
