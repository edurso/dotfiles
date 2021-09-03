" Neovim Configuration File
" Author: @edurso


" CONFIGURATION VARS

" <leader>
let mapleader=","

" ale
let g:ale_sign_column_always=1
let g:ale_sign_error='✘'
let g:ale_sign_warning=''

" ncm2
"let g:ncm2#match_highlight = 'bold'

" startify
let g:startify_padding_left=10
let g:startify_session_persistence=1
let g:startify_enable_special=0
let g:startify_change_to_vcs_root=1
let g:startify_lists = [
            \ {'type': 'dir'},
            \ {'type': 'files'},
            \ {'type': 'sessions'},
            \ {'type': 'bookmarks'},
            \ {'type': 'commands'},
            \ ]
let g:startify_bookmarks =  [
            \ {'v': '~/.config/nvim'},
            \ ]
let g:startify_commands = [
            \ {'ch': ['Health Check', ':checkhealth']},
            \ {'ps': ['Plugins Status', ':PluginStatus']},
            \ {'pc': ['Offload Unused Plugins', ':PluginClean']},
            \ {'pi': ['Install Plugins', ':PluginInstall']},
            \ {'pu': ['Update Vim Plugins',':PluginUpdate | PluginUpgrade']},
            \ {'uc': ['Update Coc Plugins', ':CocUpdate']},
            \ {'h':  ['Help', ':help']},
            \ ]

" rainbow
let g:rainbow_active=1

