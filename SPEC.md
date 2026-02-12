# Master Claude Template Specification

## Overview

The `master-claude` repository defines a shared template system for bootstrapping AI-assisted development capabilities across all repositories in the uniiverse organization. This ensures consistent AI behavior, reusable skills, and standardized development workflows.

## Goals

1. **Consistency**: Ensure Claude behaves consistently across all repositories
2. **Reusability**: Share common skills, agents, and commands organization-wide
3. **Discoverability**: Make AI capabilities easy to find and use
4. **Maintainability**: Centralize updates to propagate to all repositories
5. **Flexibility**: Allow per-repository customization without breaking core functionality

## Repository Structure

```
master-claude/
├── SPEC.md                           # This file - the specification
├── README.md                         # User-facing documentation
├── templates/
│   ├── CLAUDE.md                     # Master AI instructions template
│   ├── CLAUDE.local.md               # Per-repo customization template
│   └── .claude/
│       ├── skills/                   # Reusable skill definitions
│       │   ├── code-review/
│       │   │   ├── skill.yaml        # Skill metadata
│       │   │   └── prompt.md         # Skill prompt template
│       │   ├── architecture-review/
│       │   ├── test-generator/
│       │   └── deploy-helper/
│       ├── agents/                   # Specialized agent configurations
│       │   ├── security-auditor/
│       │   │   ├── agent.yaml        # Agent configuration
│       │   │   └── instructions.md   # Agent-specific instructions
│       │   ├── tech-lead/
│       │   ├── code-archaeologist/
│       │   └── performance-expert/
│       ├── commands/                 # Custom CLI commands
│       │   ├── bootstrap.sh          # Bootstrap this repo with template
│       │   ├── sync.sh               # Sync from master-claude
│       │   └── validate.sh           # Validate template integrity
│       └── config/
│           ├── hooks.yaml            # Default hook configurations
│           └── settings.yaml         # Default Claude settings
├── scripts/
│   ├── bootstrap-repo.sh             # Bootstrap a repository
│   ├── sync-to-repos.sh              # Push updates to all repos
│   └── validate-template.sh          # CI validation script
└── docs/
    ├── skills-guide.md               # How to create skills
    ├── agents-guide.md               # How to create agents
    ├── customization-guide.md        # How to customize per-repo
    └── distribution-guide.md         # How to distribute updates
```

## Core Components

### 1. CLAUDE.md - Master Instructions

**Purpose**: Define uniiverse-wide AI coding standards, practices, and behaviors.

**Contents**:
- Organization coding standards reference
- Security requirements
- Code quality guidelines
- Performance expectations
- Documentation standards
- Testing requirements
- References to skills and agents

**Versioning**: Include version number and update timestamp.

**Template Variables**:
- `{{REPO_NAME}}`: Repository name
- `{{REPO_PURPOSE}}`: Brief description
- `{{PRIMARY_LANGUAGES}}`: Main programming languages
- `{{TEAM_CONTACTS}}`: Team/owner information

### 2. CLAUDE.local.md - Per-Repository Customization

**Purpose**: Allow repository-specific overrides and additions without modifying the master template.

**Contents**:
- Repository-specific preferences
- Technology stack details
- Local conventions
- Team-specific workflows
- Custom skill/agent configurations

**Precedence**: Instructions in CLAUDE.local.md override CLAUDE.md when conflicts arise.

### 3. Skills - Reusable Capabilities

**Structure**:
```yaml
# skill.yaml
name: code-review
version: 1.0.0
description: Comprehensive code review following uniiverse standards
trigger_patterns:
  - "review this code"
  - "code review"
  - "/review"
dependencies:
  - coding-standards
parameters:
  - name: scope
    type: string
    required: false
    default: "full"
    options: ["full", "security", "performance", "style"]
tags:
  - code-quality
  - review
```

**Standard Skills**:
- `code-review`: Comprehensive code review
- `architecture-review`: System design review
- `test-generator`: Generate test cases
- `security-scan`: Security vulnerability assessment
- `performance-profile`: Performance analysis
- `deploy-helper`: Deployment assistance
- `migration-planner`: Data/code migration planning
- `refactor-advisor`: Refactoring recommendations

### 4. Agents - Specialized Configurations

**Structure**:
```yaml
# agent.yaml
name: security-auditor
version: 1.0.0
description: Specialized security review and vulnerability assessment
model: opus-4-6
temperature: 0.1
tools:
  - Read
  - Grep
  - Bash
  - WebFetch
context_files:
  - SECURITY.md
  - .security-config.yaml
behavior:
  focus: security-first
  thoroughness: very-high
  risk_tolerance: none
```

**Standard Agents**:
- `security-auditor`: Security-focused review
- `tech-lead`: Architecture and design guidance
- `code-archaeologist`: Legacy code analysis
- `performance-expert`: Performance optimization
- `test-strategist`: Testing strategy and coverage
- `api-designer`: API design and documentation

### 5. Commands - Custom CLI Extensions

**Purpose**: Provide uniiverse-specific Claude CLI commands.

**Standard Commands**:
- `/bootstrap`: Initialize repository with template
- `/sync-master`: Pull latest from master-claude
- `/validate-template`: Check template integrity
- `/uniiverse-review`: Full uniiverse-standards review
- `/deploy-check`: Pre-deployment validation

## Distribution Strategy

### Bootstrap Process

