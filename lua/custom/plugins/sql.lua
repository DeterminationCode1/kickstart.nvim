-- TJ DeVries: https://www.youtube.com/watch?v=ALGBuFLzDSA
-- DevOps video https://www.youtube.com/watch?v=NhTPVXP8n7w&t=404s
-- repo dadbod-ui: https://github.com/kristijanhusak/vim-dadbod-ui
--
-- Usage
-- see :h dadbod-ui.txt
--
-- :DBUIAddConnection
--    To add a new connection use :DBUIAddConnection or hit enter on the connection word or hit 'A'
--    Now, add a connection string in the format of your DB provider
--    E.g. in a Django project using Postgresql you can find the connection detalis in the .env file:
--    url format: postgres://POSTGRES_USER:POSTGRES_PASSWORD@POSTGRES_HOST:POSTGRES_PORT/POSTGRES_DB
--    connect url: postgres://myuser:mysecretpassword@localhost:5434/dockerdc
--    - E.g. SQLite:
--    url format: sqlite://path/to/your/database.db
--    connect url (for key analysis db): :
--    TODO: you might be able to construct the url in the .env file and store it in DAD_UI_URL env var that
--    is automatically picked up by dadbod-ui?
--
-- Save SQL qurey
--    Hit '<leader>W' to save the current query to a file
--
-- Autocmopletion
--    if you added 'nivm-dadbod-completion' to your sql file type nvim-cmp settings, you should get attribute and table name completions
--    Furthermore, if you add lua-friendly snippets to cmp sources you will get sql snippets as well
--    E.g. use the following format to get attribute completions: `select u.id, u.email from users u`
--    FIX: currently the autocompletion for table_names also suggest non-tables. Not sure if this is wanted?
return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'kristijanhusak/vim-dadbod-completion', lazy = true },
    { 'tpope/vim-dadbod', lazy = true },
  },
  lazy = true,
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1 -- NOTE: this is VERY nice to have on. Defaults to 0
    vim.g.db_ui_win_position = 'left' -- defaults to 'left'
    vim.g.db_ui_winwidth = 40 -- defaults to 40

    vim.keymap.set('n', '<leader>tq', '<cmd>DBUIToggle<CR>', { noremap = true, silent = true, desc = 'Toggle DBUI (for SQL)' })
  end,
}