" fzf
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!.dart_tool/**' --glob '!.idea' --glob '!node_modules'"

" nerdtree
let NERDTreeShowHidden=1
let g:NERDTreeChDirMode=2
let g:NERDTreeMapOpenSplit='$'

" autoformat
if has('unix')
    let g:python3_host_prog="/usr/bin/python3.9" " Location of python3 installation for vim-autoformat
    let g:formatterpath= ['$HOME/.config/nvim/fmt'] " Path to directory where formatters are installed for vim-autoformat
endif

" context
let g:context_nvim_no_redraw=1

" CONFIGURATION VARS END


" PLUGINS

" configurations for Vundle
" https://github.com/VundleVim/Vundle.vim
set nocompatible
filetype off

" install plugins
" note that most (all?) plugins have
" GitHub repos with the same name
if has('win32')
    set rtp+=$HOME\AppData\Local\nvim\bundle\Vundle.vim
else
    set rtp+=$HOME/.config/nvim/bundle/Vundle.vim " add vundle to runtime path
endif

" setup Vundle
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" themes, graphics, etc.
Plugin 'kaicataldo/material.vim', { 'branch': 'main' } " colorscheme
Plugin 'haishanh/night-owl.vim' " colorscheme
Plugin 'jaredgorski/spacecamp' " colorscheme
Plugin 'joshdick/onedark.vim' " colorscheme
Plugin 'dracula/vim', { 'as': 'dracula' } " colorscheme
Plugin 'chriskempson/tomorrow-theme', { 'rtp': 'vim' } " colorscheme
Plugin 'rhysd/vim-color-spring-night' " colorscheme
Plugin 'ryanoasis/vim-devicons' " filetype icons
Plugin 'bryanmylee/vim-colorscheme-icons' " filetype icons
Plugin 'luochen1990/rainbow' " highlight parenthesis
Plugin 'gregsexton/MatchTag' " highlight match html tags
Plugin 'airblade/vim-gitgutter' " git status in gutter
Plugin 'jiangmiao/auto-pairs' " automatically close all open parenthesis/brackets

" completion utilities
Plugin 'ncm2/ncm2' " auto complete
Plugin 'roxma/nvim-yarp' " auto complete
Plugin 'ncm2/ncm2-bufword' " auto complete extension
Plugin 'ncm2/ncm2-path' " auto complete extension
Plugin 'ncm2/ncm2-github' " auto complete extension
Plugin 'ncm2/ncm2-syntax' " auto complete extension
Plugin 'Shougo/neco-syntax' " auto complete extension
Plugin 'subnut/ncm2-github-emoji' " auto complete extension
Plugin 'ncm2/ncm2-tmux' " auto complete extension
Plugin 'ncm2/ncm2-tagprefix' " auto complete extension
Plugin 'ncm2/ncm2-neoinclude' " auto complete extension
Plugin 'Shougo/neoinclude.vim' " auto complete extension
Plugin 'ncm2/ncm2-cssomni' " auto complete extension
Plugin 'ncm2/ncm2-tern',  {'do': 'npm install'} " auto complete extension
Plugin 'ncm2/ncm2-jedi' " auto complete extension
Plugin 'ncm2/ncm2-pyclang' " auto complete extension
Plugin 'ncm2/ncm2-vim' " auto complete extension
Plugin 'Shougo/neco-vim' " auto complete extension
Plugin 'TyberiusPrime/ncm2-bufline' " auto complete extension
Plugin 'ObserverOfTime/ncm2-jc2', {'for': ['java', 'jsp']} " auto complete extension
Plugin 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']} " auto complete extension

" utilities
Plugin 'preservim/nerdtree' " file tree explorer
Plugin 'Xuyuanp/nerdtree-git-plugin' " git status by file in nerdtree
Plugin 'dense-analysis/ale' " linting
Plugin 'mhinz/vim-startify' " cool start up screen
Plugin 'Chiel92/vim-autoformat' " auto format
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } } " fuzzy search
Plugin 'junegunn/fzf.vim' " fuzzy vim integration
Plugin 'itchyny/vim-gitbranch' " git branch name
Plugin 'tpope/vim-fugitive' " git integration
Plugin 'scrooloose/nerdcommenter' " comment shortcuts
Plugin 'wellle/context.vim' " show context of buffer
Plugin 'dansomething/vim-hackernews' " why not
Plugin 'kevinoid/vim-jsonc' " jsonc (json w/ comments) integration

" let Vundle know it is done
call vundle#end()

" indent based on filetype
filetype plugin indent on
filetype plugin on

" PLUGINS END


" COLORSCHEME

syntax on
colorscheme onedark

" COLORSCHEME END


" SETTINGS

set termguicolors
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


" STATUSLINE

set laststatus=2 " make statusline visible
set stl= " initialize
set stl+=%#CursorIM#
set stl+=\ %(%{$USER}%)\  " print username
set stl+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ \ ':''} " editor mode
set stl+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ \ ':''} " editor mode
set stl+=%#Cursor#%{(mode()=='r')?'\ \ REPLACE\ \ ':''} " editor mode
set stl+=%#DiffDelete#%{(mode()=='v')?'\ \ VISUAL\ \ ':''} " editor mode
set stl+=%#CursorLineNR# " visual mode background
set stl+=%(\ \ %{gitbranch#name()}\ %) " print git branch
set stl+=%#Visual# " visual mode background
set stl+=%{&paste?'\ PASTE\ ':''}
set stl+=%{&spell?'\ SPELL\ ':''}
set stl+=%#DiffChange#%R " readonly flag
set stl+=%#DiffDelete#%{&mod?'\ UNSAVED\ ':''} " add "UNSAVED" if file has changed
set stl+=%#Cursor#
set stl+=\ %t\  " filename
set stl+=%#CursorLineNR#
set stl+=%= " allign to right
set stl+=\ %{LinterStatus()}\ \| " display linter status
set stl+=\ %p%% " percent through file
set stl+=\ \|\ Line%3l\ \| " line number and formatting
set stl+=\ %Y\ \| " file type
set stl+=\ %{&fileencoding?&fileencoding:&encoding}\ -\  " file encoding
set stl+=\[%{&fileformat}]\ \| " file formt
set stl+=\ %3l:%-2c\  " linenum:columnum
set stl+= " end

" STATUSLINE END


" FUNCTIONS

" get ale linter status
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
                \   '%dW %dE',
                \   all_non_errors,
                \   all_errors
                \)
endfunction

" FUNCTIONS END


" COMMANDS

" general
au BufEnter * set fo-=c fo-=r fo-=o " stop annoying auto commenting on new lines
au FileType help wincmd L " open help in vertical split
au BufWritePre * :%s/\s\+$//e " remove trailing whitespaces before saving
" return to last edit position when opening files
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" nerdtree
autocmd BufWinEnter * silent NERDTreeMirror " Open the existing NERDTree on each new tab.
autocmd VimEnter * NERDTree | wincmd p " Open NERDTree when Vim is opened
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif

" jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()

" autoformat
au BufWrite * :Autoformat " autoformat on write

" fzf
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

" COMMANDS END


" KEYMAPS

" general
noremap q :wq<CR>
noremap q! :q!<CR>
noremap qa :qa<CR>

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

" use a different register for delete and paste
nnoremap d "_d
vnoremap d "_d
vnoremap p "_dP
nnoremap x "_x

" list colorschemes
nmap <leader>c :Colors<CR>
nmap cs <leader>c

" list files
nmap <leader>f :Files<CR>
nmap f <leader>f

" list git commit history
nmap <leader>gc :Commits<CR>
nmap gc <leader>gc
nmap <leader>g gc

" list open buffers
nmap <leader>b :Buffers<CR>

" startify
nmap <leader>s :Startify<CR>
nmap s <leader>s

" comment toggle
nmap cc <Plug>NERDCommenterToggle
vmap cc <Plug>NERDCommenterToggle<CR>gv

" Refresh nvim (run init script again)
nmap <leader>r :so ~/.config/nvim/init.vim<CR>

" show hackernews
nmap hn <C-w>v<C-w>l:HackerNews best<CR>J
nmap <leader>h hn

" gradle key maps
nnoremap <F5> :!./gradlew deploy<CR>
nnoremap gb :!./gradlew build<CR>

" formatter
nnoremap <F3> :Autoformat<CR>

" nerdtree
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" vundle shortcuts
noremap <leader>pi :PluginInstall<CR>
noremap <leader>pu :PluginUpdate<CR>
noremap <leader>pu :PluginUpgrade<CR>
noremap <leader>ps :PluginStstus<CR>
noremap <leader>pc :PluginClean<CR>

" ncm2
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" KEYMAPS END

