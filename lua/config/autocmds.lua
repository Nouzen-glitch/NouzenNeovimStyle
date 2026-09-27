local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight the yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank()
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
