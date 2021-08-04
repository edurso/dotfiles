#!/bin/zsh

# Installs edurso's Dotfiles on Debian or Ubuntu
# Author: @edurso

# Set up apt-get repositories
sudo add-apt-repository ppa:lazygit-team/release
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update

# Install dep packages
declare -a packages=("git" "ripgrep" "neovim" "lazygit" "curl" "gh" "zsh")
for package in ${packages[@]}; do
    dpkg -s "$package" >/dev/null 2>&1 && {
        echo "$package is installed"
    } || {
        sudo apt-get install $package
    }
done

# Install/update starship
sh - "$(curl -fsSL https://starship.rs/install.sh)"

# If zsh is not the current shell, change it
if [[ $SHELL != "/usr/bin/zsh" ]]; then
    chsh -s /usr/bin/zsh root
fi

# Make directory for git repository if it doesn't exist
if [[ ! -d "$HOME/dotfiles" ]]; then
    mkdir -p $HOME/dotfiles
fi

# If there is no HEAD file in "$HOME/dotfiles" then make git repo
if [[ ! -e "$HOME/dotfiles/HEAD" ]]; then
    git init --bare $HOME/dotfiles
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME remote add origin https://github.com/edurso/dotfiles.git
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME fetch origin master
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME reset --hard FETCH_HEAD
fi

