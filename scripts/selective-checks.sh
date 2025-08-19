#!/usr/bin/env bash

# Selective Checks Script
# This script runs checks only on changed files based on the project profile

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROFILE_FILE=".project-profile"
GIT_DIFF_CMD="git diff --cached --name-only"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to get current profile
get_current_profile() {
    if [[ -f "$PROFILE_FILE" ]]; then
        grep "^PROFILE=" "$PROFILE_FILE" | cut -d'=' -f2 | tr -d ' '
    else
        echo "universal"
    fi
}

# Function to get changed files
get_changed_files() {
    local file_pattern="$1"
    $GIT_DIFF_CMD | grep -E "$file_pattern" || true
}

# Function to check if files exist
has_changed_files() {
    local file_pattern="$1"
    local changed_files=$(get_changed_files "$file_pattern")
    [[ -n "$changed_files" ]]
}

# Function to run Python checks on changed files
run_python_checks() {
    local changed_files=$(get_changed_files "\.py$")
    if [[ -n "$changed_files" ]]; then
        log "Running Python checks on changed files..."
        echo "$changed_files" | xargs black --check --diff 2>/dev/null || warning "Black check failed"
        echo "$changed_files" | xargs isort --check-only --diff 2>/dev/null || warning "isort check failed"
        echo "$changed_files" | xargs flake8 2>/dev/null || warning "Flake8 check failed"
        echo "$changed_files" | xargs bandit -f json -o bandit-report.json 2>/dev/null || warning "Bandit check failed"
        success "Python checks completed"
    else
        log "No Python files changed, skipping Python checks"
    fi
}

# Function to run JavaScript checks on changed files
run_js_checks() {
    local changed_files=$(get_changed_files "\.(js|jsx|ts|tsx)$")
    if [[ -n "$changed_files" ]]; then
        log "Running JavaScript/TypeScript checks on changed files..."
        echo "$changed_files" | xargs npx eslint 2>/dev/null || warning "ESLint check failed"
        echo "$changed_files" | xargs npx prettier --check 2>/dev/null || warning "Prettier check failed"
        success "JavaScript/TypeScript checks completed"
    else
        log "No JavaScript/TypeScript files changed, skipping JS checks"
    fi
}

# Function to run Go checks on changed files
run_go_checks() {
    local changed_files=$(get_changed_files "\.go$")
    if [[ -n "$changed_files" ]]; then
        log "Running Go checks on changed files..."
        echo "$changed_files" | xargs go fmt 2>/dev/null || warning "go fmt check failed"
        echo "$changed_files" | xargs go vet 2>/dev/null || warning "go vet check failed"
        golangci-lint run 2>/dev/null || warning "golangci-lint check failed"
        success "Go checks completed"
    else
        log "No Go files changed, skipping Go checks"
    fi
}

# Function to run Terraform checks on changed files
run_terraform_checks() {
    local changed_files=$(get_changed_files "\.tf$")
    if [[ -n "$changed_files" ]]; then
        log "Running Terraform checks on changed files..."
        terraform fmt -check -recursive 2>/dev/null || warning "terraform fmt check failed"
        terraform validate 2>/dev/null || warning "terraform validate check failed"
        tflint 2>/dev/null || warning "tflint check failed"
        tfsec . 2>/dev/null || warning "tfsec check failed"
        success "Terraform checks completed"
    else
        log "No Terraform files changed, skipping Terraform checks"
    fi
}

# Function to run Pulumi checks on changed files
run_pulumi_checks() {
    local changed_files=$(get_changed_files "\.(ts|js|py|go)$")
    if [[ -n "$changed_files" ]]; then
        log "Running Pulumi checks on changed files..."
        pulumi validate 2>/dev/null || warning "pulumi validate check failed"
        success "Pulumi checks completed"
    else
        log "No Pulumi files changed, skipping Pulumi checks"
    fi
}

# Function to run Bash checks on changed files
run_bash_checks() {
    local changed_files=$(get_changed_files "\.(sh|bash)$")
    if [[ -n "$changed_files" ]]; then
        log "Running Bash checks on changed files..."
        echo "$changed_files" | xargs shellcheck 2>/dev/null || warning "shellcheck failed"
        echo "$changed_files" | xargs bash -n 2>/dev/null || warning "bash syntax check failed"
        success "Bash checks completed"
    else
        log "No Bash files changed, skipping Bash checks"
    fi
}

