local ls = require 'luasnip'
local s = ls.snippet -- create a snippet
local t = ls.text_node -- insert static text
local i = ls.insert_node -- type text
local f = ls.function_node -- Call any lua / vim function
local fmt = require('luasnip.extras.fmt').fmt -- format text
local fmta = require('luasnip.extras.fmt').fmta

-- NOTE: use this very helpful command to add the snippets of a different
-- filetype to the current filetype.
require('luasnip').filetype_extend('javascriptreact', { 'javascript' })

return {}
