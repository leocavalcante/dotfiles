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
alias gpt="chatgpt"
alias l="eza --all --icons --git"
alias ls="eza --all --icons --git"
alias ll="eza --long --all --icons --git"
alias push="git push"
alias v="vibe"
alias c="clear"
alias h="cd ~ && clear"
alias stk="starship toggle kubernetes"
alias python="python3"
alias pip="pip3"
alias cld="claude --dangerously-skip-permissions"  # ⚠️ Skips permission prompts - use with caution
alias cldp="claude -p"
alias oc="opencode"
alias occ="opencode --continue"

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
  local dotfiles_dir="$HOME/.dotfiles"
  echo "🌟 Starting dotfiles update process! 🌟"
  
  cd "$dotfiles_dir" || {
    echo "⚠️ Could not find the .dotfiles directory!"
    return 1
  }
  
  echo "🔄 Pulling latest changes from git repository..."
  git pull --quiet && echo "✅ Repository updated."
  
  if command -v stow >/dev/null 2>&1; then
    echo "📦 Restowing dotfiles using GNU Stow..."
    stow . && echo "✅ Dotfiles stowed successfully."
  else
    echo "❌ GNU Stow not installed! Please install it to continue."
  fi
  
  cd "$HOME" || echo "⚠️ Could not return to the home directory!"
  echo "🏁 Dotfiles update process completed."
}

# System update utility
up() {
  case "$(uname)" in
    Linux)
      if [[ -n "$TERMUX_VERSION" ]]; then
        pkg update && pkg upgrade -y
      else
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
      fi
      ;;
  esac
  if command -v brew >/dev/null 2>&1; then
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
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ─── Lazy-loaded Tools ───

# Lazy-load goose terminal initialization
if command -v goose >/dev/null 2>&1; then
  goose() {
    unfunction goose
    eval "$(command goose term init zsh)"
    command goose "$@"
  }
fi

# Lazy-load opencode completion
if command -v opencode >/dev/null 2>&1; then
  _opencode_load_completion() {
    unfunction _opencode_load_completion
    eval "$(command opencode completion zsh)"
  }
  compctl -K _opencode_load_completion opencode
fi

# ─── Antigen Plugin Manager ───
ANTIGEN="$HOME/antigen.zsh"
if [[ ! -f "$ANTIGEN" ]]; then
  curl -sSL https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh -o "$ANTIGEN"
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

