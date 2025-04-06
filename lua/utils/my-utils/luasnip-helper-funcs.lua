-- ~/.config/nvim/lua/luasnip-helper-funcs.lua
-- tip by https://ejmastnak.com/tutorials/vim-latex/luasnip/#:~:text=--%20Include%20this%20%60in_mathzone%60%20function%20at%20the%20start%20of%20a%20snippets%20file
local M = {}

-- Be sure to explicitly define these LuaSnip node abbreviations!
local ls = require 'luasnip'
local sn = ls.snippet_node
local i = ls.insert_node

function M.get_visual(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

-- cursor is a specific line number. Indexing starts at 1.
function M.is_line(line)
  return vim.api.nvim_win_get_cursor(0)[1] == line
end

-- Check if its the top of the file
-- Useful for e.g. frontmatter snippets.
function M.top_of_file()
  return vim.api.nvim_win_get_cursor(0)[1] == 1
end

-- https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/util/utils.lua#L16C1-L26C4
-- not used
M.no_backslash = function(line_to_cursor, matched_trigger)
  return not line_to_cursor:find('\\%a+$', -#line_to_cursor)
end

-- https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/util/utils.lua#L16C1-L26C4
-- make it easy to check if multiple conditions are true
-- e.g. `condition = pipe({in_mathzone, line_begin})`
M.pipe = function(fns)
  return function(...)
    for _, fn in ipairs(fns) do
      if not fn(...) then
        return false
      end
    end

    return true
  end
end

-- merge two lua tables
M.merge_tables = function(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

return M
-- From any snippet file, source `get_visual` from global helper functions file
-- local helpers = require 'luasnip-helper-funcs'
-- local get_visual = helpers.get_visual
