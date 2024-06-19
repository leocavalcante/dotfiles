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

# Sources
source $HOME/.oh-my-zsh/oh-my-zsh.sh
source "$HOME/antigen.zsh"

# Antigen (https://antigen.sharats.me/)
antigen use oh-my-zsh
antigen theme robbyrussell
antigen bundle git
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
hi() {
  cd "$HOME/.dotfiles"
  git pull
  cd "$HOME"
  sudo apt update
  sudo apt upgrade -y
}

code() {
  z "$1"
  nvim .
}

# Tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
