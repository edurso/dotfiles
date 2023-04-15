# Installs edurso's Dotfiles on Debian or Ubuntu
# Author: @edurso

# Error when reference undefined vars
set -o nounset

# Install libs for next step
sudo apt install -y curl
sudo apt install -y software-properties-common
sudo apt install -y wget
sudo apt install -y apt-transport-https
sudo apt update

# Set up apt-get repositories
sudo add-apt-repository ppa:lazygit-team/release
sudo add-apt-repository ppa:neovim-ppa/unstable
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb https://packages.microsoft.com/repos/vscode stable main"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update

# Install dep packages
declare -a packages=(
    "code"
    "git"
    "ripgrep"
    "neovim"
    "lazygit"
    "gh"
    "nodejs"
    "ruby-full"
    "gcc"
    "g++"
    "make"
    "yarn"
    "python3"
    "net-tools"
    "python3-pip"
    "openjdk-11-jdk"
    "gradle"
    "tree"
    "cmake"
    "gnupg2"
    "ca-certificates"
    "build-essential"
    "gpg"
    "gpg-agent"
    "pinentry-curses"
    "docker.io"
    "jupyter-core"
    "neofetch"
)
for package in ${packages[@]}; do
    dpkg -s "$package" >/dev/null 2>&1 && {
        echo "$package is installed"
    } || {
        sudo apt install -y $package
    }
done
sudo apt update

# Python libraries
declare -a libs=(
    "neovim"
    "opencv-python"
    "matplotlib"
    "pynvim"
    "numpy"
    "pandas"
    "tensorflow"
    "torch"
    "keras"
    "pillow"
    "tldr"
)
for lib in ${libs[@]}; do
    pip3 install $lib
done

# Get rid of old profiles if they exist
if [[ -e "$HOME/.bashrc" ]]; then
   rm -rf $HOME/.bashrc
fi

if [[ -e "$HOME/.zshrc" ]]; then
   rm -rf $HOME/.zshrc
fi

# Make directory for git repository if it doesn't exist
if [[ ! -d "$HOME/dotfiles" ]]; then
    mkdir -p $HOME/dotfiles
fi

# If there is no HEAD file in "$HOME/dotfiles" then make git repo
if [[ ! -e "$HOME/dotfiles/HEAD" ]]; then
    git init --bare $HOME/dotfiles
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME remote add origin git@github.com:edurso/dotfiles.git
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME fetch origin master
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME reset --hard FETCH_HEAD
    git --git-dir=$HOME/dotfiles/ --work-tree=$HOME pull origin master
fi

# Set Up NeoVim (vim-plug plugins, etc.)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

# Install act
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Zsh and Plugins
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

# Verify that bash is the configured shell
sudo chsh -s /usr/bin/zsh $USER

# Change directory
cd $HOME

# Restart shell
zsh

