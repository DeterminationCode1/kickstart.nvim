local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local c = ls.choice_node
local d = ls.dynamic_node
-- local fmta = ls.format_node

-- Example: expanding a snippet on a new line only.
-- In a snippet file, first require the line_begin condition...
local line_begin = require('luasnip.extras.expand_conditions').line_begin

-- NOTE: use this very helpful command to add the snippets of a different
-- filetype to the current filetype.
require('luasnip').filetype_extend('rmd', { 'r' })

return {}
