# Repository Structure

Complete directory structure of the master-claude template system.

## Master-Claude Repository

```
master-claude/
│
├── README.md                          # User-facing documentation
├── SPEC.md                            # Technical specification
├── STRUCTURE.md                       # This file - structure overview
├── .gitignore                         # Git ignore patterns
│
├── templates/                         # Templates distributed to repos
│   ├── CLAUDE.md                      # Master AI instructions
│   ├── CLAUDE.local.md                # Per-repo customization template
│   │
│   └── .claude/                       # Claude Code configuration
│       │
│       ├── skills/                    # Reusable skill definitions
│       │   ├── code-review/
│       │   │   ├── skill.yaml         # Skill metadata
│       │   │   └── prompt.md          # Skill prompt
│       │   │
│       │   ├── security-scan/
│       │   │   ├── skill.yaml
│       │   │   └── prompt.md
│       │   │
│       │   ├── test-generator/
│       │   ├── architecture-review/
│       │   ├── performance-profile/
│       │   └── deploy-helper/
│       │
│       ├── agents/                    # Specialized agents
│       │   ├── security-auditor/
│       │   │   ├── agent.yaml         # Agent configuration
│       │   │   └── instructions.md    # Agent instructions
│       │   │
│       │   ├── tech-lead/
│       │   ├── code-archaeologist/
│       │   └── performance-expert/
│       │
│       ├── commands/                  # Custom CLI commands
│       │   ├── sync.sh                # Sync from master-claude
│       │   ├── validate.sh            # Validate template
│       │   └── README.md              # Command documentation
│       │
│       └── config/                    # Configuration files
│           ├── hooks.yaml             # Hook configurations
│           └── settings.yaml          # Claude settings
│
├── scripts/                           # Distribution scripts
│   ├── bootstrap-repo.sh              # Bootstrap a repo
│   ├── sync-to-repos.sh               # Batch sync to all repos
│   ├── validate-template.sh           # CI validation
│   └── README.md                      # Scripts documentation
│
└── docs/                              # Documentation
    ├── skills-guide.md                # How to create skills
    ├── agents-guide.md                # How to create agents
    ├── customization-guide.md         # Customization guide
    ├── distribution-guide.md          # Distribution guide
    └── examples/                      # Usage examples
        ├── skill-examples.md
        └── agent-examples.md
```

## Bootstrapped Repository Structure

After running bootstrap-repo.sh, a repository will have:

```
your-repo/
│
├── CLAUDE.md                          # Symlink to .claude/master/templates/CLAUDE.md
├── CLAUDE.local.md                    # Repo-specific customizations
│
├── .claude/                           # Claude configuration
│   │
│   ├── master/                        # Git submodule -> master-claude
│   │   └── [entire master-claude repo]
│   │
│   ├── skills/                        # Skills directory
│   │   ├── code-review/               # Symlink -> master/templates/.claude/skills/code-review
│   │   ├── security-scan/             # Symlink -> master/templates/.claude/skills/security-scan
│   │   └── custom/                    # Repo-specific skills
│   │       └── my-custom-skill/
│   │           ├── skill.yaml
│   │           └── prompt.md
│   │
│   ├── agents/                        # Agents directory
│   │   ├── security-auditor/          # Symlink -> master/templates/.claude/agents/security-auditor
│   │   ├── tech-lead/                 # Symlink -> master/templates/.claude/agents/tech-lead
│   │   └── custom/                    # Repo-specific agents
│   │
│   ├── commands/                      # Commands directory
│   │   ├── sync.sh                    # Symlink -> master/templates/.claude/commands/sync.sh
│   │   └── validate.sh                # Symlink -> master/templates/.claude/commands/validate.sh
│   │
│   ├── config/                        # Local configuration
│   │   ├── hooks.yaml
│   │   └── settings.yaml
│   │
│   └── template-version.yaml          # Version tracking
│
├── [your application code...]
│
└── .gitignore                         # Should include .claude/template-version.yaml
```

## File Purposes

### Core Template Files

| File | Purpose | Synced from Master |
|------|---------|-------------------|
| `CLAUDE.md` | Core AI instructions for all repos | ✅ Yes (symlink) |
| `CLAUDE.local.md` | Repo-specific customizations | ❌ No (local only) |

