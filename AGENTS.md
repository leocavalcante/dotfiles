# AGENTS.md

This file provides instructions for AI coding agents working with this dotfiles repository.

## Project Overview

This is a personal dotfiles repository for **leocavalcante** (Leo Cavalcante) containing development environment configurations. The repository emphasizes:

- **AI-First Development Workflows** - Deep integration with multiple AI coding tools (Claude Code, OpenCode, Goose, GitHub Copilot) with support for local API proxies and cloud backends
- **Unified GitHub Dark Default Theme** - Custom colorscheme hand-crafted and applied consistently across ALL tools (Neovim, tmux, kitty, Alacritty, Starship, Windows Terminal)
- **Performance-Optimized Zsh Shell** - Aggressive lazy-loading, caching, and optimizations to minimize startup time
- **Multi-Language LSP Support** - Go, PHP, Lua, Markdown with auto-formatting and import organization
- **DevOps-Focused tmux** - Status bar displays Kubernetes context, AWS profile, git branch, battery, and system info
- **GNU Stow Symlink Management** - Clean separation of dotfiles and home directory

## Project Structure

```
.
├── .alacritty.toml                    # Alacritty terminal emulator config
├── .config/
│   ├── git/ignore                     # Global gitignore file
│   ├── kitty/
│   │   ├── kitty.conf                 # Kitty terminal config
│   │   └── current-theme.conf         # Kitty theme (GitHub Dark Default)
│   ├── nvim/
│   │   ├── init.lua                   # Neovim entry point (lazy.nvim bootstrap)
│   │   ├── lazy-lock.json             # Locked plugin versions
│   │   ├── lua/
│   │   │   ├── settings.lua           # Editor settings (tabs, line numbers, etc.)
│   │   │   ├── keymaps.lua            # Key mappings (leader: Space)
│   │   │   ├── colors/github-dark.lua # Custom GitHub Dark colorscheme (323 lines)
│   │   │   └── plugins/               # Individual plugin configurations (12 files)
│   │   │       ├── copilot.lua        # GitHub Copilot AI
│   │   │       ├── dadbod.lua         # Database client (vim-dadbod stack)
│   │   │       ├── harpoon.lua        # Quick file navigation
│   │   │       ├── lsp.lua            # LSP setup (lsp-zero, Mason, nvim-cmp)
│   │   │       ├── lualine.lua        # Statusline
│   │   │       ├── markdown-preview.lua # Markdown live preview
│   │   │       ├── neo-tree.lua       # File explorer
│   │   │       ├── telescope.lua      # Fuzzy finder
│   │   │       ├── treesitter.lua     # Syntax highlighting
│   │   │       ├── vim-be-good.lua    # Vim motions practice game
│   │   │       ├── vim-tmux-navigator.lua # Seamless tmux/vim navigation
│   │   │       └── wakatime.lua       # Coding time tracking
│   │   └── lazyvim.json               # LazyVim compatibility marker
│   ├── opencode/
│   │   └── opencode.json              # OpenCode configuration
│   └── starship.toml                  # Starship prompt with GitHub Dark palette
├── .emacs.d/
│   └── init.el                        # Emacs configuration (straight.el package manager)
├── .claude/
│   ├── CLAUDE.md                      # Claude Code instructions & preferences
│   ├── settings.json                  # Claude Code config (model, permissions, statusline)
│   ├── statusline.sh                  # Claude statusline with context window % & git branch
│   └── skills/creating-skills/        # Claude Code skill creation templates
│       ├── SKILL.md                   # Skill specification
│       ├── SPECIFICATION.md           # Official skill specification
│       └── EXAMPLES.md                # Skill examples
├── .gemini/
│   └── settings.json                  # Google Gemini AI configuration
├── .gitconfig                         # Git configuration (delta pager, GitHub Dark theme, merge conflict style)
├── .gitignore                         # Global gitignore patterns
├── .stow-local-ignore                 # Files to exclude from stow symlink creation
├── .tmux.conf                         # Tmux config (prefix: C-Space, DevOps status bar)
├── .zshrc                             # Zsh shell configuration (main config file, 600+ lines)
├── AGENTS.md                          # This file (AI agent instructions)
├── CLAUDE.md                          # Symlink to .claude/CLAUDE.md
├── opencoder                          # Autonomous OpenCode runner script (817 lines)
├── README.md                          # User-facing documentation
├── LICENSE                            # MIT License (2022-2025)
└── themes/
    ├── iterm2.itermcolors             # iTerm2 GitHub Dark Default theme export
    └── windows-terminal.json          # Windows Terminal GitHub Dark Default theme export
```

## Zsh Shell Configuration

**File:** `~/.zshrc` (600+ lines)

### Custom Functions

All functions use `emulate -L zsh` for consistent behavior and include error handling.

