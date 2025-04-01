-- IntelliJ
-- I changed the keymap from `gj` to `gzj` because I use `gj` on a querty layout
-- to go down to the next markdown heading.
-- TODO: adjust the markdown and this command in a way that both coexist and
-- only in markdown files the `next heading` command overwrites this command.
-- to move the cursor down.
vim.keymap.set('n', 'go', function() -- previously: gzj
  local currentFile = vim.fn.expand '%:p'
  -- local command = 'open -a "IntelliJ IDEA" ' .. currentFile -- This actually works...
  vim.system({ 'idea', currentFile }, { text = true }, function(obj)
    -- print(obj.code)
    -- print(obj.stdout)
    -- print(obj.stderr)
  end)
end, { desc = '[G]o to Intelli[J] - open current file' })
