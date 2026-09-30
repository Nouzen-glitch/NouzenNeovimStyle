-- Loads optional files from lua/user/ (your personal layer, gitignored).
-- A missing file is fine; an error inside your file is shown, not swallowed.
local M = {}

function M.load(name)
    local ok, err = pcall(require, name)
    if ok then
        return true
    end
    if not tostring(err):find("module '" .. name .. "' not found", 1, true) then
        vim.schedule(function()
            vim.notify(name .. " error:\n" .. tostring(err), vim.log.levels.ERROR)
        end)
    end
    return false
end

return M