| Function | Purpose | Key Details |
|----------|---------|-------------|
| `enable_copilot_api()` | Route Anthropic API through local Copilot API proxy | Sets `ANTHROPIC_BASE_URL`, model names, key to `"copilot-api"` at `http://localhost:4141` |
| `disable_copilot_api()` | Revert Anthropic API routing | Unsets all Copilot API environment variables |
| `enable_bedrock()` | Enable AWS Bedrock as Claude provider | Sets `CLAUDE_CODE_USE_BEDROCK=1`, `AWS_REGION=us-east-1`, Bedrock model ARNs |
| `disable_bedrock()` | Disable AWS Bedrock | Unsets Bedrock environment variables |
| `dot()` | Update dotfiles from Git repository | `git pull --quiet` + `stow .` to resymlink |
| `up()` | System package update utility | Linux: `apt update/upgrade`; Termux: `pkg update/upgrade`; macOS: `brew update/upgrade` |
| `composer()` | PHP Composer wrapper with lazy auth | Auto-loads `~/.config/composer/auth.json` on first call |
| `z()` | Zoxide directory jumper (lazy-loaded stub) | Self-replacing function that initializes zoxide on first use |
| `zi()` | Zoxide interactive mode (lazy-loaded stub) | Self-replacing function that initializes zoxide on first use |
| `goose()` | Goose AI terminal tool (lazy-loaded stub) | Self-replacing function that initializes Goose on first use |
| `opencode()` | OpenCode CLI tool (lazy-loaded stub) | Self-replacing function that initializes OpenCode completions on first use |

### Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `l` | `eza --all --icons --git` | List all files with eza, icons, and git status |
| `ls` | `eza --all --icons --git` | Same as `l` |
| `ll` | `eza --long --all --icons --git` | Long listing format |
| `h` | `cd ~` | Quick home directory navigation |
| `stk` | `starship toggle kubernetes` | Toggle Kubernetes info in prompt |
| `python` | `python3` | Use Python 3 by default |
| `pip` | `pip3` | Use pip3 by default |
| `cld` | `claude --dangerously-skip-permissions` | Claude CLI without permission prompts |
| `cldp` | `claude -p` | Claude CLI in pipe/print mode |
| `oc` | `opencode` | Short alias for opencode |
| `occ` | `opencode --continue` | Continue previous opencode session |

### Plugin Manager: Antigen

- **Auto-installed** from `https://github.com/zsh-users/antigen` if missing
- **Framework:** oh-my-zsh
- **Plugins:**
  - `git` (oh-my-zsh) - Git aliases and functions
  - `tmux` (oh-my-zsh) - Tmux integration
  - `zsh-autosuggestions` (zsh-users) - Fish-like autosuggestions
  - `zsh-completions` (zsh-users) - Additional completion definitions
  - `zsh-history-substring-search` (zsh-users) - History search by substring
  - `fast-syntax-highlighting` (zdharma-continuum) - Faster syntax highlighting

### Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `LANG` | `en_US.UTF-8` | Locale setting |
| `COMPOSE_BAKE` | `true` | Docker Compose bake feature flag |
| `EDITOR`, `GIT_EDITOR`, `KUBE_EDITOR`, `SUDO_EDITOR` | `nvim` | Default editor for all contexts |
| `OPENCODE_DISABLE_CLAUDE_CODE_PROMPT` | `1` | OpenCode configuration (disable Claude prompt override) |
| `OPENCODE_ENABLE_EXA` | `1` | OpenCode configuration (enable exa integration) |
| `COMPOSER_PATH` | `~/.config/composer` | PHP Composer config directory |
| `GOPATH` | `~/go` (if Go installed) | Go workspace path |
| `GOBIN` | `$GOPATH/bin` | Go binary installation path |

### PATH Configuration

Priority order (first has highest precedence):
1. `~/.local/bin` - Local user binaries
2. `~/.config/composer/vendor/bin` - PHP Composer global packages
3. Original `$path` entries
4. `~/go/bin` - Go binaries (conditional: only if `go` exists)
5. `~/.bun/bin` - Bun runtime (conditional: only if exists)
6. `~/.opencode/bin` - OpenCode binaries (conditional: Termux only)

**Deduplication:** `typeset -U PATH path` prevents duplicate entries.

### Optimization Techniques

| Optimization | Technique | Benefit |
|--------------|-----------|---------|
| **Lazy-loading** | Stub functions (z, zi, goose, opencode) that self-replace on first use | Reduces startup time by 20-50ms |
| **Caching** | Starship init script cached to `~/.cache/zsh/starship_init.zsh`, invalidated when binary changes | Saves 10-30ms per shell launch |
| **Hash lookups** | `(( $+commands[cmd] ))` instead of `command -v` subprocesses | Faster command availability checks |
| **Compinit optimization** | Uses `(#qN.mh+24)` glob qualifier to rebuild completion cache only if >24 hours old | Skips expensive rebuilds on every shell start |
| **Cached uname** | `_UNAME="$(uname)"` called once | Avoids repeated subprocess calls |
| **Composer lazy-load** | Auth file loaded only when `composer()` function is called | Reduces startup when not using Composer |

**Result:** Zsh startup time reduced by 30-80ms through these optimizations (Jan 14, 2026).

### History Configuration

