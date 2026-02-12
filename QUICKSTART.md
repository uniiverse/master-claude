# Quick Start Guide

Get up and running with the master-claude template system in 5 minutes.

## For Repository Maintainers

### Bootstrap Your Repository

Run this from your repository root:

```bash
curl -sSL https://raw.githubusercontent.com/uniiverse/master-claude/main/scripts/bootstrap-repo.sh | bash
```

This will:
- ✅ Create `.claude/` directory structure
- ✅ Add master-claude as a git submodule
- ✅ Create `CLAUDE.md` with uniiverse standards
- ✅ Create `CLAUDE.local.md` for customization
- ✅ Symlink shared skills, agents, and commands

### Customize for Your Repository

Edit `CLAUDE.local.md`:

```bash
vim CLAUDE.local.md
```

Add repository-specific details:

```markdown
# My API Service - Local AI Customizations

## Tech Stack
- Python 3.11+ with FastAPI
- PostgreSQL 15
- Redis for caching

## Conventions
- Use async/await for all I/O operations
- All endpoints require authentication
- Response time must be < 100ms

## Performance Critical
- Flag any O(n²) or worse algorithms
- Database queries must use indexes
```

### Commit Changes

```bash
git add .claude CLAUDE.md CLAUDE.local.md .gitignore
git commit -m "Initialize Claude Code template"
git push
```

### Start Using Skills

```bash
# Code review
claude /code-review

# Security scan
claude /security-scan

# Natural language
claude "review this code for security issues"
```

## For Developers

### Use Skills in Your Workflow

```bash
# Before committing
claude /code-review

# Before deployment
claude /security-scan

# When stuck
claude "help me optimize this slow query"
```

### Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Code Review | `/code-review` | Comprehensive code review |
| Security Scan | `/security-scan` | Vulnerability assessment |
| Test Generator | `/test-gen` | Generate test cases |
| Architecture Review | `/arch-review` | System design review |

### Available Agents

| Agent | Trigger | Expertise |
|-------|---------|-----------|
| Security Auditor | "security review" | Security vulnerabilities |
| Tech Lead | "architecture" | System design |
| Performance Expert | "optimization" | Performance tuning |
| Code Archaeologist | "legacy code" | Understanding old code |

### Sync Latest Updates

```bash
# Pull latest skills and agents
.claude/commands/sync.sh

# Validate setup
.claude/commands/validate.sh
```

## For Template Maintainers

### Add a New Skill

```bash
cd master-claude/templates/.claude/skills
mkdir my-new-skill
cd my-new-skill
```

Create `skill.yaml`:

```yaml
name: my-new-skill
version: 1.0.0
description: What this skill does
trigger_patterns:
  - "do the thing"
  - "/my-skill"
tags:
  - category
```

Create `prompt.md`:

```markdown
# My New Skill

This skill does something specific.

## Instructions

1. First step
2. Second step
3. Third step

Now proceed with the task.
```

### Test Your Skill

```bash
# In a test repository
.claude/commands/sync.sh
claude /my-skill
```

### Publish Update

```bash
git add templates/.claude/skills/my-new-skill
git commit -m "Add my-new-skill"
git push
```

### Distribute to All Repositories

```bash
# Notify teams
./scripts/sync-to-repos.sh

# Or let GitHub Action handle it
# (runs weekly, creates PRs automatically)
```

## Common Workflows

### Daily Development

```bash
# Start coding
claude "what should I work on today?"

# During development
claude "review this function"
claude "generate tests for this"

# Before commit
claude /code-review

# Before push
.claude/commands/validate.sh
```

### Code Review

```bash
# Review PR
claude /code-review scope=full

# Security-focused review
claude /code-review scope=security

# Performance-focused review
claude /code-review scope=performance
```

### Debugging

```bash
# Understand error
claude "explain this error: [paste error]"

# Find related code
claude "where is authentication handled?"

# Analyze performance
claude agent performance-expert "why is this endpoint slow?"
```

### Refactoring

```bash
# Get architecture guidance
claude agent tech-lead "how should I refactor this module?"

# Security review
claude agent security-auditor "review authentication flow"

# Performance optimization
claude agent performance-expert "optimize this query"
```

## Troubleshooting

### Skill Not Working

```bash
# Validate template
.claude/commands/validate.sh

# Check skill exists
ls .claude/skills/

# Check symlinks
ls -la .claude/skills/
```

### Out of Sync

```bash
# Update to latest
.claude/commands/sync.sh

# Check version
cat .claude/template-version.yaml
```

### Custom Skill Not Found

Custom skills go in `.claude/skills/custom/`:

```bash
mkdir -p .claude/skills/custom/my-skill
# Add skill.yaml and prompt.md
```

## Best Practices

### ✅ DO

- Customize via `CLAUDE.local.md`
- Keep custom skills in `.claude/skills/custom/`
- Sync regularly with `.claude/commands/sync.sh`
- Use skills for common tasks
- Commit template changes

### ❌ DON'T

- Modify `CLAUDE.md` directly (it's a symlink)
- Edit shared skills/agents (create custom ones instead)
- Ignore sync notifications
- Hardcode secrets in templates
- Skip validation before pushing

## Next Steps

1. ✅ Bootstrap your repository
2. ✅ Customize `CLAUDE.local.md`
3. ✅ Try built-in skills
4. ✅ Share feedback with the team
5. ✅ Create custom skills for your needs

## Resources

- **Full Documentation**: [README.md](./README.md)
- **Technical Spec**: [SPEC.md](./SPEC.md)
- **Skills Guide**: [docs/skills-guide.md](./docs/skills-guide.md)
- **Agents Guide**: [docs/agents-guide.md](./docs/agents-guide.md)
- **Structure**: [STRUCTURE.md](./STRUCTURE.md)

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/uniiverse/master-claude/issues)
- **Discussion**: #ai-tooling on Slack
- **Email**: engineering-enablement@uniiverse.org

---

**Ready to start?** Run the bootstrap script in your repository:

```bash
curl -sSL https://raw.githubusercontent.com/uniiverse/master-claude/main/scripts/bootstrap-repo.sh | bash
```
