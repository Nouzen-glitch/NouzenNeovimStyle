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

        -- Keys that only exist inside toggleterm buffers. Other terminals
        -- (:terminal running lazygit, fzf, vim...) keep every key for the program.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("EliteTerminal", { clear = true }),
            pattern = "toggleterm",
            callback = function(args)
                local function t(lhs, rhs, desc)
                    vim.keymap.set("t", lhs, rhs, { buffer = args.buf, desc = desc })
                end
                -- Esc and jk switch to Normal mode (scroll, search, window navigation).
                t("jk", [[<C-\><C-n>]], "Terminal: back to Normal mode")
                t("<Esc>", [[<C-\><C-n>]], "Terminal: back to Normal mode")
                -- Move out of the terminal window.
                t("<C-h>", [[<C-\><C-n><C-w>h]], "Terminal: focus left window")
                t("<C-j>", [[<C-\><C-n><C-w>j]], "Terminal: focus lower window")
                t("<C-k>", [[<C-\><C-n><C-w>k]], "Terminal: focus upper window")
                t("<C-l>", [[<C-\><C-n><C-w>l]], "Terminal: focus right window")
            end,
        })
    end,
}