- **Size:** 50,000 entries (HISTSIZE and SAVEHIST)
- **Options:**
  - `HIST_IGNORE_DUPS` - Don't store consecutive duplicates
  - `HIST_FIND_NO_DUPS` - Don't show duplicates when searching
  - `HIST_IGNORE_SPACE` - Commands starting with space aren't saved
  - `SHARE_HISTORY` - Share history between sessions
  - `EXTENDED_HISTORY` - Save timestamps
  - `INC_APPEND_HISTORY` - Append to history immediately
  - `APPEND_HISTORY` - Append instead of replace

## Neovim Configuration

**File:** `~/.config/nvim/`

### Plugin Manager: lazy.nvim

- **Bootstrap:** Clones from GitHub with `--filter=blob:none` if missing at `~/.local/share/nvim/lazy/lazy.nvim`
- **Auto-discovery:** Loads all files from `lua/plugins/` directory automatically

### Installed Plugins (24 total)

| Plugin | Purpose |
|--------|---------|
| `folke/lazy.nvim` | Plugin manager (self-managed) |
| `VonHeikemen/lsp-zero.nvim` (v3.x) | LSP configuration helper |
| `williamboman/mason.nvim` | LSP/tool installer |
| `williamboman/mason-lspconfig.nvim` | Mason-LSP integration |
| `neovim/nvim-lspconfig` | LSP client configurations |
| `hrsh7th/nvim-cmp` | Autocompletion engine |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `nvim-telescope/telescope.nvim` (0.1.8) | Fuzzy finder (files, grep, buffers, help) |
| `nvim-lua/plenary.nvim` | Lua utility library |
| `ThePrimeagen/harpoon` | Quick file navigation |
| `nvim-neo-tree/neo-tree.nvim` (v3.x) | File explorer with dotfiles support |
| `nvim-tree/nvim-web-devicons` | File icons |
| `MunifTanjim/nui.nvim` | UI component library |
| `nvim-treesitter/nvim-treesitter` | Advanced syntax highlighting |
| `github/copilot.vim` | GitHub Copilot AI code completion |
| `nvim-lualine/lualine.nvim` | Statusline with mode indicators |
| `christoomey/vim-tmux-navigator` | Seamless tmux/vim pane navigation |
| `tpope/vim-dadbod` | Database interaction client |
| `kristijanhusak/vim-dadbod-ui` | Database UI |
| `kristijanhusak/vim-dadbod-completion` | Database autocompletion |
| `iamcco/markdown-preview.nvim` | Markdown live preview |
| `wakatime/vim-wakatime` | Coding time tracking |
| `ThePrimeagen/vim-be-good` | Vim motions practice game |

### Key Bindings

**Leader Key:** `Space`

#### Core Navigation
| Mode | Key | Action |
|------|-----|--------|
| Normal | `<C-h>` | Move focus to left window |
| Normal | `<C-j>` | Move focus to lower window |
| Normal | `<C-k>` | Move focus to upper window |
| Normal | `<C-l>` | Move focus to right window |
| Insert | `jj` | Exit insert mode |

#### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (includes hidden, excludes .git/.venv) |
| `<leader>fg` | Live grep (search file contents) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help documentation |

#### Harpoon (Quick Navigation)
| Key | Action |
|-----|--------|
| `<leader>hm` | Mark current file |
| `<leader>hn` | Go to next harpoon mark |
| `<leader>hp` | Go to previous harpoon mark |
| `<leader>ha` | Show harpoon marks menu |

#### Neo-tree (File Explorer)
| Key | Action |
|-----|--------|
| `<leader>t` | Toggle file explorer |

#### Tmux Navigator
| Key | Action |
|-----|--------|
| `<C-h>` | Navigate left (tmux pane or vim split) |
| `<C-j>` | Navigate down |
| `<C-k>` | Navigate up |
| `<C-l>` | Navigate right |
| `<C-\>` | Navigate to previous pane |

#### LSP (Default Bindings)
| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | References |
| `gs` | Signature help |
| `<F2>` | Rename |
| `<F3>` | Format |
| `<F4>` | Code action |
| `gl` | Show diagnostics |
| `[d` / `]d` | Navigate diagnostics |

### LSP Setup

**Language Servers (auto-installed via Mason):**
- `lua_ls` - Lua
- `phpactor` - PHP
- `marksman` - Markdown
- `gopls` - Go

**Go-specific:** Auto-organizes imports and formats on save

**Completion:** nvim-cmp with LSP source, LuaSnip for snippets

### Custom GitHub Dark Colorscheme

**File:** `lua/colors/github-dark.lua` (323 lines)

Hand-crafted custom colorscheme with full coverage:
- Editor UI elements (cursor, selection, statusline, etc.)
- Syntax highlighting (all token types)
- Treesitter captures
- LSP semantic tokens
- Plugin-specific highlight groups (Telescope, Neo-tree, Cmp, Mason, etc.)

**Color Palette:**

