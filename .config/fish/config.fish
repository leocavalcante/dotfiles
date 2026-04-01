# ─── Environment Variables ───
set -gx LANG en_US.UTF-8
set -gx COMPOSE_BAKE true
set -gx EDITOR nvim
set -gx GIT_EDITOR $EDITOR
set -gx KUBE_EDITOR $EDITOR
set -gx SUDO_EDITOR $EDITOR
set -gx PAGER "delta --navigate"
set -gx XDG_CONFIG_HOME $HOME/.config/
set -gx GPG_TTY (tty)

# PHP
set -gx COMPOSER_PATH $HOME/.config/composer

# Go
set -q GOPATH; or set -gx GOPATH $HOME/go
set -gx GOBIN $GOPATH/bin

# ─── PATH Configuration ───
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/composer/vendor/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.bun/bin

# Termux-specific
if set -q TERMUX_VERSION
    fish_add_path $HOME/.opencode/bin
end

# ─── Aliases ───
alias l "eza --all --icons --git"
alias ll "eza --long --all --icons --git"
alias push "git push"
alias gd "git diff-all"
alias stk "starship toggle kubernetes"
alias python python3
alias pip pip3
alias lg lazygit
alias k kubectl
alias ktx kubectx
alias kns kubens

# ─── Interactive Shell Setup ───
if status is-interactive
    # Vi key bindings (replaces zsh-vi-mode)
    fish_vi_key_bindings

    # Starship prompt
    if command -q starship
        starship init fish | source
    end

    # Zoxide (z and zi commands)
    if command -q zoxide
        zoxide init fish | source
    end

    # Direnv
    if command -q direnv
        direnv hook fish | source
    end

    # Goose
    if command -q goose
        goose term init fish | source
    end
end
