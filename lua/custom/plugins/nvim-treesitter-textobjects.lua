-- repo: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- exmaple guide: https://www.josean.com/posts/nvim-treesitter-and-textobjects
-- Loads the treesitter textobjects extension that allows you to use syntax aware vim text objects like functions, classes, etc.
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

          keymaps = {
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display. You could also exclude desc.
            -- You can use the capture groups defined in textobjects.scm
            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
            -- originally l=, r=, but conflicted with built-in mappings
            -- Me: seems like @assignment.lhs is similar to @assignment.inner
            -- ['p='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
            ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

            ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

            ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
            ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

            ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
            ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

            ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },

            ['ae'] = { query = '@comment.outer', desc = 'Select inner part of a comment' },
            ['ie'] = { query = '@comment.inner', desc = 'Select inner part of a comment' },
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
            ['@class.outer'] = '<c-v>', -- blockwise
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
            ['<leader>na'] = '@parameter.inner', -- swap parameters/argument with next
            ['<leader>nm'] = '@function.outer', -- swap function with next
          },
          swap_previous = {
            ['<leader>pa'] = '@parameter.inner', -- swap parameters/argument with prev
            ['<leader>pm'] = '@function.outer', -- swap function with previous
          },
        },
      },
    }
  end,
}