| Name | Hex | Usage |
|------|-----|-------|
| bg | `#0d1117` | Main background |
| bg_highlight | `#161b22` | Float backgrounds |
| bg_visual | `#264f78` | Visual selection |
| border | `#30363d` | Window borders |
| fg | `#e6edf3` | Main text |
| fg_muted | `#8b949e` | Muted text |
| fg_subtle | `#6e7681` | Subtle text (comments) |
| red | `#ff7b72` | Errors, keywords |
| orange | `#ffa657` | Numbers, types |
| yellow | `#d29922` | Warnings |
| green | `#3fb950` | Success, tags |
| cyan | `#39c5cf` | Strings |
| blue | `#58a6ff` | Constants, info |
| purple | `#bc8cff` | Functions |

### Editor Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| `clipboard` | `unnamedplus` | System clipboard integration |
| `expandtab` | `true` | Use spaces instead of tabs |
| `tabstop` | `4` | Tab display width |
| `shiftwidth` | `4` | Indent width |
| `number` | `true` | Show line numbers |
| `relativenumber` | `true` | Show relative line numbers |
| `cursorline` | `true` | Highlight current line |
| `scrolloff` | `10` | Keep 10 lines visible above/below cursor |
| `splitbelow` | `true` | New horizontal splits below |
| `splitright` | `true` | New vertical splits to right |
| `smartcase` | `true` | Case-sensitive if uppercase in search |
| `ignorecase` | `true` | Case-insensitive search default |
| `undofile` | `true` | Persistent undo history |
| `termguicolors` | `true` | 24-bit color support |
| `mouse` | `'a'` | Enable mouse in all modes |
| `breakindent` | `true` | Wrapped lines respect indent |

## Tmux Configuration

**File:** `.tmux.conf`

### Prefix Key
`Ctrl + Space` (replaces default `Ctrl + B`)

### Plugins (TPM - Tmux Plugin Manager)

| Plugin | Purpose |
|--------|---------|
| `tmux-plugins/tpm` | Tmux Plugin Manager bootstrapper |
| `tony-sol/tmux-kubectx` | Kubernetes context display |
| `christoomey/vim-tmux-navigator` | Seamless vim/tmux pane navigation |
| `omerxx/tmux-sessionx` | Enhanced session management with fuzzy finder |
| `tmux-plugins/tmux-prefix-highlight` | Shows when prefix is active |
| `tmux-plugins/tmux-yank` | System clipboard integration for copy mode |

### Key Bindings

#### Pane Navigation (No prefix required)
| Binding | Action |
|---------|--------|
| `C-h` | Select pane left |
| `C-j` | Select pane down |
| `C-k` | Select pane up |
| `C-l` | Select pane right |

#### Pane Splitting (Prefix required)
| Binding | Action |
|---------|--------|
| `prefix + j` | Split window horizontally |
| `prefix + l` | Split window vertically |

#### Pane Resizing (Prefix required, repeatable)
| Binding | Action |
|---------|--------|
| `prefix + C-h` | Resize left by 2 |
| `prefix + C-j` | Resize down by 2 |
| `prefix + C-k` | Resize up by 2 |
| `prefix + C-l` | Resize right by 2 |

#### Sessions
| Binding | Action |
|---------|--------|
| `prefix + s` | Session picker (sessionx) |

### Status Bar

**Position:** Top

**Theme:** GitHub Dark Default colors

**Content (left to right):**
1. Session name (blue background)
2. Prefix highlight indicator
3. Git branch (purple)
4. AWS profile (orange)
5. Kubernetes context (blue, ⎈ symbol)
6. Current directory basename
7. Date (DD/MM, weekday)
8. Time (HH:MM)
9. Battery percentage (green, %, macOS-specific)

**Terminal:** `tmux-256color` with true color (RGB) support enabled

## Git Configuration

**File:** `.gitconfig` (with include of `~/.gitconfig.local`)

### Core Features

**Pager:** Delta (syntax-highlighted diffs)
**Merge Conflict Style:** diff3 (shows base version)
**Diff Highlighting:** Moved lines shown with distinct colors

### Delta Configuration (GitHub Dark Theme)

| Element | Color |
|---------|-------|
| Deletions (minus) | Background `#3d2028`, text `#ff7b72` (red) |
| Additions (plus) | Background `#244032`, text `#3fb950` (green) |
| Hunk header | `#161b22` background |
| File names | `#58a6ff` (blue) |
| Commit hash | `#d29922` (yellow) |

**Features:**
- Line numbers enabled
- Navigation with `n`/`N` between sections
- Interactive staging with `git add -p` uses delta

### Push/Pull Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| `push.autoSetupRemote` | `true` | Auto-setup remote on first push (no need for `-u`) |
| `pull.rebase` | `false` | Use merge strategy instead of rebase |

### Git LFS Integration

Full Git LFS support for large binary files configured.

## Terminal Configurations

### Alacritty (.alacritty.toml)

| Setting | Value |
|---------|-------|
| Font | JetBrainsMono Nerd Font Mono, size 12 |
| Window padding | 10x10 |
| Decorations | Buttonless |
| Opacity | 95% (translucent) |
| Blur | Enabled |

### Kitty (.config/kitty/)

| Setting | Value |
|---------|-------|
| Font | JetBrainsMono Nerd Font Mono, size 12.0 |
| Theme | GitHub Dark Default (custom palette) |
| Colors | 16 ANSI colors defined |

### Starship Prompt (.config/starship.toml)

