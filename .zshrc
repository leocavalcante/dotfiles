# ─── Early Setup ───
typeset -U PATH path

# ─── Environment Variables ───
export LANG="en_US.UTF-8"
export COMPOSE_BAKE="true"
export EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT="1"
export OPENCODE_ENABLE_EXA="1"

# PHP
export COMPOSER_PATH="$HOME/.config/composer"

# Go
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="$GOPATH/bin"

# ─── PATH Configuration ───
path=(
  "$HOME/.local/bin"
  "$HOME/.config/composer/vendor/bin"
  "$HOME/go/bin"
  "$HOME/.bun/bin"
  $path
)

# Termux-specific
[[ -n "$TERMUX_VERSION" ]] && path=("$HOME/.opencode/bin" $path)

# ─── Aliases ───
alias l="eza --all --icons --git"
alias ll="eza --long --all --icons --git"
alias push="git push"
alias stk="starship toggle kubernetes"
alias python="python3"
alias pip="pip3"
alias oc="opencode"
alias occ="opencode --continue"
# GitHub CLI aliases
alias ghpr="gh pr list"
alias ghprc="gh pr create"
alias ghprv="gh pr view"
alias ghi="gh issue list"
alias ghiv="gh issue view"
alias ghw="gh workflow list"
alias ghr="gh run list"

# ─── Functions ───

# Enable Anthropic Copilot API (local routing)
enable_copilot_api() {
  local anthropic_url="http://localhost:4141"
  export ANTHROPIC_BASE_URL="$anthropic_url"
  export ANTHROPIC_API_URL="$anthropic_url"
  export ANTHROPIC_API_BASE="$anthropic_url"
  export ANTHROPIC_API_KEY="copilot-api"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4.5"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4.5"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4.5"
  export ANTHROPIC_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL}"
  export ANTHROPIC_SMALL_FAST_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL}"
  export DISABLE_NON_ESSENTIAL_MODEL_CALLS="1"
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
  echo "✨ Copilot API enabled"
}

# Disable Anthropic Copilot API
disable_copilot_api() {
  unset ANTHROPIC_BASE_URL
  unset ANTHROPIC_API_URL
  unset ANTHROPIC_API_BASE
  unset ANTHROPIC_API_KEY
  unset ANTHROPIC_DEFAULT_HAIKU_MODEL
  unset ANTHROPIC_DEFAULT_SONNET_MODEL
  unset ANTHROPIC_DEFAULT_OPUS_MODEL
  unset ANTHROPIC_MODEL
  unset ANTHROPIC_SMALL_FAST_MODEL
  unset DISABLE_NON_ESSENTIAL_MODEL_CALLS
  unset CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
  echo "⚫ Copilot API disabled"
}

# Enable AWS Bedrock
enable_bedrock() {
  export CLAUDE_CODE_USE_BEDROCK="1"
  export AWS_REGION="us-east-1"
  export ANTHROPIC_MODEL="global.anthropic.claude-sonnet-4-5-20250929-v1:0"
  export ANTHROPIC_SMALL_FAST_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"
  echo "☁️  Bedrock enabled"
}

# Disable AWS Bedrock
disable_bedrock() {
  unset CLAUDE_CODE_USE_BEDROCK
  unset AWS_REGION
  unset ANTHROPIC_MODEL
  unset ANTHROPIC_SMALL_FAST_MODEL
  echo "⚫ Bedrock disabled"
}

# Update dotfiles from repository
dot() {
  emulate -L zsh
  local dotfiles_dir="$HOME/.dotfiles"
  echo "Starting dotfiles update process"
  
  cd "$dotfiles_dir" || {
    echo "Could not find the .dotfiles directory!" >&2
    return 1
  }
  
  echo "Pulling latest changes from git repository..."
  git pull --quiet && echo "Repository updated."
  
  if (( $+commands[stow] )); then
    echo "Restowing dotfiles using GNU Stow..."
    stow . && echo "Dotfiles stowed successfully."
  else
    echo "GNU Stow not installed! Please install it to continue." >&2
  fi
  
  cd "$HOME" || {
    echo "Could not return to the home directory!" >&2
    return 1
  }
  echo "Dotfiles update process completed."
}

# System update utility
up() {
  emulate -L zsh
  case "$(uname)" in
    Linux)
      if [[ -n "$TERMUX_VERSION" ]]; then
        pkg update && pkg upgrade -y
      else
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
      fi
      ;;
  esac
  if (( $+commands[brew] )); then
    brew update && brew upgrade && brew cleanup
  fi
}

# Composer with auto-loaded auth
composer() {
  if [[ -z "$COMPOSER_AUTH" && -f "$COMPOSER_PATH/auth.json" ]]; then
    export COMPOSER_AUTH="$(<"$COMPOSER_PATH/auth.json")"
  fi
  command composer "$@"
}

# ─── Tool Initialization (Eager) ───
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# ─── Lazy-loaded Tools ───

# Lazy-load zoxide (z and zi commands)
if (( $+commands[zoxide] )); then
  z() {
    unfunction z zi 2>/dev/null
    eval "$(zoxide init zsh)"
    z "$@"
  }
  zi() {
    unfunction z zi 2>/dev/null
    eval "$(zoxide init zsh)"
    zi "$@"
  }
fi

# Lazy-load goose terminal initialization
if (( $+commands[goose] )); then
  goose() {
    unfunction goose
    eval "$(command goose term init zsh)"
    command goose "$@"
  }
fi

# Lazy-load opencode completion
if (( $+commands[opencode] )); then
  _opencode_load_completion() {
    unfunction _opencode_load_completion
    eval "$(command opencode completion zsh)"
  }
  compctl -K _opencode_load_completion opencode
fi

# Lazy-load direnv
if (( $+commands[direnv] )); then
  _direnv_hook() {
    unfunction _direnv_hook
    eval "$(direnv hook zsh)"
    _direnv_hook
  }
  typeset -ag precmd_functions
  precmd_functions+=(_direnv_hook)
fi

# ─── Antigen Plugin Manager ───
ANTIGEN="$HOME/antigen.zsh"
ANTIGEN_VERSION="v2.2.3"
ANTIGEN_SHA256="3d0261e1f00decf59b04555ef5696cb7008b924b92d8d82fd70914121c1eb7ae"
if [[ ! -f "$ANTIGEN" ]]; then
  local tmp_antigen="/tmp/antigen_$$.zsh"
  curl -sSL "https://raw.githubusercontent.com/zsh-users/antigen/${ANTIGEN_VERSION}/bin/antigen.zsh" -o "$tmp_antigen"
  local actual_sha256="$(sha256sum "$tmp_antigen" 2>/dev/null || shasum -a 256 "$tmp_antigen" | cut -d' ' -f1)"
  if [[ "$actual_sha256" == "$ANTIGEN_SHA256"* ]]; then
    mv "$tmp_antigen" "$ANTIGEN"
  else
    echo "Antigen checksum mismatch! Expected: $ANTIGEN_SHA256, Got: $actual_sha256" >&2
    rm -f "$tmp_antigen"
  fi
fi
if [[ -f "$ANTIGEN" ]]; then
  source "$ANTIGEN"
  antigen use oh-my-zsh
  antigen bundle git
  # antigen bundle jeffreytse/zsh-vi-mode
  antigen bundle tmux
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zdharma-continuum/fast-syntax-highlighting
  antigen apply
fi

