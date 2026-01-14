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

# ─── History ───
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# PHP
export COMPOSER_PATH="$HOME/.config/composer"

# ─── PATH Configuration ───
path=(
  "$HOME/.local/bin"
  "$HOME/.config/composer/vendor/bin"
  $path
)

# Go (only if installed)
if command -v go >/dev/null 2>&1; then
  export GOPATH="${GOPATH:-$HOME/go}"
  export GOBIN="$GOPATH/bin"
  path+=("$GOBIN")
fi

# Bun (only if installed)
[[ -d "$HOME/.bun/bin" ]] && path+=("$HOME/.bun/bin")

# Termux-specific
[[ -n "$TERMUX_VERSION" ]] && path=("$HOME/.opencode/bin" $path)

# ─── Aliases ───
alias l="eza --all --icons --git"
alias ls="eza --all --icons --git"
alias ll="eza --long --all --icons --git"
alias h="cd ~"
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
  emulate -L zsh
  local anthropic_url="http://localhost:4141"
  export ANTHROPIC_BASE_URL="$anthropic_url"
  export ANTHROPIC_API_URL="$anthropic_url"
  export ANTHROPIC_API_BASE="$anthropic_url"
  export ANTHROPIC_API_KEY="copilot-api"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4.5"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4.5"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4.5"
  export ANTHROPIC_MODEL="claude-sonnet-4.5"
  export ANTHROPIC_SMALL_FAST_MODEL="claude-haiku-4.5"
  export DISABLE_NON_ESSENTIAL_MODEL_CALLS="1"
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
  echo "Copilot API enabled"
}

# Disable Anthropic Copilot API
disable_copilot_api() {
  emulate -L zsh
  unset ANTHROPIC_BASE_URL ANTHROPIC_API_URL ANTHROPIC_API_BASE ANTHROPIC_API_KEY
  unset ANTHROPIC_DEFAULT_HAIKU_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_OPUS_MODEL
  unset ANTHROPIC_MODEL ANTHROPIC_SMALL_FAST_MODEL
  unset DISABLE_NON_ESSENTIAL_MODEL_CALLS CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
  echo "Copilot API disabled"
}

# Enable AWS Bedrock
enable_bedrock() {
  emulate -L zsh
  export CLAUDE_CODE_USE_BEDROCK="1"
  export AWS_REGION="us-east-1"
  export ANTHROPIC_MODEL="global.anthropic.claude-sonnet-4-5-20250929-v1:0"
  export ANTHROPIC_SMALL_FAST_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"
  echo "Bedrock enabled"
}

# Disable AWS Bedrock
disable_bedrock() {
  emulate -L zsh
  unset CLAUDE_CODE_USE_BEDROCK AWS_REGION ANTHROPIC_MODEL ANTHROPIC_SMALL_FAST_MODEL
  echo "Bedrock disabled"
}

# Update dotfiles from repository
dot() {
  emulate -L zsh
  local dotfiles_dir="$HOME/.dotfiles"
  echo "Starting dotfiles update process..."
  
  cd "$dotfiles_dir" || {
    echo "Could not find the .dotfiles directory!"
    return 1
  }
  
  echo "Pulling latest changes from git repository..."
  if ! git pull --quiet; then
    echo "Failed to pull latest changes from git!"
    cd "$HOME"
    return 1
  fi
  echo "Repository updated."
  
  if command -v stow >/dev/null 2>&1; then
    echo "Restowing dotfiles using GNU Stow..."
    if stow .; then
      echo "Dotfiles stowed successfully."
    else
      echo "Failed to stow dotfiles!"
      cd "$HOME"
      return 1
    fi
  else
    echo "GNU Stow not installed! Please install it to continue."
    cd "$HOME"
    return 1
  fi
  
  cd "$HOME" || echo "Could not return to the home directory!"
  echo "Dotfiles update process completed."
}

# System update utility
up() {
  emulate -L zsh
  if [[ "$(uname)" == "Linux" ]]; then
    if [[ -n "$TERMUX_VERSION" ]]; then
      pkg update && pkg upgrade -y
    else
      sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    fi
  fi
  command -v brew >/dev/null 2>&1 && brew update && brew upgrade && brew cleanup
}

# Composer with auto-loaded auth
composer() {
  emulate -L zsh
  command composer "$@"
}

# Cache Composer auth on startup if available
if [[ -f "$COMPOSER_PATH/auth.json" ]]; then
  export COMPOSER_AUTH="$(<"$COMPOSER_PATH/auth.json")"
fi

# ─── Tool Initialization (Cached) ───
_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$_zsh_cache_dir" ]] || mkdir -p "$_zsh_cache_dir"

# Zoxide with lazy-load
if command -v zoxide >/dev/null 2>&1; then
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

# Starship with cache invalidation
if command -v starship >/dev/null 2>&1; then
  _starship_bin="$(command -v starship)"
  _starship_version="$(starship --version 2>/dev/null | head -1)"
  _starship_cache="$_zsh_cache_dir/starship_init.zsh"
  _starship_hash="$_zsh_cache_dir/starship.hash"
  if [[ ! -f "$_starship_cache" ]] || [[ "$_starship_bin" -nt "$_starship_cache" ]] || \
     [[ ! -f "$_starship_hash" ]] || [[ "$_starship_version" != "$(<"$_starship_hash")" ]]; then
    starship init zsh > "$_starship_cache"
    echo "$_starship_version" > "$_starship_hash"
  fi
  source "$_starship_cache"
  unset _starship_bin _starship_version _starship_cache _starship_hash
fi

unset _zsh_cache_dir

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
  opencode() {
    unfunction opencode
    eval "$(command opencode completion zsh)"
    command opencode "$@"
  }
fi

# ─── Completion System ───
autoload -Uz compinit
# Rebuild completion cache if older than 24 hours
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ─── Antigen Plugin Manager ───
ANTIGEN="$HOME/antigen.zsh"
if [[ ! -f "$ANTIGEN" ]]; then
  echo "📥 Downloading Antigen plugin manager..."
  if ! curl -sSL https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh -o "$ANTIGEN"; then
    echo "⚠️ Failed to download Antigen. Some shell features may be unavailable."
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