| Module | Configuration |
|--------|---------------|
| **directory** | Truncate 2 levels, bold style |
| **git_branch** | Purple color |
| **git_status** | Disabled |
| **cmd_duration** | Shows milliseconds, yellow, min_time: 0 |
| **character** | Green `❯` success, red `❯` error |
| **nodejs** | Auto-detects package.json, node_modules |
| **timeout** | 3000ms |
| **Most modules** | Disabled (kubernetes, aws, docker_context, package, username) |

**Custom Palette:** GitHub Dark Default colors extracted and defined inline

## Emacs Configuration

**File:** `.emacs.d/init.el`

**Package Manager:** straight.el (v7, bootstrapped from radian-software)

### Installed Packages

| Package | Purpose |
|---------|---------|
| `company` | Global auto-completion |
| `copilot` | GitHub Copilot AI |
| `go-mode` | Go language support with LSP |
| `lsp-mode` | Language Server Protocol client |
| `magit` | Git interface |
| `php-mode` | PHP language support with LSP |
| `vertico` | Minibuffer completion UI (global) |
| `yasnippet` | Snippet expansion (global) |
| `yasnippet-snippets` | Pre-built snippet library |

### Key Settings

- **No backup files** - Cleaner working directory
- **Case-insensitive file completion**
- **Auto-follow symlinks** for dotfiles
- **Visual bell** (no audible bell)
- **Tab width:** 4 spaces
- **Minimal UI** - Menu bar and tool bar disabled
- **Line numbers** in programming modes
- **Allowed commands:** `upcase-region` enabled

## Opencoder - Autonomous OpenCode Runner

**File:** `opencoder` (900+ lines)

A POSIX-compliant Bash script that runs OpenCode CLI in a fully autonomous way, creating development plans and executing them continuously without manual intervention. Features a friendly, verbose interface with emojis and human-like messages that make it feel like a real developer working on your project. This is a key component of the AI-first development workflow.

### Overview

Opencoder implements an **agentic development loop** with three phases:
1. **Planning** - Uses a high-capability model to analyze the project and create actionable task plans
2. **Execution** - Uses a faster model to execute individual tasks from the plan
3. **Evaluation** - Reviews completed work and decides whether to start a new cycle

### Usage

```bash
# Using provider presets (recommended)
opencoder --provider github-copilot
opencoder --provider github-copilot "build a todo app"
opencoder --provider anthropic -c 10 "create a REST API"

# Using explicit models
opencoder -P anthropic/claude-sonnet-4 -E anthropic/claude-haiku
opencoder -P anthropic/claude-sonnet-4 -E anthropic/claude-haiku "build a todo app"
```

### Command Line Arguments

| Argument | Description |
|----------|-------------|
| `--provider PROVIDER` | Use a provider preset (github-copilot, anthropic, openai) |
| `-P, --planning-model MODEL` | Model for planning/evaluation phases |
| `-E, --execution-model MODEL` | Model for task execution |
| `-p, --project DIR` | Project directory (default: `$OPENCODER_PROJECT_DIR` or `$PWD`) |
| `-c, --cycle-limit N` | Stop after N cycles (default: unlimited) |
| `-v, --verbose` | Enable verbose logging |
| `HINT` | Optional instruction for what to build (positional argument) |

### Provider Presets

| Provider | Planning Model | Execution Model |
|----------|----------------|-----------------|
| `github-copilot` | `claude-opus-4.5` | `claude-sonnet-4.5` |
| `anthropic` | `claude-sonnet-4` | `claude-haiku` |
| `openai` | `gpt-4` | `gpt-4o-mini` |

### Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `OPENCODER_PROJECT_DIR` | `$PWD` | Default project directory |
| `OPENCODER_MAX_RETRIES` | `3` | Max retries per operation |
| `OPENCODER_BACKOFF_BASE` | `10` | Base seconds for exponential backoff |
| `OPENCODER_LOG_RETENTION` | `30` | Days to keep old logs |

### Directory Structure

When running, opencoder creates a `.opencoder/` directory in the project:

```
$PROJECT_DIR/.opencoder/
├── state                    # Current execution state (cycle, phase, task index)
├── current_plan.md          # Active task plan (markdown checklist)
├── alerts.log               # Critical error alerts
├── config.env               # Optional configuration overrides
├── history/                 # Archived completed plans
│   └── plan_YYYYMMDD_HHMMSS_cycleN.md
└── logs/
    ├── main.log             # Main rotating log
    └── cycles/              # Per-cycle detailed logs
        └── cycle_001.log
```

### Plan Format

Plans are saved as markdown checklists at `.opencoder/current_plan.md`:

```markdown
# Plan: [descriptive title]
Created: 2026-01-16T10:30:00Z
Cycle: 1

## Context
[Brief description of project state and goals]

## Tasks
- [ ] Task 1: Description
- [ ] Task 2: Description
- [x] Task 3: Completed task
...

## Notes
[Any additional context]
```

### Execution Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Planning   │────▶│  Execution  │────▶│ Evaluation  │
│   Phase     │     │   Phase     │     │   Phase     │
└─────────────┘     └─────────────┘     └─────────────┘
       ▲                                       │
       │                                       │
       └───────────────────────────────────────┘
              (if COMPLETE, start new cycle)
