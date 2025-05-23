-- to create a lua module. simply return a lua table from this file. A lua table is defined using `x={ }`.
return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",ob
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
    -- see below for full list of optional dependencies 👇
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter',
    'hrsh7th/nvim-cmp',
  },
  config = function(_, opts)
    require('obsidian').setup(opts)

    -- My keybindings
    -- Think of the prefix as '[G]o to [O]bsidian'
    vim.keymap.set('n', 'go', '', { desc = 'Obsidian: [G]o to [O]bsidian' }) -- for which-key
    vim.keymap.set({ 'n', 'v' }, 'goe', ":'<,'>ObsidianExtractNote<CR>", { desc = 'Obsidian: [E]xtract highlighted text to a new note and link to it' })
    -- Open note in obsidian
    vim.keymap.set('n', 'goo', '<cmd>ObsidianOpen<CR>', { desc = 'Obsidian: [O]pen the current note in Obsidian' })
    -- Paste image from clipboard
    vim.keymap.set('n', 'gop', '<cmd>ObsidianPasteImg<CR>', { desc = 'Obsidian: [P]aste an image from the clipboard' })
  end,
  opts = {
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = {
      {
        name = 'Knowledge Wiki',
        path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Knowledge_Wiki/',
      },
      -- {
      --   name = "personal",
      --   path = "~/vaults/personal",
      -- },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      --   -- Optional, override certain settings.
      --   overrides = {
      --     notes_subdir = "notes",
      --   },
      -- },
    },

    -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
    -- 'workspaces'. For example:
    -- dir = "~/vaults/work",

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    -- NOTE: seems like `notes_subdir` ONLY accepts relative paths to the workspace.
    -- notes_subdir = './notes',

    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*".
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'notes/dailies',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    -- ME BE AWARE: these mappings are only set in obsidian vaults so you can override some of your coding specific mappings
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ['<cr>'] = {
        action = function()
          -- WARN: Originally this used util.smart_action() but hitting enter accidentally created new checkboxes which was annoying.
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { buffer = true, expr = true },
      },
      -- NOTE: My personal mappings. WARN: not working besides space o. besides space o.
      -- Open the current note in the browser
      -- ['<leader>o'] = {
      --   action = '<cmd>ObsidianOpen<CR>',
      --   opts = { buffer = true },
      -- },
      -- -- Extract the highlighted text to a new note
      -- ['<leader>e'] = {
      --   action = '<CMD>ObsidianExtractNote<CR>',
      --   opts = { buffer = true },
      -- },
      -- -- Paste an image from the clipboard
      -- ['<leader>p'] = {
      --   action = '<CMD>ObsidianPasteImg<CR>',
      --   opts = { buffer = true },
      -- },
    },

    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = 'notes_subdir',

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        -- suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()

        -- NOTE: ME: don't like - instead of space. makes .md more verbose as you need to use [[a-b-c-d|a b c d]] embedds and less natural language
        -- I also don't like the prefix as in a wiki no title should exist twice: e.g. 142-Python 4412-Python. Maybe in a pure Zettelkasten it would make sense?
        -- ME: allowed chars in title
        -- -- It would be convinient to use special chars like `Git & Github` vs `Git and Github`. But different operating systems might not allow & in file names
        -- -- For long term bullet proof file names, it's a good idea to not allow special chars.
        -- -- The only char I will use is the `space` as it significiantly improves usabiliyt in less md verbosidty and appearance in graph view
        -- -- Also you can always use `fd` or other shell tools to quickly replace all `spaces` in the all files names with a `-`.
        suffix = title:gsub('[^A-Za-z0-9- ]', '') -- :lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      -- NOTE: I didn't like the timestamp prefix for my wiki notes. For a pure Zettelkasten it might be good?
      -- return tostring(os.time()) .. '-' .. suffix
      return suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,

    -- Optional, customize how wiki links are formatted. You can set this to one of:
    --  * "use_alias_only", e.g. '[[Foo Bar]]'
    --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
    --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    --  * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    -- wiki_link_func = function(opts)
    --   -- DEFAULT recommendation:
    --   -- return require('obsidian.util').wiki_link_id_prefix(opts)
    --
    --   -- ME:
    --   -- return require('obsidian.util').wiki_link_alias_only(opts)
    --   return require('obsidian.util').wiki_link_note_path(opts)
    -- end,
    -- prepend_note_id: This is Obsidian's default behaviour. E.g. [[propositional logic - DS|aussagenlogik]]
    wiki_link_func = 'prepend_note_id',

    -- Optional, customize how markdown links are formatted.
    markdown_link_func = function(opts)
      return require('obsidian.util').markdown_link(opts)
    end,

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = 'wiki',

    -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
    ---@return string
    image_name_func = function()
      -- Prefix image names with timestamp.
      return string.format('%s', os.time()) -- Me, defaults to timestamp '%s-'
    end,

    -- Optional, boolean or a function that takes a filename and returns a boolean.
    -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = true, -- Defaults to false.

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Me: Because I use natural language titles without aliases or character best practices, adding the alias as title would just duplicate it.
      -- Me: In the future if you decide to use more human unfriendly file names, this might be useful again.
      -- Default: Add the title of the note as an alias.
      -- if note.title then
      --   note:add_alias(note.title)
      -- end
      -- TODO: find a way to automatically sync the note file name with the first heading in the note.
      -- But it should only be one way from file name to heading and not the other way around (safety reasons)

      -- local out = { id = note.id, aliases = note.aliases, tags = note.tags } -- Me: default
      local out = {}
      -- Me: add aliases, tags if they exist
      -- TODO: maybe the two if statements could be done in the note.metadata loop?
      if note.aliases ~= nil and not vim.tbl_isempty(note.aliases) then
        out.aliases = note.aliases
      end
      if note.tags ~= nil and not vim.tbl_isempty(note.tags) then
        out.tags = note.tags
      end

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Optional, for templates (see below).
    templates = {
      folder = 'templates', -- Old location: 'Assets/templates'
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart { 'open', url } -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = true, -- Defaults to false.

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = 'telescope.nvim',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
    },

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
    sort_by = 'modified',
    sort_reversed = true,

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
    -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
    open_notes_in = 'current',

    -- Optional, define your own callbacks to further customize behavior.
    -- NOTE: Me: Tip: read through the `obsidian.nvim/lua/obsidian/client.lua` file to see all the available callbacks.
    -- You can find it by hitting `gf` on `obsidian.Client` in the statement below.
    -- WARNING: Me: You cannot use note.contents = ... to update the note contents - it's read
    -- only (i think, or maybe you could call a commit method on the note somehow?).
    -- Use the `update_content` option in `client:write_note` instead.
    callbacks = {
      -- Runs at the end of `require("obsidian").setup()`.
      ---@param client obsidian.Client
      post_setup = function(client) end,

      -- Runs anytime you enter the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      enter_note = function(client, note)
        -- FIX: important: than solution for automating the heading sync is the method `note:save_to_buffer()`
        -- It uses the nvim lua api to inject new lines into the buffer after the frontmatter. You don't need the obsidian.nvim functions.
        -- TODO:implement the fix above.
        -- TODO: find a way to automatically sync the note file name with the first heading in the note.
        -- But it should only be one way from file name to heading and not the other way around (safety reasons)

        -- if note == nil then
        --   return
        -- end
        -- -- If it's not a markdown file, don't do anything.
        -- if not note.path.filename:match '%.md$' then
        --   return
        -- end

        -- WARNING: old bad not working solution
        -- @param lines table: A table of strings representing the lines of the note (excluding frontmatter).
        -- @return table: A table of strings representing the updated contents of the note.
        -- local update_content_func = function(lines)
        --   local updated_contents = lines or {}
        --   if updated_contents == nil then
        --     return {}
        --   end
        --   -- if the first line is a heading, update it
        --   -- else inject a new heading with the note title
        --   if updated_contents[1]:match '^#' then
        --     updated_contents[1] = '# ' .. note.id
        --   else
        --     table.insert(updated_contents, 1, '# ' .. note.id)
        --   end
        --   return updated_contents
        -- end

        -- Commit changes to disk.
        -- client:write_note_to_buffer(note)
        -- client:write_note(note, { update_content = update_content_func })
        -- Reopen the same note in the buffer. This will load the new disk changes.
        -- client:open_note(note)
      end,

      -- Runs anytime you leave the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      leave_note = function(client, note) end,

      -- Runs right before writing the buffer for a note.
      ---@param client obsidian.Client
      ---@param note obsidian.Note
      pre_write_note = function(client, note) end,

      -- Runs anytime the workspace is set/changed.
      ---@param client obsidian.Client
      ---@param workspace obsidian.Workspace
      post_set_workspace = function(client, workspace) end,
    },

    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      -- Me: disable UI of obsidian.nvim so markview.nvim can take over
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = '•', hl_group = 'ObsidianBullet' },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      block_ids = { hl_group = 'ObsidianBlockID' },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianBullet = { bold = true, fg = '#89ddff' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianBlockID = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },

    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = 'assets', -- This is the default
      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        -- Me: added space before img because the formatter automatically removes the previous space,
        path = client:vault_relative_path(path) or path
        return string.format(' ![%s|600](%s)', path.name, path)
      end,
    },
  },
}
