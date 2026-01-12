# Environment variables
export LANG="en_US.UTF-8"
export COMPOSE_BAKE="true"
export EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT="1"
export OPENCODE_ENABLE_EXA="1"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

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

# Aliases
alias gpt="chatgpt"
alias l="eza --all --icons --git"
alias ls="eza --all --icons"
alias ll="eza --long --all --git --icons"
alias push="git push"
alias v="vibe" 
alias cl="clear"
alias stk="starship toggle kubernetes"
alias python="python3"
alias pip="pip3"
alias cld="claude --allow-dangerously-skip-permissions"
alias cldp="claude -p"
alias oc="opencode"
alias ocp="opencode --prompt"

# Functions
enable_copilot_api() {
  export ANTHROPIC_BASE_URL="http://localhost:4141"
  export ANTHROPIC_API_URL="http://localhost:4141"
  export ANTHROPIC_API_BASE="http://localhost:4141"
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

enable_bedrock() {
  export CLAUDE_CODE_USE_BEDROCK="1"
  export AWS_REGION="us-east-1"
  export ANTHROPIC_MODEL="global.anthropic.claude-sonnet-4-5-20250929-v1:0"
  export ANTHROPIC_SMALL_FAST_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"
  echo "☁️  Bedrock enabled"
}

disable_bedrock() {
  unset CLAUDE_CODE_USE_BEDROCK
  unset AWS_REGION
  unset ANTHROPIC_MODEL
  unset ANTHROPIC_SMALL_FAST_MODEL
  echo "⚫ Bedrock disabled"
}

dot() {
  echo "🌟 Starting dotfiles update process! 🌟"
  cd "$HOME/.dotfiles" || {
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

up() {
  case "$(uname)" in
    Linux)
      if [ -n "$TERMUX_VERSION" ]; then
        pkg update && pkg upgrade -y
      else
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
      fi
      ;;
  esac
  brew update && brew upgrade && brew cleanup
}

# Tools
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v goose >/dev/null 2>&1; then
  eval "$(goose term init zsh)"
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
  # antigen bundle jeffreytse/zsh-vi-mode
  antigen bundle tmux
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
fi


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/data/data/com.termux/files/home/.opencode/bin:$PATH
