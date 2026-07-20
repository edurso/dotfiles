# Zsh Configuration File
#
# Author: @edurso

# use neovim as default editor
export EDITOR='nvim'

# zsh history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=1000
setopt appendhistory

# starship
export STARSHIP_CONFIG=~/.zsh/starship.toml
eval "$(starship init zsh)"

# source zsh plugins/extensions
source ~/.zsh/plugins.zsh

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.local/bin"
export DIRENV_WARN_TIMEOUT=100s
export PATH="/usr/bin:$PATH"

# configs/licenses for fpga devel
source ~/.zsh/fpga.zsh

# use aliases configuration
source ~/.zsh/alias.zsh

# initialize mamba
source ~/.zsh/mamba.zsh

# hook direnv to shell to recognize .envrc files
eval "$(direnv hook zsh)"

caen() {
    local port=5951
    local host="login-course.engin.umich.edu"
    local user="edurso"

    ssh -f -L ${port}:localhost:${port} "${user}@${host}" "sleep 30" || return 1
    sleep 1
    vncviewer "localhost:${port}"
}


export QSYS_ROOTDIR="/home/edurso/quartus/25.1std/quartus/sopc_builder/bin"

# Added by Quartus Prime software
export SALT_LICENSE_FILE="$SALT_LICENSE_FILE;/home/edurso/.altera.quartus/questa_lic.dat"
