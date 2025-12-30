# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. Configuration files are symlinked from this directory to the home directory.

**IMPORTANT**: This repository is publicly available at github.com/leocavalcante/dotfiles. Always verify that no sensitive data (API keys, tokens, passwords, credentials, or personal information) is being committed and pushed.

## Installation & Management

```shell
# Install/update symlinks
stow .

# Update dotfiles (pull latest + restow)
dot
```

The `dot` function (defined in `.zshrc`) handles pulling updates and restowing.

## Structure

- `.zshrc` - Zsh configuration with aliases, functions, environment variables, and Antigen plugin management
- `.tmux.conf` - Tmux configuration (prefix: `C-Space`) with vim-style navigation and GitHub Dark theme
- `.config/nvim/` - Neovim configuration using lazy.nvim plugin manager
- `.config/kitty/` - Kitty terminal configuration
- `.config/starship.toml` - Starship prompt configuration
- `.emacs.d/init.el` - Emacs configuration using straight.el package manager

## Neovim Architecture

- `init.lua` - Entry point, bootstraps lazy.nvim, loads settings/keymaps/plugins
- `lua/settings.lua` - Editor settings and colorscheme loading
- `lua/keymaps.lua` - Key mappings (leader: Space)
- `lua/plugins/` - Individual plugin configurations as separate files
- `lua/colors/` - Custom colorscheme definitions

Key plugins: lsp-zero (with Mason for LSP management), telescope, harpoon, neo-tree, treesitter, copilot.

## Theme

GitHub Dark Default theme is used consistently across all tools (Neovim, tmux, kitty, starship).

## Key Bindings

- **Neovim**: `jj` exits insert mode, `Ctrl+h/j/k/l` for window navigation
- **Tmux**: `prefix+j` horizontal split, `prefix+l` vertical split, `Ctrl+h/j/k/l` pane navigation, `prefix+s` session picker (sessionx)
