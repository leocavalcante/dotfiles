# https://youtrack.jetbrains.com/articles/IDEA-A-19/Shell-Environment-Loading
[ -z "$INTELLIJ_ENVIRONMENT_READER" ] && plugins=(tmux)

export COMPOSER_AUTH=$(cat ~/.composer/auth.json)
export EDITOR="emacs -nw"
export GIT_EDITOR=$EDITOR
export GOPATH=~/go
export KUBE_EDITOR=$EDITOR
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$GOPATH/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh
source $HOME/antigen.zsh
source $HOME/.phpbrew/bashrc

alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias ct="composer test"
alias cu="composer update"
alias d="docker"
alias dc="docker compose"
alias e="emacs -nw"
alias ee="emacs -nw ~/.emacs.default/init.el"
alias ek="emacs -nw ~/.config/kitty/kitty.conf"
alias en="emacs -nw ~/notes.org"
alias et="emacs -nw ~/.tmux.conf"
alias ez="emacs -nw ~/.zshrc"
alias g="git"
alias ga="git add --all"
alias gc="git checkout"
alias gd="git diff"
alias gm="git commit"
alias gp="git push -u"
alias gs="git status"
alias gu="git pull"
alias gub="git pull --rebase"
alias hyperf="php bin/hyperf.php"
alias k="kubectl"
alias kns="kubens"
alias ktx="kubectx"
alias ls="exa -al"

antigen init $HOME/.antigenrc
eval "$(starship init zsh)"