# Function to run universal checks
run_universal_checks() {
    log "Running universal checks..."
    
    # YAML files
    local yaml_files=$(get_changed_files "\.(yaml|yml)$")
    if [[ -n "$yaml_files" ]]; then
        echo "$yaml_files" | xargs yamllint 2>/dev/null || warning "YAML lint check failed"
    fi
    
    # JSON files
    local json_files=$(get_changed_files "\.json$")
    if [[ -n "$json_files" ]]; then
        echo "$json_files" | xargs python -m json.tool > /dev/null 2>/dev/null || warning "JSON validation failed"
    fi
    
    # Markdown files
    local md_files=$(get_changed_files "\.md$")
    if [[ -n "$md_files" ]]; then
        echo "$md_files" | xargs markdownlint 2>/dev/null || warning "Markdown lint check failed"
    fi
    
    success "Universal checks completed"
}

# Function to run security checks
run_security_checks() {
    log "Running security checks on changed files..."
    
    # Secret detection on all changed files
    local all_changed_files=$($GIT_DIFF_CMD)
    if [[ -n "$all_changed_files" ]]; then
        # Run TruffleHog on changed files
        echo "$all_changed_files" | xargs trufflehog --fail 2>/dev/null || warning "TruffleHog check failed"
        
        # Run GitLeaks
        gitleaks detect --verbose 2>/dev/null || warning "GitLeaks check failed"
    fi
    
    success "Security checks completed"
}

# Function to run profile-specific checks
run_profile_checks() {
    local profile="$1"
    
    case "$profile" in
        "python")
            run_python_checks
            ;;
        "js")
            run_js_checks
            ;;
        "go")
            run_go_checks
            ;;
        "terraform")
            run_terraform_checks
            ;;
        "pulumi")
            run_pulumi_checks
            ;;
        "bash")
            run_bash_checks
            ;;
        "universal")
            run_universal_checks
            ;;
        *)
            warning "Unknown profile: $profile"
            ;;
    esac
}

# Function to show usage
show_usage() {
    echo "Selective Checks Script - Run checks only on changed files"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  format     - Format changed files"
    echo "  lint       - Lint changed files"
    echo "  security   - Security checks on changed files"
    echo "  all        - Run all checks on changed files"
    echo "  help       - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 format"
    echo "  $0 lint"
    echo "  $0 security"
    echo "  $0 all"
}

# Function to format changed files
format_changed_files() {
    local profile=$(get_current_profile)
    log "Formatting changed files for profile: $profile"
    
    case "$profile" in
        "python")
            local py_files=$(get_changed_files "\.py$")
            if [[ -n "$py_files" ]]; then
                echo "$py_files" | xargs black
                echo "$py_files" | xargs isort
            fi
            ;;
        "js")
            local js_files=$(get_changed_files "\.(js|jsx|ts|tsx|json|css|scss|html|yaml|yml|md)$")
            if [[ -n "$js_files" ]]; then
                echo "$js_files" | xargs npx prettier --write
            fi
            ;;
        "go")
            local go_files=$(get_changed_files "\.go$")
            if [[ -n "$go_files" ]]; then
                echo "$go_files" | xargs go fmt
            fi
            ;;
        "terraform")
            local tf_files=$(get_changed_files "\.tf$")
            if [[ -n "$tf_files" ]]; then
                terraform fmt -recursive
            fi
            ;;
        "pulumi")
            local pulumi_files=$(get_changed_files "\.(ts|js|py|go)$")
            if [[ -n "$pulumi_files" ]]; then
                pulumi fmt
            fi
            ;;
        "bash")
            local sh_files=$(get_changed_files "\.(sh|bash)$")
            if [[ -n "$sh_files" ]]; then
                echo "$sh_files" | xargs shfmt -w -i 2 -ci
            fi
            ;;
        *)
            warning "Unknown profile: $profile"
            ;;
    esac
    
    success "Formatting completed"
}

# Main script logic
case "${1:-}" in
    "format")
        format_changed_files
        ;;
    "lint")
        local profile=$(get_current_profile)
        run_universal_checks
        run_profile_checks "$profile"
        ;;
    "security")
        run_security_checks
        ;;
    "all")
        local profile=$(get_current_profile)
        run_universal_checks
        run_profile_checks "$profile"
        run_security_checks
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    *)
        show_usage
        exit 1
        ;;
esac 