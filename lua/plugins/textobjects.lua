return {
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = {},
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {spec = require("config.leader_groups").which_key_spec()},
    },
}
