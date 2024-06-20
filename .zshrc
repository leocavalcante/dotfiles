# Config
ZSH_TMUX_AUTOSTART=true

# Environment variables
export LANG=en_US.UTF-8
export EDITOR="nvim"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export SUDO_EDITOR=$EDITOR
export PATH="$PATH:$HOME/.local/bin"

# PHP
export COMPOSER_PATH="$HOME/.config/composer"
export COMPOSER_BIN="$COMPOSER_PATH/vendor/bin"
export COMPOSER_AUTH="$(cat $COMPOSER_PATH/auth.json)"
export PATH="$PATH:$COMPOSER_BIN"

# Go
export GOPATH="$(go env GOPATH)"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Antigen (https://antigen.sharats.me/)
source "$HOME/antigen.zsh"
antigen bundle tmux
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Aliases
alias c="clear"
alias gpt="chatgpt"
alias l="exa --all --icons --git"

# Bindings
bindkey '^ ' autosuggest-accept

# Functions
dot() {
  cd "$HOME/.dotfiles"
  git pull
  stow .
  cd "$HOME"
}

code() {
  z "$1"
  nvim .
}

# Tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
