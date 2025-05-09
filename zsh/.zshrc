# Zsh Configuration File
# Author: @edurso

# use neovim as default editor
export EDITOR='nvim'

# initialize mamba
source ~/.zsh/mamba.zsh

# mrover configurations
source ~/.zsh/mrover.zsh

# mcfly for a better ctrl+r
export MCFLY_FUZZY=2
export MCFLY_KEY_SCHEME=vim
export MCFLY_PROMPT="➜"
export MCFLY_DISABLE_MENU=TRUE
export MCFLY_INTERFACE_VIEW=BOTTOM
eval "$(mcfly init zsh)"

# zsh plugins
source ~/.zsh/plug/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plug/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zoxide 
eval "$(zoxide init zsh)"

# starship
export STARSHIP_CONFIG=~/.zsh/starship.toml
eval "$(starship init zsh)"

# assorted things that need to be on path
# GNU ARM cross-compilers for embedded
arm_compilers="/home/edurso/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin"
if [ -d "$arm_compilers" ]; then
    export PATH="$arm_compilers:$PATH"
fi

# check cuda and include if present
cuda_dir="/usr/local/cuda/bin"
if [ -d "$cuda_dir" ]; then
    export PATH="$cuda_dir:$PATH"
fi

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"
export PATH="$HOME/miniforge3/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"

# use aliases configuration
source ~/.zsh/alias.zsh

