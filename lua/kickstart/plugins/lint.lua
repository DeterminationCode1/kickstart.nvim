return {

  { -- Linting
    -- Official docs > Usage https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#usage
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    -- me: I prefer defining the linters in the options and not in the seput
    -- call. It seems cleaner and I have the suspicion that it make merging the
    -- opts here with opts for this plugin defined in other files like
    -- `languages/python.lua` easier.
    --
    -- NOTE: I prefer to define the linters for specific filetypes in a filetype
    -- specific config file like `languages/python.lua` or
    -- `languages/javascript.lua` so it's easy to see all configs for a language.

    -- WARNING: adding `opts_extend` for some reasons causes nvim-lint to break
    -- Allow extending options in other files https://github.com/folke/lazy.nvim/blob/main/CHANGELOG.md#features-19
    -- opts_extend = { 'linters_by_ft' },
    opts = {
      -- Define which linter you want for which fileformat.
      --
      -- TIP, check linters are working: comment in/out the `markdownlint`
      -- formatter. You should no longer get an error for having multiple level one
      -- headings.
      linters_by_ft = {
        css = { 'stylelint' },
        -- docker = { 'hadolint' },
        -- NOTE: I deactivated luacheck because I only use it for Neovim configs and in
        -- these files it was throwing a lot of errors like "undefined global variable vim"
        -- lua = { 'luacheck' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        zsh = { 'shellcheck' },
      },
    },
    config = function(_, opts)
      local lint = require 'lint'

      lint.linters_by_ft = opts.linters_by_ft

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require('lint').try_lint 'cspell' -- WARNING: Seems like it's causing a problem that breaks telescope and opening some buffers?
        end,
      })
    end,
  },
}
