" Author: @edurso
" ~/.vimrc
" Configures Vim Settings

" Configure Simple Settings "
syntax enable
set autoindent
set smartindent " this indents too much sometimes :(
filetype indent plugin on
set nostartofline
set confirm
set mouse=a
set hidden
set tabstop=4
set softtabstop=4
set expandtab
set number
set title
set showcmd
set cursorline
set wildmenu
set showmatch
set visualbell
set hls " highlight results in search
set ic " ignore capitialization on letters in searches
set is " show partial matches

" Function Returns Refreshed Git Status "
function! GitRefresh()
    let gitoutput = systemlist('cd '.expand('%:p:h:S').' && git status --porcelain -b 2>/dev/null')
    if len(gitoutput) > 0
        let b:gitstatus = strpart(get(gitoutput,0,''),3) .'/'. strpart(get(gitoutput,1,' '),1,2)
    else
        let b:gitstatus = 'gitless'
    endif
endfunc
autocmd BufEnter,BufWritePost * call GitRefresh() " auto refresh git on buffer entry and write
 
" Configure Colors "
hi LineNr ctermfg=160 ctermbg=234
hi CursorLineNR ctermfg=190
hi DiffAdd ctermfg=0 ctermbg=2
hi DiffChange ctermfg=0 ctermbg=13
hi Cursor ctermfg=11
hi Visual ctermfg=0
hi DiffDelete ctermfg=15 ctermbg=12
hi CursorIM ctermbg=248 ctermfg=0

" Create Statusline "
set laststatus=2 " make statusline visible
set stl= " initialize
set stl+=%#CursorIM#
set stl+=\ edurso\  " print username
set stl+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ \ ':''} " editor mode
set stl+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ \ ':''} " editor mode
set stl+=%#Cursor#%{(mode()=='r')?'\ \ REPLACE\ \ ':''} " editor mode
set stl+=%#DiffDelete#%{(mode()=='v')?'\ \ VISUAL\ \ ':''} " editor mode
set stl+=%#CursorLineNR# " visual mode background
set stl+=\ %(<%{b:gitstatus}>%)\  " print git branch 
set stl+=%#LineNr#
set stl+=\ Tab\ %n\  " buffer number
set stl+=%#Visual# " visual mode background
set stl+=%{&paste?'\ PASTE\ ':''}
set stl+=%{&spell?'\ SPELL\ ':''} 
set stl+=%#DiffChange#%R " readonly flag
set stl+=%#DiffDelete#%{&mod?'\ UNSAVED\ ':''} " add "UNSAVED" if file has changed
set stl+=%#Cursor#
set stl+=\ %t\  " filename
set stl+=%#CursorLineNR#
set stl+=%= " allign to right
set stl+=%#CursorIM#
set stl+=\ %p%% " percent through file
set stl+=\ \|\ Line%3l\ \| " line number and formatting
set stl+=\ %Y\ \| " file type
set stl+=\ %{&fileencoding?&fileencoding:&encoding}\ -\  " file encoding
set stl+=\[%{&fileformat}]\ \  " file formt
set stl+=\|\ %3l:%-2c\  " linenum:columnum
set stl+= " end

