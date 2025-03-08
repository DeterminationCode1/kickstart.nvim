local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- TODO Create a nvim autocmd for markdown files to add space after symbols but
-- not if a specific other symbol follows it. E.g. `!` should not be followed by
-- a space if `[]()` follows it.

return {
  -- automatic white space

  s({ trig = ',', snippetType = 'autosnippet', wordTrig = false }, { t ', ' }),
  s({ trig = ':', snippetType = 'autosnippet', wordTrig = false }, { t ': ' }),
  s({ trig = '?', snippetType = 'autosnippet', wordTrig = false }, { t '? ' }),
  -- s({ trig = '!', snippetType = 'autosnippet', wordTrig = false }, { t '! ' }), -- NOTE:  '!' is not used because of `!=` operator
  -- NOTE:  '.' is not used because as a programmer dot notation like `foo.bar` is common
}
