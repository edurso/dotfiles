return {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
        require("which-key").setup()

        require("which-key").add({
            { "<leader>a", group = "AI (Claude)" },
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Document" },
            { "<leader>g", group = "Git (float/browse)" },
            { "<leader>h", group = "Git Hunk", mode = { "n", "v" } },
            { "<leader>i", group = "Import" },
            { "<leader>r", group = "Rename" },
            { "<leader>s", group = "Search" },
            { "<leader>t", group = "Toggle" },
            { "<leader>w", group = "Workspace" },
        })
    end,
}
