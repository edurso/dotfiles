" Author: @edurso
" Uses Vundle to Set Up Vim Plugins

set nocompatible
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" ===================
" my plugins here
" ===================

Plugin 'dracula/vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" ===================
" end of plugins
" ===================
call vundle#end()
filetype plugin indent on
