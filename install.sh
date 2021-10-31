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
sudo apt update

# Install dep packages
declare -a packages=(
    "git"
    "ripgrep"
    "neovim"
    "lazygit"
    "gh"
    "zsh"
    "nodejs"
    "gcc"
    "g++"
    "make"
    "yarn"
    "python3.9"
    "python3.9-distutils"
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
    "code"
)
for package in ${packages[@]}; do
    dpkg -s "$package" >/dev/null 2>&1 && {
        echo "$package is installed"
    } || {
        sudo apt install -y $package
    }
done
sudo apt update

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
fi

# Set Up NeoVim (VundleVim plugins, etc.)
if [[ ! -d "$HOME/.config/nvim/bundle/Vundle.vim" ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
fi
nvim +PluginInstall +qall

# Install vs code extensions
declare -a extensions=(
    "austin.code-gnu-global"
    "bierner.markdown-preview-github-styles"
    "christian-kohler.path-intellisense"
    "DavidAnson.vscode-markdownlint"
    "dbankier.vscode-instant-markdown"
    "docsmsft.docs-markdown"
    "donjayamanne.githistory"
    "dotdevru.prettier-java"
    "ecmel.vscode-html-css"
    "esbenp.prettier-vscode"
    "fallenwood.vimL"
    "GitHub.codespaces"
    "GitHub.copilot"
    "GitHub.github-vscode-theme"
    "GitHub.vscode-pull-request-github"
    "GrapeCity.gc-excelviewer"
    "kisstkondoros.vscode-gutter-preview"
    "kiteco.kite"
    "luqimin.velocity"
    "mdickin.markdown-shortcuts"
    "ms-azuretools.vscode-docker"
    "ms-dotnettools.csharp"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "ms-vscode.Theme-MarkdownKit"
    "ms-vsliveshare.vsliveshare"
    "ms-vsliveshare.vsliveshare-audio"
    "ms-vsliveshare.vsliveshare-pack"
    "mwpb.java-prettier-formatter"
    "naco-siren.gradle-language"
    "Pivotal.vscode-boot-dev-pack"
    "Pivotal.vscode-concourse"
    "Pivotal.vscode-manifest-yaml"
    "Pivotal.vscode-spring-boot"
    "PKief.material-icon-theme"
    "rebornix.ruby"
    "redhat.java"
    "redhat.vscode-commons"
    "redhat.vscode-xml"
    "richardwillis.vscode-gradle-extension-pack"
    "shd101wyy.markdown-preview-enhanced"
    "tht13.html-preview-vscode"
    "tomoki1207.pdf"
    "torn4dom4n.latex-support"
    "VisualStudioExptTeam.vscodeintellicode"
    "vscjava.vscode-gradle"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-dependency"
    "vscjava.vscode-java-pack"
    "vscjava.vscode-java-test"
    "vscjava.vscode-maven"
    "vscjava.vscode-spring-boot-dashboard"
    "vscjava.vscode-spring-initializr"
    "walkme.Markdown-extension-pack"
    "wingrunr21.vscode-ruby"
    "wpilibsuite.vscode-wpilib"
    "yzane.markdown-pdf"
    "yzhang.markdown-all-in-one"
)
for ext in ${extensions[@]}; do
    code --install-extension $ext
done


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
sudo chsh -s /usr/bin/zsh $USER

# Change directory
cd $HOME

# Restart shell
zsh

