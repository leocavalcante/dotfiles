# Environment variables
export LANG=en_US.UTF-8
export COMPOSER_AUTH=$(cat ~/.composer/auth.json)
export EDITOR="emacs -nw"
export GIT_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR

# Sources
source $HOME/.oh-my-zsh/oh-my-zsh.sh
source $HOME/antigen.zsh

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
gbd-all-except() {
    git branch | grep -v "${1:-$(git branch --show-current)}" | xargs git branch -D
}

dock() {
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $(pwd):/usr/local/src \
        -w /usr/local/src \
        --net host \
        $(env | awk -F= '/^[[:alpha:]]/{print $1}' | sed 's/^/-e/') \
        --name "dock-$(openssl rand -hex 2)" $@
}

reload() {
    source ~/.zshrc
    source ~/.zprofile
}

# Aliases

## Editor
alias e="$EDITOR"
alias eaws="$EDITOR ~/.aws/config"
alias egit="$EDITOR ~/.gitconfig"
alias ehosts="sudo $EDITOR /etc/hosts"
alias einit="$EDITOR ~/.emacs.d/init.el"
alias ekube="$EDITOR ~/.kube/config"
alias eprofile="$EDITOR ~/.zprofile"
alias erc="$EDITOR ~/.zshrc"

## Docker
alias dc="docker-compose"
alias dcd="docker-compose down --remove-orphans"
alias dcu="docker-compose up"
alias dr="docker run --rm --init"
alias dri="docker run --rm --init -it"
alias dsh="docker run --rm -it --entrypoint sh"

## Git
alias ga="git add"
alias gb="git branch"
alias gc="git checkout"
alias gd="git diff"
alias gm="git commit -m"
alias gp="git push"
alias gs="git status"
alias gt="git stash"
alias gu="git pull --rebase"
