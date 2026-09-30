return {
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = {},
    },

    {
        -- Auto-close brackets and quotes.
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        opts = {},
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = { spec = require("config.leader_groups").which_key_spec() },
    },
}
