-- luasnippets  for common abbreviations
--

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

return {
  s({ trig = 'eg ', snippetType = 'autosnippet' }, {
    t 'e.g. ',
  }),
  s({ trig = 'ie ', snippetType = 'autosnippet' }, {
    t 'i.e. ',
  }),
  s({ trig = 'etc ', snippetType = 'autosnippet' }, {
    t 'etc. ',
  }),
  -- s({ trig = 'mr', snippetType = 'autosnippet' }, {
  --   t 'Mr. ',
  -- }),
  -- s({ trig = 'mrs', snippetType = 'autosnippet' }, {
  --   t 'Mrs. ',
  -- }),
  -- s({ trig = 'ms', snippetType = 'autosnippet' }, {
  --   t 'Ms. ',
  -- }),
}
