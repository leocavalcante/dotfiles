
# HomeLab Mosh sessions do not inherit the GNOME display. Absent on LCPC.
[ -f "$HOME/.config/homelab/session-env.sh" ] && . "$HOME/.config/homelab/session-env.sh"

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

# ─── Aliases ───
alias cl="clear"
alias gd="git diff-all"
alias k="kubectl"
alias kns="kubens"
alias ktx="kubectx"
alias l="eza --all --icons --git"
alias lg="lazygit"
alias ldo="lazydocker"
alias ll="eza --long --all --icons --git"
alias pip="pip3"
alias python="python3"
alias stk="starship toggle kubernetes"
alias cdx="codex --yolo --model gpt-5.6-luna -c model_reasoning_effort=max"
alias cdxe="codex exec --yolo --model gpt-5.6-luna -c model_reasoning_effort=max"
alias csr="cursor agent --yolo --model 'auto-smart[optimize_for=intelligence]'"

# LCPC and Termux both use this to reach the lab. --predict=always is the
# overlap their mosh builds accept; Termux rejects experimental and
# --predict-overwrite.
alias mhome='mosh --predict=always ubuntu -- tmux new-session -A -s 0'

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
    # --no-folding keeps ~/.config a real directory, so machine-local
    # credentials never land inside this public working tree.
    stow --no-folding . && echo "Dotfiles stowed successfully."
  else
    echo "GNU Stow not installed! Please install it to continue." >&2
  fi
  
  cd "$HOME" || {
    echo "Could not return to the home directory!" >&2
    return 1
  }
  echo "Dotfiles update process completed."
}

# Update the private agent harness
agents() {
  emulate -L zsh
  local agents_dir="$HOME/.agents"
  local current_branch
  local worktree_status

  echo "Starting agent harness update process"

  current_branch=$(git -C "$agents_dir" branch --show-current) || {
    echo "Could not inspect the agent harness repository." >&2
    return 1
  }
  if [[ "$current_branch" != "main" ]]; then
    echo "Refusing to update: $agents_dir is not on main (currently ${current_branch:-detached})." >&2
    return 1
  fi

  worktree_status=$(git -C "$agents_dir" status --porcelain) || {
    echo "Could not inspect the agent harness worktree." >&2
    return 1
  }
  if [[ -n "$worktree_status" ]]; then
    echo "Local changes found in $agents_dir; refusing to update." >&2
    return 1
  fi

  echo "Fetching latest changes..."
  git -C "$agents_dir" fetch --quiet origin refs/heads/main:refs/remotes/origin/main || {
    echo "Could not fetch the agent harness repository." >&2
    return 1
  }

  if git -C "$agents_dir" merge-base --is-ancestor HEAD origin/main; then
    git -C "$agents_dir" merge --ff-only --quiet origin/main || {
      echo "Could not fast-forward the agent harness repository." >&2
      return 1
    }
    echo "Repository updated."
  elif git -C "$agents_dir" merge-base --is-ancestor origin/main HEAD; then
    echo "Local repository is already ahead of origin/main; nothing to update."
  else
    echo "Local and remote histories have diverged; refusing to update." >&2
    return 1
  fi

  echo "Agent harness update process completed."
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

# Android's regcomp rejects the `\a` escape in the plugin's zvm_cursor_style
# regex, so every accepted command line prints a compile error. PCRE accepts
# the pattern, and local_options keeps the option from leaking out.
if [[ -n "$TERMUX_VERSION" ]] && zmodload zsh/pcre 2>/dev/null; then
  _zvm_pcre_cursor_style() {
    functions -c zvm_cursor_style zvm_cursor_style_posix_re || return
    zvm_cursor_style() {
      setopt local_options re_match_pcre
      zvm_cursor_style_posix_re "$@"
    }
  }
  zvm_after_init_commands+=('_zvm_pcre_cursor_style')
fi

# ─── Antigen Plugin Manager ───
# A remote shell must not stop on Oh My Zsh's update prompt.
zstyle ':omz:update' mode disabled
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
ANTIGEN="$HOME/antigen.zsh"
ANTIGEN_VERSION="v2.2.3"
ANTIGEN_SHA256="3d0261e1f00decf59b04555ef5696cb7008b924b92d8d82fd70914121c1eb7ae"
# Reuse Antigen compdump; full compinit is slow under proot.
ANTIGEN_COMPINIT_OPTS=(-C -i)
if [[ ! -f "$ANTIGEN" ]]; then
  local tmp_antigen="${TMPDIR:-/tmp}/antigen_$$.zsh"
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

# Machine-local overrides. This file is not in the public dotfiles repo.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
