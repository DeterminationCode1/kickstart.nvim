-- repo https://github.com/iamcco/markdown-preview.nvim
-- Description: Preview markdown files from nvim in the browser
-- Funfact: The auto-generated website of the markdown file seems to be done with Next.js
--
-- You can install with or without yarn/npm
-- Stand of 2024-08-01 you chose to use yarn/npm instead of building from source
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && npm install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,

  ft = { 'markdown' },
  config = function()
    -- Toggle the markdown preview (<leader>mp would also be okay -> more space for other mappings on `m`)
    -- NOTE: maybe `<leader>m` would be better
    vim.keymap.set('n', '<leader>mp', '<CMD>MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'Markdown Preview: Toggle' })
  end,
}
