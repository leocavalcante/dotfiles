# User Profile

- Name: Leo
- Preferred language: **English**

# Git Workflow

- **Commit Signing**: Always sign commits with `-s` or `--signoff` flag
  - Example: `git commit -s -m "feat: add new feature"`
  - This adds a `Signed-off-by` line certifying Developer Certificate of Origin (DCO)
- **Atomic Commits**: Always prefer atomic commits over single large commits
  - When asked to commit, first review ALL changes (both staged and unstaged files)
  - Analyze and group changes into logical units based on their purpose
  - Create multiple small commits, each representing a single logical change
  - Workflow:
    1. Run `git status` to see all changed files
    2. Run `git diff` and `git diff --staged` to understand the changes
    3. Group related changes together (e.g., feature code, tests, config, docs)
    4. Stage and commit each group separately with descriptive messages
  - Benefits: Makes code review easier, enables cleaner git history, and allows for easier reverts
- **Conventional Commits**: Always use the Conventional Commits specification for commit messages
  - Format: `<type>[optional scope]: <description>`
  - Optional body and footer(s) can be added for more context
  - Types:
    - `feat`: New feature (correlates with MINOR in SemVer)
    - `fix`: Bug fix (correlates with PATCH in SemVer)
    - `build`: Changes to build system or dependencies
    - `chore`: Maintenance tasks
    - `ci`: CI/CD configuration changes
    - `docs`: Documentation changes
    - `style`: Code style changes (formatting, no logic change)
    - `refactor`: Code refactoring (no feature or fix)
    - `perf`: Performance improvements
    - `test`: Adding or updating tests
  - Breaking changes:
    - Append `!` after type/scope: `feat!: breaking change`
    - Or add footer: `BREAKING CHANGE: description`
    - Correlates with MAJOR in SemVer
  - Scope: Optional context in parentheses, e.g., `feat(parser): add array parsing`
  - Examples:
    - `feat(auth): add OAuth2 login support`
    - `fix: resolve null pointer in user service`
    - `docs(readme): update installation instructions`
    - `refactor!: change API response format`

# Pull Request Guidelines

- **Conventional Commits for PR Titles**: Use the same Conventional Commits format for PR titles as used for commit messages
  - Format: `<type>[optional scope]: <description>`
  - Examples: `feat(auth): add OAuth2 login support`, `fix: resolve null pointer in user service`
- **Labels**: Apply appropriate labels to categorize the PR using GitHub's standard labels
  - GitHub provides default labels that should be used when applicable:
    - `bug` - Something isn't working
    - `documentation` - Improvements or additions to documentation
    - `enhancement` - New feature or request
    - `good first issue` - Good for newcomers
    - `help wanted` - Extra attention is needed
    - `question` - Further information is requested
    - `duplicate` - This issue or pull request already exists
    - `invalid` - This doesn't seem right
    - `wontfix` - This will not be worked on
  - Label mapping from Conventional Commits:
    - `feat` → use `enhancement`
    - `fix` → use `bug`
    - `docs` → use `documentation`
    - `refactor`, `chore`, `style`, `build`, `ci`, `test`, `perf` → use `enhancement` or no label
- **Assignment**: Always assign PRs to me using: `--assignee @me`
- Example: `gh pr create --title "feat: add feature" --body "Description" --label enhancement --assignee @me`

# User Preferences

## Code & Documentation

- All responses, code comments, and documentation should be in English
- Avoid over-engineering and premature abstractions
- Keep solutions simple and focused on the requested task

## Context Window Management

- **Prefer Background Tasks/Subagents**: Always offload work to background tasks or subagents instead of running in the main session
- This helps maintain a clean context window and prevents context overflow during long sessions
- Use subagents for: codebase exploration, research, multi-step tasks, and any work that can run independently

## HTTP Requests

- **Prefer Bash(curl)**: Always use `curl` via the Bash tool instead of other HTTP tools for HTTP requests

## Package Managers & Runtimes

- **Python projects**: Always use `uv` instead of `pip`, `poetry`, or standard `python`
  - Faster dependency resolution and installation
  - Use as runtime: `uv run script.py`, `uv run pytest`
  - Package management: `uv pip install package`, `uv venv`, `uv sync`
- **JavaScript/TypeScript projects**: Always use `bun` instead of `npm`, `yarn`, `pnpm`, or `node`
  - Faster package installation, script execution, and runtime
  - Use as runtime: `bun run script.ts`, `bun script.js`
  - Package management: `bun install`, `bun add package`

## Memory

When the user asks to "save to memory", "remember this", or "store in memory", update both of these files with the information provided:
- `~/.claude/CLAUDE.md`
- `~/.config/goose/.goosehints`

This keeps preferences synchronized across different AI assistants and allows persistent context across sessions.

# Claude Code Configuration

## Local/Work-Specific Settings

For work-specific or local machine configuration that shouldn't be committed to public repositories, see:
- `~/.claude/CLAUDE.local.md` - Contains work-specific settings, credentials, team information, and environment details

This file is automatically loaded by Claude Code and provides context about the local work environment.
