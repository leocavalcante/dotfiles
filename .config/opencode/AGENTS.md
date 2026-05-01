## NEVER
- Execute the `git add` command, unless explicitly asked
- Execute the `git commit` command, unless explicitly asked
- Execute the `git push` command, unless explicitly asked
- Commit secrets, API keys, tokens, passwords, or credentials
- Create documentation files unless explicitly requested

## PREFER
- English for responses, code comments, and documentation
- Short, concise, technically accurate responses
- Simple, focused solutions without over-engineering
- Atomic commits following the Conventional Commits specification
- Signed commits using `git commit -s`
- Pull Request titles following the Conventional Commits specification
- Pull Requests assigned to me using `--assignee @me`
- Code references using `file_path:line_number`

## TOOLS
- Use specialized tools instead of shell commands for file operations
- Use `curl` for HTTP requests
- Use `uv` instead of `python`, `pip` or `poetry`
- Use `bun` instead of `node`, `npm`, `yarn`, `pnpm`, or `npx` for running, installing, and scripting
- Use `kubectx` for k8s context management
- Use `kubens` for k8s namespace management
- Use `tkn` for Tekton cluster management
- Save memory updates to `~/.config/opencode/AGENTS.md`
