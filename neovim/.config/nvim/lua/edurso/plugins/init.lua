return {
    {
        "mg979/vim-visual-multi",
        -- 'init' runs before the plugin is loaded and is perfect for global variables
        init = function()
            -- Sets the global variable that defines the key sequences for the plugin
            vim.g.VM_maps = {
                ['Add Cursor Up'] = '<A-S-Up>',
                ['Add Cursor Down'] = '<A-S-Down>',
            }
        end,
        -- 'config' runs after the plugin is loaded (or before if the plugin isn't lazy-loaded)
        config = function()
            -- Sets the Neovim keymaps to trigger the plugin's functionality (<Plug> maps)
            vim.api.nvim_set_keymap('n', '<A-S-Up>', '<Plug>(VM-Add-Cursor-Up)', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<A-S-Down>', '<Plug>(VM-Add-Cursor-Down)', { noremap = true, silent = true })

            -- If using vim.keymap.set (the modern Lua way):
            -- vim.keymap.set('n', '<A-S-Up>', '<Plug>(VM-Add-Cursor-Up)')
            -- vim.keymap.set('n', '<A-S-Down>', '<Plug>(VM-Add-Cursor-Down)')
        end,
    },
    { "NoahTheDuke/vim-just" },
    {
        "stevanmilic/nvim-lspimport",
        -- 'config' is used to define keymaps, options, and run setup functions
        config = function()
            -- Auto-import Keymap
            -- Mapped to <leader>a in Normal mode (n) to execute the import function.
            vim.keymap.set("n", "<leader>a", require("lspimport").import, { noremap = true, silent = true })
        end,
    },
    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] []
            require("mini.surround").setup()

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    -- { "github/copilot.vim" },
}