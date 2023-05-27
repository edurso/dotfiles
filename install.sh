#!/bin/bash

# Error when reference undefined vars
set -o nounset

# Install libs for next step
# sudo apt install -y curl software-properties-common wget apt-transport-https cmake gnupg2 ca-certificates build-essential gpg gpg-agent pinentry-curses

# Set up apt-get repositories
# sudo add-apt-repository -y ppa:lazygit-team/release
# sudo add-apt-repository -y ppa:neovim-ppa/unstable
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
# curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
# wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
# sudo add-apt-repository "deb https://packages.microsoft.com/repos/vscode stable main"
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
# sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
# rm -f packages.microsoft.gpg
# sudo apt update

# Install dep packages
sudo apt install -y code \
                    git \
                    ripgrep \
                    neovim \
                    lazygit \
                    gh \
                    nodejs \
                    ruby-full \
                    gcc \
                    g++ \
                    make \
                    yarn \
                    python3 \
                    net-tools \
                    python3-pip \
                    openjdk-11-jdk \
                    openjdk-17-jdk \
                    gradle \
                    tree \
                    cmake \
                    docker.io \
                    jupyter-core \
                    neofetch \
                    linux-tools-$(uname -r)
sudo apt update

pip3 install neovim opencv-python matplotlib pynvim numpy pandas pillow tldr
