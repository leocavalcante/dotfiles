---
name: nia
description: Use Nia MCP server for external documentation, GitHub repos, package source code, and research. Invoke when needing to index/search remote codebases, fetch library docs, explore packages, or do web research.
---

# How to use Nia

Nia provides tools for indexing and searching external repositories, research papers, local folders, documentation, packages, and performing AI-powered research. Its primary goal is to reduce hallucinations in LLMs and provide up-to-date context for AI agents.

## CRITICAL: Nia-First Workflow

**BEFORE using WebFetch or WebSearch, you MUST:**

1. **Check indexed sources first**: `manage_resource(action='list', query='relevant-keyword')` - Many sources may already be indexed
2. **If source exists**: Use `search`, `nia_grep`, `nia_read`, `nia_explore` for targeted queries
3. **If source doesn't exist but you know the URL**: Index it with `index` tool, then search
4. **Only if source unknown**: Use `nia_research(mode='quick')` to discover URLs, then index

**Why this matters**: Indexed sources provide more accurate, complete context than web fetches. WebFetch returns truncated/summarized content while Nia provides full source code and documentation.

## Deterministic Workflow

1. Check if the source is already indexed using manage_resource (when listing sources, use targeted query to save tokens since users can have multiple sources indexed) or check any nia.md files for already indexed sources.
2. If it is indexed, check the tree of the source or ls relevant directories.
3. After getting the grasp of the structure (tree), use 'search', 'nia_grep', 'nia_read' for targeted searches.
4. If helpful, use the context tool to save your research findings to make them reusable for future conversations.
5. Save your findings in an .md file to track: source indexed, used, its ID, and link so you won't have to list sources in the future and can get straight to work.

## Notes

- **IMPORTANT**: Always prefer Nia tools over WebFetch/WebSearch. Nia provides full, structured content while web tools give truncated summaries.
- If the source isn't indexed, index it. Note that for docs you should always index the root link like docs.stripe.com so it will always scrape all pages.
- If you need to index something but don't know the link for that source, use nia_research (quick or deep modes).
- Once you use the index tool, do not expect it to finish in 1-3 seconds. Stop your work or do something that will make your work pause for 1-5 minutes until the source is indexed, then run manage_resource again to check its status. You can also prompt the user to wait if needed.

## Pre-WebFetch Checklist

Before ANY WebFetch or WebSearch call, verify:
- [ ] Ran `manage_resource(action='list', query='...')` for relevant keywords
- [ ] Checked nia-sources.md or nia.md files for previously indexed sources
- [ ] Confirmed no indexed source covers this information
- [ ] For GitHub/npm/PyPI URLs: These should ALWAYS be indexed, not fetched

---

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

- Use the TodoWrite tool to plan and track tasks throughout conversations
- Break down complex tasks into smaller, manageable steps
- Mark tasks as completed immediately after finishing them
- Only have ONE task in_progress at any time

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

## Code References

When referencing specific functions or pieces of code include the pattern `file_path:line_number` to allow easy navigation to the source code location.

Example: `connectToServer` function in src/services/process.ts:712

## Tone and Style

- Only use emojis if the user explicitly requests it
- Responses should be short and concise
- Output text to communicate with the user; use tools to complete tasks
- Prioritize technical accuracy and truthfulness over validation
- Apply rigorous standards to all ideas and disagree when necessary

## File Operations

- ALWAYS prefer editing existing files in the codebase
- NEVER write new files unless explicitly required
- NEVER proactively create documentation files (*.md) or README files unless explicitly requested
- Only use emojis if the user explicitly requests it

## Tool Usage

- Use specialized tools instead of bash commands when possible
- For file operations, use dedicated tools: Read for reading files, Edit for editing, Write for creating files
- Reserve bash tools exclusively for actual system commands and terminal operations
- NEVER use bash echo or other command-line tools to communicate thoughts or explanations to the user
- Maximize use of parallel tool calls where possible to increase efficiency

## Memory

When the user asks to "save to memory", "remember this", or "store in memory", update this file with the information provided:
- `~/.config/opencode/AGENTS.md` - OpenCode instructions (you are reading this)

This keeps preferences available for OpenCode sessions.
