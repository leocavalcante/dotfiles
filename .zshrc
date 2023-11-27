export COMPOSER_AUTH=$(cat ~/.composer/auth.json)
export EDITOR="vi"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin:$GOPATH/bin:$PATH
export ZSH_THEME="robbyrussell"
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
source $HOME/antigen.zsh
source $HOME/.phpbrew/bashrc

git-branch-delete-all-except() {
  git branch | grep -v $1 | xargs git branch -D
}

antigen init $HOME/.antigenrc
