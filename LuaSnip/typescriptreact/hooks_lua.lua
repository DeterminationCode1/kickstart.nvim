local ls = require 'luasnip'
local s = ls.snippet -- create a snippet
local t = ls.text_node -- insert static text
local i = ls.insert_node -- type text
local f = ls.function_node -- Call any lua / vim function
local fmt = require('luasnip.extras.fmt').fmt -- format text
local fmta = require('luasnip.extras.fmt').fmta

-- local str = require 'snips.utils.str'
-- local box_trim_lines = str.box_trim_lines

-- local get_line_iter = function(str)
--   if str:sub(-1) ~= '\n' then
--     str = str .. '\n'
--   end

--   return str:gmatch '(.-)\n'
-- end

-- local box_trim_lines = function(str)
--   local new_str = ''

--   for line in get_line_iter(str) do
--     line = line:gsub('^%s+', '')
--     line = string.gsub(line, '%s+$', '')
--     new_str = new_str .. '\n' .. line
--   end

--   return new_str
-- end

return {
  -- ============================= useState ==============================
  s(
    { trig = 'ust ', snippetType = 'autosnippet', desc = 'useState' },
    fmt(
      [[
      const [{}, {}] = useState({})
    ]],
      {
        i(1),
        f(function(args)
          local name = args[1][1]

          return string.format('set%s', name:sub(1, 1):upper() .. name:sub(2, -1))
        end, { 1 }),
        i(2),
      }
    ),
    {}
  ),
  -- ============================= useEffect =============================
  -- there is a way to write a luasnippet to automatically add all dependencies
  -- to useEffect array automatically by calling the eslint script.
  --
  -- -- Gitrepo using luasnip to automatically import hooks and add dependencies to
  -- useEffect
  -- reddit:  https://www.reddit.com/r/neovim/comments/1admqxx/share_your_interesting_snippets_of_luasnip/
  --
  -- https://github.com/weilbith/vim-blueplanet/blob/9cf6ebd445cc070a5d5130d03005988e278fab71/after/pack/plugins/opt/LuaSnip/lua/snippets/callbacks/lsp_code_actions.lua#L203
  --
  -- https://github.com/weilbith/vim-blueplanet/blob/9cf6ebd445cc070a5d5130d03005988e278fab71/after/pack/plugins/opt/LuaSnip/luasnippets/typescriptreact/hooks_api.lua
  s(
    { trig = 'ue ', snippetType = 'autosnippet', desc = 'useEffect' },
    fmt(
      [[
      useEffect(() => {{
        {}
      }}, [{}])
    ]],
      {
        i(1),
        -- use eslint script
        i(0),
      }
    ),
    {}
  ),
  -- ============================= useRef ==============================
  s(
    { trig = 'uref ', snippetType = 'autosnippet', desc = 'useRef' },
    fmt(
      [[
      const {} = useRef({})
    ]],
      {
        i(1),
        i(2),
      }
    ),
    {}
  ),
}
