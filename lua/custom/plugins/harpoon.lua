return {
  'theprimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = '[A]dd current file to harpoon' })
    -- default: c-e (dvorak lm2)
    vim.keymap.set('n', '<C-s>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle harpoon quick menu' })

    -- primegan default: dvorak right homerow: htns
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(1)
    end, { desc = 'Go to harpoon file 1' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon:list():select(2)
    end, { desc = 'Go to harpoon file 2' })
    vim.keymap.set('n', '<C-y>', function()
      harpoon:list():select(3)
    end, { desc = 'Go to harpoon file 3' })
    vim.keymap.set('n', "<C-'>", function()
      harpoon:list():select(4)
    end, { desc = 'Go to harpoon file 4' })

    -- toggle previous & next buffers stored within harpoon list
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end, { desc = 'toggle previous & next buffers stored within harpoon list' })

    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end, { desc = 'toggle previous & next buffers stored within harpoon list' })
    -- terminl naviation.
    -- primegan doesn't seem to use harpoons terminal nav capabilities himself but just uses the default tmux keybindings.
    -- he has nvim always on 1 and a new terminal always on 2 (he said this in this video min 2: 'https://www.youtube.com/watch?v=-ybcihpwkna&t=2980.
    -- that he usese the default tmux bindings can be seen in this video https://youtu.be/-ybcihpwkna?si=uzt_gpnbnkvh6rne):
    -- - prefix c creat new terminal
    -- - prefix 2 go to terminal
    -- - prefix 1 go back to nvim.
    -- WARN: I prefer toggleterm to quickly open a terminal because it's automatically in the right directory and has first-class vim motions integrated.
    -- vim.keymap.set('n', '<C-t>', '<cmd>!tmux-harpoon-toggle<CR>', { desc = 'Toggle between tmux window 1 and 2' })
  end,
}
