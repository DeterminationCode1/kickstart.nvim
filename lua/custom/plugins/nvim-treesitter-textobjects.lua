-- repo: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- exmaple guide: https://www.josean.com/posts/nvim-treesitter-and-textobjects
-- Loads the treesitter textobjects extension that allows you to use syntax aware vim text objects like functions, classes, etc.
--
-- Other external textobjects are:
-- - h: a git hunk from gitsigns.nvim
-- - g: global file / whole file in mini.ai
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  lazy = true,
  config = function()
    require('nvim-treesitter.configs').setup {

      textobjects = {

        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          -- Colemak home row: arst g m neio
          keymaps = {
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display. You could also exclude desc.
            -- You can use the capture groups defined in textobjects.scm
            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
            ['aa'] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
            ['ia'] = { query = '@assignment.inner', desc = 'Select inner/left part of an assignment' },
            -- originally l=, r=, but conflicted with built-in mappings
            -- Me: seems like @assignment.lhs is similar to @assignment.inner
            -- ['p='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
            -- ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

            -- previously I used 'aa, ia' but I needed that mapping for '@assignment'
            -- 'heading with children' in markdown
            ['ao'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
            ['io'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

            -- i as in `if` a conditional
            -- i as in `list_items` in markdown files.
            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

            -- l as in `loop` in code files.
            -- l as in 'link' in markdown files.
            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
            ['nl'] = { query = '@my-link.name', desc = 'Select human name of a link' },
            -- ['al'] = { query = '@text.mylink', desc = 'Select url of a link' },

            -- f as in `function` in code files.
            ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
            ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

            -- m as in `method` in code files.
            ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
            ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

            -- c as in `class` in code files.
            -- markdown: c is by default mapped to markdown headings
            ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },

            ['ae'] = { query = '@comment.outer', desc = 'Select inner part of a comment' },
            ['ie'] = { query = '@comment.inner', desc = 'Select inner part of a comment' },

            -- markdown Chunk markdown heading sections
            -- ['ac'] = { query = '@my-section', desc = 'Section in markdown' },

            -- code blocks ```ts ...```. c class, o parameter, b generic block
            -- was already taken
            ['ad'] = { query = '@block.outer', desc = 'Select outer part of a code block' },
            ['id'] = { query = '@block.inner', desc = 'Select inner part of a code block' },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            -- ['@function.outer'] = 'V', -- linewise
            ['@method.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- linewise
            -- ['@my-section'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true or false
          include_surrounding_whitespace = false,
        },

        -- Add a swap field, enable this treesitter module and add keymaps for
        -- swapping a text object with the next/previous occurrence of it.
        swap = {
          enable = true,
          swap_next = {
            ['<leader>no'] = '@parameter.inner', -- swap parameters/argument with next
            ['<leader>nm'] = '@function.outer', -- swap function with next
            -- ['<leader>ns'] = '@my-section', -- swap section in markdown
            ['<leader>ni'] = '@if.inner', -- swap markdown list item with next
            ['<leader>nc'] = '@class.outer', -- swap parameters/argument with next
          },
          swap_previous = {
            ['<leader>po'] = '@parameter.inner', -- swap parameters/argument with prev
            ['<leader>pm'] = '@function.outer', -- swap function with previous
            -- ['<leader>ps'] = '@my-section', -- swap section in markdown
            ['<leader>pi'] = '@if.inner', -- swap markdown list item with next
            ['<leader>pc'] = '@class.outer', -- swap parameters/argument with prev
          },
        },
      },
    }
  end,
}
