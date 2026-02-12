#!/usr/bin/env bash
set -euo pipefail

# Validate Claude Code template integrity
# Usage: .claude/commands/validate.sh

SCRIPT_VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[PASS]${NC} $*"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[FAIL]${NC} $*" >&2; }

ERRORS=0
WARNINGS=0
CHECKS=0

check_file_exists() {
    local file=$1
    local required=${2:-true}

    ((CHECKS++))

    if [ -f "$file" ] || [ -L "$file" ]; then
        success "Found: $file"
        return 0
    else
        if [ "$required" = "true" ]; then
            error "Missing required file: $file"
            ((ERRORS++))
        else
            warning "Missing optional file: $file"
            ((WARNINGS++))
        fi
        return 1
    fi
}

check_dir_exists() {
    local dir=$1
    local required=${2:-true}

    ((CHECKS++))

    if [ -d "$dir" ]; then
        success "Found: $dir/"
        return 0
    else
        if [ "$required" = "true" ]; then
            error "Missing required directory: $dir"
            ((ERRORS++))
        else
            warning "Missing optional directory: $dir"
            ((WARNINGS++))
        fi
        return 1
    fi
}

check_yaml_syntax() {
    local file=$1

    ((CHECKS++))

    if [ ! -f "$file" ]; then
        return 1
    fi

    # Basic YAML syntax check
    if command -v python3 >/dev/null 2>&1; then
        if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            success "Valid YAML: $file"
            return 0
        else
            error "Invalid YAML syntax: $file"
            ((ERRORS++))
            return 1
        fi
    else
        warning "Python3 not found, skipping YAML validation for $file"
        ((WARNINGS++))
        return 0
    fi
}

check_no_secrets() {
    local patterns=(
        'password.*=.*["\047]'
        'api[_-]?key.*=.*["\047]'
        'secret.*=.*["\047]'
        'token.*=.*["\047]'
        'AWS_ACCESS_KEY'
        'AWS_SECRET'
    )

    ((CHECKS++))

    local found=0

    for pattern in "${patterns[@]}"; do
        if grep -rI -E -i "$pattern" . \
            --exclude-dir=.git \
            --exclude-dir=node_modules \
            --exclude-dir=venv \
            --exclude="*.log" \
            >/dev/null 2>&1; then

            error "Potential secret found matching pattern: $pattern"
            grep -rI -E -i "$pattern" . \
                --exclude-dir=.git \
                --exclude-dir=node_modules \
                --exclude-dir=venv \
                --exclude="*.log" | head -3
            ((found++))
        fi
    done

    if [ $found -eq 0 ]; then
        success "No hardcoded secrets detected"
        return 0
    else
        error "Found $found potential secrets"
        ((ERRORS++))
        return 1
    fi
}

check_symlinks() {
    ((CHECKS++))

    local broken=0

    # Find all symlinks and check if they're valid
    while IFS= read -r -d '' symlink; do
        if [ ! -e "$symlink" ]; then
            error "Broken symlink: $symlink -> $(readlink "$symlink")"
            ((broken++))
        fi
    done < <(find . -type l -print0 2>/dev/null)

    if [ $broken -eq 0 ]; then
        success "All symlinks are valid"
        return 0
    else
        error "Found $broken broken symlinks"
        ((ERRORS++))
        return 1
    fi
}

check_version_tracking() {
    ((CHECKS++))

    if [ ! -f .claude/template-version.yaml ]; then
        error "Version tracking file missing"
        ((ERRORS++))
        return 1
    fi

    # Check required fields
    local required_fields=("master_claude_version" "last_sync")
    local missing=0

    for field in "${required_fields[@]}"; do
        if ! grep -q "^$field:" .claude/template-version.yaml; then
            error "Missing required field in version file: $field"
            ((missing++))
        fi
    done

    if [ $missing -eq 0 ]; then
        success "Version tracking file is valid"
        return 0
    else
        ((ERRORS++))
        return 1
    fi
}

main() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Template Validation v${SCRIPT_VERSION}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    info "Checking required files..."
    check_file_exists "CLAUDE.md"
    check_file_exists "CLAUDE.local.md"
    check_file_exists ".claude/template-version.yaml"

    echo ""
    info "Checking directory structure..."
    check_dir_exists ".claude"
    check_dir_exists ".claude/master"
    check_dir_exists ".claude/skills"
    check_dir_exists ".claude/agents"
    check_dir_exists ".claude/commands"

    echo ""
    info "Checking YAML syntax..."
    check_yaml_syntax ".claude/template-version.yaml"
    for yaml_file in .claude/skills/*/skill.yaml; do
        [ -f "$yaml_file" ] && check_yaml_syntax "$yaml_file"
    done
    for yaml_file in .claude/agents/*/agent.yaml; do
        [ -f "$yaml_file" ] && check_yaml_syntax "$yaml_file"
    done

    echo ""
    info "Checking for hardcoded secrets..."
    check_no_secrets

    echo ""
    info "Checking symlinks..."
    check_symlinks

    echo ""
    info "Checking version tracking..."
    check_version_tracking

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Validation Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Total checks: $CHECKS"
    echo -e "Errors:       ${RED}$ERRORS${NC}"
    echo -e "Warnings:     ${YELLOW}$WARNINGS${NC}"
    echo ""

    if [ $ERRORS -eq 0 ]; then
        success "Validation passed!"
        echo ""
        exit 0
    else
        error "Validation failed with $ERRORS errors"
        echo ""
        exit 1
    fi
}

main "$@"
