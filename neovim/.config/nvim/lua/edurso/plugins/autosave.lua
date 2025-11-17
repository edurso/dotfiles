return {
    'pocco81/auto-save.nvim',
    config = function ()
        require('auto-save').setup({
            enabled = true,
            trigger_events = {
                'InsertLeave',
                'TextChanged',
            },
            write_delay = 500,
            concurrency_delay = 1000,
            debug = false,
            debounce_text_changed = 1000,
            exclude_buftypes = {
                'nofile',
                'terminal',
                'prompt',
            },
            exclude_filetypes = {
                'gitcommit',
                'gitrebase',
                'svn',
                'hgcommit',
                'hgrmessage',
                'git',
                'ledger',
                'vim',
                'help',
                'man',
                'dashboard',
                'lazy',
                'NvimTree',
                'harpoon',
            },
            disable_cjk_widths = false,
        })
    end
}
