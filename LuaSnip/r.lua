local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local c = ls.choice_node
local d = ls.dynamic_node

-- Example: expanding a snippet on a new line only.
local line_begin = require('luasnip.extras.expand_conditions').line_begin

return {
  -- Pipe Operator - tidyverse
  s({ trig = '>>', wordTrig = true, snippetType = 'autosnippet' }, { t ' |> ' }),
  -- ==================== code blocks ====================
  s(
    { trig = 'cb', snippetType = 'autosnippet' },
    fmta(
      [[```r
<>
```

<>]],
      { i(1), i(0) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = 'Cb', snippetType = 'autosnippet' },
    fmta(
      [[```r
<>
```

<>]],
      { i(1), i(0) }
    ),
    { condition = line_begin }
  ),
}
