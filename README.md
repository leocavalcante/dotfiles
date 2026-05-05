# ~/.dotfiles

Personal development environment with AI-powered workflows and unified Gruvbox Dark theme.

## Features

- **AI-First Development** - Deep integration with Claude Code, GitHub Copilot CLI, OpenCode, Goose, and Gemini with extensive shell wrapper functions
- **Unified Gruvbox Dark Theme** - Consistently applied across Neovim, tmux, Kitty, Alacritty, and git-delta
- **Performance-Optimized Shells** - Zsh and Fish with aggressive lazy-loading, caching, and startup optimizations
- **DevOps-Focused tmux** - Status bar displays Kubernetes context, AWS profile, and git branch; 11 plugins including session persistence and fuzzy search
- **Modern Neovim Setup** - 27 plugins with LSP support for Go, PHP, Lua, TypeScript, Python, Rust, YAML, JSON, and Markdown; Git integration; Copilot; Database client; Wakatime
- **Cross-Platform** - Works on macOS (Homebrew), Linux (apt), and Termux

## What's Included

| Component | Purpose |
|-----------|---------|
| **Zsh** (`.zshrc`) | Shell with 13 custom functions, Antigen plugin manager, 7 curated plugins |
| **Fish** (`.config/fish/`) | Alternative shell with identical tooling: vi bindings, Starship, zoxide, direnv, Goose |
| **Neovim** (`.config/nvim/`) | Modern editor with LSP, fuzzy finder, file explorer, AI copilot, Wakatime |
| **tmux** (`.tmux.conf`) | Terminal multiplexer with DevOps status bar, session persistence, and vim integration |
| **Git** (`.gitconfig`) | Delta pager with Gruvbox Dark theme, LFS support, diff-all alias |
| **Terminal Apps** | Alacritty (`.alacritty.toml`), Kitty (`.config/kitty/`), Starship (`.config/starship.toml`) |
| **Emacs** (`.emacs.d/`) | Minimal setup with LSP, Copilot, and completions |
| **AI Configs** | Claude Code (`.claude/`), GitHub Copilot (`.copilot/`), OpenCode (`.config/opencode/`), Gemini (`.gemini/`) |
| **DevOps Tools** | k9s (`.config/k9s/`), lazygit (`.config/lazygit/`), bat (`.config/bat/`) |
| **Themes** | Gruvbox Dark/Light, Solarized Dark/Light exports for iTerm2 and Windows Terminal |

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

## AI Shell Wrappers

The Zsh and Fish configs include Copilot CLI shortcut functions:

| Function | Description |
|----------|-------------|
| `co <prompt>` | Copilot CLI with Claude Sonnet (streaming, yolo mode) |
| `coco <prompt>` | Same as `co` with `--continue` flag |
| `coha <prompt>` | Copilot CLI with Claude Haiku (fast/cheap) |
| `cohaco <prompt>` | Same as `coha` with `--continue` flag |
| `copus <prompt>` | Copilot CLI with Claude Opus (premium) |
| `copusco <prompt>` | Same as `copus` with `--continue` flag |
| `ico` | Interactive Copilot CLI (Sonnet) |
| `icoco` | Interactive Copilot CLI (Sonnet) with `--continue` |
| `icopus` | Interactive Copilot CLI (Opus) |

## Key Bindings Quick Reference

### Neovim (Leader = Space)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>hm` - Mark file (harpoon)
- `<leader>hn/hp` - Next/previous mark
- `<leader>t` - Toggle file explorer
- `jj` - Exit insert mode

### tmux (Prefix = `C-Space`)
- `C-h/j/k/l` - Navigate panes (no prefix, works across Neovim + tmux)
- `prefix + h` - Split horizontally
- `prefix + l` - Split vertically
- `prefix + j` - Previous window
- `prefix + k` - Next window
- `prefix + s` - Session picker (sessionx)
- `prefix + C-h/j/k/l` - Resize panes

## Theme

**Gruvbox Dark** - Unified across all tools

```
Background: #282828
Foreground: #ebdbb2
Red:        #cc241d / #fb4934 (bright)
Green:      #98971a / #b8bb26 (bright)
Yellow:     #d79921 / #fabd2f (bright)
Blue:       #458588 / #83a598 (bright)
Magenta:    #b16286 / #d3869b (bright)
Cyan:       #689d6a / #8ec07c (bright)
```

Theme exports available for iTerm2 (`themes/iterm2.itermcolors`), Windows Terminal (`themes/windows-terminal.json`), and multiple variants (`gruvbox-dark`, `gruvbox-light`, `solarized-dark`, `solarized-light`).

## Architecture

- **Stow Management** - Symlinks managed via GNU Stow (`.stow-local-ignore` excludes docs and local configs)
- **Plugin Managers** - Antigen (Zsh), lazy.nvim (Neovim), TPM (tmux), straight.el (Emacs)
- **LSP** - Mason for auto-install (9 servers: gopls, ts_ls, pylsp, rust_analyzer, phpactor, lua_ls, marksman, yamlls, jsonls); auto-organizes Go imports on save
- **tmux Plugins** - 11 plugins: kubectx display, vim-tmux-navigator, extrakto, sessionx, fzf, continuum (auto-restore), open, prefix-highlight, resurrect, yank, TPM
- **Dotfiles Public** - Repository at [github.com/leocavalcante/dotfiles](https://github.com/leocavalcante/dotfiles)

## Documentation

- **`.config/opencode/AGENTS.md`** - Comprehensive guide for AI agents and detailed configuration reference
- **`.claude/CLAUDE.md`** - User profile, git workflow, and commit preferences

## License

MIT License (2022-2026) - Leo Cavalcante
