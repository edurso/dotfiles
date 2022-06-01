# Bash Configuration File
# Uses starship (see starship.rs) and neovim
# Author: @edurso


# setup starship
eval "$(starship init bash)"


# config bash settings
case $- in
    *i*) ;;
    *) return;;
esac
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# use bash colors
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# alias maps

# std functions
alias ll='ls -alF'
alias la='ls -a -l'
alias l='ls -l'
alias cls='clear'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# applications
alias pip='pip3'
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias vi='nvim'
alias vim='nvim'

# navigation
alias dev='cd $HOME/dev'
alias d='dev'

# application shortcuts
alias as='run-as'
alias df='dotfile'
alias jl='jupyter lab&'
alias ghu='gh-update'

man() {
    tldr "$1"
}

# lazygit
lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}


# add yarn to path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


# add java to path

# java paths
JAVA11='/usr/lib/jvm/java-11-openjdk-amd64'

# add java to path
export JAVA_HOME=$JAVA11 # current java version
export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin # add $JAVA_HOME to $PATH


# enable gpg signing
export GPG_TTY=$(tty)
if [ ! -f ~/.gnupg/S.gpg-agent ]; then
    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf )
fi
export GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent:0:1


# ignore case in bash
echo 'set completion-ignore-case On' >> /etc/inputrc
echo 'set completion-ignore-case On' | sudo tee -a /etc/inputrc


# bash autocomplete
source /etc/profile.d/bash_completion.sh

