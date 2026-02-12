# Architecture Overview

Visual representation of the master-claude template system architecture.

## System Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    MASTER-CLAUDE REPOSITORY                     │
│                   (Single Source of Truth)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │  CLAUDE.md   │  │   Skills     │  │   Agents     │        │
│  │  (Standards) │  │ (Reusable)   │  │ (Specialized)│        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │CLAUDE.local  │  │   Commands   │  │    Docs      │        │
│  │  (Template)  │  │   (Scripts)  │  │   (Guides)   │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Git Submodule
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
            ▼                 ▼                 ▼
   ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
   │   Repo A       │ │   Repo B       │ │   Repo C       │
   │  (Frontend)    │ │  (Backend)     │ │  (Service)     │
   └────────────────┘ └────────────────┘ └────────────────┘
```

## Distribution Flow

```
                    BOOTSTRAP PROCESS

    Developer         Bootstrap         Repository
       │                │                  │
       │   Run Script   │                  │
       ├───────────────>│                  │
       │                │  Create .claude/ │
       │                ├─────────────────>│
       │                │                  │
       │                │  Add Submodule   │
       │                ├─────────────────>│
       │                │                  │
       │                │  Create Symlinks │
       │                ├─────────────────>│
       │                │                  │
       │                │ CLAUDE.local.md  │
       │                ├─────────────────>│
       │                │                  │
       │   Success!     │                  │
       │<───────────────┤                  │
       │                │                  │
```

## Update Propagation

```
                    UPDATE FLOW

┌────────────────┐         ┌────────────────┐         ┌────────────────┐
│ Template       │         │ Repository     │         │  Developer     │
│ Update         │         │ Submodule      │         │  Workspace     │
└───────┬────────┘         └───────┬────────┘         └───────┬────────┘
        │                          │                          │
        │  1. Push to main         │                          │
        │                          │                          │
        │  2. GitHub Action        │                          │
        │     triggers             │                          │
        │                          │                          │
        │  3. Create PR            │                          │
        ├─────────────────────────>│                          │
        │                          │                          │
        │                          │  4. Notify team          │
        │                          ├─────────────────────────>│
        │                          │                          │
        │                          │  5. Review & approve     │
        │                          │<─────────────────────────┤
        │                          │                          │
        │                          │  6. Merge PR             │
        │                          │<─────────────────────────┤
        │                          │                          │
        │                          │  7. Sync updates         │
        │                          │  (.claude/commands/sync) │
        │                          │                          │
```

## File Hierarchy

```
                    CUSTOMIZATION LAYERS

    ┌─────────────────────────────────────────────┐
    │  User Personal Preferences                  │  ← Highest Priority
    │  ~/.claude/CLAUDE.local.md                  │
    └─────────────────────────────────────────────┘
                      │
                      │ Overrides
                      ▼
    ┌─────────────────────────────────────────────┐
    │  Repository Customizations                  │
    │  CLAUDE.local.md                            │
    └─────────────────────────────────────────────┘
                      │
                      │ Overrides
                      ▼
    ┌─────────────────────────────────────────────┐
    │  Organization Standards                     │
    │  CLAUDE.md (symlinked from master)          │
    └─────────────────────────────────────────────┘
                      │
                      │ Based on
                      ▼
    ┌─────────────────────────────────────────────┐
    │  Master Template                            │  ← Source of Truth
    │  master-claude/templates/CLAUDE.md          │
    └─────────────────────────────────────────────┘
```

## Skill Invocation Flow

```
    Developer                Claude Code               Skills
       │                         │                       │
       │  "review this code"     │                       │
       ├────────────────────────>│                       │
       │                         │                       │
       │                         │  Match trigger        │
       │                         │  pattern              │
       │                         ├──────────────────────>│
       │                         │                       │
       │                         │  Load skill.yaml      │
       │                         │<──────────────────────┤
       │                         │                       │
       │                         │  Load prompt.md       │
       │                         │<──────────────────────┤
       │                         │                       │
       │                         │  Execute with context │
       │                         │                       │
       │                         │  Use tools (Read,     │
       │                         │  Grep, etc.)          │
       │                         │                       │
       │  Review results         │                       │
       │<────────────────────────┤                       │
       │                         │                       │
