" Neovim Configuration File
" Author: @edurso

" Config for ale
let g:ale_disable_lsp = 1

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
Plugin 'mhinz/vim-startify'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'junegunn/vim-journal'
Plugin 'junegunn/rainbow_parentheses.vim'
Plugin 'nightsense/forgotten'
Plugin 'zaki/zazen'
Plugin 'airblade/vim-gitgutter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'nightsense/nemo'
Plugin 'yuttie/hydrangea-vim'
Plugin 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plugin 'rhysd/vim-color-spring-night'

" Utilities
Plugin 'preservim/nerdtree'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'Chiel92/vim-autoformat'
Plugin 'dense-analysis/ale'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'kdheepak/lazygit.nvim'
Plugin 'tpope/vim-fugitive'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'majutsushi/tagbar'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ryanoasis/vim-devicons'
Plugin 'scrooloose/nerdcommenter'
Plugin 'junegunn/vim-easy-align'
Plugin 'alvan/vim-closetag'
Plugin 'tpope/vim-abolish'
Plugin 'Yggdroot/indentLine'
Plugin 'sheerun/vim-polyglot'
Plugin 'chrisbra/Colorizer'
Plugin 'KabbAmine/vCoolor.vim'
Plugin 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plugin 'metakirby5/codi.vim'
Plugin 'dkarter/bullets.vim'
Plugin 'antoinemadec/FixCursorHold.nvim'
Plugin 'wellle/context.vim'
Plugin 'dansomething/vim-hackernews'

" End Plugins
call vundle#end()

" Indent based on filetype
filetype plugin indent on
filetype plugin on

" Set colorscheme
syntax on
colorscheme spacecamp_lite
set termguicolors

" NERDTree vars
let NERDTreeShowHidden=1
autocmd BufWinEnter * silent NERDTreeMirror " Open the existing NERDTree on each new tab.
autocmd VimEnter * NERDTree | wincmd p " Open NERDTree when Vim is opened

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" Easy Align
xmap ga <Plugin>(EasyAlign)
nmap ga <Plugin>(EasyAlign)

" coc.nvim
set updatetime=300
set shortmess+=c
nmap <slient> gd <Plugin>(coc-definition)
nmap <slient> gy <Plugin>(coc-type-definition)
nmap <slient> gi <Plugin>(coc-implementation)
nmap <slient> gr <Plugin>(coc-references)
nmap <slient> [g <Plugin>(coc-diagnostic-prev)
nmap <slient> ]g <Plugin>(coc-diagnostic-next)

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plugin>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plugin>(coc-format-selected)
nmap <leader>f  <Plugin>(coc-format-selected)

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

" vim-signify
let g:signify_sign_add = '│'
let g:signify_sign_delete = '│'
let g:signify_sign_change = '│'
hi DiffDelete guifg=#ff5555 guibg=none

" FixCursorHold for better performance
let g:cursorhold_updatetime=100

" context.vim
let g:context_nvim_no_redraw=1

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

" LazyGit plugin vars
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 0.9 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed

" Location of python3 installation for vim-autoformat
let g:python3_host_prog="/usr/bin/python3"

" Path to directory where formatters are installed for vim-autoformat
let g:formatterpath= ['$HOME/.config/nvim/fmt']

" Gradle Key Maps
" Some of these are FRC-specific (e.g. <F5> to run a gradle deploy to a robot)
nnoremap <F5> :!./gradlew deploy<CR>
nnoremap gb :!./gradlew build<CR>

" Autoformatting with vim-autoformat
nnoremap <F3> :Autoformat<CR>
au BufWrite * :Autoformat

" Other misc. mappings (for plugins, etc.)
let mapleader=","
nmap <leader>q :NERDTreeToggle<CR>
nmap \\ <leader>q
nmap <leader>w :TagbarToggle<CR>
nmap tt <leader>w
nmap <leader>ee :Colors<CR>
nmap cs <leader>ee
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap hn <C-w>v<C-w>l:HackerNews best<CR>J
xmap <leader>a gaip*
nmap <leader>a gaip*
nmap <leader>s :Rg<CR>
nmap <leader>d :Files<CR>
nmap <leader>f :BLines<CR>
nmap <leader>h :RainbowParentheses!!<CR>
nmap <leader>k :ColorToggle<CR>
nmap <leader>l :Limelight!!<CR>
xmap <leader>l :Limelight!!<CR>

