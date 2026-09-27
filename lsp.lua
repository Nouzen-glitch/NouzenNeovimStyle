return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            -- Mason installs the actual language servers.
            -- mason-lspconfig then enables installed servers through
            -- Neovim's modern vim.lsp.enable() mechanism.
            require("mason").setup()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "basedpyright",
                    "lua_ls",
                    "rust_analyzer",
                    "bashls",
                },
                automatic_enable = true,
            })
            -- LuaLS configuration for this Neovim configuration itself.
            local nvim_config = vim.fn.stdpath("config")

            vim.lsp.config("lua_ls", {
                root_dir = function(bufnr, on_dir)
                    local file = vim.api.nvim_buf_get_name(bufnr)

                    if file:sub(1, #nvim_config) == nvim_config then
                        on_dir(nvim_config)
                    end
                end,

                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },

                        diagnostics = {
                            globals = { "vim" },
                        },

                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                nvim_config,
                            },
                        },

                        telemetry = {
                            enable = false,
                        },
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
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
}
