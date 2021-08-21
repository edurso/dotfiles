#!/bin/zsh

# Installs edurso's Dotfiles on Debian or Ubuntu
# Author: @edurso

# error when reference undefined vars
set -o nounset

# exit when a command fails
set -o errexit

# Set up apt-get repositories
sudo add-apt-repository ppa:lazygit-team/release
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get update

# Install dep packages
declare -a packages=("git" "ripgrep" "lazygit" "curl" "gh" "zsh" "nodejs" "gcc" "g++" "make" "yarn" "python3.9" "python3.9-distutils")
for package in ${packages[@]}; do
    dpkg -s "$package" >/dev/null 2>&1 && {
        echo "$package is installed"
    } || {
        sudo apt-get install -y $package
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
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME remote add origin https://github.com/edurso/dotfiles.git
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME fetch origin master
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME reset --hard FETCH_HEAD
fi

# Download and Install NeoVim
wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage
chmod u+x ./nvim.appimage
mv nvim.appimage $HOME/bin/

# Set Up NeoVim (VundleVim plugins, etc.)
if [[ ! -d "$HOME/.config/nvim/bundle/Vundle.vim" ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
fi
nvim +PluginInstall +qall

# Install extensions
#mkdir -p $HOME/.config/coc/extensions
#cd $HOME/.config/coc/extensions
#if [ ! -f package.json ]; then
#echo '{"dependencies":{}}'> package.json
#fi

# Install coc.nvim extensions
#npm install \
#coc-snippets \
#coc-html \
#coc-highlight \
#coc-dot-complete \
#coc-dash-complete \
#coc-calc \
#coc-yaml \
#coc-xml \
#coc-sql \
#coc-sh \
#coc-python \
#coc-pyright \
#coc-omnisharp \
#coc-markdownlint \
#coc-syntax \
#coc-go \
#coc-json \
#coc-java \
#coc-clangd \
#coc-yank \
#coc-prettier \
#--global-style \
#--ignore-scripts \
#--no-bin-links \
#--no-package-lock \
#--only=prod

# Build coc.nvim
#npm run build

# Install/update starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# Get rid of old profiles if they exist
if [[ -e "$HOME/.bashrc" ]]; then
    rm -rf $HOME/.bashrc
fi
if [[ -e "$HOME/.profile" ]]; then
    rm -rf $HOME/.profile
fi
if [[ -e "$HOME/.bash_history" ]]; then
    rm -rf $HOME/.bash_history
fi
if [[ -e "$HOME/.bash_logout" ]]; then
    rm -rf $HOME/.bash_logout
fi

# Set user shell to zsh (just installed)
chsh -s /usr/bin/zsh $USER

# Change directory
cd $HOME

# Restart shell
zsh

