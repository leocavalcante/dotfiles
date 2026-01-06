# Agent Skills Specification

## Directory Structure

```
skill-name/
├── SKILL.md              # Required
├── scripts/              # Optional - executable utilities
├── references/           # Optional - additional documentation
└── assets/               # Optional - templates, data files
```

## YAML Frontmatter Fields

### Required Fields

| Field | Constraints |
|-------|-------------|
| `name` | 1-64 chars, lowercase `[a-z0-9-]`, must match directory name, no leading/trailing/consecutive hyphens |
| `description` | 1-1024 chars, no XML tags, third person voice |

### Optional Fields

| Field | Constraints | Purpose |
|-------|-------------|---------|
| `license` | String | License identifier (e.g., "Apache-2.0") or file reference |
| `compatibility` | Max 500 chars | Environment requirements, required packages |
| `metadata` | Key-value pairs | Custom properties beyond spec |
| `allowed-tools` | Space-delimited | Pre-approved tools (experimental) |

## Full Template

```yaml
---
name: my-skill-name
description: Performs X task. Use when user mentions Y or needs Z.
license: MIT
compatibility: Requires Python 3.9+, pdfplumber package
metadata:
  author: your-name
  version: 1.0.0
allowed-tools: Bash(git:*) Read Write
---

# Skill Title

[Markdown body here]
```

## Token Budget Guidelines

| Content | Target | Notes |
|---------|--------|-------|
| Metadata (name + description) | ~100 tokens | Loaded at startup for all skills |
| SKILL.md body | <5000 tokens | Loaded when skill triggered |
| Supporting files | Unlimited | Loaded only as needed |

**Rule of thumb**: Keep SKILL.md under 500 lines.

## Naming Rules

### Valid Names
- `processing-pdfs`
- `data-analysis`
- `git-commit-helper`
- `api-v2-client`

### Invalid Names
- `Processing-PDFs` (uppercase)
- `-processing-pdfs` (leading hyphen)
- `processing--pdfs` (consecutive hyphens)
- `processing_pdfs` (underscore)
- `processing.pdfs` (dot)
- Names containing: `anthropic`, `claude`

## Description Best Practices

### Good Descriptions

```yaml
# Specific, includes triggers
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.

# Action-oriented with context
description: Generate conventional commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

### Bad Descriptions

```yaml
# Too vague
description: Helps with documents

# Missing trigger context
description: Processes data

# Wrong voice (first person)
description: I help you analyze spreadsheets
```

## File Reference Rules

1. **One level deep** - All references should be directly from SKILL.md
2. **Relative paths** - Use paths relative to skill root
3. **Forward slashes** - Always use `/`, never `\`

```markdown
# Good
See [REFERENCE.md](REFERENCE.md)
Run `python scripts/validate.py`

# Bad - nested reference
See [advanced.md](docs/advanced.md) which references [details.md](details.md)

# Bad - backslash
Run `python scripts\validate.py`
```

## Validation Command

```bash
skills-ref validate ./my-skill
```
