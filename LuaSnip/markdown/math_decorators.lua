-- Include this `in_mathzone` function at the start of a snippets file...
-- local in_mathzone = function() -- Didn't work
--   -- The `in_mathzone` function requires the VimTeX plugin
--   vim.notify 'VimTeX is required for this snippet to work'
--   local res = vim.fn['vimtex#syntax#in_mathzone']()
--   vim.notify('resut ' .. res)
--   -- return vim.fn['vimtex#syntax#in_mathzone']() == 1
--   return vim.api.nvim_eval 'vimtex#syntax#in_mathzone()' == 1
-- end

local utils = require 'utils.my-utils.luasnip-helper-funcs'
local merge = utils.merge_tables
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local in_mathzone = require('utils.my-utils.treesitter-contexts').in_mathzone

local in_text = require('utils.my-utils.treesitter-contexts').in_text
local line_begin = require('luasnip.extras.expand_conditions').line_begin
-- -- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- -- expand only in math contexts.
local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

local default1 = { wordTrig = false, regTrig = true, snippetType = 'autosnippet', priority = 100 }
local default3 = { condition = pipe { in_mathzone, no_backslash }, show_conditon = pipe { in_mathzone, no_backslash } }

return {
  -- math decorator
  -- inspired by https://github.com/iurimateus/luasnip-latex-snippets.nvim/blob/4b91f28d91979f61a3e8aef1cee5b7c7f2c7beb8/lua/luasnip-latex-snippets/math_iA.lua#L19
  s({ trig = '(%a+)bar', name = 'bar', wordTrig = false, regTrig = true, snippetType = 'autosnippet', priority = 100 }, {
    f(function(_, snip)
      return string.format('\\overline{%s}', snip.captures[1])
    end, {}),
  }, default3),
  -- { trig = '(%a+)und', name = 'underline', wordTrig = false, regTrig = true, snippetType = 'autosnippet', priority = 100 }
  s(merge({ trig = '(%a+)und', name = 'underline' }, default1), {
    f(function(_, snip)
      return string.format('\\underline{%s}', snip.captures[1])
    end, {}),
  }, default3),
  -- dot
  s(merge({ trig = '(%a+)dot', name = 'dot' }, default1), {
    f(function(_, snip)
      return string.format('\\dot{%s}', snip.captures[1])
    end, {}),
  }, default3),
  -- hat
  s(merge({ trig = '(%a+)hat', name = 'hat' }, default1), {
    f(function(_, snip)
      return string.format('\\hat{%s}', snip.captures[1])
    end, {}),
  }, default3),
  -- over right arrow
  s(merge({ trig = '(%a+)ora', name = 'ora' }, default1), {
    f(function(_, snip)
      return string.format('\\overrightarrow{%s}', snip.captures[1])
    end, {}),
  }, default3),
  -- over left arrow
  s(merge({ trig = '(%a+)ola', name = 'ola' }, default1), {
    f(function(_, snip)
      return string.format('\\overleftarrow{%s}', snip.captures[1])
    end, {}),
  }, default3),
}
