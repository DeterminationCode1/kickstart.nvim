-- see "friendly-snippets > javascript" for inspiration:
-- https://github.com/rafamadriz/friendly-snippets/blob/efff286dd74c22f731cdec26a70b46e5b203c619/snippets/javascript/next.json

local ls = require 'luasnip'
local s = ls.snippet -- create a snippet
local t = ls.text_node -- insert static text
local i = ls.insert_node -- type text
local f = ls.function_node -- Call any lua / vim function
local fmt = require('luasnip.extras.fmt').fmt -- format text
local fmta = require('luasnip.extras.fmt').fmta
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local fmta = ls.format_node

-- Example: expanding a snippet on a new line only.
-- local line_begin = require('luasnip.extras.expand_conditions').line_begin
-- local top_of_file = require('utils.luasnip-helper-funcs').top_of_file
-- local is_line = require('utils.luasnip-helper-funcs').is_line

-- local get_visual = require('utils.luasnip-helper-funcs').get_visual

-- "${1:iterable}.filter((${2:item}) => {\n\t${0}\n})"
-- s({ trig = 'find', snippetType = 'autosnippet' }, fmta([[<>.filter(<> => {\n\t<>\n})]], { i(1, 'iter'), i(2, 'item'), i(0) })),
return {
  -- ======================= Next.js components ==========================================
  s(
    { trig = 'uimg ', snippetType = 'autosnippet', desc = 'use next.js Image component' },
    fmt("<Image src='{}' width='{}' height='{}' alt='{}' /> {}", { i(1), i(2), i(3), i(4), i(0) }),
    {}
  ),
}
