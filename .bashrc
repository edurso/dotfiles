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

# edit .bashrc file
alias ebrc='nvim ~/.bashrc'

# std functions
alias ll='ls -alF'
alias la='ls -a -l'
alias l='ls -l'
alias cls='clear'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# applications
alias python='python3'
alias pip='pip3'
alias dotfile='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vm='vmware-view'

# navigation
alias d='dev'

# application shortcuts
alias as='run-as'
alias df='dotfile'
alias jl='jupyter lab&'
alias ghu='gh-update'
alias firefox='/home/edurso/Documents/firefox-106.0.1/firefox/firefox'

# shortcuts
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias rm='rm -rf'

# alias's for tarball archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# mrover utils
alias source_mrover='source ~/dev/catkin_ws/devel/setup.bash'

# auto ls after cd
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

# searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# copy file with a progress bar
cpp()
{
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
	| awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

# copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp $1 $2 && cd $2
	else
		cp $1 $2
	fi
}

# move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv $1 $2 && cd $2
	else
		mv $1 $2
	fi
}

# create and go to the directory
mkdirg ()
{
	mkdir -p $1
	cd $1
}

# goes up a specified number of directories  (i.e. up 4)
up ()
{
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# show current network information
netinfo ()
{
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	echo ""
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	echo ""
	/sbin/ifconfig | awk /'inet addr/ {print $4}'

	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	echo "---------------------------------------------------"
}

# extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# switch manual to tldr pages
man() {
    tldr "$1"
}

# open in file explorer
open() {
    gio open "$1"
}

start() {
    gio open "$1"
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

# go to dev
dev() {
    cd /home/edurso/dev/
}


# add yarn to path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


# add firefox to path
export PATH="$HOME/Documents/firefox-106.0.1/firefox:$PATH"


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


# disable ntfs color highlights
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS


# matlab
export PATH="/home/edurso/.local/share/applications/MATLAB/R2022a/bin:$PATH"
export PATH="/home/edurso/Documents/MATLAB/R2022a/bin:$PATH"


# anaconda initialize
__conda_setup="$('/home/edurso/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/edurso/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/edurso/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/edurso/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


# ros setup
source /opt/ros/noetic/setup.bash


# clear screen of gpg agent output
clear

