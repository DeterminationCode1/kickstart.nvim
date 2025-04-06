-- https://github.com/bullets-vim/bullets.vim
--
-- This plugin automatically adds bullet points on the next line respecting
-- indentation.
--
-- for the full documentation use: `:h bullets` (be sure to be in a markdown
-- file or the plugin and its docs might not be loaded)
--
-- Usage:
--
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
  ft = {
    'markdown',
    'text',
    'gitcommit',
    'scratch',
  },
  init = function()
    -- " default = []
    -- " N.B. You can set these mappings as-is without using this g:bullets_custom_mappings option but it
    -- " will apply in this case for all file types while when using g:bullets_custom_mappings it would
    -- " take into account file types filter set in g:bullets_enabled_file_types, and also
    -- " g:bullets_enable_in_empty_buffers option.
    -- vim.g.bullets_custom_mappings = {
    --   { 'imap', '<tab>', '<Plug>(bullets-demote)' },
    -- }

    -- Nested Outline Bullet Levels -- DOCUMENTATION h: bullets-outline-levels
    -- ----------------------------
    -- You can create heirarchically nested outlines using indentation and different
    -- bullet types for each level of indentation. Define the type of bullet used for
    -- each level using the following ordered list:

    --    `let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-',`
    --   `   \ 'std*', 'std+']`

    -- Demoting a bullet ([I]<C-t>, [N]`>>`, [V]`>`) will increase its indentation and use the
    -- next bullet level defined in this list. Similarly, promoting the bullet
    -- ([I]<C-d>, [N]`<<`, [V]`<`) will decrease the bullet
    -- indentation and use the previous bullet level. Promoting a top-level bullet
    -- will remove the bullet and demoting a bottom-level bullet will indent, but not
    -- change the bullet marker.
    --
    -- " Ordered list containing the heirarchical bullet levels, starting from the outer most level.
    -- " Available bullet level options (cannot use the same marker more than once)
    -- " ROM/rom = upper/lower case Roman numerals (e.g., I, II, III, IV)
    -- " ABC/abc = upper/lower case alphabetic characters (e.g., A, B, C)
    -- " std[-/*/+] = standard bullets using a hyphen (-), asterisk (*), or plus (+) as the marker.
    -- " chk = checkbox (- [ ])
    --
    -- NOTE: I changed this setting because it was annoying when using a normal
    -- `-` list and indenting it by one level to get a differnt bullet type.
    -- that also screwed up the automatic formatter like prettier sometimes and
    -- it broke up the bullets into separated lists...
    vim.g.bullets_outline_levels = {
      'num', -- numbered list
      'std-', -- standard bullet
      -- 'std*', -- standard bullet
      -- 'std+', -- standard bullet
      -- 'num', -- numbered list
      -- 'abc', -- lower case letters
      -- 'rom', -- roman numbers
      -- 'ABC', -- upper case letters
      -- 'ROM', -- roman numbers
    }
    vim.g.bullets_auto_indent_after_colon = 1 -- default = 1
  end,
}
