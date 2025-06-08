-- ============================= Foot notes - Plugin ==========================
-- repo https://github.com/chenxin-yan/footnote.nvim
--
-- WARNING: the plugin was too aggressive for my taste. It deleted no longer
-- referenced footnotes but that caused sources to be deleted before I could
-- even reference them.
--
-- alpha version plugin written in lua for managing footnotes in markdown files.
-- Only 30 stars, but the whole plugin is one file in the `lua` folder, so I
-- could read and understand everything it does.
return {
  'chenxin-yan/footnote.nvim',
  config = function()
    require('footnote').setup {
      -- add any configuration here
      keys = {
        new_footnote = '', -- Default <C-f>. Me:  <C-d>
        organize_footnotes = '<leader>mo', -- Markdown [O]rganize footnotes
        next_footnote = '', -- Default ']f',
        prev_footnote = '', -- Default '[f',
      },
      organize_on_save = false,
      organize_on_new = false,
    }

    -- Set my own keymaps
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'footnote.nvim keymaps',
      pattern = { 'markdown' },
      callback = function()
        vim.keymap.set({ 'i' }, '<C-f>', "<cmd>lua require('footnote').new_footnote()<cr>", { desc = 'Create markdown footnote', buffer = 0 })

        -- if Opts.keys.organize_footnotes ~= '' then
        --   vim.keymap.set(
        --     'n',
        --     Opts.keys.organize_footnotes,
        --     "<cmd>lua require('footnote').organize_footnotes()<cr>",
        --     { desc = 'Organize footnote', buffer = 0 }
        --   )
        -- end
        -- if Opts.keys.next_footnote ~= '' then
        --   vim.keymap.set('n', Opts.keys.next_footnote, "<cmd>lua require('footnote').next_footnote()<cr>", { desc = 'Next footnote', buffer = 0 })
        -- end
        -- if Opts.keys.prev_footnote ~= '' then
        --   vim.keymap.set('n', Opts.keys.prev_footnote, "<cmd>lua require('footnote').prev_footnote()<cr>", { desc = 'Previous footnote', buffer = 0 })
        -- end
      end,
    })
  end,
}
