return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "t", ":Neotree reveal<CR>", { desc = "NeoTree reveal" } },
    },
    opts = {
        filesystem = {
            window = {
                mappings = {
                    ["t"] = "close_window",
                },
            },
        },
    },
}