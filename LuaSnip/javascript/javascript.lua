-- see "friendly-snippets > javascript" for inspiration:
-- https://github.com/rafamadriz/friendly-snippets/blob/efff286dd74c22f731cdec26a70b46e5b203c619/snippets/javascript/javascript.json

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
  -- ======================= Variable Assignment ==========================================
  s({ trig = 'l ', snippetType = 'autosnippet' }, fmta('let <> = <>\n\n<>', { i(1, 'name'), i(2, 'value'), i(0) }), {}),
  s({ trig = 'c ', snippetType = 'autosnippet' }, fmta('const <> = <>\n\n<>', { i(1, 'name'), i(2, 'value'), i(0) }), {}),

  s({ trig = 'cd ', snippetType = 'autosnippet' }, fmta('const { <> } = <>\n\n<>', { i(1, 'prop'), i(2, 'value'), i(0) }), {}),
  s(
    { trig = 'ca ', snippetType = 'autosnippet', desc = 'const assignment await' },
    fmta('const <> = await <>\n\n<>', { i(1, 'name'), i(2, 'value'), i(0) }),
    {}
  ),

  s(
    { trig = 'cda ', snippetType = 'autosnippet', desc = 'const destructuring assignment awaited' },
    fmta('const { <> } = await <>\n\n<>', { i(1, 'prop'), i(2, 'value'), i(0) }),
    {}
  ),
  s({ trig = 'co ', snippetType = 'autosnippet', desc = 'const object' }, fmta('const <> = {\n<>\n}\n<>', { i(1, 'name'), i(2, 'value'), i(0) }), {}),
  s({ trig = 'car ', snippetType = 'autosnippet', desc = 'const array' }, fmta('const <> = [<>]\n<>', { i(1, 'name'), i(2, 'value'), i(0) }), {}),

  -- -- ======================= Function Declaration ==========================================
  -- s({ trig = 'af ', snippetType = 'autosnippet', desc = 'arrow function' }, fmta('(<>) => <>', { i(1, 'name'), i(0) }), {}),
  -- s(
  --   { trig = 'f ', snippetType = 'autosnippet', desc = 'arrow function with body' },
  --   fmta('(<>) => {\n\t<>\n}\n<>', { i(1, 'arg'), i(2, 'statement'), i(0) }),
  --   {}
  -- ),
  -- s(
  --   { trig = 'fr ', snippetType = 'autosnippet', desc = 'arrow function with return' },
  --   fmta('(<>) => {\n\t<>\nreturn <>\n}\n<>', { i(1, 'arg'), i(2, 'statement'), i(3, 'res'), i(0) }),
  --   {}
  -- ),

  -- -- ======================== Debugging ==========================================
  s({ trig = 'cl ', snippetType = 'autosnippet', desc = 'console.log' }, fmta('console.log(<>)\n<>', { i(1, 'value'), i(0) }), {}),
  s({ trig = 'cv ', snippetType = 'autosnippet', desc = 'console.log a variable' }, fmta("console.log('<>:', <>)\n<>", { i(1, 'var'), i(2), i(0) }), {}),

  -- -- ========================= Logical Instructions ==========================================
  s({ trig = 'te', desc = 'ternary', snippetType = 'autosnippet' }, fmta('<> ? <> : <>', { i(1, 'cond'), i(2, 'true'), i(3, 'false') }), {}),
  s({ trig = 'if', desc = 'if statement', snippetType = 'autosnippet' }, fmta('if (<>) {\n\t<>\n}\n\n<>', { i(1, 'cond'), i(2), i(0) }), {}),
  s(
    { trig = 'ife', desc = 'if else statement', snippetType = 'autosnippet' },
    fmta('if (<>) {\n\t<>\n} else {\n\t<>\n}\n\n<>', { i(1, 'cond'), i(2), i(3), i(0) }),
    {}
  ),

  -- -- Return
  -- s({ trig = 'ra', desc = 'return new array', snippetType = 'autosnippet' }, fmta('return [<>]\n<>', { i(1, 'value'), i(0) }), {}),
  -- -- ======================= Array Methods ==========================================
  s({ trig = 'fe ', snippetType = 'autosnippet' }, fmta('<>.forEach( (<>)) {\n\t<>\n}\n\n<>', { i(1, 'iter'), i(2, 'ele'), i(3), i(0) }), {}),
  s({ trig = 'map ', snippetType = 'autosnippet' }, fmta('<>.map( (<>)) {\n\t<>\n}\n\n<>', { i(1, 'iter'), i(2, 'ele'), i(3), i(0) }), {}),
  -- s(
  --   { trig = 'reduce ', snippetType = 'autosnippet' },
  --   fmta('<>.reduce( (<>, <>)) => {\n\t<>\n}\n\n<>', { i(1, 'iter'), i(2, 'prev'), i(3, 'current'), i(4), i(0) }),
  --   {}
  -- ),
  -- s({ trig = 'filter ', snippetType = 'autosnippet' }, fmta('<>.filter( (<>)) => {\n\t<>\n}\n\n<>', { i(1, 'iter'), i(2, 'item'), i(3), i(0) }), {}),
  -- s({ trig = 'find ', snippetType = 'autosnippet' }, fmta('<>.find( (<>)) => {\n\t<>\n}\n\n<>', { i(1, 'iter'), i(2, 'item'), i(3), i(0) }), {}),

  -- -- =========================== Export & Import ==========================================================
  -- s({ trig = 'e ', snippetType = 'autosnippet' }, fmta('export <>() {\n\t<>\n}\n<>', { i(1, 'member'), i(0) }), {}),

  -- Import
  -- s({ trig = 'im ', snippetType = 'autosnippet' }, fmta("import <> from '<>'\n<>", { i(2, '*'), i(1, 'module'), i(0) }), {}),
  -- -- ============================= Try Catch ==================================================
  -- s({ trig = 'tc', snippetType = 'autosnippet' }, fmta('try {\n\t<>\n} catch (<>) {\n\t<>\n}\n\n<>', { i(1), i(2, 'err'), i(3), i(0) }), {}),
}
