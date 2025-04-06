-- start math modes snippets
local pipe = require('utils.my-utils.luasnip-helper-funcs').pipe
local in_mathzone = require('utils.my-utils.treesitter-contexts').in_mathzone
local in_text = require('utils.my-utils.treesitter-contexts').in_text
local line_begin = require('luasnip.extras.expand_conditions').line_begin
-- -- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- -- expand only in math contexts.
local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

return {

  -- Math modes
  s({ trig = 'xm', dscr = 'inline math', snippetType = 'autosnippet' }, fmta('$<>$ <>', { i(1), i(0) }), { condition = in_text }),
  s({ trig = 'Xm', dscr = 'inline math', snippetType = 'autosnippet' }, fmta('$<>$ <>', { i(1), i(0) }), { condition = in_text }),
  s(
    { trig = 'dm', dscr = 'display math', snippetType = 'autosnippet', wordTrig = true },
    fmta(
      [[
    
    
    
$$
<>
$$
    
<>]],
      { i(1), i(0) }
    ),
    {
      condition = pipe {
        in_text,
      },
    }
  ),
  s(
    { trig = 'Dm', dscr = 'display math', snippetType = 'autosnippet', wordTrig = true },
    fmta(
      [[
    
    
    
$$
<>
$$
    
<>]],
      { i(1), i(0) }
    ),
    { condition = in_text }
  ),
}
