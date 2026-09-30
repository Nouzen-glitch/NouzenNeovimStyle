-- :checkhealth elite
local M = {}
local h = vim.health

local function has(name)
    return vim.fn.executable(name) == 1
end

local function check_tool(name, level, advice)
    if has(name) then
        h.ok(name .. " found")
    else
        level(name .. " not found", advice)
    end
end

function M.check()
    h.start("Elite: Neovim")
    local v = vim.version()
    local vs = string.format("%d.%d.%d", v.major, v.minor, v.patch)
    if vim.version.ge(v, { 0, 11, 0 }) then
        h.ok("Neovim " .. vs)
    else
        h.error("Neovim " .. vs .. " is too old", "This config needs Neovim 0.11 or newer.")
    end

    h.start("Elite: install")
    local cfg = vim.fn.stdpath("config")
    local app = vim.env.NVIM_APPNAME
    h.info("Config folder: " .. cfg)
    h.info("App name: " .. ((app and app ~= "") and app or "nvim (default)"))
    local stat = vim.uv.fs_lstat(cfg)
    if stat and stat.type == "link" then
        h.ok("Config is a symlink to " .. (vim.uv.fs_readlink(cfg) or "?"))
    elseif stat then
        h.info("Config is a regular folder (fine if you cloned straight into it)")
    else
        h.error("Config folder not found")
    end
    h.info("Run :EliteInfo to see how it was installed and where any backup went")

    h.start("Elite: required tools")
    check_tool("git", h.error, "Needed by lazy.nvim to install plugins.")
    check_tool("make", h.warn, "Needed to build telescope-fzf-native and LuaSnip's jsregexp.")
    if has("cc") or has("gcc") or has("clang") then
        h.ok("C compiler found")
    else
        h.warn("No C compiler found", "Install gcc or clang: needed for Tree-sitter parsers and fzf-native.")
    end
    check_tool("rg", h.warn, "Install ripgrep: needed for <leader>fg (live grep).")
    check_tool("curl", h.warn, "Needed by Mason.")
    check_tool("unzip", h.warn, "Needed by Mason.")

    h.start("Elite: language server toolchains (Mason)")
    check_tool("node", h.warn, "Needed for ts_ls, prettier and other npm-based tools.")
    check_tool("npm", h.warn, "Needed for ts_ls, prettier and other npm-based tools.")
    check_tool("python3", h.warn, "Needed for basedpyright and ruff.")
    if has("go") then
        h.ok("go found")
    else
        h.info("go not found (only needed if you add Go tools such as gopls)")
    end

    h.start("Elite: appearance")
    h.info("A Nerd Font cannot be detected from inside Neovim. If icons show as boxes,")
    h.info("set a Nerd Font as your terminal's font.")

    h.start("Elite: your personal layer (lua/user/)")
    local root = cfg .. "/lua/user"
    local any = false
    for _, f in ipairs({ "options.lua", "keymaps.lua" }) do
        if vim.uv.fs_stat(root .. "/" .. f) then
            h.ok("user/" .. f .. " present")
            any = true
        end
    end
    local plugins = vim.fn.glob(root .. "/plugins/*.lua", false, true)
    if #plugins > 0 then
        h.ok(#plugins .. " user plugin file(s)")
        any = true
    end
    if vim.uv.fs_stat(cfg .. "/lua/config/languages_local.lua") then
        h.ok("config/languages_local.lua present")
        any = true
    end
    if not any then
        h.info("Nothing here yet. See docs/MIGRATING.md and the *.example files in lua/user/")
    end
end

return M
