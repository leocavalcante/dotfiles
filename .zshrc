
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
# K9s under tmux-256color paints #282828 as 256-color #262626. TERM=xterm-256color
# keeps truecolor, so its background matches Alacritty.
alias k9s="TERM=xterm-256color k9s"
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

# Commit local config changes, merge origin/main, and publish without rewriting history.
_sync_config_repo() {
  emulate -L zsh
  local repo_dir="$1" repo_name="$2"
  local current_branch git_dir worktree_status unmerged_files divergence
  local local_head remote_head
  local commit_helper="$HOME/.agents/scripts/git_commit.py"
  local git_helper="$HOME/.dotfiles/scripts/sync_git.py"
  local -a commit_command=(python3 "$commit_helper" --repo-dir "$repo_dir")
  local -a remote_git=(python3 "$git_helper" -C "$repo_dir")
  local -x PYTHONDONTWRITEBYTECODE=1 GIT_TERMINAL_PROMPT=0

  current_branch=$(git -C "$repo_dir" branch --show-current) || return
  if [[ "$current_branch" != "main" ]]; then
    echo "Refusing to sync: $repo_dir is not on main (currently ${current_branch:-detached})." >&2
    return 1
  fi
  git_dir=$(git -C "$repo_dir" rev-parse --absolute-git-dir) || return
  unmerged_files=$(git -C "$repo_dir" ls-files --unmerged) || return
  if [[ -n "$unmerged_files" || -e "$git_dir/MERGE_HEAD" ||
        -e "$git_dir/CHERRY_PICK_HEAD" || -e "$git_dir/REVERT_HEAD" ||
        -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
    echo "Finish the in-progress Git operation in $repo_dir before syncing." >&2
    return 1
  fi
  if [[ ! -f "$commit_helper" || ! -f "$git_helper" ]] || (( ! $+commands[python3] )); then
    echo "Sync requires python3, $commit_helper, and $git_helper." >&2
    return 1
  fi

  echo "Syncing $repo_name..."
  echo "Fetching $repo_name from origin/main (30s deadline)..."
  "${remote_git[@]}" fetch --quiet origin refs/heads/main:refs/remotes/origin/main || return
  worktree_status=$(git -C "$repo_dir" status --porcelain) || return
  if [[ -n "$worktree_status" ]]; then
    git -C "$repo_dir" add --all -- . || return
    git -C "$repo_dir" diff --cached --stat || return
    printf 'chore(%s): sync local changes\n' "$repo_name" |
      "${commit_command[@]}" --message-file - || return
  fi

  divergence=$(git -C "$repo_dir" rev-list --left-right --count HEAD...origin/main) || return
  local -a counts=(${=divergence})
  if (( counts[1] == 0 )); then
    git -C "$repo_dir" merge --ff-only --quiet origin/main || return
  elif (( counts[2] > 0 )); then
    git -C "$repo_dir" merge --no-ff --no-commit origin/main || {
      echo "Resolve and finish the merge in $repo_dir, then retry. Nothing was pushed." >&2
      return 1
    }
    git -C "$repo_dir" diff --cached --stat || return
    printf 'chore(%s): merge remote changes\n' "$repo_name" |
      "${commit_command[@]}" --message-file - --allow-empty || return
  fi

  echo "Verifying $repo_name commits..."
  "${commit_command[@]}" --verify-range origin/main || return
  echo "Pushing $repo_name to origin/main (30s deadline)..."
  "${remote_git[@]}" push origin HEAD:refs/heads/main || return
  local_head=$(git -C "$repo_dir" rev-parse HEAD) || return
  echo "Checking $repo_name remote HEAD (30s deadline)..."
  remote_head=$("${remote_git[@]}" ls-remote --exit-code --heads origin refs/heads/main) || return
  if [[ "${remote_head%%[[:space:]]*}" != "$local_head" ]]; then
    echo "Could not verify $repo_name sync: origin/main differs from HEAD." >&2
    return 1
  fi
  worktree_status=$(git -C "$repo_dir" status --porcelain) || return
  if [[ -n "$worktree_status" ]]; then
    echo "New local changes remain in $repo_dir; run sync again." >&2
    return 1
  fi
  echo "$repo_name synchronized."
}

# Sync dotfiles, then apply their Stow links.
dot() {
  emulate -L zsh
  _sync_config_repo "$HOME/.dotfiles" dotfiles || return
  if (( ! $+commands[stow] )); then
    echo "GNU Stow not installed! Please install it to continue." >&2
    return 1
  fi
  echo "Restowing dotfiles using GNU Stow..."
  # --no-folding keeps ~/.config a real directory, so machine-local
  # credentials never land inside this public working tree.
  stow --dir="$HOME/.dotfiles" --target="$HOME" --no-folding . || return
  echo "Dotfiles update process completed."
}

# Sync the private agent harness.
agents() {
  _sync_config_repo "$HOME/.agents" agents
}

# Update agentic development tools
keep-it-up() {
  emulate -L zsh
  dot && agents || return
  if [[ -n "$TERMUX_VERSION" || "$PREFIX" == /data/data/com.termux/files/usr ]]; then
    # Termux installs Pi through npm, not Pi's managed installer.
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent || return
  else
    pi update || return
  fi
  pi update --extensions
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
