-- utils/open_in_idea.lua
local M = {}

-- naïve root finder identical to the shell version above ---------------------
local function has_marker(path)
  for _, m in ipairs { '.idea', '.git', 'pom.xml', 'build.gradle' } do
    if vim.uv.fs_stat(vim.fs.joinpath(path, m)) then
      return true
    end
  end
end

local function find_root(file)
  local dir = vim.fs.dirname(file)
  while dir and dir ~= '/' and not has_marker(dir) do
    dir = vim.fs.dirname(dir)
  end
  return dir or vim.fs.dirname(file)
end
-------------------------------------------------------------------------------

function M.open_current_in_idea()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('Current buffer has no file name', vim.log.levels.ERROR)
    return
  end

  local root = find_root(file)
  local line = vim.fn.line '.'
  local idea = 'idea' -- adjust if you renamed the launcher script

  --   <project-root> --line N <file>
  vim.system({ idea, root, '--line', tostring(line), file }, { text = true }, function(obj)
    print(obj.stdout)
    print(obj.stderr)
  end)

  vim.notify(('Opening %s:%d in IntelliJ IDEA…'):format(file, line))
end

-- -- IntelliJ
-- -- TODO: adjust the markdown and this command in a way that both coexist and
-- -- only in markdown files the `next heading` command overwrites this command.
-- -- to move the cursor down.
vim.keymap.set('n', 'go', M.open_current_in_idea, { desc = '[Go] to IntelliJ IDEA - open current file' })
