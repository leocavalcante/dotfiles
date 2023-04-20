export GOPATH=~/go
export EDITOR="emacs -nw"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export LANG=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$GOPATH/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_TMUX_AUTOSTART=true

ZSH_THEME="half-life"

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
alias ee="e ~/.emacs.d/init.el"
alias emacs="emacs -nw"
alias en="e ~/notes.org"
alias et="e ~/.tmux.conf"
alias ez="e ~/.zshrc"
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
alias ns="nix-shell"
alias nsp="ns -p"
alias phw="phpbrew"