```

## Repository Structure After Bootstrap

```
repository/
│
├── Application Code
│   ├── src/
│   ├── tests/
│   └── ...
│
├── AI Configuration
│   ├── CLAUDE.md ────────────┐ (symlink)
│   │                         │
│   ├── CLAUDE.local.md       │
│   │   [Custom overrides]    │
│   │                         │
│   └── .claude/              │
│       │                     │
│       ├── master/ ──────────┘ (git submodule)
│       │   └── [master-claude repo]
│       │
│       ├── skills/
│       │   ├── code-review ────> (symlink to master)
│       │   ├── security-scan ──> (symlink to master)
│       │   └── custom/
│       │       └── my-skill/ (repo-specific)
│       │
│       ├── agents/
│       │   ├── security-auditor -> (symlink to master)
│       │   └── custom/
│       │
│       ├── commands/
│       │   ├── sync.sh ────────> (symlink to master)
│       │   └── validate.sh ────> (symlink to master)
│       │
│       └── template-version.yaml
│
└── Version Control
    └── .gitignore
```

## Data Flow: Code Review Example

```
1. INVOCATION
   Developer: "claude /code-review"
                   │
                   ▼
2. TRIGGER MATCHING
   Claude Code matches "/code-review"
   to skill trigger pattern
                   │
                   ▼
3. SKILL LOADING
   Load: .claude/skills/code-review/
   - skill.yaml (config)
   - prompt.md (instructions)
                   │
                   ▼
4. CONTEXT GATHERING
   Load context files:
   - CLAUDE.md (standards)
   - CLAUDE.local.md (repo customizations)
   - Changed files (via Read tool)
                   │
                   ▼
5. ANALYSIS
   Execute prompt with:
   - Skill instructions
   - Organization standards
   - Repository context
   - Code files
                   │
                   ▼
6. TOOL USAGE
   - Read: View code files
   - Grep: Search patterns
   - Bash: Run linters
                   │
                   ▼
7. OUTPUT GENERATION
   Structured review with:
   - Summary
   - Issues by severity
   - Recommendations
   - File:line references
                   │
                   ▼
8. PRESENTATION
   Display formatted results
   to developer
```

## Dependency Graph

```
        ┌─────────────────┐
        │  Developer      │
        └────────┬────────┘
                 │ uses
                 ▼
        ┌─────────────────┐
        │  Claude Code    │
        │     CLI         │
        └────────┬────────┘
                 │ loads
                 ▼
        ┌─────────────────┐
        │  Skills/Agents  │◄─────┐
        └────────┬────────┘      │
                 │ references    │ symlinks
                 ▼               │
        ┌─────────────────┐      │
        │  CLAUDE.md      │◄─────┤
        └────────┬────────┘      │
                 │ inherits      │
                 ▼               │
        ┌─────────────────┐      │
        │ master-claude   │      │
        │   (submodule)   │──────┘
        └─────────────────┘
