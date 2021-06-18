#!/usr/bin/zsh 

# Author: @edurso
# Script installs some useful coc.nvim extensions

nvim -c 'CocInstall -sync coc-json coc-html coc-css coc-yaml coc-sql coc-xml coc-sh coc-python coc-pyright coc-markdownlint coc-omnisharp coc-json coc-java coc-go coc-git coc-gist coc-dot-complete coc-dash-complete coc-calc|q'
