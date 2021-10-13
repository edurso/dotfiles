# Installs edurso's Dotfiles on Windows
# Author: @edurso

# install scoop
if ( Test-Path "$HOME\scoop\shims\scoop" ) {
    scoop update
} else {
    iwr -useb get.scoop.sh | iex
}

# add scoop buckets
scoop bucket add java
scoop bucket add extras
scoop bucket add versions

# install tools
scoop install git
scoop install openjdk11
scoop install gradle
scoop install vscode
scoop install lazygit
scoop install starship
scoop install neovim-nightly
scoop install curl

# set up dotfiles repository if it isn't there already
if ( !(Test-Path "$HOME\dotfiles") ) {
    git clone "https://github.com/edurso/dotfiles.git" "$HOME\dotfiles"
} else {
    git -C "$HOME\dotfiles" pull
}

# set up vundle if it doesn't exist
if ( !(Test-Path "$HOME\AppData\Local\nvim\bundle\Vundle.vim") ) {
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME\AppData\Local\nvim\bundle\Vundle.vim"
}

# copy dotfiles to their proper windows locations
if ( !(Test-Path "$HOME\.config\starship.toml") ) {
    Remove-Item -Force "$HOME\.config\starship.toml"
}
Copy-Item "$HOME\dotfiles\.config\starship.toml" -Destination "$HOME\.config\"

if ( !(Test-Path "$HOME\AppData\Local\nvim\init.vim") ) {
    Remove-Item -Force "$HOME\AppData\Local\nvim\init.vim"
}
Copy-Item "$HOME\dotfiles\.config\nvim\init.vim" -Destination "$HOME\AppData\Local\nvim\"

if ( !(Test-Path "$HOME\AppData\Roaming\lazygit\config.yml") ) {
    Remove-Item -Force "$HOME\AppData\Roaming\lazygit\config.yml"
}
Copy-Item "$HOME\dotfiles\.config\lazygit\config.yml" -Destination "$HOME\AppData\Roaming\lazygit\"

if ( !(Test-Path "$HOME\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1") ) {
    Remove-Item -Force "$HOME\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}
Copy-Item "$HOME\dotfiles\win\Microsoft.PowerShell_profile.ps1" -Destination "$HOME\OneDrive\Documents\WindowsPowerShell\"

# reload profile
&$PROFILE

