#!/usr/bin/env bash
set -euo pipefail

# Sync repository with latest master-claude template
# Usage: .claude/commands/sync.sh

SCRIPT_VERSION="1.0.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in a repository with master-claude
check_setup() {
    if [ ! -d .claude/master ]; then
        fatal "master-claude not found. Run bootstrap-repo.sh first."
    fi

    if [ ! -f .claude/template-version.yaml ]; then
        warning "Version file not found. Creating one..."
        echo "master_claude_version: unknown" > .claude/template-version.yaml
    fi
}

# Get current version
get_current_version() {
    if [ -f .claude/template-version.yaml ]; then
        grep "master_claude_version:" .claude/template-version.yaml | awk '{print $2}'
    else
        echo "unknown"
    fi
}

# Update submodule
update_submodule() {
    info "Updating master-claude submodule..."

    cd .claude/master

    # Fetch latest changes
    git fetch origin main

    # Check if updates are available
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)

    if [ "$LOCAL" = "$REMOTE" ]; then
        success "Already up to date"
        cd ../..
        return 1
    fi

    # Get commit messages
    info "New updates available:"
    git log --oneline HEAD..origin/main | head -10

    # Pull updates
    git pull origin main

    cd ../..

    success "Submodule updated"
    return 0
}

# Check for conflicts with local customizations
check_conflicts() {
    info "Checking for conflicts with local customizations..."

    local conflicts=0

    # Check if CLAUDE.md was modified locally
    if [ -f CLAUDE.md ] && [ ! -L CLAUDE.md ]; then
        warning "CLAUDE.md is not a symlink. You may have local modifications."
        warning "Consider moving customizations to CLAUDE.local.md"
        ((conflicts++))
    fi

    # Check for skill conflicts
    if [ -f .claude/template-version.yaml ]; then
        while IFS= read -r override; do
            if [ -f "$override" ] || [ -d "$override" ]; then
                info "Preserved custom override: $override"
            fi
        done < <(grep -A 100 "custom_overrides:" .claude/template-version.yaml | grep "  - " | sed 's/  - //')
    fi

    if [ $conflicts -gt 0 ]; then
        warning "$conflicts potential conflicts detected"
        return 1
    fi

    success "No conflicts detected"
    return 0
}

# Update version file
update_version_file() {
    info "Updating version file..."

    local new_version
    local current_date
    local commit_hash

    cd .claude/master
    new_version=$(grep "^version:" ../../SPEC.md 2>/dev/null | head -1 | awk '{print $2}' || echo "1.0.0")
    commit_hash=$(git rev-parse HEAD)
    cd ../..

    current_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    # Update version file
    if [ -f .claude/template-version.yaml ]; then
        # Create backup
        cp .claude/template-version.yaml .claude/template-version.yaml.bak

        # Update fields
        if command -v sed >/dev/null 2>&1; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' "s/^master_claude_version:.*/master_claude_version: $new_version/" .claude/template-version.yaml
                sed -i '' "s/^last_sync:.*/last_sync: $current_date/" .claude/template-version.yaml
                sed -i '' "s/^last_sync_commit:.*/last_sync_commit: $commit_hash/" .claude/template-version.yaml
            else
                # Linux
                sed -i "s/^master_claude_version:.*/master_claude_version: $new_version/" .claude/template-version.yaml
                sed -i "s/^last_sync:.*/last_sync: $current_date/" .claude/template-version.yaml
                sed -i "s/^last_sync_commit:.*/last_sync_commit: $commit_hash/" .claude/template-version.yaml
            fi
        fi

        rm -f .claude/template-version.yaml.bak
    fi

    success "Version file updated to $new_version"
}

# Verify symlinks are intact
verify_symlinks() {
    info "Verifying symlinks..."

    local broken=0

    # Check CLAUDE.md
    if [ -L CLAUDE.md ]; then
        if [ ! -e CLAUDE.md ]; then
            error "Broken symlink: CLAUDE.md"
            ((broken++))
        fi
    fi

    # Check skills
    if [ -d .claude/skills ]; then
        for skill in .claude/skills/*; do
            if [ -L "$skill" ] && [ ! -e "$skill" ]; then
                error "Broken symlink: $skill"
                ((broken++))
            fi
        done
    fi

    # Check agents
    if [ -d .claude/agents ]; then
        for agent in .claude/agents/*; do
            if [ -L "$agent" ] && [ ! -e "$agent" ]; then
                error "Broken symlink: $agent"
                ((broken++))
            fi
        done
    fi

    if [ $broken -gt 0 ]; then
        error "$broken broken symlinks detected"
        warning "Run bootstrap script again to fix: scripts/bootstrap-repo.sh"
        return 1
    fi

    success "All symlinks are valid"
    return 0
}

# Show what's new
show_changes() {
    info "Recent changes in master-claude:"
    echo ""

    cd .claude/master

    # Show recent commits
    git log --oneline -5

    # Show modified files
    echo ""
    info "Updated files:"
    git diff --name-only HEAD@{1} HEAD | head -10

    cd ../..
}

# Print summary
print_summary() {
    local current_version
    current_version=$(get_current_version)

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    success "Sync completed successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Current version: $current_version"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Review changes:"
    echo "     git status"
    echo "     git diff .claude/master"
    echo ""
    echo "  2. Test updated skills/agents"
    echo ""
    echo "  3. Commit the sync:"
    echo "     git add .claude"
    echo "     git commit -m 'Sync master-claude template to $current_version'"
    echo ""
    echo "Documentation: https://github.com/uniiverse/master-claude"
    echo ""
}

# Main function
main() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Master Claude Template Sync v${SCRIPT_VERSION}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    local current_version
    current_version=$(get_current_version)
    info "Current version: $current_version"
    echo ""

    check_setup
    check_conflicts

    if update_submodule; then
        update_version_file
        verify_symlinks
        show_changes
        print_summary
    else
        info "No updates available. You're already on the latest version."
    fi
}

# Run main function
main "$@"
