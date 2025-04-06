-- WARNING: all snippets requiring a '/'  like 'a/b' will not work with the
-- current implementation. no idea why.
-- - defining  the 'a/b' snippet in all.lua it works in all files but not in
-- markdown. e.g. in this lua file it will work but in markdown its not working
-- even though the snippet is listded by the 'snipetlist' command
local utils = require 'utils.my-utils.luasnip-helper-funcs'
local merge = utils.merge_tables
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local in_mathzone = require('utils.my-utils.treesitter-contexts').in_mathzone

local in_text = require('utils.my-utils.treesitter-contexts').in_text
local line_begin = require('luasnip.extras.expand_conditions').line_begin
local ls = require 'luasnip'
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

-- alternative config  approach
-- local s = ls.snippet
-- local default1 = { wordTrig = false, trigEngine = 'pattern', snippetType = 'autosnippet', priority = 100 }
-- local default3 = { condition = pipe { in_mathzone }, show_conditon = pipe { in_mathzone } }

-- https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/lea snip-latex-snippets/math_war.lea#L50C1-L56C1
local frac_no_parenthesis = {
  f(function(_, snip)
    return string.format('\\frac{%s}', snip.captures[1])
  end, {}),
  t '{',
  i(1),
  t '}',
  i(0),
}

local frac_node = {
  f(function(_, snip)
    local match = snip.trigger
    local stripped = match:sub(1, #match - 1)

    i = #stripped
    local depth = 0
    while i >= 0 do
      if stripped:sub(i, i) == ')' then
        depth = depth + 1
      end
      if stripped:sub(i, i) == '(' then
        depth = depth - 1
      end
      if depth == 0 then
        break
      end
      i = i - 1
    end

    if depth ~= 0 then
      return string.format('%s\\frac{}', stripped)
    else
      return string.format('%s\\frac{%s}', stripped:sub(1, i - 1), stripped:sub(i + 1, #stripped - 1))
    end
  end, {}),
  t '{',
  i(1),
  t '}',
  i(0),
}

local frac_no_parenthesis_triggers = {
  '(\\?[%w]+\\?^%w)/',
  '(\\?[%w]+\\?_%w)/',
  '(\\?[%w]+\\?^{%w*})/',
  '(\\?[%w]+\\?_{%w*})/',
  '(\\?%w+)/',
}

-- Base configuration for all snippets of this file
local s = ls.extend_decorator.apply(ls.snippet, {
  wordTrig = false,
  trigEngine = 'pattern',
  snippetType = 'autosnippet',
  condition = pipe { in_mathzone },
})

local snippets = {
  s({
    priority = 1000,
    trig = '.*%)/',
    name = '() frac',
    desc = 'Fraction with parentheses. E.g. (a+b)/ -> \\frac{a+b}',
    wordTrig = true,
  }, vim.deepcopy(frac_node)),
  -- me: ff as an alternative trigger to ()/ for fractions
  -- used by ejnowski
  s( -- ToDo: delete this as it's already in loop
    {
      priority = 10000,
      trig = '([%w]+)/',
      name = ' fraction my',
      desc = 'Fraction with parentheses. Eg ffa+b -> \\frac{a+b}',
      -- wordTrig = true,
    },
    fmta('\\frac{<>}{<>} <>', { f(function(_, snip)
      return string.format('%s', snip.captures[1])
    end, {}), i(1), i(0) })
  ),
  s(
    {
      priority = 1000,
      trig = '(%s+)ff',
      name = ' ff frac',
      desc = 'Fraction with parentheses. Eg ffa+b -> \\frac{a+b}',
      -- wordTrig = true,
    },
    fmta('<>\\frac{<>}{<>} <>', { f(function(_, snip)
      return string.format('%s', snip.captures[1])
    end, {}), i(1), i(2), i(0) })
  ),
}

-- for _, trig in ipairs(frac_no_parenthesis_triggers) do
--   table.insert(snippets, s({ trig = trig, name = 'Fraction no ()' }, vim.deepcopy(frac_no_parenthesis)))
-- end
--

for _, trig in pairs(frac_no_parenthesis_triggers) do
  snippets[#snippets + 1] = s(
    {
      name = 'Fraction no ()',
      trig = trig,
    },

    -- vim.deepcopy(frac_no_parenthesis))
    {
      f(function(_, snip)
        return string.format('\\frac{%s}', snip.captures[1])
      end, {}),
      t '{',
      i(1),
      t '}',
      i(0),
    }
  )
end

return snippets
