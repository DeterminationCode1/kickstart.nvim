-- WARNING: after implementing the neovim build-in `gcgc` uncomment around a
-- comment. I found out that it was built-in in neovim 0.10.0 (`gcgc`) and also
-- mini.comment provided an even better text object for comments.

-- `gcu` to uncomment consecutive commented l
--
-- I reimplemented this handy keymap used by the `vim-commentary` plugin from Tim Pope.
-- It seems like it's not a part of the `Comment.nvim` plugin, but I found it useful.
-- vim.keymap.set('n', prefix .. 'u', function()
--   local api = require 'Comment.api'
--   local config = require('Comment.config'):get()
--   local fn = vim.fn
--   local buf = vim.api.nvim_get_current_buf()

--   local start = fn.line '.'
--   local total_lines = fn.line '$'
--   local lines = vim.api.nvim_buf_get_lines(buf, start - 1, total_lines, false)

--   -- Match lines that start with only optional whitespace, then a comment symbol
--   local comment_patterns = {
--     '^%s*%/%/', -- C++, Java, JS
--     '^%s*%#', -- Python, Shell, YAML
--     '^%s*%-%-', -- Lua, SQL
--     '^%s*;', -- Lisp, Clojure
--     '^%s*%%%%', -- MATLAB
--     '^%s*%/%*', -- C-style block start
--     '^%s*<%!%-%-', -- HTML/XML
--   }

--   local function is_comment(line)
--     -- Reject empty or whitespace-only lines
--     if line:match '^%s*$' then
--       return false
--     end

--     -- Must start with a valid comment prefix and no code before it
--     for _, pat in ipairs(comment_patterns) do
--       if line:match(pat) then
--         return true
--       end
--     end
--     return false
--   end

--   -- Step 1–3: Move cursor upward until top of comment block
--   local top = start
--   for lnum = start - 1, 1, -1 do
--     local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
--     if not is_comment(line) then
--       break
--     end
--     top = lnum
--   end

--   vim.api.nvim_win_set_cursor(0, { top, 0 }) -- move cursor to top

--   -- Step 4: Count comment lines downward from new position
--   local count = 0
--   for lnum = top, total_lines do
--     local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
--     if not is_comment(line) then
--       break
--     end
--     count = count + 1
--   end

--   if count > 0 then
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
--     -- vim.notify('top: ' .. top, vim.log.levels.INFO)
--     vim.api.nvim_win_set_cursor(0, { top, 0 }) -- move to top line
--     api.toggle.linewise.count(count, config)
--   else
--     vim.notify('No consecutive commented lines found.', vim.log.levels.INFO)
--   end
-- end, { desc = 'Uncomment consecutive commented lines (Comment.nvim)' })
