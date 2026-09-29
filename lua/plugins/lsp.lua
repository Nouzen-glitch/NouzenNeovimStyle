local languages = require("util.languages")

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            -- Servers come from config/languages.lua (+ languages_local.lua).
            -- Mason installs them; mason-lspconfig enables every installed
            -- server through vim.lsp.enable().
            --
            -- Per-server settings go here, e.g.:
            --   vim.lsp.config("gopls", { settings = { gopls = { staticcheck = true } } })

            -- LuaLS is scoped to this Neovim configuration only.
            local nvim_config = vim.uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")

            vim.lsp.config("lua_ls", {
                root_dir = function(bufnr, on_dir)
                    local file = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(bufnr)) or ""
                    if file:sub(1, #nvim_config) == nvim_config then
                        on_dir(nvim_config)
                    end
                end,

                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME, nvim_config },
                        },
                        telemetry = { enable = false },
                    },
                },
            })
        end,
    },

    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },

    {
        "mason-org/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = languages.servers(),
            automatic_enable = true,
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    {
        -- Installs formatters/linters listed under `tools` in languages.lua.
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = languages.tools(),
        },
    },

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
}
