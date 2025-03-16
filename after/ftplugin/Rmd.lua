-- DUPLICATED in Rmd.lua, R.lua
local open_file_in_rstudio = function() -- Or: <leader>gr, <leader>mo. By default go=gg
  -- Check if the file is an Rmd or R file
  local file_extension = vim.fn.expand '%:e'
  -- NOTE:  `.r` works on some OS but is not common extension for R. use `.R` instead.
  local allowed_extensions = { 'Rmd', 'R', 'r' }
  if not vim.tbl_contains(allowed_extensions, file_extension) then
    vim.notify('Only .Rmd or .R files can be opened in RStudio', vim.log.levels.WARN)
    return
  end

  -- Get the current file path
  local current_file_path = vim.fn.expand '%:p'
  -- Open the file in RStudio
  local rstudio_command = 'open -a "RStudio" ' .. current_file_path
  vim.notify('Opening in RStudio', vim.log.levels.INFO)
  -- vim.notify('Debug: ' .. rstudio_command, vim.log.levels.INFO)
  vim.fn.system(rstudio_command)
end

vim.keymap.set('n', 'go', open_file_in_rstudio, { desc = 'Open current [R] file in R[S]tudio' })
