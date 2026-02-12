# Master Claude Template

> Shared AI development template for all uniiverse organization repositories

## What is This?

This repository provides a standardized template system that bootstraps AI-assisted development capabilities across all uniiverse repositories. It ensures Claude behaves consistently, provides reusable skills, and maintains organization-wide coding standards.

## Quick Start

### Bootstrap a Repository

From any uniiverse repository:

```bash
curl -sSL https://raw.githubusercontent.com/uniiverse/master-claude/main/scripts/bootstrap-repo.sh | bash
```

This will:
- Create `.claude/` directory with skills, agents, and commands
- Add `CLAUDE.md` with uniiverse coding standards
- Create `CLAUDE.local.md` for repository-specific customization
- Initialize version tracking

### Sync Latest Updates

```bash
# Update your repository with latest template changes
.claude/commands/sync.sh
```

## What You Get

### 📋 Coding Standards

A comprehensive `CLAUDE.md` that defines:
- Code quality guidelines
- Security requirements
- Performance expectations
- Documentation standards
- Testing practices

### 🎯 Reusable Skills

Pre-built capabilities like:
- **code-review**: Comprehensive code reviews
- **security-scan**: Vulnerability assessment
- **test-generator**: Generate test cases
- **architecture-review**: System design review
- **performance-profile**: Performance analysis

Invoke with: `claude /skill-name` or by description

### 🤖 Specialized Agents

Purpose-built agents for:
- **security-auditor**: Security-focused analysis
- **tech-lead**: Architecture guidance
- **code-archaeologist**: Legacy code exploration
- **performance-expert**: Optimization recommendations

### ⚡ Custom Commands

Uniiverse-specific commands:
- `/bootstrap`: Initialize template in repo
- `/sync-master`: Update from master-claude
- `/validate-template`: Check template integrity
- `/uniiverse-review`: Full standards compliance review

## Repository Structure

```
your-repo/
├── CLAUDE.md                    # Core AI instructions (synced from master)
├── CLAUDE.local.md              # Your customizations
└── .claude/
    ├── skills/                  # Shared skills (symlinked)
    ├── agents/                  # Shared agents (symlinked)
    ├── commands/                # CLI commands (symlinked)
    ├── config/
    │   ├── hooks.yaml
    │   └── settings.yaml
    └── master/                  # Git submodule to master-claude
```

## Customization

### Repository-Specific Instructions

Edit `CLAUDE.local.md` to add repository-specific preferences:

```markdown
# My Repository Customizations

## Tech Stack
- Python 3.11+ with FastAPI
- PostgreSQL 15
- Redis for caching

## Preferences
- Use async/await for all I/O operations
- Prefer Pydantic models over dataclasses
- All API endpoints must have OpenAPI documentation

## Team Conventions
- Sprint planning on Mondays
- Code freeze on Thursdays
- Deploy to staging happens automatically on merge to `develop`
```

### Adding Custom Skills

Create repository-specific skills in `.claude/skills/custom/`:

```bash
mkdir -p .claude/skills/custom/my-skill
cat > .claude/skills/custom/my-skill/skill.yaml <<EOF
name: my-custom-skill
version: 1.0.0
description: Does something specific to this repo
trigger_patterns:
  - "do the thing"
EOF
```

## Version Management

Track your template version:

```bash
# Check current version
cat .claude/template-version.yaml

# Update to latest
.claude/commands/sync.sh

# Pin to specific version
echo "1.2.3" > .claude/.template-version-pin
```

## How It Works

### Customization Hierarchy

Instructions are applied in this order (highest priority first):

1. **~/.claude/CLAUDE.local.md** - Your personal preferences
2. **CLAUDE.local.md** - Repository-specific instructions
3. **CLAUDE.md** - Core uniiverse standards (synced from master)
4. **Master Template** - The source template

### Distribution via Git Submodules

The template uses git submodules to share content:

```bash
# Your repo references master-claude
.claude/master/ -> git submodule

# Core files are symlinked
CLAUDE.md -> .claude/master/templates/CLAUDE.md
.claude/skills -> .claude/master/templates/.claude/skills
.claude/agents -> .claude/master/templates/.claude/agents
```

Updates propagate automatically when you sync.

## Development

### Creating a Skill

See [docs/skills-guide.md](./docs/skills-guide.md)

### Creating an Agent

See [docs/agents-guide.md](./docs/agents-guide.md)

### Contributing

1. Fork master-claude
2. Create feature branch
3. Add/modify templates
4. Test in pilot repository
5. Submit PR with examples

## Support

- **Documentation**: [Full Specification](./SPEC.md)
- **Issues**: [GitHub Issues](https://github.com/uniiverse/master-claude/issues)
- **Chat**: #ai-tooling on Slack
- **Owner**: Engineering Enablement Team

## Roadmap

- [x] Core specification
- [ ] Bootstrap script
- [ ] Essential skills (code-review, security-scan)
- [ ] Specialized agents
- [ ] GitHub Actions for auto-sync
- [ ] Pilot with 5 repositories
- [ ] Organization-wide rollout

## License

Internal use only - Uniiverse Organization

---

**Version**: 1.0.0
**Last Updated**: 2026-02-12
**Maintainer**: Engineering Enablement Team