### Skill Files

| File | Purpose |
|------|---------|
| `skill.yaml` | Skill metadata, triggers, parameters |
| `prompt.md` | Actual skill instructions |

### Agent Files

| File | Purpose |
|------|---------|
| `agent.yaml` | Agent configuration and behavior |
| `instructions.md` | Agent behavioral instructions |

### Command Scripts

| File | Purpose |
|------|---------|
| `sync.sh` | Update repo with latest master-claude |
| `validate.sh` | Validate template integrity |
| `bootstrap-repo.sh` | Initial repo setup |

### Configuration

| File | Purpose |
|------|---------|
| `hooks.yaml` | Hook configurations |
| `settings.yaml` | Claude settings |
| `template-version.yaml` | Version tracking |

## Symlink Structure

Symlinks allow updates to propagate automatically:

```
Repository File                    →  Master-Claude Source
────────────────────────────────────────────────────────────────
CLAUDE.md                          →  .claude/master/templates/CLAUDE.md
.claude/skills/code-review/        →  .claude/master/templates/.claude/skills/code-review
.claude/agents/security-auditor/   →  .claude/master/templates/.claude/agents/security-auditor
.claude/commands/sync.sh           →  .claude/master/templates/.claude/commands/sync.sh
```

## Custom vs Shared Resources

### Shared (Symlinked from Master)

- Core skills (code-review, security-scan, etc.)
- Core agents (security-auditor, tech-lead, etc.)
- Commands (sync, validate)
- CLAUDE.md (base instructions)

### Repository-Specific (Local)

- `.claude/skills/custom/` - Custom skills
- `.claude/agents/custom/` - Custom agents
- `CLAUDE.local.md` - Local instructions
- `.claude/config/` - Local configuration
- `.claude/template-version.yaml` - Version tracking

## Update Flow

```
┌─────────────────┐
│ master-claude   │
│   (GitHub)      │
└────────┬────────┘
         │
         │ git submodule update
         │
         ▼
┌─────────────────┐
│ .claude/master/ │
│  (submodule)    │
└────────┬────────┘
         │
         │ symlinks
         │
         ▼
┌─────────────────┐     ┌────────────────────┐
│ Shared Skills/  │◄────│ CLAUDE.local.md    │
│ Agents/Commands │     │ (customizations)   │
└─────────────────┘     └────────────────────┘
         │
         │ used by
         │
         ▼
┌─────────────────┐
│  Claude Code    │
└─────────────────┘
```

## Version Management

```yaml
# .claude/template-version.yaml

master_claude_version: 1.2.3        # Semantic version
last_sync: 2026-02-12T10:30:00Z     # ISO 8601 timestamp
last_sync_commit: abc123def456       # Git commit hash
auto_sync_enabled: true              # Auto-sync via GitHub Action
custom_overrides:                    # Files not synced
  - CLAUDE.local.md
  - .claude/skills/custom/
```

## Size Estimates

| Component | Files | Size |
|-----------|-------|------|
| Master-claude repo | ~30 | ~500 KB |
| Per-repo overhead | ~5 | ~50 KB |
| Submodule reference | 1 | ~1 KB |
| Symlinks | ~10 | ~10 KB |

Total per-repository impact: ~60 KB (excluding submodule content)

## Git Considerations

### .gitignore Recommendations

```gitignore
# In each repository
.claude/template-version.yaml     # Regenerated on sync
```

### Submodule Management

```bash
# Clone repo with submodules
git clone --recurse-submodules <repo-url>

# Update submodules in existing clone
git submodule update --init --recursive

# Update to latest master-claude
cd .claude/master
git pull origin main
cd ../..
git add .claude/master
git commit -m "Update master-claude to v1.2.3"
```

## Directory Naming Conventions

- **Skills**: `kebab-case` (e.g., `code-review`, `security-scan`)
- **Agents**: `kebab-case` (e.g., `security-auditor`, `tech-lead`)
- **Scripts**: `kebab-case.sh` (e.g., `bootstrap-repo.sh`)
- **Config files**: `kebab-case.yaml` (e.g., `template-version.yaml`)
- **Docs**: `kebab-case.md` (e.g., `skills-guide.md`)

---

**Version**: 1.0.0
**Last Updated**: 2026-02-12