1. **Initial Setup**:
   ```bash
   # From any repository
   curl -sSL https://raw.githubusercontent.com/uniiverse/master-claude/main/scripts/bootstrap-repo.sh | bash
   ```

2. **What Bootstrap Does**:
   - Creates `.claude/` directory structure
   - Copies template files (CLAUDE.md, skills, agents, commands)
   - Creates CLAUDE.local.md with repository-specific placeholders
   - Initializes git submodule reference to master-claude
   - Runs initial validation

3. **Git Submodule Approach**:
   ```bash
   # Add master-claude as submodule
   git submodule add https://github.com/uniiverse/master-claude.git .claude/master

   # Symlink core files
   ln -s .claude/master/templates/CLAUDE.md CLAUDE.md
   ln -s .claude/master/templates/.claude/skills .claude/skills
   ln -s .claude/master/templates/.claude/agents .claude/agents
   ```

### Update/Sync Process

**Manual Sync**:
```bash
# From repository root
.claude/commands/sync.sh
# or
claude /sync-master
```

**Automated Sync**:
- GitHub Action runs weekly
- Checks for updates to master-claude
- Creates PR if changes detected
- Requires human approval to merge

**Versioning**:
```yaml
# .claude/template-version.yaml
master_claude_version: 1.2.3
last_sync: 2026-02-12T10:30:00Z
auto_sync_enabled: true
custom_overrides:
  - CLAUDE.local.md
  - .claude/skills/custom-skill
```

## Customization Hierarchy

**Precedence Order** (highest to lowest):

1. **User's ~/.claude/CLAUDE.local.md**: Personal preferences
2. **Repository CLAUDE.local.md**: Repo-specific instructions
3. **Repository CLAUDE.md**: Core instructions (synced from master)
4. **Master Template**: The source of truth

**Override Mechanism**:
```markdown
<!-- In CLAUDE.local.md -->
# Override: Code Review Depth
> This overrides the default code review behavior from CLAUDE.md

When reviewing code in this repository:
- Skip style checks (handled by pre-commit hooks)
- Focus on business logic and security
- Performance is critical - flag any O(n²) or worse
```

## Validation & Quality Control

### Pre-Commit Validation

```bash
# .claude/commands/validate.sh checks:
- CLAUDE.md exists and is valid
- Required skills are present
- Template version is documented
- No hardcoded secrets in templates
- Syntax of YAML configurations
```

### CI/CD Integration

```yaml
# .github/workflows/claude-template-validation.yml
name: Validate Claude Template
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Template
        run: |
          .claude/commands/validate.sh
          .claude/commands/check-version.sh
```

### Health Metrics

Track across organization:
- Template version distribution
- Custom skill usage
- Agent invocation frequency
- Sync compliance rate

## Security Considerations

1. **Secret Management**:
   - Never include credentials in templates
   - Use placeholder tokens: `{{SECRET_NAME}}`
   - Document required secrets in README

2. **Access Control**:
   - master-claude repository: Core team write access
   - Individual repos: Can customize via CLAUDE.local.md
   - Sync process: Requires PR approval

3. **Audit Trail**:
   - Log all template updates
   - Track which repos are on which versions
   - Monitor custom overrides

## Implementation Phases

### Phase 1: Foundation (Week 1)
- [ ] Create repository structure
- [ ] Define CLAUDE.md template
- [ ] Create basic bootstrap script
- [ ] Document core concepts

### Phase 2: Core Skills (Week 2-3)
- [ ] Implement 3-5 essential skills
- [ ] Create skill development guide
- [ ] Test in pilot repository
- [ ] Gather feedback

### Phase 3: Agents & Commands (Week 4)
- [ ] Define 2-3 specialized agents
- [ ] Implement custom commands
- [ ] Create agent development guide

### Phase 4: Distribution (Week 5-6)
- [ ] Build sync mechanism
- [ ] Create GitHub Actions
- [ ] Setup version tracking
- [ ] Pilot with 3-5 repositories

### Phase 5: Organization Rollout (Week 7-8)
- [ ] Bootstrap all active repositories
- [ ] Training and documentation
- [ ] Establish support process
- [ ] Monitor adoption metrics

## Success Metrics

- **Adoption**: % of uniiverse repositories bootstrapped
- **Consistency**: % of repos on latest template version
- **Usage**: Skill/agent invocation frequency
- **Quality**: Code review findings by Claude
- **Efficiency**: Time saved on common tasks
- **Satisfaction**: Developer feedback scores

## Future Enhancements

- **Marketplace**: Share skills across organizations
- **Analytics**: Usage insights and optimization recommendations
- **AI Tuning**: Fine-tune agents based on organization patterns
- **Integration**: Connect with JIRA, Confluence, Slack
- **Templates**: Project-type specific templates (microservice, frontend, etc.)

## Maintenance

**Ownership**: Engineering Enablement Team

**Review Cadence**:
- Weekly: Review incoming skill/agent requests
- Monthly: Analyze usage metrics and adjust
- Quarterly: Major version updates and deprecations

**Support**:
- GitHub Issues: Bug reports and feature requests
- Slack: #ai-tooling for questions
- Wiki: Comprehensive guides and examples

## References

- [Claude Code Documentation](https://code.claude.com/docs)
- [Skill Development Guide](./docs/skills-guide.md)
- [Agent Development Guide](./docs/agents-guide.md)
- [Customization Examples](./docs/customization-guide.md)
