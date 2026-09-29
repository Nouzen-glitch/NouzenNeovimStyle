-- Builds the LSP / parser / formatter / tool lists from config.languages
-- (plus the optional config.languages_local). Used by plugins/lsp.lua,
-- treesitter.lua and formatting.lua.
local M = {}

local function as_list(value)
    if value == nil then
        return {}
    elseif type(value) == "table" then
        return value
    end
    return { value }
end

local function load()
    local langs = vim.deepcopy(require("config.languages"))

    local ok, extra = pcall(require, "config.languages_local")
    if ok then
        if type(extra) == "table" then
            for ft, cfg in pairs(extra) do
                langs[ft] = cfg or nil -- `false` removes a default
            end
        end
    elseif not tostring(extra):find("module 'config.languages_local' not found", 1, true) then
        vim.schedule(function()
            vim.notify("languages_local.lua error:\n" .. tostring(extra), vim.log.levels.ERROR)
        end)
    end

    return langs
end

local function collect(field)
    local items = {}
    for _, cfg in pairs(load()) do
        vim.list_extend(items, as_list(cfg[field]))
    end
    table.sort(items)

    local seen, out = {}, {}
    for _, item in ipairs(items) do
        if not seen[item] then
            seen[item] = true
            table.insert(out, item)
        end
    end
    return out
end

function M.servers() return collect("lsp") end
function M.parsers() return collect("parser") end
function M.tools() return collect("tools") end

function M.formatters_by_ft()
    local out = {}
    for ft, cfg in pairs(load()) do
        if cfg.formatter then
            out[ft] = as_list(cfg.formatter)
        end
    end
    return out
end

return M