```

## Sync Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     SYNC PROCESS                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Step 1: Check Version                                      │
│  ┌────────────────────────────────────────────────┐        │
│  │ Read .claude/template-version.yaml             │        │
│  │ Current: 1.0.0                                 │        │
│  └────────────────────────────────────────────────┘        │
│                        │                                     │
│                        ▼                                     │
│  Step 2: Update Submodule                                   │
│  ┌────────────────────────────────────────────────┐        │
│  │ cd .claude/master                              │        │
│  │ git fetch origin main                          │        │
│  │ git pull origin main                           │        │
│  └────────────────────────────────────────────────┘        │
│                        │                                     │
│                        ▼                                     │
│  Step 3: Validate Symlinks                                  │
│  ┌────────────────────────────────────────────────┐        │
│  │ Check all symlinks point to valid files       │        │
│  │ Report any broken links                        │        │
│  └────────────────────────────────────────────────┘        │
│                        │                                     │
│                        ▼                                     │
│  Step 4: Update Version File                                │
│  ┌────────────────────────────────────────────────┐        │
│  │ master_claude_version: 1.2.3                   │        │
│  │ last_sync: 2026-02-12T10:30:00Z                │        │
│  │ last_sync_commit: abc123def                    │        │
│  └────────────────────────────────────────────────┘        │
│                        │                                     │
│                        ▼                                     │
│  Step 5: Report Changes                                     │
│  ┌────────────────────────────────────────────────┐        │
│  │ List new/updated skills and agents             │        │
│  │ Show commit log                                │        │
│  └────────────────────────────────────────────────┘        │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Security Architecture

```
┌─────────────────────────────────────────────────────────┐
│               SECURITY BOUNDARIES                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌───────────────────────────────────────────────┐    │
│  │ Validation Layer                              │    │
│  │ - No hardcoded secrets                        │    │
│  │ - YAML syntax validation                      │    │
│  │ - Symlink verification                        │    │
│  │ - Script injection prevention                 │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│                       ▼                                 │
│  ┌───────────────────────────────────────────────┐    │
│  │ Template Distribution                         │    │
│  │ - Read-only master-claude                     │    │
│  │ - Symlinks prevent modification               │    │
│  │ - Git submodule integrity                     │    │
│  └───────────────────────────────────────────────┘    │
│                       │                                 │
│                       ▼                                 │
│  ┌───────────────────────────────────────────────┐    │
│  │ Execution Layer                               │    │
│  │ - User permissions respected                  │    │
│  │ - No privilege escalation                     │    │
│  │ - Sandboxed script execution                  │    │
│  └───────────────────────────────────────────────┘    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Scaling Architecture

```
                 As Organization Grows

     10 Repos              100 Repos             1000 Repos
         │                     │                      │
         │                     │                      │
    ┌────┴────┐           ┌────┴────┐           ┌────┴────┐
    │ Manual  │           │ Hybrid  │           │  Auto   │
    │ Bootstrap│          │ Bootstrap│          │Bootstrap │
    └─────────┘           └─────────┘           └─────────┘
         │                     │                      │
         │                     │                      │
    ┌────▼────┐           ┌────▼────┐           ┌────▼────┐
    │ Manual  │           │ PR Auto │           │  Auto   │
    │  Sync   │           │  Sync   │           │  Sync   │
    └─────────┘           └─────────┘           └─────────┘
         │                     │                      │
         │                     │                      │
    ┌────▼────┐           ┌────▼────┐           ┌────▼────┐
    │  Slack  │           │ Metrics │           │Analytics│
    │ Notify  │           │Dashboard│           │Platform │
    └─────────┘           └─────────┘           └─────────┘
```

## Technology Stack

```
┌──────────────────────────────────────────────────┐
│              TECHNOLOGY LAYERS                   │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌────────────────────────────────────────┐    │
│  │ Presentation                           │    │
│  │ - Markdown documentation               │    │
│  │ - CLI output formatting                │    │
│  └────────────────────────────────────────┘    │
│                     │                            │
│  ┌────────────────────────────────────────┐    │
│  │ Application                            │    │
│  │ - Bash scripts (bootstrap, sync)       │    │
│  │ - YAML configuration                   │    │
│  │ - Claude Code CLI                      │    │
│  └────────────────────────────────────────┘    │
│                     │                            │
│  ┌────────────────────────────────────────┐    │
│  │ Distribution                           │    │
│  │ - Git submodules                       │    │
│  │ - Symlinks                             │    │
│  │ - Version tracking                     │    │
│  └────────────────────────────────────────┘    │
│                     │                            │
│  ┌────────────────────────────────────────┐    │
│  │ Infrastructure                         │    │
│  │ - GitHub (source control)              │    │
│  │ - GitHub Actions (automation)          │    │
│  └────────────────────────────────────────┘    │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

**Version**: 1.0.0
**Last Updated**: 2026-02-12
