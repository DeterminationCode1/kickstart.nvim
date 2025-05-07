-- When not using AI and code completion,  it was helpful to be able to have an
-- extra snippet expand step at the end of each snippet to add a space or new
-- line automatically.
--
-- But `TAB` is also use for AI completion which is often much more useful
-- within some snippets then a space or new line.

-- This file backs up the old withspace oriented snippets.

return {
  -- Frontmatter =====================================================================================================
  --   s(
  --     { trig = 'Fm', snippetType = 'autosnippet' },
  --     fmta(
  --       [[---
  -- <>: <>
  -- ---

  -- <>]],
  --       { i(1, 'key'), i(2, 'val'), i(3) }
  --     ),

  --     {
  --       condition = function()
  --         return top_of_file() --[[ or is_line(3) ]]
  --       end,
  --     }
  --   ),
  --

  -- code blocks =====================================================================================================
  --   s(
  --     { trig = 'cb', snippetType = 'autosnippet' },
  --     fmta(
  --       [[```<>
  -- <>
  -- ```

  -- <>]],
  --       { i(1, 'lang'), i(2), i(0) }
  --     ),
  --     { condition = line_begin }
  --   ),
  --   s(
  --     { trig = 'Cb', snippetType = 'autosnippet' },
  --     fmta(
  --       [[```<>
  -- <>
  -- ```

  -- <>]],
  --       { i(1, 'lang'), i(2), i(3) }
  --     ),
  --     { condition = line_begin }
  --   ),
  -- }
}
