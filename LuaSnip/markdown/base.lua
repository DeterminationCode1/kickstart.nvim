-- Basic markdown features snippets:
-- - headings
-- - links
-- - page break / horizontal rule
-- - frontmatter
-- - code blocks

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
local top_of_file = require('utils.luasnip-helper-funcs').top_of_file
local is_line = require('utils.luasnip-helper-funcs').is_line

local get_visual = require('utils.luasnip-helper-funcs').get_visual

return {
  -- s(
  --   { trig = '(\\?%w+)/', name = 'aaa frac', wordTrig = false, trigEngine = 'pattern', snippetType = 'autosnippet' },
  --   fmta('\\frac{<>}{<>} <>', { f(function(_, snip)
  --     return string.format('%s', snip.captures[1])
  --   end, {}), i(1), i(0) })
  -- ),
  -- Frontmatter =====================================================================================================
  s(
    { trig = 'Fm', snippetType = 'autosnippet' },
    fmta(
      [[---
<>: <>
---

<>]],
      { i(1, 'key'), i(2, 'val'), i(3) }
    ),

    {
      condition = function()
        return top_of_file() --[[ or is_line(3) ]]
      end,
    }
  ),

  -- Headings ========================================================================================================
  -- Colemak-DH keyboard layout
  s({ trig = 'xn', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'Xn', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'xe', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'Xe', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'xi', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),
  s({ trig = 'Xi', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),
  s({ trig = 'xo', snippetType = 'autosnippet' }, { t '##### ' }, { condition = line_begin }),
  s({ trig = 'Xo', snippetType = 'autosnippet' }, { t '##### ' }, { condition = line_begin }),
  -- QWERTY keyboard layout
  s({ trig = 'xj', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'Xj', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'xk', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'Xk', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'xl', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),
  s({ trig = 'Xl', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),
  s({ trig = 'x;', snippetType = 'autosnippet' }, { t '##### ' }, { condition = line_begin }),
  s({ trig = 'X;', snippetType = 'autosnippet' }, { t '##### ' }, { condition = line_begin }),

  -- Special headings
  -- One-pager. o + xn (level 2 heading)
  s(
    { trig = 'oxn', snippetType = 'autosnippet' },
    fmta(
      [[## One-pager

<>]],
      { i(0) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = 'Oxn', snippetType = 'autosnippet' },
    fmta(
      [[## One-pager

<>]],
      { i(0) }
    ),
    { condition = line_begin }
  ),

  -- links
  -- s({ trig = 'xl', snippetType = 'autosnippet', wordTrig = true }, fmta([[[<>](<>) ]], { i(1, 'link'), d(2, get_visual) })),

  -- page break =====================================================================================================
  -- WARNING: the snippet `br` didn't work out because too many words start with
  -- `br` and triggered the snippet accidentally. e.g. Break, Brew etc.
  --   s(
  --     { trig = 'br', snippetType = 'autosnippet' },
  --     fmta(
  --       [[---

  -- <>]],
  --       i(0)
  --     ),
  --     { condition = line_begin }
  --   ),
  --   s(
  --     { trig = 'Br', snippetType = 'autosnippet' },
  --     fmta(
  --       [[---

  -- <>]],
  --       i(0)
  --     ),
  --     { condition = line_begin }
  --   ),

  -- text styling ====================================================================================================
  -- bold
  s({ trig = 'bb', snippetType = 'autosnippet' }, fmta('**<>** <>', { i(1), i(0) }), {}),

  -- code blocks =====================================================================================================
  s(
    { trig = 'cb', snippetType = 'autosnippet' },
    fmta(
      [[```<>
<>
```

<>]],
      { i(1, 'lang'), i(2), i(0) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = 'Cb', snippetType = 'autosnippet' },
    fmta(
      [[```<>
<>
```

<>]],
      { i(1, 'lang'), i(2), i(3) }
    ),
    { condition = line_begin }
  ),
}
