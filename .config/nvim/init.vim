" Author: @edurso
" nvim init
" points to normal vim config in user path
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
