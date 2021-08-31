
if ( Test-Path "$HOME\scoop\shims\scoop" ) {
    echo "Found scoop, instusing existing installation"
        scoop update
} else {
    echo "installing scoop"
        iwr -useb get.scoop.sh | iex
}

echo "adding extra buckets"
scoop bucket add java
scoop bucket add extras
scoop bucket add versions

echo "installing things"
scoop install git openjdk11 vscode lazygit starship neovim-nightly

function mklink {
    cmd /c mklink $args
}

git clone "https://github.com/edurso/dotfiles.git" "$HOME\dotfiles"

mklink /d "$HOME\bin" "$HOME\dotfiles\bin"
mklink "$HOME\.config\starship.toml" "$HOME\dotfiles\.config\starship.toml"

git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME\AppData\Local\nvim\bundle\Vundle.vim"
mklink "$HOME\AppData\Local\nvim\init.vim" "$HOME\dotfiles\.config\nvim\init.vim"


mklink "$HOME\AppData\Roaming\lazygit\config.yml" "$HOME\dotfiles\.config\lazygit\config.yml"
mklink "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" "$HOME\dotfiles\win\Microsoft.PowerShell_profile.ps1"

