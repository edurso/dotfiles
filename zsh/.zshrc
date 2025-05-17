# Zsh Configuration File
# Author: @edurso

# use neovim as default editor
export EDITOR='nvim'

# starship
export STARSHIP_CONFIG=~/.zsh/starship.toml
eval "$(starship init zsh)"

# initialize mamba
#source ~/.zsh/mamba.zsh

# mrover configurations
source ~/.zsh/mrover.zsh

# source zsh plugins/extensions
source ~/.zsh/plugins.zsh

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

# configs/licenses for fpga devel
source ~/.zsh/fpga.zsh

# use aliases configuration
source ~/.zsh/alias.zsh

# hook direnv to shell to recognize .envrc files
eval "$(direnv hook zsh)"

# fix this for some reason
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib:/lib"
