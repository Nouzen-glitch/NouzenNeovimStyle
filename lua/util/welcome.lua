-- Tells the user, once, what scripts/install.sh did (backup location, how to
-- start, how to undo). The installer writes <state>/elite-install-info; the
-- first launch shows it in a centered window and renames the file to *.shown.
-- `:EliteInfo` shows it again.
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
    local lines = { "Elite Neovim was installed (" .. (info.mode or "unknown") .. " mode).", "" }

    if info.backup and info.backup ~= "" then
        table.insert(lines, "Your previous config was moved to:")
        table.insert(lines, "  " .. info.backup)
    elseif info.mode == "alongside" then
        table.insert(lines, "Your existing Neovim config was not touched.")
    else
        table.insert(lines, "Nothing needed backing up.")
    end

    if info.launcher and info.launcher ~= "" then
        table.insert(lines, "")
        table.insert(lines, "Start this config with: " .. vim.fs.basename(info.launcher))
    end
    if info.source and info.source ~= "" then
        table.insert(lines, "")
        table.insert(lines, "Undo:   " .. info.source .. "/scripts/uninstall.sh")
        table.insert(lines, "Update: " .. info.source .. "/scripts/update.sh")
    end
    table.insert(lines, "")
    table.insert(lines, "Show this again: :EliteInfo     Check your setup: :checkhealth elite")

    return lines
end

-- A centered window that sits above other floats (such as lazy.nvim's installer
-- on the very first launch), so it cannot be missed. Close with q, <Esc> or <CR>.
local function show(lines)
    local max_width = math.max(20, vim.o.columns - 8)
    local width = 0
    for _, l in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(l))
    end
    width = math.min(width + 2, max_width)

    local height = 0
    for _, l in ipairs(lines) do
        height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(l) / width))
    end
    height = math.min(height, math.max(1, vim.o.lines - 6))

    local prev = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = "wipe"

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
        col = math.max(0, math.floor((vim.o.columns - width) / 2)),
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = " Elite Neovim ",
        title_pos = "center",
        footer = " q / <Esc> / <CR> to close ",
        footer_pos = "center",
        zindex = 250,
    })
    vim.wo[win].wrap = true

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_win_is_valid(prev) then
            vim.api.nvim_set_current_win(prev)
        end
    end
    for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
        vim.keymap.set("n", key, close, { buffer = buf, nowait = true, desc = "Close" })
    end
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
        show(message(read(path)))
    end, { desc = "Show how Elite Neovim was installed" })

    if vim.fn.filereadable(fresh) == 0 then
        return
    end

    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
            -- Delay a moment so it lands after lazy.nvim's first-run UI opens.
            vim.defer_fn(function()
                local ok, info = pcall(read, fresh)
                if not ok then
                    return
                end
                show(message(info))
                vim.uv.fs_rename(fresh, shown)
            end, 300)
        end,
    })
end

return M
