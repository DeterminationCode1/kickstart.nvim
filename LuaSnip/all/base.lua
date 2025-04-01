local ls = require 'luasnip' -- having \frac{razt}{rst} \frac{rst}{}

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- \frac{rsttr}{hi} \frac{rtt}{} \frac{r}{hi} rrsdt \frac{4}{8}
return {

  --
  -- other
  -- inject space as workaround to not expand luasnippets
  -- E.g. you could not write t or any other snippet trigger without expanding
  -- them when hitting space. But by typing the here defined snippet you can
  -- type a space indirectly without triggering a snippet expansion.
  -- s({ trig = 'xsp', snippetType = 'autosnippet', wordTrig = false }, { t ' ' }),
  s({ trig = ',,', snippetType = 'autosnippet', wordTrig = false, priority = 100 }, { t ' ' }),
  s({ trig = 'xx', snippetType = 'autosnippet', wordTrig = false, priority = 100 }, { t ' ' }),
  s({ trig = ', , ', snippetType = 'autosnippet', wordTrig = false, priority = 100 }, { t ' ' }),
  -- s({ trig = '(%w+)/', wordTrig = true, trigEngine = 'pattern', snippetType = 'autosnippet' }, { t 'IAmTrig' }), -- rst/ IAmTrig IAmTrig IAmTrig  IAmTrigr IAmTrig
  -- s(
  --   { trig = '(\\?%w+)/', wordTrig = false, trigEngine = 'pattern', snippetType = 'autosnippet' },
  --   fmta('\\frac{<>}{<>} <>', { f(function(_, snip)
  --     return string.format('%s', snip.captures[1])
  --   end, {}), i(1), i(0) })
  -- ),
  -- IAmTrig trig/ ttrs/ IAmTrig IAmTrig IAmTrig IAmTrig IAmTrig IAmTrig
  -- IAmTrig IAmTrig rst rts return IAmTrig

  -- A snippet that expands the trigger "hi" into the string "Hello, world!". -- Hello, world!
  -- s({ trig = 'hiIAmALuasnippet' }, { t 'Hello, world!' }),
  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  -- require('luasnip').snippet({ trig = 'foo' }, { t 'Another snippet.' }),

  -- s({ trig = 'hilua', snippetType = 'autosnippet', wordTrigger = false }, { t 'autosnippet All' }),
}
