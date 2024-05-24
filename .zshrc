# Environment variables
export LANG=en_US.UTF-8
export EDITOR="code"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export SUDO_EDITOR=$EDITOR

# PHP
export COMPOSER_PATH="$HOME/.config/composer"
export COMPOSER_BIN="$COMPOSER_PATH/vendor/bin"
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
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen theme robbyrussell
antigen apply

# Functions
hi() {
  cd "$HOME/.dotfiles"
  git pull
  cd "$HOME"
  sudo apt update
  sudo apt upgrade -y
}
