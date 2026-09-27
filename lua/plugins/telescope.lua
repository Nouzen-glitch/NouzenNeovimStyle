return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                },
            },
        },
    },
}
