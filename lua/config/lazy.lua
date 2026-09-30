-- Bootstrap lazy.nvim using its documented stable branch.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "--branch=stable", lazyrepo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        return
    end
end

vim.opt.rtp:prepend(lazypath)

-- Your personal plugins live in lua/user/plugins/ (gitignored). lazy.nvim prints
-- an error when an imported folder has no specs, so only import it once it
-- contains a plugin file.
local spec = { { import = "plugins" } }
local user_plugins = vim.fn.stdpath("config") .. "/lua/user/plugins"
if #vim.fn.glob(user_plugins .. "/**/*.lua", false, true) > 0 then
    table.insert(spec, { import = "user.plugins" })
end

require("lazy").setup({
    -- Personal copy by default; see util/lockfile.lua.
    lockfile = require("util.lockfile").path(),
    spec = spec,
    rocks = { enabled = false },
    -- Check for plugin updates quietly; run :Lazy to see them.
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
    install = {
        colorscheme = { "tokyonight" },
    },
})
