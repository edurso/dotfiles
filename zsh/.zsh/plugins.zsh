# plugins and misc. extensions for zsh

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

# autocompletion
autoload -Uz +X compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# bind keys for jumping
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# zoxide
eval "$(zoxide init zsh)"