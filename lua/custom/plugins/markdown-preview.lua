-- repo https://github.com/iamcco/markdown-preview.nvim
-- Description: Preview markdown files from nvim in the browser
--
-- You can with or without yarn/npm
-- Stand of 2024-08-01 you chose to use yarn or npm
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && npm install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,

  ft = { 'markdown' },
  config = function()
    -- Toggle the markdown preview (<leader>mp would also be okay)
    vim.keymap.set('n', '<leader>m', '<CMD>MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'Markdown Preview: Toggle' })
  end,
}
