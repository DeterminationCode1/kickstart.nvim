-- https://github.com/bullets-vim/bullets.vim
--
-- This plugin automatically adds bulletpoints on the next line respecting
-- indentation.
-- In markdown or a text file start a bulleted list using - or *. Press return
-- to go to the next line, a new list item will be created.
--
-- When in insert mode, you can increase indentation with ctrl+t and decrease it
-- with ctrl+d
--
-- By default its enabled on filetypes 'markdown', 'text', 'gitcommit', 'scratch'

-- return {}
return {
  'bullets-vim/bullets.vim',
  init = function()
    -- " default = []
    -- " N.B. You can set these mappings as-is without using this g:bullets_custom_mappings option but it
    -- " will apply in this case for all file types while when using g:bullets_custom_mappings it would
    -- " take into account file types filter set in g:bullets_enabled_file_types, and also
    -- " g:bullets_enable_in_empty_buffers option.
    -- vim.g.bullets_custom_mappings = {
    --   { 'imap', '<tab>', '<Plug>(bullets-demote)' },
    -- }
  end,
}
