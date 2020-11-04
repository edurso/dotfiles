eval "$(starship init zsh)"

source $HOME/.config/antigen.zsh
antigen-use oh-my-zsh
antigen-bundle git
antigen-bundle desyncr/auto-ls
antigen-apply

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

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

alias ll='ls -alF'
alias la='ls -a -l'
alias l='ls -l'
alias eclipse='/home/edurso/.app/eclipse/java-2020-06/eclipse/eclipse&'
alias python=python3
alias pip=pip3
alias ee='cd /mnt/c/Users/edurso'
alias cls='clear'
alias la='ls -a -l'
alias as='android-studio'
alias ec='eclipse'
alias qt='qtcreator&'
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias df='dotfile'
alias vim='nvim'
alias vi='nvim'
alias jlab='jupyter lab&'
alias jpnb='jupyter lab&'
alias jl='jupyter lab&'

frc() {
    /mnt/c/Users/Public/wpilib/2020/vscode/Code.exe "$1"
}

start() {
    explorer.exe "$1"
}
py() {
    /usr/bin/python3.8 "$1"
}

np() {
    notepad.exe "$1"
}

putty() {
    putty.exe "$1" & 
}

ping() {
    ping.exe "$1" 
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export DISPLAY=:0
QT='/~/.app/qt/qt-everywhere-src-5.15.0/~/qt/qt515static'
PATH=$QT/bin:$PATH
export PATH
JAVA_HOME='/usr/lib/jvm/java-11-openjdk-amd64'
#JAVA_HOME='/usr/lib/jvm/jdk-13.0.2+8' #?
#JRE_HOME='/usr/lib/jvm/jdk-13.0.2+8-jre' #?
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
#PATH=$PATH:$HOME/bin:$JRE_HOME/bin #?
export JAVA_HOME
export JRE_HOME
export PATH
#export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64' # USE THIS FOR SPARK APPS
export SPARK_HOME='/home/edurso/.app/spark-2.4.5-bin-hadoop2.7'
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
export PYSPARK_PYTHON=python3
#export PATH=$SPARK_HOME:$PATH:~/.local/bin:$JAVA_HOME/bin:$JAVA_HOME/jre/bin # USE THIS FOR SPARK APPS
export PATH="$PATH:$HOME/.app/raspbian10/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export SDKMAN_DIR="/home/edurso/.sdkman"
[[ -s "/home/edurso/.sdkman/bin/sdkman-init.sh" ]] && source "/home/edurso/.sdkman/bin/sdkman-init.sh"


