# Zsh Aliases
# Author: @edurso

# color aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# edit .zshrc file
alias ezrc='nvim ~/.zshrc'

# std functions
alias ll='ls -alF'
alias la='ls -a -l'
alias l='ls -l'
alias cls='clear'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# neovim entrypoints
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# just typos
alias j='just'
alias ju='just'
alias jus='just'

# zoxide -> cd
alias cd='z'

# parent directories
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# aliases to common functions
alias nf='neofetch'
alias tool='jetbrains-toolbox'
alias jb='jetbrains-toolbox'
alias jl='jupyter lab&'
alias rm='rm -rf'
alias fin='encfs ~/dropbox/personal/Dropbox/finance ~/finance'

# open lazygit
lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# mamba aliases (only set if mamba is installed)
if command -v mamba >/dev/null 2>&1; then
    m() {
        mamba "$@"
    }
    ma() {
        mamba activate "$1"
    }
    me() {
        mamba env "$@"
    }
fi

