# Environment variables
export LANG=en_US.UTF-8
export EDITOR="nvim"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export SUDO_EDITOR=$EDITOR
export PATH="$PATH:$HOME/.local/bin"
export KITTY_SHELL_INTEGRATION=no-cursor

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
antigen use oh-my-zsh
antigen bundle git
antigen bundle tmux
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Aliases
alias gpt="chatgpt"
alias l="exa --all --icons --git"

# Functions
dotfiles() {
  cd "$HOME/.dotfiles"
  git pull
  stow .
  cd "$HOME"
}

code() {
  z "$1"
  nvim .
}

update() {
    sudo apt update
    sudo apt upgrade -y
    sudo do-release-upgrade
    sudo apt autoremove -y
}

# Tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
