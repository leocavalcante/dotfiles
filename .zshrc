export COMPOSER_AUTH=$(cat ~/.composer/auth.json)
export EDITOR="emacsclient -c"
export GIT_EDITOR=$EDITOR
export GOPATH=~/go
export KUBE_EDITOR=$EDITOR
export LANG=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$GOPATH/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_TMUX_AUTOSTART=true

ZSH_THEME="dstufft"

plugins=(tmux)

source $ZSH/oh-my-zsh.sh
source $HOME/antigen.zsh
source $HOME/.phpbrew/bashrc

antigen init $HOME/.antigenrc

alias c="composer"
alias ci="composer install"
alias cr="composer require"
alias ct="composer test"
alias cu="composer update"
alias d="docker"
alias dc="docker-compose"
alias e="emacs"
alias ec="emacsclient -c"
alias ed="emacs --daemon"
alias ee="emacsclient -c ~/.emacs.default/init.el"
alias ek="emacsclient -e \"(kill-emacs)\""
alias en="emacsclient -c ~/notes.org"
alias et="emacsclient -c ~/.tmux.conf"
alias ez="emacsclient -c ~/.zshrc"
alias g="git"
alias ga="git add --all"
alias gc="git checkout"
alias gd="git diff"
alias gm="git commit"
alias gp="git push -u"
alias gs="git status"
alias gu="git pull"
alias gub="git pull --rebase"
alias k="kubectl"
alias kns="kubens"
alias ktx="kubectx"
alias ls="exa -al"

