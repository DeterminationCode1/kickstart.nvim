-- https://github.com/hrsh7th/nvim-cmp/issues/666#issuecomment-1000925581

-- Remove buffer source from markdown files in nvim-cmp because it made it
-- difficult to find file suggestions when hitting [[]] in markdown files.
local cmp = require 'cmp'
local sources = cmp.get_config().sources
if not sources then
  return
end

for i = #sources, 1, -1 do
  if sources[i].name == 'buffer' then
    table.remove(sources, i)
  end
end
cmp.setup.buffer { sources = sources }
