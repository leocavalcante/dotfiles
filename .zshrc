# Environment variables
export LANG=en_US.UTF-8
export EDITOR="code"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export SUDO_EDITOR=$EDITOR

# PHP
if [ -d "$HOME/.composer" ]; then
    COMPOSER_PATH="$HOME/.composer"
elif [ -d "$HOME/.config/composer" ]; then
    COMPOSER_PATH="$HOME/.config/composer"
fi
if [ -n "$COMPOSER_PATH" ]; then
    export COMPOSER_AUTH="$(cat "$COMPOSER_PATH/auth.json")"
    export PATH="$PATH:$COMPOSER_PATH/vendor/bin"
fi

# Go
export GOPATH="$(go env GOPATH)"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Sources
source $HOME/.oh-my-zsh/oh-my-zsh.sh

if [ ! -f "$HOME/antigen.zsh" ]; then
    curl -sL git.io/antigen > "$HOME/antigen.zsh"
fi
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
