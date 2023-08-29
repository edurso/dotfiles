" Neovim Configuration File
" Author: @edurso


" CONFIGURATION VARS

" <leader>
let mapleader=","

" autocomplete
let g:deoplete#enable_at_startup = 1

" fzf
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.5, 'height': 0.5,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!.dart_tool/**' --glob '!.idea' --glob '!node_modules'"

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onedark'

" CONFIGURATION VARS END


" PLUGINS

" configurations for vim-plug
set nocompatible
filetype off

call plug#begin()

" install plugins
Plug 'joshdick/onedark.vim' " colorscheme
Plug 'airblade/vim-gitgutter' " git status in gutter
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " autocompletion
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' } " tabnine
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf installer
Plug 'junegunn/fzf.vim' " fzf vim plugin
Plug 'jiangmiao/auto-pairs' " automatically close all open parenthesis/brackets
Plug 'tpope/vim-fugitive' " git tool
Plug 'vim-airline/vim-airline' " statusline
Plug 'vim-airline/vim-airline-themes' " statusline themes

" let vim-plug know it is done
call plug#end()

" indent based on filetype
filetype plugin indent on
filetype plugin on

" PLUGINS END


" COLORSCHEME

if has('termguicolors')
    set termguicolors
endif
syntax on
colorscheme onedark
set background=dark
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight Normal guibg=none
highlight NonText guibg=none

" COLORSCHEME END


" SETTINGS

set autoindent
set nostartofline
set confirm
set mouse=a
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
set emoji
set noshowcmd
set noshowmode
set hls
set ic
set is
set nocursorline
set nocursorcolumn
set scrolljump=5
set lazyredraw
set redrawtime=10000
set synmaxcol=180
set re=1
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes
set completeopt=noinsert,menuone,noselect

" SETTINGS END


" COMMANDS

" fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

" COMMANDS END


" KEYMAPS

" general
noremap qq :wq<CR>
noremap q! :q!<CR>
noremap qa :qa<CR>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" switch between splits using ctrl + {h,j,k,l}
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
noremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" show mapping on all modes with F1
nmap <F1> <plug>(fzf-maps-n)
imap <F1> <plug>(fzf-maps-i)
vmap <F1> <plug>(fzf-maps-x)

" new line in normal mode and back
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" list colorschemes
nmap <leader>c :Colors<CR>
nmap cs :Colors<CR>

" list files
nmap f :Files<CR>

" list git commit history
nmap <leader>gc :Commits<CR>
nmap gc <leader>gc
nmap <leader>g gc

" list open buffers
nmap <leader>bb :Buffers<CR>

" vim-plug shortcuts
noremap <leader>pi :PlugInstall<CR>
noremap <leader>pu :PlugUpdate<CR>
noremap <leader>pu :PlugUpgrade<CR>
noremap <leader>ps :PlugStstus<CR>
noremap <leader>pc :PlugClean<CR>

" KEYMAPS END

