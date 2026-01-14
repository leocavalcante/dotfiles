# ~/.dotfiles

Personal development environment with AI-powered workflows and unified GitHub Dark theme.

## Features

- **AI-First Development** - Deep integration with Claude Code, OpenCode, Goose, and GitHub Copilot with support for local API proxies and AWS Bedrock
- **Unified GitHub Dark Theme** - Custom colorscheme consistently applied across Neovim, tmux, kitty, Alacritty, Starship, and terminal apps
- **Performance-Optimized Zsh** - Aggressive lazy-loading, caching, and startup optimizations (30-80ms reduction)
- **DevOps-Focused tmux** - Status bar displays Kubernetes context, AWS profile, git branch, and battery info
- **Modern Neovim Setup** - 24 plugins with LSP support for Go, PHP, Lua, and Markdown; Git integration; Copilot; Database client
- **Cross-Platform** - Works on macOS (Homebrew), Linux (apt), and Termux

## What's Included

| Component | Purpose |
|-----------|---------|
| **Zsh** (`.zshrc`) | Shell with 10 custom functions, Antigen plugin manager, 6 curated plugins |
| **Neovim** (`.config/nvim/`) | Modern editor with LSP, fuzzy finder, file explorer, AI copilot |
| **tmux** (`.tmux.conf`) | Terminal multiplexer with DevOps status bar and vim integration |
| **Git** (`.gitconfig`) | Delta pager, LFS support, GitHub Dark theme |
| **Terminal Apps** | Alacritty, Kitty, and Starship prompt configs |
| **Emacs** (`.emacs.d/`) | Minimal setup with LSP, Copilot, database client |
| **AI Configs** | Claude Code (`.claude/`), OpenCode, Gemini with instructions and skills |
| **Themes** | GitHub Dark Default exports for iTerm2 and Windows Terminal |

## Quick Start

**Prerequisites:**
- Git
- Zsh shell
- GNU Stow

**Install:**
```bash
cd ~/.dotfiles
stow .
```

This creates symlinks from the repository to `$HOME`. First run will auto-install Antigen plugins and Neovim plugins on first launch.

## Key Bindings Quick Reference

### Zsh
- `<leader>` in Neovim = `Space`
- `C-Space` = tmux prefix
- `C-h/j/k/l` = navigation (works across Neovim + tmux seamlessly)

### Neovim (Leader = Space)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>hm` - Mark file (harpoon)
- `<leader>hn/hp` - Next/previous mark
- `<leader>t` - Toggle file explorer
- `jj` - Exit insert mode

### tmux
- `prefix + j` - Split horizontal
- `prefix + l` - Split vertical
- `prefix + s` - Session picker
- `prefix + C-h/j/k/l` - Resize panes

## Theme

**GitHub Dark Default** - Unified across all tools

```
Background: #0d1117
Foreground: #e6edf3
Red:        #ff7b72 (errors, keywords)
Green:      #3fb950 (success, tags)
Yellow:     #d29922 (warnings)
Blue:       #58a6ff (constants)
Purple:     #bc8cff (functions)
Cyan:       #39c5cf (strings)
```

Theme exports available for iTerm2 (`themes/iterm2.itermcolors`) and Windows Terminal (`themes/windows-terminal.json`).

## Architecture

- **Stow Management** - Symlinks managed via GNU Stow (`.stow-local-ignore` excludes docs and local configs)
- **Plugin Managers** - Antigen (Zsh), lazy.nvim (Neovim), TPM (tmux), straight.el (Emacs)
- **LSP** - lsp-zero (Neovim), Mason for auto-install
- **Dotfiles Public** - Repository at [github.com/leocavalcante/dotfiles](https://github.com/leocavalcante/dotfiles)

## Documentation

- **`AGENTS.md`** - Comprehensive guide for AI agents and detailed configuration reference
- **`CLAUDE.md`** - Pointer to AGENTS.md (single source of truth for AI instructions)
- **`.claude/CLAUDE.md`** - User profile, git workflow, and commit preferences

## License

MIT License (2022-2025) - Leo Cavalcante
