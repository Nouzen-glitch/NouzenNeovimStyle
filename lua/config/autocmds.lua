local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight the yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Reopen a file at the position where you last left it.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(args)
        if vim.bo[args.buf].filetype == "gitcommit" then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Reload files that changed on disk (git checkout, formatters, other tools).
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = group,
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Create missing parent folders when saving to a new path.
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(args)
        if args.match:match("^%w%w+:[\\/][\\/]") then
            return -- remote/URL buffers
        end
        vim.fn.mkdir(vim.fn.fnamemodify(args.file, ":p:h"), "p")
    end,
})

-- Show diagnostics as virtual text, but keep them visually restrained.
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many",
    },
})
