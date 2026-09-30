-- Tells the user, once, what scripts/install.sh did (backup location, how to
-- start, how to undo). The installer writes <state>/elite-install-info; the
-- first launch shows it and renames it to *.shown. `:EliteInfo` shows it again.
local M = {}

local function paths()
    local base = vim.fn.stdpath("state") .. "/elite-install-info"
    return base, base .. ".shown"
end

local function read(path)
    local info = {}
    for _, line in ipairs(vim.fn.readfile(path)) do
        local key, value = line:match("^(%w+)=(.*)$")
        if key then
            info[key] = value
        end
    end
    return info
end

local function message(info)
    local lines = { "Elite Neovim was installed (" .. (info.mode or "unknown") .. " mode)." }

    if info.backup and info.backup ~= "" then
        table.insert(lines, "Your previous config was moved to:")
        table.insert(lines, "  " .. info.backup)
    elseif info.mode == "alongside" then
        table.insert(lines, "Your existing Neovim config was not touched.")
    end

    if info.launcher and info.launcher ~= "" then
        table.insert(lines, "Start this config with: " .. vim.fs.basename(info.launcher))
    end
    if info.source and info.source ~= "" then
        table.insert(lines, "Undo: " .. info.source .. "/scripts/uninstall.sh")
    end
    table.insert(lines, "See this again with :EliteInfo. Check your setup with :checkhealth elite")

    return table.concat(lines, "\n")
end

function M.setup()
    local fresh, shown = paths()

    vim.api.nvim_create_user_command("EliteInfo", function()
        local path = (vim.fn.filereadable(fresh) == 1 and fresh)
            or (vim.fn.filereadable(shown) == 1 and shown)
            or nil
        if not path then
            vim.notify("No install record found (this config was not set up by scripts/install.sh).")
            return
        end
        vim.notify(message(read(path)))
    end, { desc = "Show how Elite Neovim was installed" })

    if vim.fn.filereadable(fresh) == 0 then
        return
    end

    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            vim.schedule(function()
                local ok, info = pcall(read, fresh)
                if not ok then
                    return
                end
                vim.notify(message(info), vim.log.levels.WARN)
                vim.uv.fs_rename(fresh, shown)
            end)
        end,
    })
end

return M
