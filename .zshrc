# Environment variables
export LANG=en_US.UTF-8
export COMPOSE_BAKE=true
export EDITOR="code"
export GIT_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"

# PHP
export COMPOSER_PATH="$HOME/.config/composer"
export COMPOSER_BIN="$COMPOSER_PATH/vendor/bin"
export COMPOSER_AUTH="$(cat "$COMPOSER_PATH/auth.json" 2>/dev/null || echo '')"
export PATH="$PATH:$COMPOSER_BIN"

# Go
if command -v go >/dev/null 2>&1; then
  export GOPATH="$(go env GOPATH)"
  export GOBIN="$GOPATH/bin"
  export PATH="$PATH:$GOBIN"
fi

# Antigen (https://antigen.sharats.me/)
if [ ! -f "$HOME/antigen.zsh" ]; then
  curl -L git.io/antigen > "$HOME/antigen.zsh"
fi
source "$HOME/antigen.zsh"
antigen use oh-my-zsh
antigen bundle git
antigen bundle tmux
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Aliases
alias gpt="chatgpt"
alias l="eza --all --icons --git"
alias ls="eza --all --icons"
alias ll="eza --long --all --git --icons"

# Functions
commit() {
  if git diff --staged --quiet; then
    echo "No staged changes to commit."
    return 1
  fi
  gd="$(git diff --staged)"
  cp="write an english git commit message based on the changes: $gd"
  git commit -m "$(chatgpt "$cp")"
}

pr() {
  if git diff --staged --quiet; then
    echo "No staged changes for PR."
    return 1
  fi
  gd="$(git diff --staged)"
  tp="write an english title for a pull request based on the changes: $gd"
  bp="write an english body for a pull request based on the changes: $gd"
  t="$(chatgpt "$tp")"
  b="$(chatgpt "$bp")"
  gh pr create -a @me -t "$t" -b "$b"
}

dot() {
  cd "$HOME/.dotfiles" || return
  git pull
  if command -v stow >/dev/null; then
    stow .
  else
    echo "GNU Stow not installed!"
  fi
  cd "$HOME" || return
}

up() {
  if [[ "$(uname)" == "Linux" ]]; then
    sudo apt update
    sudo apt upgrade -y
    # Uncomment the following line if you want to include a release upgrade every time
    # sudo do-release-upgrade
    sudo apt autoremove -y
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew update
    brew upgrade
    brew cleanup
  fi
}

# Tools
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi
