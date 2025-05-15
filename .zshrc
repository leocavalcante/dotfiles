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
  antigen bundle zsh-syntax-highlighting
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

vibe() {
  local BLUE="\033[1;34m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local RED="\033[1;31m"
  local CYAN="\033[1;36m"
  local RESET="\033[0m"
  local BOLD="\033[1m"

  local backup_flag=0
  local push_flag=0

  local VIBE_SYSTEM_PROMPT="You are a helpful assistant who answers questions clearly and directly, focusing only on the essential information.
When asked to write or modify code in a file, always provide the entire content of the file, including unchanged lines and your modifications. Do not include any explanations or additional comments—only output the complete, updated file."

  local args=()
  for arg in "$@"; do
    if [ "$arg" = "--backup" ]; then
      backup_flag=1
    elif [ "$arg" = "--push" ]; then
      push_flag=1
    else
      args+=("$arg")
    fi
  done

  if [ ${#args[@]} -lt 1 ]; then
    echo -e "${CYAN}" >&2
    echo " __     __ _ _           " >&2
    echo " \ \   / /(_) |__   ___  " >&2
    echo "  \ \ / / | | '_ \ / _ \ " >&2
    echo "   \ V /  | | | | | (_) |" >&2
    echo "    \_/   |_|_| |_|\___/ " >&2
    echo -e "${RESET}${GREEN}Welcome to Vibe!${RESET}" >&2
    echo -e "${BOLD}Usage:${RESET} vibe <instructions> [<filename>] [--backup] [--push]" >&2
    return 1
  fi

  local instructions="${args[1]}"
  local file=""
  local output_to_stdout=""
  local target_type=""

  local ask_target_prompt="Given these instructions, reply with 'stdout' if the output should go to the terminal or stdout, reply with the filename (just the file path, nothing else) if it should modify a file. Never reply with both. Instructions: $instructions"

  if [ ${#args[@]} -lt 2 ]; then
    echo -e "${YELLOW}🔍 Determining target (file or stdout) via chatgpt...${RESET}" >&2
    target_type="$(chatgpt "$ask_target_prompt" | head -n 1 | tr -d '\"')"
    if [ -z "$target_type" ]; then
      echo -e "${RED}❌ No target could be extracted from the instructions.${RESET}" >&2
      return 1
    fi
    if [ "$target_type" = "stdout" ]; then
      output_to_stdout="yes"
    else
      output_to_stdout="no"
      file="$target_type"
    fi
    echo -e "${CYAN}🔎 ChatGPT decided:${RESET} ${BOLD}$target_type${RESET}" >&2
  else
    file="${args[2]}"
    echo -e "${CYAN}📄 Filename provided as argument:${RESET} ${BOLD}$file${RESET}" >&2
    output_to_stdout="no"
  fi

  if [ "$output_to_stdout" = "yes" ]; then
    local content prompt improved
    echo -e "${YELLOW}📝 Building prompt for chatgpt...${RESET}" >&2
    prompt="Improve this file with the following instructions: $instructions"
    echo -e "${CYAN}🤖 Requesting improvements from chatgpt...${RESET}" >&2
    improved="$(chatgpt --role "$VIBE_SYSTEM_PROMPT" "$prompt")"
    if [ -z "$improved" ]; then
      echo -e "${RED}❌ No improvement result produced.${RESET}" >&2
      return 1
    fi
    printf "%s\n" "$improved"
    return 0
  fi

  if [ -z "$file" ]; then
    echo -e "${RED}❌ No filename was determined for file update.${RESET}" >&2
    return 1
  fi

  if [ ! -f "$file" ]; then
    echo -e "${YELLOW}🆕 File does not exist. Creating file:${RESET} $file" >&2
    touch "$file"
  fi

  if [ ! -f "$file" ]; then
    echo -e "${RED}❌ File not found:${RESET} $file" >&2
    return 1
  fi

  local content prompt improved

  echo -e "${BLUE}📖 Reading file:${RESET} ${CYAN}$file${RESET}" >&2
  content="$(<"$file")"

  echo -e "${YELLOW}📝 Building prompt for chatgpt...${RESET}" >&2
  prompt="Improve this file with the following instructions: $instructions"$'\n'"$content"

  echo -e "${CYAN}🤖 Requesting improvements from chatgpt...${RESET}" >&2
  improved="$(chatgpt --role "$VIBE_SYSTEM_PROMPT" "$prompt")"
  if [ -z "$improved" ]; then
    echo -e "${RED}❌ No improvements made to ${RESET}${CYAN}$file${RESET}${RED}.${RESET}" >&2
    return 1
  fi

  if [ "$backup_flag" -eq 1 ]; then
    local backup="$file.bak.$(date +%s)"
    echo -e "${YELLOW}🗄️  Creating backup at${RESET} ${CYAN}$backup${RESET}" >&2
    cp "$file" "$backup"
  fi

  echo -e "${GREEN}✍️  Overwriting${RESET} ${CYAN}$file${RESET} ${GREEN}with improvements...${RESET}" >&2
  printf "%s\n" "$improved" > "$file"
  if [ "$backup_flag" -eq 1 ]; then
    echo -e "${GREEN}✅ Improvement complete!${RESET} ${BOLD}Backup saved as${RESET} ${CYAN}$backup${RESET} ${GREEN}🎉${RESET}" >&2
  else
    echo -e "${GREEN}✅ Improvement complete!${RESET} ${CYAN}$file${RESET} ${GREEN}overwritten.${RESET}" >&2
  fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -f "$file" ]; then
    git add "$file"
    commit
    if [ "$push_flag" -eq 1 ] && [ $? -eq 0 ]; then
      git push
    fi
  else
    echo -e "${RED}❗ Not in a git repository or file not found for git add.${RESET}" >&2
  fi
}

# Tools
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
