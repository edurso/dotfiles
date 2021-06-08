# .zshrc
# Author: @edurso


# setup starship
eval "$(starship init zsh)"


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
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
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
alias eclipse='/home/edurso/.app/eclipse/java-2020-06/eclipse/eclipse&'
alias python=python3
alias pip=pip3
alias vim='nvim'
alias vi='nvim'
alias ee='cd /mnt/c/Users/edurso'
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# shortcuts
alias as='run-as'
alias ec='eclipse'
alias qt='qtcreator&'
alias df='dotfile'
alias jlab='jupyter lab&'
alias jpnb='jupyter lab&'
alias jl='jupyter lab&'
alias ghu='gh-update'


# additional parameterized shortcuts

# win app
start() { explorer.exe "$1" }
np() { notepad.exe "$1" & }

# network
putty() { putty.exe "$1" & }
ping() { ping.exe "$1" }

# util
py() { /usr/bin/python3.8 "$1" }

# lazygit
lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# config x-server display
export DISPLAY=:0


# add qt to path
QT='/~/.app/qt/qt-everywhere-src-5.15.0/~/qt/qt515static'
export PATH=$QT/bin:$PATH


# add java to path

# java paths
JDK8='/usr/lib/jvm/java-8-openjdk-amd64'
JDK11='/usr/lib/jvm/java-11-openjdk-amd64'
JDK13='/usr/lib/jvm/jdk-13.0.2+8'
JRE13='/usr/lib/jvm/jdk-13.0.2+8-jre'

# add java to path
export JAVA_HOME=$JAVA11
export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin

# add apache spark to path
export SPARK_HOME='/home/edurso/.app/spark-2.4.5-bin-hadoop2.7' # note that spark requires java8
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
export PYSPARK_PYTHON=python3
export PATH=$SPARK_HOME:$PATH:~/.local/bin:$JAVA_HOME/bin:$JAVA_HOME/jre/bin 

# add raspbian 10 to path
export PATH="$PATH:$HOME/.app/raspbian10/bin"

# add rvm to path
export PATH="$PATH:$HOME/.rvm/bin"

# add sdkman to path
export SDKMAN_DIR="/home/edurso/.sdkman"
[[ -s "/home/edurso/.sdkman/bin/sdkman-init.sh" ]] && source "/home/edurso/.sdkman/bin/sdkman-init.sh"


# source antigen plugin manager for zsh
source $HOME/.config/antigen.zsh


# select and apply zsh plugins
antigen use oh-my-zsh
antigen bundle git
antigen bundle desyncr/auto-ls
antigen apply

cd ~

