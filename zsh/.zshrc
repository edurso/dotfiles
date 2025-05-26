# Zsh Configuration File
#
# Author: @edurso

# use neovim as default editor
export EDITOR='nvim'

# zsh history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000

# starship
export STARSHIP_CONFIG=~/.zsh/starship.toml
eval "$(starship init zsh)"

# initialize mamba
source ~/.zsh/mamba.zsh

# source zsh plugins/extensions
source ~/.zsh/plugins.zsh

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"
export PATH="$HOME/miniforge3/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# configs/licenses for fpga devel
source ~/.zsh/fpga.zsh

# use aliases configuration
source ~/.zsh/alias.zsh

# hook direnv to shell to recognize .envrc files
eval "$(direnv hook zsh)"

