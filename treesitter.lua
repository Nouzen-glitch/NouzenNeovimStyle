return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- The current main branch targets newer Neovim versions.
        -- master remains the compatibility branch for Nvim 0.11-era setups.
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "python",
                    "lua",
                    "vim",
                    "vimdoc",
                    "bash",
                    "rust",
                    "javascript",
                    "typescript",
                    "json",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                auto_install = true,
            })
        end,
    },
}
