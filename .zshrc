# Environment variables
export LANG=en_US.UTF-8
export EDITOR="emacs -nw"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export GOPATH="$(go env GOPATH)"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

if [ -s "$HOME/.composer/auth.json" ]; then
    export COMPOSER_AUTH="$(cat "$HOME/.composer/auth.json")"
fi

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
