return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,                     -- Height of the bottom terminal pane
      open_mapping = [[<C-\>]],     -- Shortcut to toggle terminal (Ctrl + \)
      direction = 'horizontal',      -- Opens at the bottom of the editor
      shade_terminals = true,        -- Darkens the terminal background slightly
      start_in_insert = true,        -- Automatically enter terminal-mode when opened
      insert_mappings = true,        -- Keeps open_mapping working in insert mode
      terminal_mappings = true,      -- Keeps open_mapping working in terminal mode
    })

    -- Helper function to map keys inside the terminal buffer
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      
      -- Press Esc to switch to Normal mode (allows scrolling and window navigation)
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
      
      -- Seamless window navigation out of the terminal window
      vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
      vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
      vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
      vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
    end

    -- Automatically apply these shortcuts only when a terminal opens
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end
}

