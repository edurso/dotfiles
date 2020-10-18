" Author: @edurso
" Changes Window Title When Vim Is Closed

function! ChangeTitle()
    set titlestring=\ %(%{$USER}%)\ wsl\ sh
endfunction

autocmd VimEnter,VimLeave,BufLeave,TermResponse * call ChangeTitle()