```

1. **Planning Phase**: Creates `current_plan.md` with 5-10 actionable tasks using the planning model
2. **Execution Phase**: Iterates through unchecked tasks (`- [ ]`), executing each with the execution model
3. **Evaluation Phase**: Reviews the plan, responds with `COMPLETE` or `NEEDS_WORK`
4. **Archive**: Completed plans are moved to `history/` with timestamp

### State Management

The script maintains persistent state in `.opencoder/state`:

```
CYCLE=1
PHASE=execution
TASK_INDEX=3
SESSION_ID=cycle_1
PLAN_FILE=current_plan.md
LAST_UPDATE=2026-01-16T10:30:00Z
```

This enables:
- **Resumability** - Restart from where it left off after interruption
- **Session continuity** - Uses `--continue` flag within the same cycle
- **Progress tracking** - Know exactly which task is being executed

### Signal Handling

| Signal | Behavior |
|--------|----------|
| `SIGTERM`, `SIGINT` | Graceful shutdown: saves state, exits cleanly |
| `SIGHUP` | Reloads configuration from `config.env` |

### Retry Logic

Operations use exponential backoff on failure:
- **Max retries:** 3 (configurable via `OPENCODER_MAX_RETRIES`)
- **Backoff formula:** `BACKOFF_BASE * (2 ^ attempt)` seconds
- **Failed tasks:** Marked complete to avoid infinite loops, logged to alerts

### Key Functions

| Function | Purpose |
|----------|---------|
| `create_plan()` | Generates new plan using planning model |
| `get_next_task()` | Finds first unchecked task in plan |
| `execute_task()` | Runs single task with execution model |
| `mark_task_complete()` | Updates `- [ ]` to `- [x]` in plan |
| `evaluate_plan()` | Assesses completion, decides next action |
| `archive_plan()` | Moves completed plan to history |
| `save_state()` / `load_state()` | Persists/restores execution state |

### Cross-Platform Compatibility

- **Portable sed:** Handles macOS BSD sed vs GNU sed differences via `sed_inplace()` function
- **POSIX compliance:** Uses `set -euo pipefail` for strict error handling
- **No bashisms:** Works on both Linux and macOS

### Integration with OpenCode

Opencoder wraps the `opencode run` command:
```bash
opencode run --model "$MODEL" --title "Opencoder [Phase] Cycle $N" "$PROMPT"
```

The `--continue` flag is used to maintain session context within cycles.

### Example Session

```bash
$ opencoder --provider github-copilot "build a REST API for user management"

Opencoder v1.0.0 - Autonomous OpenCode Runner

[2026-01-16 10:30:00] Initializing opencoder directory structure at: /home/user/myproject
[2026-01-16 10:30:00] Starting main execution loop
[2026-01-16 10:30:00] Planning model: github-copilot/claude-opus-4.5
[2026-01-16 10:30:00] Execution model: github-copilot/claude-sonnet-4.5
[2026-01-16 10:30:00] User hint: build a REST API for user management
[2026-01-16 10:30:00] ==========================================
[2026-01-16 10:30:00] Starting cycle 1
[2026-01-16 10:30:00] ==========================================
[2026-01-16 10:30:00] Creating new plan for cycle 1 using model: github-copilot/claude-opus-4.5
[2026-01-16 10:30:15] Plan created successfully
[2026-01-16 10:30:15] Executing tasks from plan
[2026-01-16 10:30:15] Executing task: Set up project structure with Go modules
...
```

### Best Practices

1. **Start with a hint** - Provide clear instructions for what you want to build
2. **Use cycle limits** - For testing, use `-c 1` to run a single cycle
3. **Monitor logs** - Check `.opencoder/logs/` for detailed execution logs
4. **Review alerts** - Critical errors are logged to `.opencoder/alerts.log`
5. **Version control** - The `.opencoder/` directory can be gitignored or committed for reproducibility

### Limitations

- Requires `opencode` CLI to be installed and configured
- No interactive input during execution (fully autonomous)
- Tasks that fail after max retries are skipped (marked complete to continue)
- Evaluation defaults to `COMPLETE` if unable to determine status

### Output Personality & User Experience

Opencoder features a **friendly, verbose interface** with emojis and human-like messages:

**Dual Logging System:**
- **Console Output** (`say()` function): Clean, emoji-rich messages for human readability
- **File Logging** (`log()` function): Timestamped technical logs in `.opencoder/logs/`

**Emoji Communication:**
- 🚀 Starting up, launching new cycles
- 📋 Planning phase with task counts
- 💪 Working on tasks (shows "task X of Y")
- ✅🎉 Completion and success celebrations
- ⚠️❌ Friendly error messages with warnings
- 🔄😅 Retry attempts with encouragement
- 🔍🧐 Evaluation and quality checks
- 👋💾 Graceful shutdown with state saving

**Progress Tracking:**
- Shows current task number (e.g., "Working on task 3 of 7")
- Displays full task description before execution
- Real-time status updates for each phase
- Clear cycle boundaries with decorative separators

**Example Output:**
```
╔════════════════════════════════════════╗
║   🤖 Opencoder v1.0.0                  ║
║   Autonomous OpenCode Runner          ║
╚════════════════════════════════════════╝

