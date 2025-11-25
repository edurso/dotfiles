return { -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = true,
        formatters_by_ft = {
            lua = { "stylua" },
            cpp = { "clang-format" },
            -- Conform can also run multiple formatters sequentially
            python = { "ruff" },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            html = { "prettierd" },
            css = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            markdown = { "prettierd" },
        },
    },
}
