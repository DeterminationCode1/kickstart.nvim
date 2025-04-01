return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
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
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500, -- defaults to 500ms
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black', 'flake8', 'mypy' },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        ocaml = { 'ocamlformat' }, -- OCaml uses .ml extension

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