🚀 Initializing opencoder workspace...
✅ Workspace ready!
🎬 Starting the autonomous development loop!
📂 Project: /path/to/project
♾️  Running continuously until stopped

════════════════════════════════════════
🔄 Cycle 1
════════════════════════════════════════

📋 Time to plan! Let me analyze the project...
🤔 Thinking about what needs to be done...
📝 Found 7 tasks in the plan
✅ Plan ready!

💪 Working on task 1 of 7
📌 Task: Implement user authentication
🔨 Let me work on this...
🎉 Task done!
```

This design makes opencoder feel like a **real developer working alongside you** rather than a silent automation tool.

## AI Tool Configurations

### Claude Code (.claude/)

**Config:** `~/.claude/settings.json`
- **Model:** Opus (highest capability)
- **Permissions:** `acceptEdits` default mode
- **Non-essential traffic:** Disabled for efficiency
- **Statusline:** Custom shell script with context window %, git branch, hostname, model name

**Statusline Script:** `~/.claude/statusline.sh` (52 lines)
- Shows context window usage as percentage and progress bar
- Displays git branch (if in repo)
- Color-coded context: Green (<50%), Yellow (50-80%), Red (≥80%)
- Includes hostname, working directory, and model name

**Instructions:** `~/.claude/CLAUDE.md`
- User profile (Leo, English)
- Atomic commits with DCO signoff
- Conventional Commits specification
- PR guidelines with label mapping
- Package manager preferences (uv for Python, bun for JavaScript)
- Memory persistence across sessions

### OpenCode (.config/opencode/)

**Config:** `~/.config/opencode/opencode.json`
- References official OpenCode config schema
- Inherits system defaults

### Claude Code Skills (.claude/skills/creating-skills/)

Provides templates and specifications for creating reusable Claude Code skills:
- `SKILL.md` - Skill specification template
- `SPECIFICATION.md` - Official skill specification format
- `EXAMPLES.md` - Example skills

Skills allow packaging custom instructions/workflows for reuse across multiple Claude Code sessions.

### Gemini AI (.gemini/)

**Config:** `~/.gemini/settings.json`
- **Auth Type:** OAuth (personal)
- **Theme:** GitHub (consistent with other tools)
- **Context File:** Uses `AGENTS.md` for AI instructions
- **Auto-accept:** Enabled for suggestions

## Custom Colorscheme: GitHub Dark Default

The entire dotfiles uses a unified **GitHub Dark Default** theme across all tools:

**Colors:**

| Color | Hex | Uses |
|-------|-----|------|
| bg | `#0d1117` | Background in nvim, terminals, tmux |
| fg | `#e6edf3` | Foreground text everywhere |
| fg_muted | `#8b949e` | Muted text (comments, line numbers) |
| fg_subtle | `#6e7681` | Subtle text |
| red | `#ff7b72` | Errors, keywords, warnings |
| orange | `#ffa657` | Types, numbers |
| yellow | `#d29922` | Warnings, search highlights |
| green | `#3fb950` | Success, tags, additions |
| cyan | `#39c5cf` | Strings, info |
| blue | `#58a6ff` | Constants, info, ui highlights |
| purple | `#bc8cff` | Functions, session names |

**Theme Exports:**
- **iTerm2** (`themes/iterm2.itermcolors`) - For iTerm2 terminal on macOS
- **Windows Terminal** (`themes/windows-terminal.json`) - For Windows Terminal

## Dependencies

### Required CLI Tools

| Tool | Purpose |
|------|---------|
| `gh` | GitHub CLI (for PR operations) |
| `stow` | GNU Stow (symlink management) |
| `eza` | Modern ls replacement |
| `zoxide` | Smart directory jumper |
| `starship` | Cross-shell prompt |
| `delta` | Git diff pager |
| `nvim` | Neovim editor |
| `zsh` | Shell |
| `git` | Version control |
| `jq` | JSON processor (Claude statusline) |

### Optional Tools

| Tool | Purpose |
|------|---------|
| `tmux` | Terminal multiplexer |
| `claude` | Claude AI CLI |
| `opencode` | OpenCode CLI |
| `goose` | Goose AI terminal tool |
| `go` | Go programming language |
| `python3` / `uv` | Python runtime and package manager |
| `node` / `bun` | JavaScript runtime and package manager |
| `php` / `composer` | PHP runtime and package manager |
| `emacs` | Emacs text editor |

## Setup and Installation

**Prerequisites:**
- GNU Stow must be installed
- Zsh shell
- Git

**Install dotfiles:**
```bash
cd ~/.dotfiles
stow .
```

This creates symlinks from the repository to `$HOME`, applying all configurations.

**First Run:**
- Antigen will auto-install and download plugins
- Neovim will bootstrap lazy.nvim and install plugins on first launch
- Starship init script will be cached

## Stow Configuration

**File:** `.stow-local-ignore`

