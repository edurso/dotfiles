" Author: @edurso
" Vim Script Functions To Get Git Information

" Function Returns Refreshed Git Status "
function! GitRefresh()
    let gitoutput = systemlist('cd '.expand('%:p:h:S').' && git status --porcelain -b 2>/dev/null')
    if len(gitoutput) > 0
        let b:gitstatus = strpart(get(gitoutput,0,''),3) .'/'. strpart(get(gitoutput,1,' '),1,2)
    else
        let b:gitstatus = 'gitless'
    endif
endfunction

autocmd BufEnter,BufWritePost * call GitRefresh() " auto refresh git on buffer entry and write