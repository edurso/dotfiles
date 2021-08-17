" Neovim Configuration File
" Author: @edurso


" CONFIGURATION VARS

" <leader>
let mapleader=","

" ale
let g:ale_disable_lsp=1
let g:ale_sign_column_always=1
let g:ale_sign_error='✘'
let g:ale_sign_warning=''

" coc
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
let g:coc_global_extensions = [
            \ 'coc-html',
            \ 'coc-highlight',
            \ 'coc-dot-complete',
            \ 'coc-dash-complete',
            \ 'coc-calc',
            \ 'coc-yaml',
            \ 'coc-xml',
            \ 'coc-sql',
            \ 'coc-sh',
            \ 'coc-python',
            \ 'coc-pyright',
            \ 'coc-omnisharp',
            \ 'coc-markdownlint',
            \ 'coc-syntax',
            \ 'coc-go',
            \ 'coc-json',
            \ 'coc-java',
            \ 'coc-clangd',
            \ 'coc-yank',
            \ 'coc-prettier',
            \ 'coc-snippets',
            \ ]

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
let g:python3_host_prog="/usr/bin/python3" " Location of python3 installation for vim-autoformat
let g:formatterpath= ['$HOME/.config/nvim/fmt'] " Path to directory where formatters are installed for vim-autoformat

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
set rtp+=~/.config/nvim/bundle/Vundle.vim " add vundle to runtime path

" setup Vundle
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" themes, graphics, etc.
Plugin 'kaicataldo/material.vim', { 'branch': 'main' } " colorscheme
Plugin 'haishanh/night-owl.vim'
Plugin 'jaredgorski/spacecamp' " colorscheme
Plugin 'dracula/vim', { 'as': 'dracula' } " colorscheme
Plugin 'chriskempson/tomorrow-theme', { 'rtp': 'vim' } " colorscheme
Plugin 'rhysd/vim-color-spring-night' " colorscheme
Plugin 'ryanoasis/vim-devicons' " filetype icons
Plugin 'bryanmylee/vim-colorscheme-icons' " filetype icons
Plugin 'luochen1990/rainbow' " highlight parenthesis
Plugin 'gregsexton/MatchTag' " highlight match html tags
Plugin 'airblade/vim-gitgutter' " git status in gutter
Plugin 'jiangmiao/auto-pairs' " automatically close all open parenthesis/brackets

" utilities
Plugin 'preservim/nerdtree' " file tree explorer
Plugin 'Xuyuanp/nerdtree-git-plugin' " git status by file in nerdtree
Plugin 'neoclide/coc.nvim', {'branch': 'release'} " LSP, etc.
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
colorscheme spacecamp_lite

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
set stl+=%#CursorIM#
set stl+=\ %p%% " percent through file
set stl+=\ \|\ Line%3l\ \| " line number and formatting
set stl+=\ %Y\ \| " file type
set stl+=\ %{&fileencoding?&fileencoding:&encoding}\ -\  " file encoding
set stl+=\[%{&fileformat}]\ \  " file formt
set stl+=\|\ %3l:%-2c\  " linenum:columnum
set stl+= " end

" STATUSLINE END


" FUNCTIONS

" check if last inserted char is a backspace (used by coc pmenu)
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" coc show documentation in window
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
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

" coc
autocmd CursorHold * silent call CocActionAsync('highlight') " highlight the symbol and its references when holding the cursor
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

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
"nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" vundle
noremap <leader>pi :PluginInstall<CR>
noremap <leader>pu :PluginUpdate<CR>
noremap <leader>pu :PluginUpgrade<CR>
noremap <leader>ps :PluginStstus<CR>
noremap <leader>pc :PluginClean<CR>

" coc
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
nmap <silent> <C-a> <Plug>(coc-cursors-word)
xmap <silent> <C-a> <Plug>(coc-cursors-range)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>o :OR <CR>
nmap <leader>jd <Plug>(coc-definition)
nmap <leader>jy <Plug>(coc-type-definition)
nmap <leader>ji <Plug>(coc-implementation)
nmap <leader>jr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <leader>a <Plug>(coc-codeaction-line)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap co :CocConfig<CR>
nmap cl :CocList<CR>

" KEYMAPS END

