# Zsh Configuration File
# Author: @edurso

# use neovim as default editor
export EDITOR='nvim'

# TODO initialize mamba here

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

# use aliases configuration
source ~/.zsh/alias.zsh

echo "im the boogieman!"

