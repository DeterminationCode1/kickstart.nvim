local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node

return {
  -- A snippet that expands the trigger "hi" into the string "Hello, world!". -- Hello, world!
  s({ trig = 'hiIAmALuasnippet' }, { t 'Hello, world!' }),
  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  -- require('luasnip').snippet({ trig = 'foo' }, { t 'Another snippet.' }),

  s({ trig = 'hilua', snippetType = 'autosnippet', wordTrigger = false }, { t 'autosnippet All' }),
}
