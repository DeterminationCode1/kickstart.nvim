-- LazyVim https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/formatting.lua
-- kickstart https://github.com/dam9000/kickstart-modular.nvim/blob/master/lua/kickstart/plugins/conform.lua

-- Autoformat
return {
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    lazy = true,
    -- NOTES: The "<leader>f" keybinding for formatting was removed because I use "format on save"
    -- instead and <leader>f is a valuable well positioned keybinding that's now used for 'search files' in telescope.
    -- keys = {
    --   {
    --     '<leader>f',
    --     function()
    --       require('conform').format { async = true, lsp_fallback = true }
    --     end,
    --     mode = '',
    --     desc = '[F]ormat buffer',
    --   },
    -- },

    -- WARNING: adding `opts_extend` for some reasons causes confirm.nvim to break
    -- allow extending options in other files https://github.com/folke/lazy.nvim/blob/main/CHANGELOG.md#features-19
    -- opts_extend = { 'formatters_by_ft', 'formatters' },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        timeout_ms = 3000, -- defaults to 500ms
        async = false, -- not recommended to change
        lsp_format = 'fallback', -- not recommended to change
      },
      -- IMPORTANT: you must add the `format_on_save` option to turn on
      -- automatic formatting on save. Defaults to `nil`.
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        -- local disable_filetypes = { c = true, cpp = true }
        local disable_filetypes = {} -- I want to format my C code
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 3000, -- kickstart default is 500ms
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { 'isort', 'black', 'flake8', 'mypy' }, -- NOTE: moved to language/python.lua
        css = { 'prettierd' },
        -- json = { 'prettierd' },
        -- jsonc = { 'prettierd' },
        yaml = { 'prettierd' },
        -- markdown = { 'prettierd' },
        -- c = { 'clang-format' },
        -- cpp = { 'clang-format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        -- ocaml = { 'ocamlformat' }, -- OCaml uses .ml extension

        -- Use the "*" filetype to run formatters on all filetypes.
        -- ['*'] = { 'codespell' }, -- FIX: Not working, causing error.FIX: Not working, causing error.
      },
      formatters = {
        -- This is a way of globally overwitting prettier config rules. It will be applied in all of your projects where prettier is used.
        -- This might be concidered bad practic as different projects often have different style conventions and you should use a loacal
        -- `.prettierrc` file - which is picked yp by conform.nvim
        -- see reddit https://www.reddit.com/r/neovim/comments/19baed2/lazyvim_conform_prettier_configuration_not_working/
        prettier = {
          prepend_args = { '--single-quote', '--print-width 70' },
        },
      },
    },
  },
}
