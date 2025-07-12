-- My custom autocommands for Neovim

-- =================== Espanso ===================
-- Only activate the Espanso text snippet engine when in insert mode.
--
-- Requirements when using Tmux:
--    Make sure you have `focus-events` turned on in your `tmux.conf`. Otherwise the
--    focus events won't be sent to Neovim and Espanso won't be
--    activated / deactivated based on app focus:
--    `set -g focus-events on`

-- deactivate Espanso when leaving insert mode.
-- CmdlineEnter, TermOpen, TermEnter are not needed
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Deactivate espanso when leaving insert mode',
  group = vim.api.nvim_create_augroup('espanso-deactivate', { clear = true }),
  callback = function()
    vim.system({ 'espanso', 'cmd', 'disable' }, { text = true }, function(obj)
      -- vim.notify('Espanso deactivated', vim.log.levels.DEBUG, { title = 'Espanso' })
    end)
  end,
})

-- deactivate Espanso when the nvim application gains focus, but only if it's
-- not in insert mode.
vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Deactivate espanso when neovim gains focus',
  group = vim.api.nvim_create_augroup('espanso-deactivate-focus', { clear = true }),
  callback = function()
    if vim.api.nvim_get_mode().mode ~= 'i' then
      vim.system({ 'espanso', 'cmd', 'disable' }, { text = true }, function(obj)
        --vim.notify('Espanso deactivated', vim.log.levels.DEBUG, { title = 'Espanso' })
      end)
    end
  end,
})

-- activate Espanso when entering insert mode or when nvim is not the active
-- application (focus lost, i.e. another app is in focus).
vim.api.nvim_create_autocmd({ 'InsertEnter', 'FocusLost' }, {
  desc = 'Activate espanso when entering insert mode',
  group = vim.api.nvim_create_augroup('espanso-activate', { clear = true }),
  callback = function()
    vim.system({ 'espanso', 'cmd', 'enable' }, { text = true }, function(obj)
      -- vim.notify('Espanso activated', vim.log.levels.DEBUG, { title = 'Espanso' })
    end)
  end,
})
-- =================== END - Espanso ===================

-- ================ Capitalize first letter of a sentence ================
-- Capitalize the first letter of a sentence.
--
-- The script was inspired by David Moody's vim script:  https://davidxmoody.com/2015/vim-auto-capitalisation/

