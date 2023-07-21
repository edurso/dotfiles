#!/bin/bash

# Author: @edurso

if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges."
    exit 1
fi

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

get_miniconda_url() {
    if [[ "$MINICONDA_VERSION" == "latest" ]]; then
        echo "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    else
        echo "https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh"
    fi
}

apt install -y curl software-properties-common wget apt-transport-https
apt update

add-apt-repository ppa:lazygit-team/release
add-apt-repository ppa:neovim-ppa/unstable
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
curl -fsSL https://deb.nodesource.com/setup_16.x | -E bash -
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
add-apt-repository "deb https://packages.microsoft.com/repos/vscode stable main"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt update

echo "Installing apt packages"
apt update
apt install -y gnome-shell gnome-control-center gnome-terminal gnome-tweaks code git ripgrep neovim lazygit gh nodejs ruby-full gcc g++ make yarn python3 net-tools python3-pip openjdk-11-jdk gradle tree cmake gnupg2 ca-certificates build-essential gpg gpg-agent pinentry-curses docker.io jupyter-core neofetch linux-tools-$(uname -r)

echo "Installing snaps"
snap install --classic obsidian
snap install --classic clion
snap install --classic pycharm-professional
snap install --classic intellij-idea-ultimate

echo "Installing miniconda3..."
MINICONDA_VERSION="latest"
INSTALL_DIR="$USER_HOME/miniconda3"
MINICONDA_URL=$(get_miniconda_url)
curl -o ~/miniconda_installer.sh -L $MINICONDA_URL
bash ~/miniconda_installer.sh -b -p $INSTALL_DIR
rm ~/miniconda_installer.sh

# Get rid of old profiles if they exist
if [[ -e "$USER_HOME/.bashrc" ]]; then
   rm -rf $USER_HOME/.bashrc
fi

if [[ -e "$USER_HOME/.zshrc" ]]; then
   rm -rf $USER_HOME/.zshrc
fi

# Make directory for git repository if it doesn't exist
if [[ ! -d "$USER_HOME/dotfiles" ]]; then
    mkdir -p $USER_HOME/dotfiles
fi

# If there is no HEAD file in "$HOME/dotfiles" then make git repo
if [[ ! -e "$USER_HOME/dotfiles/HEAD" ]]; then
    git init --bare $USER_HOME/dotfiles
    git --git-dir=$USER_HOME/dotfiles/ --work-tree=$USER_HOME config --local status.showUntrackedFiles no
    git --git-dir=$USER_HOME/dotfiles/ --work-tree=$USER_HOME remote add origin git@github.com:edurso/dotfiles.git
    git --git-dir=$USER_HOME/dotfiles/ --work-tree=$USER_HOME fetch origin master
    git --git-dir=$USER_HOME/dotfiles/ --work-tree=$USER_HOME reset --hard FETCH_HEAD
    git --git-dir=$USER_HOME/dotfiles/ --work-tree=$USER_HOME pull origin master
fi

# Set Up NeoVim (vim-plug plugins, etc.)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

# Install act
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Install SKDMan
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Zsh and Plugins
apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

# Verify that bash is the configured shell
chsh -s /usr/bin/zsh $SUDO_USER

# Change directory
cd $USER_HOME

# Restart shell
zsh
