" Neovim Configuration File
" Author: @edurso


" ALE Config

let g:ale_disable_lsp=1
let g:ale_sign_column_always=1
let g:ale_sign_error='✘'
let g:ale_sign_warning=''

" ALE END


" PLUGINS Config (Managed w/ Vundle)

" Configurations for Vundle
" https://github.com/VundleVim/Vundle.vim
set nocompatible
filetype off

" Install plugins
" Note that most (all?) plugins have
" GitHub repos with the same name
set rtp+=~/.config/nvim/bundle/Vundle.vim " add vundle to runtime path

" Setup Vundle
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Themes, graphics, etc.
Plugin 'kaicataldo/material.vim', { 'branch': 'main' }
Plugin 'jaredgorski/spacecamp'
Plugin 'dracula/vim', { 'as': 'dracula' }
Plugin 'bryanmylee/vim-colorscheme-icons'
Plugin 'airblade/vim-gitgutter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plugin 'rhysd/vim-color-spring-night'
Plugin 'ryanoasis/vim-devicons'

" Utilities
Plugin 'preservim/nerdtree'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'Chiel92/vim-autoformat'
Plugin 'dense-analysis/ale'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'tpope/vim-fugitive'
Plugin 'majutsushi/tagbar'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdcommenter'
Plugin 'antoinemadec/FixCursorHold.nvim'
Plugin 'wellle/context.vim'
Plugin 'dansomething/vim-hackernews'
Plugin 'kevinoid/vim-jsonc'

" Let Vundle know it is done
call vundle#end()

" Indent based on filetype
filetype plugin indent on
filetype plugin on

" PLUGINS END


" COLORSCHEME Config

syntax on
colorscheme spacecamp_lite
set termguicolors

" COLORSCHEME END


" ALE Config

"autocmd CursorHold * silent call ALEHover()
nmap <slient> gd :ALEGoToDefinition

" ALE END

" NERDTREE Config

let NERDTreeShowHidden=1

autocmd BufWinEnter * silent NERDTreeMirror " Open the existing NERDTree on each new tab.

autocmd VimEnter * NERDTree | wincmd p " Open NERDTree when Vim is opened

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" NERDTREE END

" JSONC Config

autocmd FileType json syntax match Comment +\/\/.\+$+

" JSONC END


" COC.NVIM Config

set updatetime=300
set shortmess+=c
"nmap <slient> gd <Plug>(coc-definition)
nmap <slient> gy <Plug>(coc-type-definition)
nmap <slient> gi <Plug>(coc-implementation)
nmap <slient> gr <Plug>(coc-references)
nmap <slient> [g <Plug>(coc-diagnostic-prev)
nmap <slient> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
nmap cr <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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

" Use co to open coc config
nmap co :CocConfig<CR>

" COC.NVIM END


" AUTOFORMAT Config

" Location of python3 installation for vim-autoformat
let g:python3_host_prog="/usr/bin/python3"

" Path to directory where formatters are installed for vim-autoformat
let g:formatterpath= ['$HOME/.config/nvim/fmt']

" Autoformatting with vim-autoformat
nnoremap <F3> :Autoformat<CR>
au BufWrite * :Autoformat

" AUTOFORMAT END


" FIXCURSORHOLD Config

let g:cursorhold_updatetime=100

" FIXCURSORHOLD END


" CONTEXT.VIM Config

let g:context_nvim_no_redraw=1

" CONTEXT.VIM END


" STATUSLINE Config

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

" STATUSLINE END


" SETTINGS Config

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

" SETTINGS END


" KEYMAPS Config

let mapleader="," " set <leader>

" Toggle NERDTree Visible
nmap <leader>f :NERDTreeToggle<CR>
nmap \\ <leader>f

" Toggle Tagbar Visible
nmap <leader>t :TagbarToggle<CR>
nmap tt <leader>t

" List Colorschemes
nmap <leader>c :Colors<CR>
nmap cs <leader>c

" List Files
nmap <leader>f :Files<CR>
nmap f <leader>f

" List Git Commit History
nmap <leader>gc :Commits<CR>
nmap gc <leader>gc

" List Open Buffers
nmap <leader>b :Buffers<CR>

" Comment toggle
nmap cc <Plug>NERDCommenterToggle
vmap cc <Plug>NERDCommenterToggle<CR>gv

" Refresh nvim (run init script again)
nmap <leader>r :so ~/.config/nvim/init.vim<CR>

" Show hackernews
nmap hn <C-w>v<C-w>l:HackerNews best<CR>J

" Gradle key maps
nnoremap <F5> :!./gradlew deploy<CR>
nnoremap gb :!./gradlew build<CR>ht!!<CR>

" KEYMAPS END

