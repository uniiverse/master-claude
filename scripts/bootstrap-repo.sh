#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a repository with the master-claude template
# Usage: curl -sSL https://raw.githubusercontent.com/universe/master-claude/main/scripts/bootstrap-repo.sh | bash

SCRIPT_VERSION="1.0.0"
MASTER_CLAUDE_REPO="https://github.com/universe/master-claude.git"
MASTER_CLAUDE_BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

fatal() {
    error "$@"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect repository name
detect_repo_name() {
    if [ -d .git ]; then
        basename "$(git rev-parse --show-toplevel)" 2>/dev/null || basename "$PWD"
    else
        basename "$PWD"
    fi
}

# Detect primary programming languages
detect_languages() {
    local languages=""

    [ -f "setup.py" ] || [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] && languages="${languages}Python, "
    [ -f "package.json" ] && languages="${languages}JavaScript/TypeScript, "
    [ -f "go.mod" ] && languages="${languages}Go, "
    [ -f "Cargo.toml" ] && languages="${languages}Rust, "
    [ -f "pom.xml" ] || [ -f "build.gradle" ] && languages="${languages}Java, "
    [ -f "Gemfile" ] && languages="${languages}Ruby, "

    # Remove trailing comma and space
    languages="${languages%, }"

    [ -z "$languages" ] && languages="Unknown"
    echo "$languages"
}

# Check prerequisites
check_prerequisites() {
    info "Checking prerequisites..."

    if ! command_exists git; then
        fatal "git is required but not installed. Please install git and try again."
    fi

    if [ ! -d .git ]; then
        warning "Not a git repository. Initializing git..."
        git init
    fi

    success "Prerequisites check passed"
}

# Create directory structure
create_structure() {
    info "Creating .claude directory structure..."

    mkdir -p .claude/{skills,agents,commands,config}
    mkdir -p .claude/skills/custom

    success "Directory structure created"
}

# Add master-claude as git submodule
add_submodule() {
    info "Adding master-claude as git submodule..."

    if [ -d .claude/master ]; then
        warning ".claude/master already exists. Skipping submodule add."
        return
    fi

    if git submodule add -f "$MASTER_CLAUDE_REPO" .claude/master 2>/dev/null; then
        success "Submodule added successfully"
    else
        warning "Could not add as submodule. Cloning directly instead..."
        git clone --depth 1 --branch "$MASTER_CLAUDE_BRANCH" "$MASTER_CLAUDE_REPO" .claude/master
        success "Repository cloned successfully"
    fi

    # Initialize submodule
    cd .claude/master
    git checkout "$MASTER_CLAUDE_BRANCH"
    cd ../..
}

# Create symlinks to shared resources
create_symlinks() {
    info "Creating symlinks to shared resources..."

    # Symlink CLAUDE.md if it doesn't exist
    if [ ! -f CLAUDE.md ]; then
        ln -s .claude/master/templates/CLAUDE.md CLAUDE.md
        success "Symlinked CLAUDE.md"
    else
        warning "CLAUDE.md already exists. Skipping."
    fi

    # Symlink skills (but not custom skills)
    if [ -d .claude/master/templates/.claude/skills ]; then
        for skill_dir in .claude/master/templates/.claude/skills/*; do
            skill_name=$(basename "$skill_dir")
            if [ ! -e ".claude/skills/$skill_name" ]; then
                ln -s "../master/templates/.claude/skills/$skill_name" ".claude/skills/$skill_name"
            fi
        done
        success "Symlinked skills"
    fi

    # Symlink agents
    if [ -d .claude/master/templates/.claude/agents ]; then
        for agent_dir in .claude/master/templates/.claude/agents/*; do
            agent_name=$(basename "$agent_dir")
            if [ ! -e ".claude/agents/$agent_name" ]; then
                ln -s "../master/templates/.claude/agents/$agent_name" ".claude/agents/$agent_name"
            fi
        done
        success "Symlinked agents"
    fi

    # Symlink commands
    if [ -d .claude/master/templates/.claude/commands ]; then
        for command_file in .claude/master/templates/.claude/commands/*; do
            command_name=$(basename "$command_file")
            if [ ! -e ".claude/commands/$command_name" ]; then
                ln -s "../master/templates/.claude/commands/$command_name" ".claude/commands/$command_name"
            fi
        done
        success "Symlinked commands"
    fi
}

# Create CLAUDE.local.md with repository-specific details
create_local_config() {
    info "Creating CLAUDE.local.md..."

    if [ -f CLAUDE.local.md ]; then
        warning "CLAUDE.local.md already exists. Skipping."
        return
    fi

    local repo_name
    local languages
    local current_date

    repo_name=$(detect_repo_name)
    languages=$(detect_languages)
    current_date=$(date +%Y-%m-%d)

    # Copy template and replace variables
    if [ -f .claude/master/templates/CLAUDE.local.md ]; then
        cp .claude/master/templates/CLAUDE.local.md CLAUDE.local.md

        # Replace template variables
        if command_exists sed; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' "s/{{REPO_NAME}}/$repo_name/g" CLAUDE.local.md
                sed -i '' "s/{{PRIMARY_LANGUAGES}}/$languages/g" CLAUDE.local.md
                sed -i '' "s/{{CURRENT_DATE}}/$current_date/g" CLAUDE.local.md
                sed -i '' "s/{{REPO_PURPOSE}}/TODO: Add repository purpose/g" CLAUDE.local.md
                sed -i '' "s/{{TEAM_CONTACTS}}/TODO: Add team contacts/g" CLAUDE.local.md
                sed -i '' "s/{{TEAM_NAME}}/TODO: Add team name/g" CLAUDE.local.md
            else
                # Linux
                sed -i "s/{{REPO_NAME}}/$repo_name/g" CLAUDE.local.md
                sed -i "s/{{PRIMARY_LANGUAGES}}/$languages/g" CLAUDE.local.md
                sed -i "s/{{CURRENT_DATE}}/$current_date/g" CLAUDE.local.md
                sed -i "s/{{REPO_PURPOSE}}/TODO: Add repository purpose/g" CLAUDE.local.md
                sed -i "s/{{TEAM_CONTACTS}}/TODO: Add team contacts/g" CLAUDE.local.md
                sed -i "s/{{TEAM_NAME}}/TODO: Add team name/g" CLAUDE.local.md
            fi
        fi

        success "Created CLAUDE.local.md"
    else
        warning "Template not found. Creating minimal CLAUDE.local.md..."
        cat > CLAUDE.local.md <<EOF
# $repo_name - Local AI Customizations

**Repository**: $repo_name
**Primary Languages**: $languages
**Last Updated**: $current_date

## Repository-Specific Instructions

<!-- Add your repository-specific AI instructions here -->

EOF
        success "Created minimal CLAUDE.local.md"
    fi
}

# Create version tracking file
create_version_file() {
    info "Creating version tracking file..."

    local current_date
    current_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    cat > .claude/template-version.yaml <<EOF
master_claude_version: 1.0.0
last_sync: $current_date
last_sync_commit: $(cd .claude/master && git rev-parse HEAD)
auto_sync_enabled: true
custom_overrides:
  - CLAUDE.local.md
  - .claude/skills/custom/
EOF

    success "Version tracking file created"
}

# Add .gitignore entries
update_gitignore() {
    info "Updating .gitignore..."

    if [ ! -f .gitignore ]; then
        touch .gitignore
    fi

    # Add .claude entries if not already present
    if ! grep -q ".claude/master" .gitignore; then
        cat >> .gitignore <<EOF

# Claude Code template
.claude/template-version.yaml
EOF
        success "Updated .gitignore"
    else
        info ".gitignore already contains .claude entries"
    fi
}

# Validate installation
validate_installation() {
    info "Validating installation..."

    local errors=0

    [ ! -d .claude ] && error ".claude directory not found" && ((errors++))
    [ ! -d .claude/master ] && error ".claude/master not found" && ((errors++))
    [ ! -f CLAUDE.md ] && error "CLAUDE.md not found" && ((errors++))
    [ ! -f CLAUDE.local.md ] && error "CLAUDE.local.md not found" && ((errors++))
    [ ! -f .claude/template-version.yaml ] && error "Version file not found" && ((errors++))

    if [ $errors -eq 0 ]; then
        success "Validation passed"
        return 0
    else
        error "Validation failed with $errors errors"
        return 1
    fi
}

# Print summary
print_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    success "Bootstrap completed successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Review and customize CLAUDE.local.md"
    echo "  2. Commit the changes:"
    echo "     git add .claude CLAUDE.md CLAUDE.local.md .gitignore"
    echo "     git commit -m 'Initialize Claude Code template'"
    echo ""
    echo "  3. Available skills:"
    echo "     - /code-review: Comprehensive code review"
    echo "     - /security-scan: Security vulnerability assessment"
    echo ""
    echo "  4. To sync updates from master-claude:"
    echo "     .claude/commands/sync.sh"
    echo ""
    echo "Documentation: https://github.com/universe/master-claude"
    echo ""
}

# Main function
main() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Master Claude Template Bootstrap v${SCRIPT_VERSION}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    check_prerequisites
    create_structure
    add_submodule
    create_symlinks
    create_local_config
    create_version_file
    update_gitignore

    if validate_installation; then
        print_summary
    else
        fatal "Installation validation failed. Please review the errors above."
    fi
}

# Run main function
main "$@"
