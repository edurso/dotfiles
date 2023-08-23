# Zsh Configuration File
# Author: @edurso

# powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# alias maps

# edit .bashrc file
alias ezrc='nvim ~/.zshrc'

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
alias logic='sudo $HOME/Documents/Logic-2.4.4-master.AppImage --no-sandbox'
alias obsidian='$HOME/Documents/Obsidian-1.1.9.AppImage'
alias modelsim='$HOME/intelFPGA/20.1/modelsim_ase/bin/vsim'
alias quartus='$HOME/intelFPGA_lite/22.1std/quartus/bin/quartus'
alias caen='ssh edurso@login.engin.umich.edu'
alias o='obsidian'

# navigation
alias d='dev'

# application shortcuts
alias as='run-as'
alias df='dotfile'
alias jl='jupyter lab&'
alias ghu='gh-update'

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


# ROS setup
ros ()
{
    source /opt/ros/noetic/setup.zsh
    source ./devel/setup.zsh
}

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
    cd $HOME/dev/
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
export GPG_TTY=$TTY
if [ ! -f ~/.gnupg/S.gpg-agent ]; then
    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf )
fi
export GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent:0:1


# disable ntfs color highlights
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS


# matlab
export PATH="/home/edurso/.local/share/applications/MATLAB/R2022a/bin:$PATH"
export PATH="/home/edurso/Documents/MATLAB/R2022a/bin:$PATH"


# thunderbird
export PATH="/home/edurso/Documents/thunderbird:$PATH"


# anaconda initialize
conda_loc="/home/edurso/anaconda3"
__conda_setup="$('$conda_loc/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$conda_loc/etc/profile.d/conda.sh" ]; then
        . "$conda_loc/etc/profile.d/conda.sh"
    else
        export PATH="$conda_loc/bin:$PATH"
    fi
fi
unset __conda_setup


# ros setup
source /opt/ros/noetic/setup.zsh


# activate conda environment
conda activate edurso

# clear screen of gpg agent output
clear

. "$HOME/.cargo/env"

# CUDA
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
export CPLUS_INCLUDE_PATH=/usr/local/cuda/include

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


export QSYS_ROOTDIR="/home/edurso/intelFPGA_lite/22.1std/quartus/sopc_builder/bin"
