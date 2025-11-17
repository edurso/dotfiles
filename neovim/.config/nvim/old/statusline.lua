vim.g.airline_theme = 'onedark'
require('nvim-tree').setup({
    on_attach = "on_attach",
    disable_netrw = true,
    view = {
        side = "left",
        adaptive_size = true,
        centralize_selection = true,
        number = true,
        relativenumber = true,
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "all",
    },
    update_focused_file = {
        enable = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    actions = {
        change_dir = {
            enable = false,
        },
    },
})

