-- Opt-in "extras": heavier features that are off by default.
--
-- Enable them in lua/user/options.lua (read before lazy.nvim starts):
--   vim.g.elite_extras = { "sessions", "dashboard" }
--
-- Each extra is described in M.registry:
--   desc     one line for :EliteExtras
--   plugins  true if lua/extras/<name>.lua exists (a lazy.nvim spec, imported
--            by config/lazy.lua only when the extra is enabled)
--   groups   <leader> prefixes it adds (feeds which-key and the cheatsheet)
--   keys     function(map) defining its shipped keys. Called while
--            config.keymaps loads, so util/keyguard sees them
--   setup    optional function run once at startup (commands)
--   health   optional function(ctx) for :checkhealth elite
-- Nothing here loads a plugin; disabled extras cost nothing.
local M = {}

local function has(name)
    return vim.fn.executable(name) == 1
end

M.order = { "sessions", "dashboard", "docker", "database", "rest", "dap" }

M.registry = {
    sessions = {
        desc = "Restore the files and splits you had open in a folder (persistence.nvim)",
        plugins = true,
        groups = { { key = "s", label = "Session" } },
        keys = function(map)
            map("n", "<leader>ss", function() require("persistence").load() end, { desc = "Restore session for this folder" })
            map("n", "<leader>sl", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
            map("n", "<leader>sd", function() require("persistence").stop() end, { desc = "Do not save this session" })
        end,
    },

    dashboard = {
        desc = "Start screen with recent files and shortcuts (alpha-nvim)",
        plugins = true,
    },

    docker = {
        desc = "lazydocker in a floating terminal (no plugin; needs docker and lazydocker)",
        plugins = false,
        parsers = { "dockerfile" },
        groups = { { key = "k", label = "Clients" } },
        keys = function(map)
            map("n", "<leader>kk", function() M.tui("lazydocker") end, { desc = "Docker (lazydocker)" })
        end,
        health = function(c)
            c.check_tool("docker", c.h.warn, "Needed by the docker extra.")
            c.check_tool("lazydocker", c.h.warn, "The docker extra opens it. Install: https://github.com/jesseduffield/lazydocker")
        end,
    },

    database = {
        desc = "Database UI and SQL completion (vim-dadbod, vim-dadbod-ui)",
        plugins = true,
        parsers = { "sql" },
        groups = { { key = "k", label = "Clients" } },
        keys = function(map)
            map("n", "<leader>kd", "<cmd>DBUIToggle<cr>", { desc = "Database UI" })
        end,
        health = function(c)
            for _, tool in ipairs({ "psql", "mysql", "sqlite3" }) do
                if has(tool) then
                    c.h.ok(tool .. " found")
                end
            end
            c.h.info("vim-dadbod needs the CLI client of each database you connect to (psql, mysql, sqlite3, ...).")
        end,
    },

    rest = {
        desc = "Run requests from .http files with curl (built in, no plugin)",
        plugins = false,
        parsers = { "http" },
        groups = { { key = "k", label = "Clients" } },
        keys = function(map)
            map("n", "<leader>kr", function() require("util.rest").run() end, { desc = "Run HTTP request under cursor" })
        end,
        setup = function()
            vim.api.nvim_create_user_command("EliteRest", function()
                require("util.rest").run()
            end, { desc = "Run the HTTP request under the cursor (.http file)" })
        end,
        health = function(c)
            c.check_tool("curl", c.h.warn, "The rest extra sends requests with curl.")
        end,
    },

    dap = {
        desc = "Debugging: breakpoints, stepping, variables UI (nvim-dap, nvim-dap-ui)",
        plugins = true,
        groups = { { key = "t", label = "Debug" } },
        keys = function(map)
            local function dap() return require("dap") end
            map("n", "<leader>tb", function() dap().toggle_breakpoint() end, { desc = "Toggle breakpoint" })
            map("n", "<leader>tc", function() dap().continue() end, { desc = "Debug: start / continue" })
            map("n", "<leader>tu", function() require("dapui").toggle() end, { desc = "Toggle debug UI" })
            map("n", "<leader>tx", function() dap().terminate() end, { desc = "Debug: stop" })
            map("n", "<F5>", function() dap().continue() end, { desc = "Debug: start / continue" })
            map("n", "<F9>", function() dap().toggle_breakpoint() end, { desc = "Toggle breakpoint" })
            map("n", "<F10>", function() dap().step_over() end, { desc = "Debug: step over" })
            map("n", "<F11>", function() dap().step_into() end, { desc = "Debug: step into" })
            map("n", "<S-F11>", function() dap().step_out() end, { desc = "Debug: step out" })
        end,
        health = function(c)
            c.check_tool("python3", c.h.warn, "debugpy (Python debugging) is installed with Python 3 and venv.")
            c.check_tool("node", c.h.warn, "js-debug-adapter (JavaScript/TypeScript debugging) needs Node.js.")
            c.h.info("Adapters (debugpy, codelldb, js-debug-adapter) are installed by Mason; see :Mason.")
        end,
    },
}

-- Names from vim.g.elite_extras: { valid names in the order given }, { unknown names }.
function M.requested()
    local want = vim.g.elite_extras
    if type(want) == "string" then
        want = { want }
    end
    local ok, bad, seen = {}, {}, {}
    if type(want) ~= "table" then
        return ok, bad
    end
    for _, name in ipairs(want) do
        if not seen[name] then
            seen[name] = true
            table.insert(M.registry[name] and ok or bad, tostring(name))
        end
    end
    return ok, bad
end

function M.enabled()
    return (M.requested())
end

function M.is_enabled(name)
    return vim.tbl_contains(M.enabled(), name)
end

-- Leader groups of the enabled extras, one entry per key.
function M.groups()
    local out, seen = {}, {}
    for _, name in ipairs(M.enabled()) do
        for _, g in ipairs(M.registry[name].groups or {}) do
            if not seen[g.key] then
                seen[g.key] = true
                table.insert(out, vim.deepcopy(g))
            end
        end
    end
    return out
end

-- Shipped keys of the enabled extras. Called from init.lua inside
-- keyguard.track_shipped, so a user key on the same lhs is reported.
function M.keymaps()
    for _, name in ipairs(M.enabled()) do
        local keys = M.registry[name].keys
        if keys then
            keys(vim.keymap.set)
        end
    end
end

function M.setup()
    for _, name in ipairs(M.enabled()) do
        local fn = M.registry[name].setup
        if fn then
            fn()
        end
    end
end

function M.warn_unknown()
    local _, bad = M.requested()
    if #bad > 0 then
        vim.schedule(function()
            vim.notify(
                "vim.g.elite_extras: unknown extra(s): " .. table.concat(bad, ", ")
                    .. ". Available: " .. table.concat(M.order, ", ") .. " (see :EliteExtras).",
                vim.log.levels.WARN
            )
        end)
    end
end

function M.lines()
    local on = {}
    for _, name in ipairs(M.enabled()) do
        on[name] = true
    end
    local lines = {
        "EXTRAS: opt-in features, all off by default",
        "",
        "Enable them in lua/user/options.lua (:EliteEdit options), then restart:",
        '  vim.g.elite_extras = { "sessions", "dashboard" }',
        "",
    }
    for _, name in ipairs(M.order) do
        lines[#lines + 1] = string.format("  [%s] %-10s %s", on[name] and "x" or " ", name, M.registry[name].desc)
    end
    local _, bad = M.requested()
    if #bad > 0 then
        lines[#lines + 1] = ""
        lines[#lines + 1] = "Unknown names in vim.g.elite_extras: " .. table.concat(bad, ", ")
    end
    vim.list_extend(lines, { "", "Keys, prerequisites and details: docs/EXTRAS.md. Check tools: :checkhealth elite" })
    return lines
end

-- Runs a terminal program (lazydocker, ...) in a floating toggleterm terminal.
-- Hidden, so it stays out of <C-\> and :TermSelect; toggleterm's Terminal-mode
-- key overrides (jk, <Esc>, <C-h/j/k/l>) are removed so the program keeps them.
local tuis = {}
function M.tui(cmd)
    if not has(cmd) then
        vim.notify(cmd .. " was not found in your PATH. Install it first (:checkhealth elite).", vim.log.levels.WARN)
        return
    end
    local term = tuis[cmd]
    if not term then
        local Terminal = require("toggleterm.terminal").Terminal
        term = Terminal:new({
            cmd = cmd,
            direction = "float",
            hidden = true,
            close_on_exit = true,
            on_open = function(t)
                for _, lhs in ipairs({ "jk", "<Esc>", "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
                    pcall(vim.keymap.del, "t", lhs, { buffer = t.bufnr })
                end
                vim.cmd("startinsert")
            end,
            on_exit = function()
                tuis[cmd] = nil
            end,
        })
        tuis[cmd] = term
    end
    term:toggle()
end

return M
