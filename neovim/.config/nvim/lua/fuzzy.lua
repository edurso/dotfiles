require('telescope').setup{
    pickers = {
        find_files = {
            hidden = true
        }
    },
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=always',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '-u'
        },
        file_ignore_patterns = { "^.git/" }
    }
}
