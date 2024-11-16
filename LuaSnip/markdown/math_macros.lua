local utils = require 'utils.luasnip-helper-funcs'
local merge = utils.merge_tables
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local in_mathzone = require('utils.treesitter-contexts').in_mathzone

local in_text = require('utils.treesitter-contexts').in_text
local line_begin = require('luasnip.extras.expand_conditions').line_begin
-- -- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- -- expand only in math contexts.
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

local default1 = { wordTrig = true, regTrig = false, snippetType = 'autosnippet', priority = 100 }
local default3 = { condition = pipe { in_mathzone }, show_conditon = pipe { in_mathzone } }

return {
  -- overload with set builders notation because analysis and algebra cannot agree on a singular notation
  -- https://github.com/evesdropper/luasnip-latex-snippets.nvim/blob/c6b5b5367dd4bb8419389f5acf528acf296adcdd/lua/luasnip-latex-snippets/luasnippets/tex/math-commands.lua
  s(
    merge({ trig = 'set' }, default1),
    fmta(
      [[
    \{<>\}<>
    ]],
      { c(1, { r(1, ''), sn(nil, { r(1, ''), t ' \\mid ', i(2) }), sn(nil, { r(1, ''), t ' \\colon ', i(2) }) }), i(0) }
    ),
    default3
  ),
}
