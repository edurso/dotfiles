#!/bin/zsh

# Installs edurso's Dotfiles on Debian or Ubuntu
# Author: @edurso

# Set up apt-get repositories
sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update

# Install dep packages
declare -a packages=("git" "ripgrep" "neovim" "lazygit" "curl")
for package in ${packages[@]}; do
    dpkg -s "$package" >/dev/null 2>&1 && {
        echo "$package is installed"
    } || {
        sudo apt-get install $package
    }
done

# Make directory for git repository if it doesn't exist
if [[ ! -d "$HOME/dotfiles" ]]; then
    mkdir -p $HOME/dotfiles
fi

# If there is no HEAD file in "$HOME/dotfiles" then make git repo
if [[ ! -e "$HOME/dotfiles/HEAD" ]]; then
    git init --bare $HOME/dotfiles
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME remote add origin git@github.com:edurso/dotfiles.git
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME fetch
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME pull
fi

