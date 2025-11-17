return {
    {
        "joshdick/onedark.vim",
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme("onedark")

            -- You can configure highlights by doing something like:
            vim.o.background = "dark"
            vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
        end,
    },
   	{
        "vim-airline/vim-airline",
        init = function()
            vim.g.airline_theme = 'onedark'
        end,
    },
    { "vim-airline/vim-airline-themes" },
}