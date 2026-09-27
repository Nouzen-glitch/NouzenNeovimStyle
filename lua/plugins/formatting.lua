return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            formatters_by_ft = {
                c = { "clang_format" },
                cpp = { "clang_format" },
                python = { "ruff_format" },
                lua = { "stylua" },
                rust = { "rustfmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                sh = { "shfmt" },
                bash = { "shfmt" },
            },

            format_on_save = function(bufnr)
                -- Disable automatic formatting for huge files.
                local max_size = 200 * 1024 -- 200 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                if ok and stats and stats.size > max_size then
                    return
                end
                return {
                    timeout_ms = 1000,
                    lsp_fallback = true,
                }
            end,
        },
    },
}
