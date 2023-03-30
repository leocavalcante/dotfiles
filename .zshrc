export COMPOSER_PATH=~/.composer
export EDITOR=emacs
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export LANG=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$COMPOSER_PATH/vendor/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_TMUX_AUTOSTART=true

ZSH_THEME="agnoster"

plugins=(tmux)

source $ZSH/oh-my-zsh.sh
source $HOME/antigen.zsh

antigen init $HOME/.antigenrc

alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias ct="composer test"
alias cu="composer update"
alias e="emacs"
alias g="git"
alias ga="git add --all"
alias gd="git diff"
alias gm="git commit"
alias gp="git push -u"
alias gs="git status"
alias gu="git pull"
alias gub="git pull --rebase"