vim.api.nvim_create_autocmd('InsertCharPre', {
  group = vim.api.nvim_create_augroup('capitalize-first-char', { clear = true }),
  -- pattern = '*', -- Match all filetypes
  pattern = { '*.md', '*.txt' }, -- Match specific filetypes if needed. '*.yml', '*.yaml'
  callback = function()
    -- Define a list of common abbreviations to exclude
    local abbreviations = { 'e.g.', 'i.e.', 'etc.', 'vs.', 'Dr.' } -- 'Mr.', 'Ms.', 'Mrs.'

    -- Get the current line up to the cursor position
    local line = vim.fn.getline('.'):sub(1, vim.fn.col '.' - 1)

    -- Check if the current word matches any of the abbreviations
    local is_abbreviation = false
    for _, abbr in ipairs(abbreviations) do
      if line:match(vim.pesc(abbr) .. '%s*$') then
        is_abbreviation = true
        break
      end
    end
    -- patterns:
    --
    -- 1. Start of the line: %^
    -- 2. After a punctuation mark: [.!?]\_s+
    -- 3. After a leading dash: \_^\-\s
    -- 4. After a markdown heading: ^#+\s+
    -- 5. After a YAML frontmatter title attribute: ^title\:\s
    -- 6. After two newlines, i.e. a new paragraph: \n\n

    -- Continue with capitalization only if not an abbreviation
    if not is_abbreviation then
      local pos = vim.fn.search([[\v(%^|[.!?]\_s+|\_^\-\s|^#+\s+|\_^title\:\s|\n\n)%#]], 'bcnw')
      if pos ~= 0 then
        -- Convert the character to uppercase
        vim.v.char = string.upper(vim.v.char)
      end
    end
  end,
})
-- ================ END - capitalize ================

-- ================ Remove whitespace - extra rules ================
-- the prettier formatter catches most unnecessary whitespace, but some
-- edge caught are and are removed by this autocmd instead.

-- Custom whitespace cleanup rules that are not handled by the prettier formatter for markdown files
--
-- Turn off formatter for specific files:
--   Anywhere in the file add: <!-- my-whitespace-ignore -->
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('cleanup-whitespace', { clear = true }),
  pattern = { '*.md' }, -- Match specific filetypes. { '*.txt'}
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    for _, line in ipairs(lines) do
      if line:match '^%s*<!%-%-%s*my%-whitespace%-ignore%s*%-%->' then
        vim.notify("Whitespace cleanup skipped: 'my-whitespace-ignore' found", vim.log.levels.DEBUG)
        return
      end
    end

    -- Save the current cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- -- Remove trailing spaces at the end of lines
    -- -- NOTE: This is already done by Prettier
    -- vim.cmd [[%s/\s\+$//e]]

    -- Remove spaces BEFORE punctuation marks: . ! ? , ; :
    -- e.g. "Hello . World" -> "Hello. World"
    --
    -- edge case: code notes in markdown files like `stow .` become `stow.`
    --    workaround: escapee the dot with a backslash. The code will still run
    --    in the terminal, but the space is not removed: `stow \.` -> `stow \.`
    --  TODO! I excluded `!` from the list because in markdown files with images
    --  the space before an `![myimage]` was removed. fix td.
    vim.cmd [[silent! %s/\s\+\([.,?:;]\)/\1/g]] -- maybe add '

    -- -- Replace multiple spaces between words with a single space
    -- -- -- NOTE: This is already done by Prettier
    -- vim.cmd [[%s/\s\{2,}/ /g]]

    -- Restore the cursor position after the substitution
    vim.api.nvim_win_set_cursor(0, { row, col })
  end,
})
-- ================ END - remove whitespace ================

-- ================ Sync "filename" and "markdown heading" ================
-- Automatically inject the file title in a human readable format as the level one (`# `) markdown
-- heading.
--
-- This will work for newly created files, files with outdated markdown
-- headings, and files with no markdown headings at all.

local function format_file_title(filename)
  -- Word separator. at the moment, only one  word seperator format at the same
  -- time is  supported.
  -- local word_separator = ' '

  -- Remove file extension
  filename = filename:gsub('%.%w+$', '')

  -- Preserve parts split by standalone dashes and underscores
  local parts = {}

  --  TODO: modif function the dynamicaly determine the word separator?

  -- Use pattern to match words and standalone dashes/underscores
  -- TODO: fix, does not work for underscore word separator
  for part in filename:gmatch '(%S+)[-_]?%s*' do
    table.insert(parts, part)
  end

  -- Capitalize the first letter of the first part
  if #parts > 0 then
    parts[1] = parts[1]:gsub('^%s*(%a)', string.upper)
  end

  -- Rejoin the parts with space while preserving the original separators
  local title = table.concat(parts, ' ')

  -- Add the markdown heading
  title = '# ' .. title

  return title
end

-- Autocommand to insert the file title as a markdown heading when creating a
-- new file or updating an existing file.
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufEnter', 'BufFilePost' }, { -- , 'BufLeave'
  group = vim.api.nvim_create_augroup('insert-file-title', { clear = true }),
  pattern = '*.md',
  callback = function()
    -- ======================== Helper functions =============================
    -- BE AWARE: A markdown heading is always a single line. Even if you have line break in nvim options turned on,
    -- or you're using a formatter like prettier to automatically break lines, the heading will always be a single (wrapped) line.

    -- Get the line number of the where the title should be inserted
    local get_title_line_number = function()
      -- NOTE: *Pure* function that inspects the buffer but never touches the cursor
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      -- front-matter present?
      if lines[1] == '---' then
        local fm_end = nil
        for i = 2, #lines do
          if lines[i] == '---' then -- closing ---
            fm_end = i
            break
          end
        end
        if fm_end then
          -- first non-blank line after the YAML block
          for j = fm_end + 1, #lines do
            if lines[j]:match '%S' then
              return j
            end
          end
          return #lines + 1 -- only front-matter in file
        end
      end
      return 1 -- no front-matter
    end

    -- Get the previous title or ''
    local get_previous_title = function(line)
      -- Search for the first heading (`# `) in the buffer
      local title = vim.fn.getline(line)
      if title:match '^# ' then
        return title
      end
      return ''
    end

    -- ================ Configure what to ignore ===========================
    local ignore_paths = {
      -- any buffer whose full path contains one of these substrings will be skipped
      -- '/tmp/', -- e.g. ignore anything in /tmp
      -- 'notes/drafts/', -- e.g. ~/projects/notes/drafts/
      -- add more...
      'kanban/',
    }
    local ignore_files = {
      'README.md',
      -- 'TODO.md',
      -- add more...
    }

    -- Get current file’s full path and name
    local fullpath = vim.fn.expand '%:p'
    local filename = vim.fn.expand '%:t'

    -- If this file lives in any ignore path, bail out
    for _, pat in ipairs(ignore_paths) do
      if fullpath:find(pat, 1, true) then
        return
      end
    end

    -- If this filename is in the ignore list, bail out
    for _, f in ipairs(ignore_files) do
      if filename == f then
        return
      end
    end

    -- Remember cursor position (before any operations!)
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- Get the filename of the current buffer
    local filename = vim.fn.expand '%:t'
    -- line the title should be inserted
    local title_line = get_title_line_number()
    local first_line = vim.fn.getline(1)

    local new_title = format_file_title(filename)
    local previouse_title = get_previous_title(title_line)

    -- ================= New file created =================
    local is_new_file = first_line == '' or first_line == nil

    if is_new_file then
      -- Insert the title at the top of the buffer
      vim.api.nvim_buf_set_lines(0, 0, 0, false, { new_title, '' })

      -- TODO: delete unnecessary lines
      -- Move the cursor to the end of the file. This will all be the 3 line
      -- because the title is a single line
      -- vim.api.nvim_win_set_cursor(0, { 3, 0 })

      -- Move the cursor to the end of the  file and Delay the strart of insert mode slightly to ensure it works
      -- vim.defer_fn(function()
      --   vim.cmd [[startinsert!]]
      -- end, 10) -- Delay of 10 milliseconds
      vim.cmd [[startinsert!]]
      vim.notify('Title of new fille created', vim.log.levels.DEBUG, { title = 'Info' })
      return
    end

    -- ================ Update file title ================
    -- The title must be the first line of the file or after the frontmatter.
    -- Other lines should not match to prevent e.g. code comments `# my comment` or
    -- normal md break lines `---` from being matched.

    -- If the title is the same as the filename, don't update it
    if previouse_title == new_title then
      vim.notify('Title is the same as the filename. No update needed.', vim.log.levels.DEBUG, { title = 'Info' })
      return
    end

    -- Update existing title
    if previouse_title ~= '' then
      -- Replace the previous title at the same line with the new title
      vim.api.nvim_buf_set_lines(0, title_line - 1, title_line, false, { new_title })
      -- restore original cursor position
      vim.api.nvim_win_set_cursor(0, cursor)
      vim.notify('Existing title updated', vim.log.levels.DEBUG, { title = 'Info' })
      return
    end

    -- ---------------- Insert title if not found ----------------
    -- insert at title_line
    vim.api.nvim_buf_set_lines(0, title_line - 1, title_line - 1, false, { new_title, '' })

    -- restore original cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
  end,
})
-- ================ END - insert file title ================
