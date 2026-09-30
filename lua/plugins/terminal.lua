return {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- These are plain `opts`, so you can change them from lua/user/plugins/
    -- without editing this file, e.g. to rebind the toggle key:
    --   { "akinsho/toggleterm.nvim", opts = { open_mapping = [[<C-t>]] } }
    opts = {
        size = 15,                 -- Height of the bottom terminal pane
        open_mapping = [[<C-\>]],  -- Toggle terminal (Ctrl + \)
        direction = "horizontal",  -- Opens at the bottom of the editor
        shade_terminals = true,    -- Darkens the terminal background slightly
        start_in_insert = true,    -- Enter terminal mode when opened
        insert_mappings = true,    -- Keep open_mapping working in insert mode
        terminal_mappings = true,  -- Keep open_mapping working in terminal mode
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        -- Keys that only exist inside terminal buffers.
        vim.api.nvim_create_autocmd("TermOpen", {
            group = vim.api.nvim_create_augroup("EliteTerminal", { clear = true }),
            pattern = "term://*",
            callback = function(args)
                local o = { buffer = args.buf }
                -- Esc switches to Normal mode (scroll, search, window navigation).
                vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], o)
                -- Move out of the terminal window.
                vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], o)
                vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], o)
                vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], o)
                vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], o)
            end,
        })
    end,
}
