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

local get_visual = require('utils.luasnip-helper-funcs').get_visual
-- -- Quickly generate markdown headings.
-- the upercase triggers are because I have configured nvim to capitalizae the
-- first line of a new paragraph.

-- This is code block choice node snippe, but in the end the extra effort of
-- opening the select ui to select e.g. js, py, md or other short words was not
-- worth it.
-- {
--         c(1, {
--           t 'sh',
--           t 'python',
--           t 'py',
--           t 'lua',
--           t 'vim',
--           t 'markdown',
--           t 'md',
--           t 'html',
--           t 'css',
--           t 'javascript',
--           t 'js',
--           t 'typescript',
--           t 'ts',
--           t 'c',
--           t 'cpp',
--           t 'java',
--           t 'go',
--           t 'rust',
--           t 'r',
--           t 'ruby',
--           t 'perl',
--           t 'bash',
--           t 'shell',
--           t 'json',
--           t 'yaml',
--           t 'toml',
--           t 'xml',
--           t 'sql',
--           t 'dockerfile',
--           t 'plaintext',
--         }),
--         i(2),
--         i(3),
--       }

return {

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
    { condition = top_of_file }
  ),

  -- Headings ========================================================================================================
  s({ trig = 'xn', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'Xn', snippetType = 'autosnippet' }, { t '## ' }, { condition = line_begin }),
  s({ trig = 'xe', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'Xe', snippetType = 'autosnippet' }, { t '### ' }, { condition = line_begin }),
  s({ trig = 'xi', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),
  s({ trig = 'Xi', snippetType = 'autosnippet' }, { t '#### ' }, { condition = line_begin }),

  -- links
  s({ trig = 'xl', snippetType = 'autosnippet', wordTrig = true }, fmta([[[<>](<>) ]], { i(1, 'link'), d(2, get_visual) })),

  -- page break =====================================================================================================
  s(
    { trig = 'br', snippetType = 'autosnippet' },
    fmta(
      [[---

<>]],
      i(0)
    ),
    { condition = line_begin }
  ),
  s(
    { trig = 'Br', snippetType = 'autosnippet' },
    fmta(
      [[---

<>]],
      i(0)
    ),
    { condition = line_begin }
  ),

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
