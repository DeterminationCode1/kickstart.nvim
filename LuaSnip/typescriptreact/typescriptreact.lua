local ls = require 'luasnip'
local s = ls.snippet -- create a snippet
local t = ls.text_node -- insert static text
local i = ls.insert_node -- type text
local f = ls.function_node -- Call any lua / vim function
local fmt = require('luasnip.extras.fmt').fmt -- format text
local fmta = require('luasnip.extras.fmt').fmta

-- NOTE: use this very helpful command to add the snippets of a different
-- filetype to the current filetype.
require('luasnip').filetype_extend('typescriptreact', { 'javascript' })

local function get_root()
  local parser = vim.treesitter.get_parser(0, 'typescript')
  local syntax_tree = parser:parse(true)
  return syntax_tree[1]:root()
end

local function has_react_import()
  local query_str = [[ 
  (import_statement
  (import_clause
  (identifier) @cap (#eq? @cap "Reactt")
  )
  )
  ]]

  local query = vim.treesitter.query.parse('typescript', query_str)

  local match = query:iter_matches(get_root(), 0, nil, nil, {
    match_limit = 1,
  })

  if match() then
    return true
  else
    return false
  end
end

return {
  -- YouTube tutorial: https://www.youtube.com/watch?v=0pSdL4C6CoE&t=493s
  s(
    { trig = 'rc ', snippetType = 'autosnippet', desc = 'React Function Component', priority = 10000 },
    fmt(
      [[
      type Props = {{

      }}

      export default function {}(props: Props) {{
          {}

          return(
              <div>
                {}
              </div>
          )
      }}
      ]],
      {
        f(function()
          -- dynamically import react at the top of the file
          if not has_react_import() then
            -- buffer=0 means current buffer
            -- start, end=0 selects first line of the buffer
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { "import React from 'react'" })
          end
          return vim.fn.expand '%:t:r' -- Gets the current filename (without extension)
        end),
        i(1), -- First insert
        f(function()
          return vim.fn.expand '%:t:r'
        end),
      }
    )
  ),
  -- s(
  --   { trig = 'rc', snippetType = 'autosnippet', desc = 'React function Component', priority = 10000 },
  --   fmt(
  --     [[
  --     import React from 'react'

  --     export default function {}() {{
  --         {}

  --         return(
  --             <div>
  --               {}
  --             </div>
  --           )
  --         }}
  -- ]],
  --     {
  --       f(function()
  --         return vim.fn.expand '%:t:r'
  --       end),
  --     i(1, 'Component'), -- default value for the first insert node
  --     i(2) -- second insert node
  --     }, -- function to get the file name
  --   ),
  --   {}
  -- ),
  --   s(
  --     { trig = 'rc', snippetType = 'autosnippet', desc = 'React function Component', priority = 10000 },
  --     fmt(
  --       [[import React from 'react'

  -- export default function {}() {{
  --     {}

  --     return(
  --         <div>
  --           {}
  --         </div>
  --       )
  --     }}
  --   ]],
  --       { f(function()
  --         return vim.fn.expand '%:t:r'
  --       end) }, -- function to get the file name
  --       i(1, 'Component'), -- default value for the first insert node
  --       i(2) -- second insert node
  --     ),
  --     {}
  --   ),
}
