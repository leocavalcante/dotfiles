# ─── Early Setup ───
typeset -U PATH path

# ─── Environment Variables ───
export LANG="en_US.UTF-8"
export COLORTERM="truecolor"
export COMPOSE_BAKE="true"
export EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
export KUBE_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export XDG_CONFIG_HOME="$HOME/.config/"
export GPG_TTY=$(tty)

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
alias gd="git diff-all"
alias stk="starship toggle kubernetes"
alias python="python3"
alias pip="pip3"
alias lg="lazygit"
alias k="kubectl"
alias ktx="kubectx"
alias kns="kubens"
alias cl="clear"
alias agenda="gcalcli agenda"
alias todo="nb todos add"
alias todos="nb todos list"

# ─── Functions ───
co() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-sonnet-4.6
}

coco() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-sonnet-4.6 --continue
}

coha() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-haiku-4.5
}

cohaco() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-haiku-4.5 --continue
}

copus() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-opus-4.6
}

copusco() {
  copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$@" --model claude-opus-4.6 --continue
}

ico() {
  copilot --yolo --disable-builtin-mcps --model claude-sonnet-4.6
}

icoco() {
  copilot --yolo --disable-builtin-mcps --model claude-sonnet-4.6 --continue
}

icopus() {
  copilot --yolo --disable-builtin-mcps --model claude-opus-4.6
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
# Starship is initialized after zsh-vi-mode via zvm_after_init_commands
# to avoid recursive zle-keymap-select conflicts.
if (( $+commands[starship] )); then
  zvm_after_init_commands+=('eval "$(starship init zsh)"')
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

# ─── zsh-vi-mode Configuration ───
ZVM_VI_INSERT_ESCAPE_BINDKEY='^['

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
  # Skip OMZ's unconditional compinit; we run it ourselves with caching below
  skip_global_compinit=1
  source "$ANTIGEN"
  antigen use oh-my-zsh
  antigen bundle git
  antigen bundle jeffreytse/zsh-vi-mode
  antigen bundle tmux
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zdharma-continuum/fast-syntax-highlighting
  antigen apply
  # Run compinit only if the dump is older than 24 hours
  autoload -Uz compinit
  local _zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n $_zcompdump(#qN.mh+24) ]]; then
    compinit -d "$_zcompdump"
    touch "$_zcompdump"
  else
    compinit -C -d "$_zcompdump"
  fi
fi

