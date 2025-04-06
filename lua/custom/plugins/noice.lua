-- https://github.com/folke/noice.nvim
return {
  'folke/noice.nvim',
  -- event = 'VeryLazy',
  event = { 'BufReadPre' },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- 'rcarriga/nvim-notify',
  },
  -- add any options here. Will call setup with these options
  opts = {
    notify = {
      enabled = false,
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        -- ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      -- command_palette = true, -- position the cmdline and popupmenu together. Me, but also moves cmd line to top
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    -- Me: use custom routes to skip some messages. see https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages
    -- routes = {
    --   -- Deactivate nvim built-in 'file was written' message after :w
    --   {
    --     filter = {
    --       event = 'msg_show',
    --       kind = '',
    --       find = 'written',
    --     },
    --     opts = { skip = true },
    --   },
    -- },
  },
}
