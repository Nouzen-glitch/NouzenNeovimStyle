return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local ls = require("luasnip")
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    {
        "saadparwaiz1/cmp_luasnip",
        event = "InsertEnter",
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
    },

    {
        "hrsh7th/cmp-buffer",
        event = "InsertEnter",
    },

    {
        "hrsh7th/cmp-path",
        event = "InsertEnter",
    },

    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
    },

    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),

                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
