require('telescope').setup{
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
