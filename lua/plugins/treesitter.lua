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
                -- Parsers come from config/languages.lua (+ languages_local.lua).
                ensure_installed = require("util.languages").parsers(),
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                -- Fetch a parser on demand when you open an unlisted filetype
                -- (highlighting only, no LSP). Set to false to install only listed parsers.
                auto_install = true,
            })
        end,
    },
}
