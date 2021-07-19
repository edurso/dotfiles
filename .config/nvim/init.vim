" Author: @edurso
" Neovim Configuration File

set nocompatible
filetype off

" Install plugins
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'kaicataldo/material.vim', { 'branch': 'main' }
Plugin 'preservim/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'itchyny/vim-gitbranch'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'kdheepak/lazygit.nvim'
Plugin 'jaredgorski/spacecamp'
Plugin 'tpope/vim-fugitive'
Plugin 'jiangmiao/auto-pairs'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'dense-analysis/ale'
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'
call vundle#end()

" Set up code formatting
call glaive#Install()
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar $HOME/.config/nvim/fmt/google-java-format-1.8-all-deps.jar"

filetype plugin indent on

colorscheme spacecamp_lite " material

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

" Open NERDTree when Vim is opened
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" Set Up Statusline
set laststatus=2 " make statusline visible
set stl= " initialize
set stl+=%#CursorIM#
set stl+=\ %(%{$USER}%)\  " print username
set stl+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ \ ':''} " editor mode
set stl+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ \ ':''} " editor mode
set stl+=%#Cursor#%{(mode()=='r')?'\ \ REPLACE\ \ ':''} " editor mode
set stl+=%#DiffDelete#%{(mode()=='v')?'\ \ VISUAL\ \ ':''} " editor mode
set stl+=%#CursorLineNR# " visual mode background
set stl+=%(\ %{gitbranch#name()}\ %) " print git branch 
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

" Set Some Settings
syntax enable
set autoindent
set nostartofline
set confirm
set mouse=a
set hidden
set tabstop=8
set softtabstop=0
set shiftwidth=4
set smartindent
set cindent
set expandtab
set relativenumber
set title
set showcmd
set cursorline
set wildmenu
set showmatch
set visualbell
set hls
set ic
set is

" Use tab key for coc.nvim intellisense
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed

" Key Maps
" Some of these are FRC-specific (e.g. <F5> to run a gradle deploy to a robot)
nnoremap <F5> :!./gradlew deploy<CR>
nnoremap gd :!./gradlew deploy<CR>
nnoremap gb :!./gradlew build<CR>
nnoremap gl :LazyGit<CR>

" Autoformatting
augroup autoformat_settings
  "autocmd FileType bzl AutoFormatBuffer buildifier
  "autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  "autocmd FileType dart AutoFormatBuffer dartfmt
  "autocmd FileType go AutoFormatBuffer gofmt
  "autocmd FileType gn AutoFormatBuffer gn
  "autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  "autocmd FileType java AutoFormatBuffer google-java-format
  "autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  "autocmd FileType rust AutoFormatBuffer rustfmt
  "autocmd FileType vue AutoFormatBuffer prettier
augroup END

