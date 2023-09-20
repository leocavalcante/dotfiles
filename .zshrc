plugins=(tmux)

export COMPOSER_AUTH=$(cat ~/.composer/auth.json)
export EDITOR="emacs -nw"
export GIT_EDITOR=$EDITOR
export GOPATH=~/go
export KUBE_EDITOR=$EDITOR
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$GOPATH/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# https://youtrack.jetbrains.com/articles/IDEA-A-19/Shell-Environment-Loading
[ -z "$INTELLIJ_ENVIRONMENT_READER" ] && ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh
source $HOME/antigen.zsh
source $HOME/.phpbrew/bashrc

antigen init $HOME/.antigenrc
eval "$(starship init zsh)"
