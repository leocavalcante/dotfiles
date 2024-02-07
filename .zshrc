# Environment variables
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
git-branch-delete-all-except() {
  git branch | grep -v $1 | xargs git branch -D
}

dock() {
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $PWD:/usr/local/src \
        -w /usr/local/src \
        --net host \
        $(env | awk -F= '/^[[:alpha:]]/{print $1}' | sed 's/^/-e/') \
        --name "dock-$(openssl rand -hex 2)" $@
}

e() {
    case "$1" in
	"rc")
	    file="~/.zshrc"
	    ;;

	"profile")
	    file="~/.zprofile"
	    ;;
	*)
	    file="$1"
	    ;;
    esac
    
    $(echo $EDITOR) $file
}
