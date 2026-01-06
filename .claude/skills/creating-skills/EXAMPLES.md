# Skill Examples

## Example 1: Simple Instruction Skill

A minimal skill for code review conventions:

```yaml
---
name: reviewing-code
description: Apply team code review standards and conventions. Use when reviewing pull requests or providing code feedback.
---

# Code Review Standards

## Review Checklist

1. Check for security vulnerabilities (injection, XSS, auth issues)
2. Verify error handling is appropriate
3. Ensure tests cover new functionality
4. Check naming conventions match project style
5. Look for performance concerns

## Feedback Format

Use this structure:
- **Must fix**: Security/correctness issues
- **Should fix**: Best practice violations
- **Consider**: Style/preference suggestions
```

## Example 2: Workflow Skill with Scripts

A skill for database migrations:

```
managing-migrations/
├── SKILL.md
├── SAFETY.md
└── scripts/
    ├── validate_migration.py
    └── rollback.py
```

**SKILL.md:**
```yaml
---
name: managing-migrations
description: Create and run database migrations safely. Use when user needs to modify database schema, add tables, or update columns.
---

# Database Migration Management

## Workflow

Copy this checklist:
```
- [ ] Create migration file
- [ ] Validate migration syntax
- [ ] Run in development
- [ ] Test rollback
- [ ] Apply to staging
```

## Creating Migrations

```bash
python manage.py makemigrations --name descriptive_name
```

## Validation

Always validate before applying:
```bash
python scripts/validate_migration.py migrations/latest.py
```

**Safety guidelines**: See [SAFETY.md](SAFETY.md)
```

## Example 3: Reference-Heavy Skill

For skills with lots of documentation:

```
querying-bigquery/
├── SKILL.md
└── schemas/
    ├── users.md
    ├── orders.md
    ├── products.md
    └── analytics.md
```

**SKILL.md:**
```yaml
---
name: querying-bigquery
description: Query company BigQuery data warehouse with correct table schemas and naming conventions. Use when user needs data analysis, reports, or SQL queries against our data.
---

# BigQuery Data Warehouse

## Available Schemas

- **Users**: See [schemas/users.md](schemas/users.md)
- **Orders**: See [schemas/orders.md](schemas/orders.md)
- **Products**: See [schemas/products.md](schemas/products.md)
- **Analytics**: See [schemas/analytics.md](schemas/analytics.md)

## Query Patterns

### Finding Specific Schemas

```bash
grep -i "field_name" schemas/*.md
```

## Common Rules

- Always filter: `WHERE environment = 'production'`
- Always exclude: `AND NOT is_test_account`
- Use UTC timestamps
```

## Example 4: Tool-Specific Skill

For skills that use specific tools:

```yaml
---
name: generating-presentations
description: Create PowerPoint presentations with consistent styling. Use when user asks to create slides, presentations, or PPTX files.
compatibility: Requires python-pptx package
allowed-tools: Bash(python:*) Write Read
---

# Presentation Generation

## Quick Start

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation()
slide = prs.slides.add_slide(prs.slide_layouts[1])
title = slide.shapes.title
title.text = "Slide Title"

prs.save("output.pptx")
```

## Slide Types

1. **Title slide**: Layout 0
2. **Title + Content**: Layout 1
3. **Section Header**: Layout 2
4. **Two Content**: Layout 3

## Styling Rules

- Title font: 44pt bold
- Body font: 24pt
- Use company colors: #1a73e8 (primary), #34a853 (accent)
```

## Anti-Pattern Examples

### Too Verbose

```yaml
# Bad - over-explains
---
name: processing-pdfs
description: This skill helps you process PDF files...
---

# PDF Processing

PDF stands for Portable Document Format. It was created by Adobe...

To process a PDF, you first need to understand that PDFs contain...
```

### Missing Triggers

```yaml
# Bad - no "when to use"
---
name: data-helper
description: Helps with data tasks
---
```

### Nested References

```yaml
# Bad - too deep
---
name: complex-skill
---

See [docs/overview.md](docs/overview.md)

# In docs/overview.md:
See [details/specifics.md](details/specifics.md)

# In details/specifics.md:
Here's the actual info...  # Claude may not reach this
```
