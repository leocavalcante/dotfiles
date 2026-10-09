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
| **Terminal Apps** | Alacritty (`.alacritty.toml`, `.config/alacritty/`), Kitty (`.config/kitty/`), Starship (`.config/starship.toml`) |
| **Emacs** (`.emacs.d/`) | Minimal setup with LSP, Copilot, and completions |
| **AI Configs** | Cursor CLI status line (`.config/cursor/statusline.sh`), Claude Code (`.claude/`), GitHub Copilot (`.copilot/`), OpenCode (`.config/opencode/`), Gemini (`.gemini/`) |
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
stow --no-folding .
```

`--no-folding` keeps directories such as `~/.config` real, and symlinks each file. A folded directory would put machine-local credentials inside this public working tree.

This creates symlinks from the repository to `$HOME`. First run will auto-install Antigen plugins and Neovim plugins on first launch.

### Cursor CLI status line

The shared script requires `jq`. Keep Cursor's machine-specific
`.config/cursor/cli-config.json` out of Git and configure each machine with:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.config/cursor/statusline.sh"
  }
}
```

The always-on rule `.cursor/rules/agents.mdc` tells Cursor to read the private
`~/.agents/AGENTS.md`. Only that rules directory is shared. The rest of
`~/.cursor` stays on the machine.

### Pi workers

The subagent extension now lives in its own repository,
[pi-subagents](https://github.com/leocavalcante/pi-subagents). Install it on
each machine with:

```bash
pi install git:github.com/leocavalcante/pi-subagents
```

Remove any old `~/.pi/agent/extensions/subagent` copy or development symlink
before installing the package, then run `/reload` in Pi.

`.pi/agent/agents/worker.md` stays in dotfiles. It defines a general-purpose
worker using `openai-codex/gpt-6-luna:max`. Ask Pi:

```text
Spawn a worker to review the authentication code without changing files.
```

Each worker runs in a separate Pi process with its own context. Workers can
read and change files through the same OS account; context isolation is not
a sandbox. The parent must include relevant context in the delegated task.
Authenticate separately on each machine with `/login`. This configuration
requires a Pi version that supports the model and `max` thinking.

For local extension development, follow the checkout's README. Dotfiles
ignores `~/.pi/agent/extensions`, including any machine-local development
symlink.

Keep `~/.pi/agent` as a real directory and use `stow --no-folding .`.
Git's Pi allowlist includes only reviewed settings, the theme, worker
instructions, and the capture prompt. Authentication, sessions, model caches,
trust decisions, and private `AGENTS.md` instructions stay outside this repo.
Review settings for secrets before committing; an allowlist does not check
file contents.

### Pi session capture

`.pi/agent/prompts/capture.md` adds `/capture` to Pi. After linking dotfiles,
run `/reload`, then use `/capture` before `/quit`. An optional focus works as
`/capture Pi tooling`.

The prompt requires the private `~/.agents` harness and its
`skills/harness/SKILL.md` on each machine. It reviews available session evidence,
promotes supported guidance, and retains uncertain findings. Pi stays open for
review; capture does not run automatically on exit or authorize pushes.

### Alacritty

`.alacritty.toml` imports `.config/alacritty/common.toml` and a machine-local `.config/alacritty/platform.toml`. The reusable macOS and Windows configs under `.config/alacritty/platforms/` are committed. Only the `platform.toml` selector symlink is ignored. Decorations, blur, colors, and the font family are shared. Font size, the shell, and the hint opener are platform-specific.

```bash
# macOS
ln -sfn platforms/macos.toml ~/.dotfiles/.config/alacritty/platform.toml

# Windows
ln -sfn platforms/windows.toml ~/.dotfiles/.config/alacritty/platform.toml
```

Windows Alacritty reads `%APPDATA%\alacritty\alacritty.toml`. Point that file at `~/.alacritty.toml` if it is not already.

### K9s

`.config/k9s/config.yaml` selects `gruvbox-dark` globally for all contexts.
The skin in `.config/k9s/skins/gruvbox-dark.yaml` uses the same soft Gruvbox
palette as Pi (`.pi/agent/themes/gruvbox.json`) and Neovim, with explicit
backgrounds so it does not depend on the device's terminal theme.

On each device, pull dotfiles and run `stow --no-folding .`, then restart K9s.
Keep `K9S_SKIN` unset and remove any context-level `k9s.ui.skin` override to
use the shared global skin. Context files remain machine-local; `k9s info`
shows their location and the active config/skins directories.

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

### tmux (Prefix = `C-Space` on workstations, `C-b` on the home lab)
- `prefix + h/j/k/l` - Select pane left/down/up/right
- `prefix + Ctrl+h/j/k/l` - Previous window (h, k) or next window (j, l)
- `prefix + Shift+h/j/k/l` - Previous session (h, k) or next session (j, l)
- `prefix + s` - Session picker (sessionx)
- `prefix + M-j/M-k` - Resize panes

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
