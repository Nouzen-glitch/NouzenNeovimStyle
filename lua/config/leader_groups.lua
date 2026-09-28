local M = {}

M.groups = {
    { key = "f", label = "Find" },
    { key = "w", label = "Windows" },
    { key = "x", label = "Diagnostics" },
    { key = "h", label = "Git Hunks" },
    { key = "b", label = "Buffers" },
    { key = "e", label = "Explorer" },
    { key = "c", label = "Code / LSP" },
    { key = "d", label = "Diagnostic Details" },
    { key = "i", label = "Inlay Hints" },
    { key = "r", label = "Rename" },
}

function M.which_key_spec()
    local spec = {
        { "<leader>?", desc = "Show all keybindings" },
    }

    for _, group in ipairs(M.groups) do
        table.insert(spec, {
            "<leader>" .. group.key,
            group = group.label,
        })
    end

    return spec
end

return M
