---
name: creating-skills
description: Create new Agent Skills following the official specification and best practices. Use when the user wants to create a skill, write a SKILL.md file, or package instructions/workflows for reuse across conversations.
---

# Creating Agent Skills

## Quick Start

1. Determine skill location:
   - Personal: `~/.claude/skills/<skill-name>/`
   - Project: `.claude/skills/<skill-name>/`

2. Create directory matching the skill name
3. Create `SKILL.md` with YAML frontmatter + markdown body
4. Add supporting files as needed

## SKILL.md Template

```yaml
---
name: skill-name-here
description: What this skill does. When to use it. Include keywords for discovery.
---

# Skill Title

## Instructions
[Step-by-step guidance]

## Examples
[Input/output examples if helpful]
```

## Field Requirements

See [SPECIFICATION.md](SPECIFICATION.md) for complete validation rules.

**name** (required):
- 1-64 characters
- Lowercase alphanumeric + hyphens only
- Must match parent directory name
- Cannot start/end with hyphen or have consecutive hyphens

**description** (required):
- 1-1024 characters
- Write in third person (injected into system prompt)
- Include WHAT it does AND WHEN to use it
- Include keywords for discovery

## Naming Convention

Use gerund form (verb + -ing):
- `processing-pdfs`
- `analyzing-data`
- `generating-reports`

## Content Guidelines

1. **Be concise** - Claude is smart; only add context it doesn't have
2. **Keep SKILL.md under 500 lines** - Split into separate files if needed
3. **One level deep references** - Don't nest file references
4. **No time-sensitive info** - Avoid dates that will become stale

## Progressive Disclosure Pattern

For larger skills, use this structure:

```
my-skill/
├── SKILL.md           # Overview + navigation (<500 lines)
├── WORKFLOWS.md       # Detailed procedures
├── REFERENCE.md       # API/technical details
└── scripts/
    └── utility.py     # Executable helpers
```

Reference files from SKILL.md:
```markdown
**Detailed workflows**: See [WORKFLOWS.md](WORKFLOWS.md)
**API reference**: See [REFERENCE.md](REFERENCE.md)
```

## Workflow Pattern

For complex multi-step tasks, include checklists:

````markdown
## Task Workflow

Copy this checklist:
```
- [ ] Step 1: Description
- [ ] Step 2: Description
- [ ] Step 3: Description
```

**Step 1: Description**
[Detailed instructions]
````

## Validation

After creating, validate the skill:
```bash
# Check structure
ls -la ~/.claude/skills/skill-name/

# Verify SKILL.md exists and has frontmatter
head -20 ~/.claude/skills/skill-name/SKILL.md
```

## Examples

See [EXAMPLES.md](EXAMPLES.md) for complete skill examples.
