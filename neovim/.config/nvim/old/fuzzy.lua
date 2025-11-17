require('telescope').setup{
    pickers = {
        find_files = {
            hidden = true
        }
    },
    defaults = {
       file_ignore_patterns = { "^.git/" }
    }
}
