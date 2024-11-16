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
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

-- https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/math_wrA.lua#L50C1-L56C1
local subscript_node = {
  f(function(_, snip)
    return string.format('%s_{%s}', snip.captures[1], snip.captures[2])
  end, {}),
  i(0),
}

local default1 = { wordTrig = false, trigEngine = 'pattern', snippetType = 'autosnippet', priority = 100 }
local default3 = { condition = pipe { in_mathzone }, show_conditon = pipe { in_mathzone } }

return {
  -- subscript
  -- https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/math_wrA.lua#L50C1-L56C1
  s(merge({ trig = '(%a)(%d)', name = 'auto subscript' }, default1), vim.deepcopy(subscript_node), default3),
  s(merge({ trig = '(%a)_(%d%d)', name = 'auto subscript 2' }, default1), vim.deepcopy(subscript_node), default3),

  s(merge({ trig = 'xnn', name = 'x_{n}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'x_{n} ', default3),
  s(merge({ trig = 'ynn', name = 'y_{n}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'y_{n} ', default3),
  s(merge({ trig = 'xii', name = 'x_{i}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'x_{i} ', default3),
  s(merge({ trig = 'yii', name = 'y_{i}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'y_{i} ', default3),
  s(merge({ trig = 'xjj', name = 'x_{j}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'x_{j} ', default3),
  s(merge({ trig = 'yjj', name = 'y_{j}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'y_{j} ', default3),
  s(merge({ trig = 'xp1', name = 'x_{p+1}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'x_{p+1} ', default3),
  s(merge({ trig = 'xm', name = 'x_{m}' }, { wordTrig = true, snippetType = 'autosnippet' }), t 'x_{m} ', default3),

  --superscript
  s(merge({ trig = 'sr', name = 'Square ^2' }, default1), fmta('^{2} <>', { i(0) }), default3),
  s(merge({ trig = 'cb', name = 'Cube ^3' }, default1), fmta('^{3} <>', { i(0) }), default3),
  s(merge({ trig = 'tp', name = '(generic) Superscript ^ / [t]o the [p]ower' }, default1), fmta('^{<>} ', { i(0) }), default3),
  s(merge({ trig = 'inv', name = 'Inverse function' }, { wordTrig = true, snippetType = 'autosnippet' }), fmta('^{<>} ', { i(0) }), default3),
}
