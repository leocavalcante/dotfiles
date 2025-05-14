# Environment variables
export LANG="en_US.UTF-8"
export COMPOSE_BAKE="true"
export EDITOR="code"
export GIT_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"

# PHP
export COMPOSER_PATH="$HOME/.config/composer"
export COMPOSER_BIN="$COMPOSER_PATH/vendor/bin"
export COMPOSER_AUTH="$(cat "$COMPOSER_PATH/auth.json" 2>/dev/null || echo '')"
export PATH="$COMPOSER_BIN:$PATH"

# Go
if command -v go >/dev/null 2>&1; then
  export GOPATH="$(go env GOPATH)"
  export GOBIN="$GOPATH/bin"
  export PATH="$GOBIN:$PATH"
fi

# Antigen (https://antigen.sharats.me/)
ANTIGEN="$HOME/antigen.zsh"
if [ ! -f "$ANTIGEN" ]; then
  curl -sSL git.io/antigen -o "$ANTIGEN"
fi
if [ -f "$ANTIGEN" ]; then
  source "$ANTIGEN"
  antigen use oh-my-zsh
  antigen bundle git
  antigen bundle tmux
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
fi

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
  local gd cp
  gd="$(git diff --staged)"
  cp="write an English git commit message based on the following changes:\n$gd"
  git commit -m "$(chatgpt "$cp")"
}

pr() {
  if git diff --staged --quiet; then
    echo "No staged changes for PR."
    return 1
  fi
  local gd tp bp t b
  gd="$(git diff --staged)"
  tp="write an English title for a pull request based on the following changes:\n$gd"
  bp="write an English body for a pull request based on the following changes:\n$gd"
  t="$(chatgpt "$tp")"
  b="$(chatgpt "$bp")"
  gh pr create -a @me -t "$t" -b "$b"
}

dot() {
  cd "$HOME/.dotfiles" || return
  git pull --quiet
  if command -v stow >/dev/null 2>&1; then
    stow .
  else
    echo "GNU Stow not installed!"
  fi
  cd "$HOME" || return
}

up() {
  case "$(uname)" in
    Linux)
      sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
      ;;
    Darwin)
      brew update && brew upgrade && brew cleanup
      ;;
  esac
}

improve_file() {
  if [ -z "$1" ]; then
    echo "Usage: improve_file <filename>"
    return 1
  fi
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "File not found: $file"
    return 1
  fi
  local content improved
  content="$(cat "$file")"
  improved="$(chatgpt "Improve this file:\n$content")"
  printf "%s\n" "$improved" > "$file"
}

# Tools
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