Controls which files are excluded from symlink creation:
- `.git/` - Git directory (never symlinked)
- `.claude/settings.local.json` - Local/work-specific Claude settings
- `.gitignore` - Repo-specific gitignore (not global)
- `AGENTS.md`, `CLAUDE.md`, `README.md`, `LICENSE` - Documentation and metadata

These files can exist in the repository without being symlinked to the home directory.

## Coding Style

**Shell scripts:**
- Use bash or zsh syntax as appropriate
- Follow existing indentation (2 spaces)
- Use descriptive variable names
- Add comments only for complex logic
- Use `local` for function variables in Zsh
- Use `emulate -L zsh` in all functions for consistency

**Configuration files:**
- Preserve existing format and style
- Keep comments intact
- Test changes before committing
- Respect original indentation and structure

**Lua (Neovim):**
- Use consistent indentation (2 spaces)
- Follow plugin documentation conventions
- Leverage lazy.nvim's lazy-loading features

## Agent Boundaries

**DO NOT:**
- Modify `.git/` directory
- Change file permissions or ownership
- Remove or modify existing working configurations without explicit user request
- Commit secrets or sensitive data
- Modify binary files in `.emacs.d/` or other config directories without understanding their purpose
- Replace Antigen with alternative plugin managers (zinit, sheldon, etc.) - this is deliberate

**DO:**
- Keep modifications minimal and surgical
- Preserve existing formatting and structure
- Test commands before suggesting them
- Respect the user's existing tool choices (nvim, zsh, tmux, etc.)
- Understand the AI-first philosophy and preserve integrations

## Special Notes

- **Antigen Plugin Manager** - The repository uses Antigen for Zsh plugins by design. Do NOT recommend replacing it with alternatives like zinit, sheldon, etc. Antigen's startup overhead is acceptable for the simplicity and stability it provides.
- **GNU Stow** - Symlinks are managed by GNU Stow. Use `stow .` to apply changes or `stow --restow .` to reapply.
- **Local Git Config** - Sensitive settings should be added to `~/.gitconfig.local` which is automatically included in `.gitconfig`.
- **Local Claude Config** - Work-specific Claude settings should be added to `~/.claude/settings.local.json` (excluded from stow).
- **Dotfiles Public** - This repository is publicly available at github.com/leocavalcante/dotfiles. Always verify that no sensitive data (API keys, tokens, passwords, credentials, or personal information) is being committed and pushed.

## Completed Optimizations (Jan 14, 2026)

The following `.zshrc` optimizations have already been implemented - DO NOT suggest these again:

- Removed Anthropic helper functions - now inline
- Consolidated duplicate Go version checks into single block
- Simplified `composer()` and `up()` functions with `emulate -L zsh`
- Added smart caching for starship initialization (binary mtime-based invalidation)
- Lazy-loaded zoxide (`z`, `zi` are stubs that init on first use)
- Replaced `command -v` checks with `(( $+commands[...] ))` hash lookups
- Lazy-loaded COMPOSER_AUTH (loads in `composer()` function, not at startup)
- Added history options: `HIST_FIND_NO_DUPS`, `INC_APPEND_HISTORY`, `APPEND_HISTORY`
- Added portable compinit with `(#qN.mh+24)` glob qualifier for cross-platform support
- Conditional Bun path addition with existence check
- Removed emoji decorations from status messages
- **Result**: Reduced startup time by 30-80ms through reduced subprocesses and optimized initialization patterns.

## Testing Changes

After modifying configuration files:

1. **Shell configs:** `source ~/.zshrc` or restart terminal
2. **Git config:** Test with `git config --list`
3. **Stow changes:** `cd ~/.dotfiles && stow --restow .`
4. **Neovim:** Launch nvim and check `:Lazy` for plugin status
5. **Tmux:** Restart tmux server with `tmux kill-server` or reload with `tmux source-file ~/.tmux.conf`

## Security

- **IMPORTANT**: This repository is publicly available at github.com/leocavalcante/dotfiles. Always verify that no sensitive data (API keys, tokens, passwords, credentials, or personal information) is being committed and pushed.
- Never commit API keys or tokens
- `~/.gitconfig.local` is for sensitive user-specific settings
- `~/.claude/settings.local.json` is for work-specific Claude settings
- Composer auth is loaded from `~/.config/composer/auth.json`
- Be cautious with shell functions that execute AI-generated content or external tools

## Owner Information

- **Owner:** leocavalcante (Leo Cavalcante)
- **Purpose:** Personal development environment configuration
- **Repository:** github.com/leocavalcante/dotfiles
- **License:** MIT (2022-2025)
- **Primary Shell:** Zsh
- **Primary Editor:** Neovim
- **Terminal Multiplexer:** tmux

## Additional Context

This is a personal, opinionated setup focused on:
- AI-assisted development workflows with multiple tool integrations
- Terminal-based tools and editors (no GUI IDEs)
- Git workflow automation and conventional commits
- Cross-platform compatibility (Linux/macOS with Homebrew, Termux support)
- Performance optimization and fast startup times
- Consistency across all tools via unified GitHub Dark Default theme
