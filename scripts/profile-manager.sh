#!/usr/bin/env bash

# Profile Manager Script
# This script manages project profiles and installs appropriate checks

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROFILE_FILE=".project-profile"
PRE_COMMIT_CONFIG=".pre-commit-config.yaml"
REPO_CHECKS_DIR="repo-checks"

# Available profiles
AVAILABLE_PROFILES=("common" "js" "go" "python" "terraform" "pulumi" "bash")

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

# Function to show usage
show_usage() {
    echo "Profile Manager - Manage project profiles and checks"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  init [PROFILE]     Initialize project with specified profile"
    echo "  set [PROFILE]      Set project profile"
    echo "  install           Install checks for current profile"
    echo "  list              List available profiles"
    echo "  show              Show current profile"
    echo "  detect            Auto-detect project type and suggest profile"
    echo "  update            Update pre-commit configuration"
    echo ""
    echo "Available profiles:"
    for profile in "${AVAILABLE_PROFILES[@]}"; do
        echo "  - $profile"
    done
    echo ""
    echo "Examples:"
    echo "  $0 init python"
    echo "  $0 set js"
    echo "  $0 install"
    echo "  $0 detect"
}

# Function to detect project type
detect_project_type() {
    local detected_types=()
    
    # Check for Python project
    if [[ -f "requirements.txt" || -f "setup.py" || -f "pyproject.toml" || -f "Pipfile" ]]; then
        detected_types+=("python")
    fi
    
    # Check for JavaScript/TypeScript project
    if [[ -f "package.json" || -f "yarn.lock" || -f "pnpm-lock.yaml" ]]; then
        detected_types+=("js")
    fi
    
    # Check for Go project
    if [[ -f "go.mod" || -f "go.sum" ]]; then
        detected_types+=("go")
    fi
    
    # Check for Terraform project
    if [[ -f "*.tf" || -f "terragrunt.hcl" ]]; then
        detected_types+=("terraform")
    fi
    
    # Check for Pulumi project
    if [[ -f "Pulumi.yaml" || -f "Pulumi.yml" ]]; then
        detected_types+=("pulumi")
    fi
    
    # Check for Bash scripts
    if find . -name "*.sh" -o -name "*.bash" | grep -q .; then
        detected_types+=("bash")
    fi
    
    echo "${detected_types[*]}"
}

# Function to read current profile
get_current_profile() {
    if [[ -f "$PROFILE_FILE" ]]; then
        grep "^PROFILE=" "$PROFILE_FILE" | cut -d'=' -f2 | tr -d ' '
    else
        echo "common"
    fi
}

# Function to set profile
set_profile() {
    local profile="$1"
    
    # Validate profile
    if [[ ! " ${AVAILABLE_PROFILES[*]} " =~ " ${profile} " ]]; then
        error "Invalid profile: $profile"
        echo "Available profiles: ${AVAILABLE_PROFILES[*]}"
        exit 1
    fi
    
    # Clean up existing profile-specific configs
    cleanup_profile_configs
    
    # Create or update profile file
    cat > "$PROFILE_FILE" << EOF
# Project Profile Configuration
# This file defines which security and quality checks to run for this repository
# Available profiles: common, js, go, python, terraform, pulumi, bash
# Multiple profiles can be specified (comma-separated)

PROFILE=$profile

# Optional: Override specific checks
# ENABLE_CHECKS=security,format,lint,test
# DISABLE_CHECKS=terraform,pulumi

# Optional: Custom file patterns for this project
# INCLUDE_PATTERNS=*.py,*.js,*.ts,*.go,*.tf,*.pulumi
# EXCLUDE_PATTERNS=node_modules/*,venv/*,__pycache__/*
EOF
    
    success "Profile set to: $profile"
}

# Function to cleanup profile-specific configuration files
cleanup_profile_configs() {
    log "Cleaning up profile-specific configuration files..."
    
    # List of files that should be removed (profile-specific)
    local files_to_remove=(
        "pyproject.toml"
        "requirements.txt"
        "package.json"
        ".eslintrc.js"
        ".prettierrc"
        "jest.config.js"
        "tsconfig.json"
        ".tflint.hcl"
        ".terraform-version"
        ".golangci.yml"
        ".semgrep.yml"
        ".yamllint"
    )
    
    for file in "${files_to_remove[@]}"; do
        if [[ -f "$file" ]]; then
            rm -f "$file"
            log "Removed: $file"
        fi
    done
    
    success "Profile configuration files cleaned up"
}

# Function to copy profile-specific configuration files
copy_profile_configs() {
    local profile="$1"
    local config_dir="$REPO_CHECKS_DIR/$profile/configs"
    
    if [[ -d "$config_dir" ]]; then
        log "Copying $profile configuration files..."
        
        # Copy all config files from profile directory to root
        cp -r "$config_dir"/* . 2>/dev/null || true
        
        success "Configuration files copied for $profile profile"
    else
        log "No configuration files found for $profile profile"
    fi
}

# Function to merge pre-commit configurations
merge_pre_commit_configs() {
    local profiles=("$@")
    local temp_config="/tmp/pre-commit-config-$$.yaml"
    
    # Start with common config
    if [[ -f "$REPO_CHECKS_DIR/common/pre-commit-config.yaml" ]]; then
        cp "$REPO_CHECKS_DIR/common/pre-commit-config.yaml" "$temp_config"
    else
        echo "repos:" > "$temp_config"
    fi
    
    # Merge additional profiles
    for profile in "${profiles[@]}"; do
        if [[ "$profile" != "common" && -f "$REPO_CHECKS_DIR/$profile/pre-commit-config.yaml" ]]; then
            log "Merging $profile profile..."
            
            # Extract repos section from profile config
            local profile_repos=$(sed -n '/^repos:/,/^[^ ]/p' "$REPO_CHECKS_DIR/$profile/pre-commit-config.yaml" | sed '1d;$d')
            
            # Append to main config
            echo "$profile_repos" >> "$temp_config"
        fi
    done
    
    # Replace main config
    mv "$temp_config" "$PRE_COMMIT_CONFIG"
    success "Pre-commit configuration updated"
}

# Function to install profile
install_profile() {
    local profile="$1"
    shift
    local profiles=("$@")
    
    log "Installing profile: $profile"
    
    # Copy profile-specific configuration files
    copy_profile_configs "$profile"
    
    # Merge pre-commit configurations (always include common + specified profile)
    if [[ ${#profiles[@]} -eq 0 ]]; then
        profiles=("common" "$profile")
    fi
    merge_pre_commit_configs "${profiles[@]}"
    
    # Install pre-commit hooks
    if command -v pre-commit >/dev/null 2>&1; then
        log "Installing pre-commit hooks..."
        pre-commit install
        pre-commit install --hook-type commit-msg
        success "Pre-commit hooks installed"
    else
        warning "pre-commit not found. Please install it first."
    fi
    
    # Install profile-specific dependencies
    install_profile_dependencies "$profile"
}

# Function to install profile-specific dependencies
install_profile_dependencies() {
    local profile="$1"
    
    case "$profile" in
        "python")
            log "Installing Python dependencies..."
            
            # Create virtual environment if it doesn't exist
            if [[ ! -d "venv" ]]; then
                log "Creating Python virtual environment..."
                python3 -m venv venv
            fi
            
            # Activate virtual environment
            source venv/bin/activate
            
            # Upgrade pip
            pip install --upgrade pip
            
            # Install project dependencies
            if [[ -f "requirements.txt" ]]; then
                pip install -r requirements.txt
            fi
            
            # Install development tools in virtual environment
            pip install black isort flake8 bandit safety mypy pylint pytest pytest-cov
            
            # Create activation script for convenience
            cat > activate-venv.sh << 'EOF'
#!/usr/bin/env bash
echo "Activating Python virtual environment..."
source venv/bin/activate
echo "Virtual environment activated. Run 'deactivate' to exit."
EOF
            chmod +x activate-venv.sh
            
            log "Python virtual environment created. Activate with: source venv/bin/activate"
            ;;
            
        "js")
            log "Installing JavaScript dependencies..."
            
            # Install project dependencies locally
            if [[ -f "package.json" ]]; then
                npm install
            fi
            
            # Install development tools locally (not globally)
            npm install --save-dev eslint prettier typescript @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-plugin-security eslint-plugin-import eslint-plugin-jest eslint-plugin-node eslint-plugin-prettier
            
            # Create npm scripts for convenience
            if [[ -f "package.json" ]]; then
                # Add scripts to package.json if they don't exist
                if ! grep -q '"format"' package.json; then
                    npm pkg set scripts.format="prettier --write \"**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}\""
                fi
                if ! grep -q '"lint"' package.json; then
                    npm pkg set scripts.lint="eslint . --ext .js,.jsx,.ts,.tsx"
                fi
                if ! grep -q '"lint:fix"' package.json; then
                    npm pkg set scripts.lint:fix="eslint . --ext .js,.jsx,.ts,.tsx --fix"
                fi
            fi
            
            log "JavaScript dependencies installed locally in node_modules/"
            ;;
            
        "go")
            log "Installing Go dependencies..."
            
            # Initialize Go module if not exists
            if [[ ! -f "go.mod" ]]; then
                go mod init $(basename $(pwd))
            fi
            
            # Install Go tools locally
            go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
            go install github.com/zricethezav/gitleaks/v8@latest
            go install github.com/fzipp/gocyclo/cmd/gocyclo@latest
            go install github.com/gordonklaus/ineffassign@latest
            
            # Create .golangci.yml if it doesn't exist
            if [[ ! -f ".golangci.yml" ]]; then
                cat > .golangci.yml << 'EOF'
run:
  timeout: 5m
  modules-download-mode: readonly

linters:
  enable:
    - gofmt
    - goimports
    - govet
    - errcheck
    - staticcheck
    - gosimple
    - ineffassign
    - typecheck
    - unused
    - gosec
    - gocyclo
    - dupl
    - misspell
    - unparam
    - nakedret
    - prealloc
    - gocritic
    - goconst
    - gocognit
    - gomnd
    - gomoddirectives
    - gomodguard
    - gosec
    - gosimple
    - govet
    - ineffassign
    - misspell
    - nakedret
    - prealloc
    - staticcheck
    - structcheck
    - typecheck
    - unconvert
    - unparam
    - unused
    - varcheck
    - whitespace

linters-settings:
  gocyclo:
    min-complexity: 15
  dupl:
    threshold: 100
  goconst:
    min-len: 2
    min-occurrences: 3
  gomnd:
    checks: argument,case,condition,operation,return,assign
  gocritic:
    enabled-tags:
      - diagnostic
      - experimental
      - opinionated
      - performance
      - style
    disabled-checks:
      - dupImport
      - ifElseChain
      - octalLiteral
      - whyNoLint
      - wrapperFunc

issues:
  exclude-rules:
    - path: _test\.go
      linters:
        - gomnd
        - gocyclo
        - dupl
        - gocognit
        - goconst
        - gomnd
        - gocritic
        - gosimple
        - ineffassign
        - nakedret
        - prealloc
        - staticcheck
        - structcheck
        - unconvert
        - unparam
        - unused
        - varcheck
        - whitespace
EOF
            fi
            
            log "Go tools installed and configured"
            ;;
            
        "terraform")
            log "Installing Terraform dependencies..."
            
            # Create terraform directory structure
            mkdir -p {modules,environments/{dev,staging,prod}}
            
            # Install tflint locally if not available
            if ! command -v tflint >/dev/null 2>&1; then
                log "Installing tflint locally..."
                mkdir -p .terraform-tools
                cd .terraform-tools
                curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                cd ..
                echo 'export PATH="$PWD/.terraform-tools:$PATH"' >> .envrc
            fi
            
            # Install tfsec locally if not available
            if ! command -v tfsec >/dev/null 2>&1; then
                log "Installing tfsec locally..."
                mkdir -p .terraform-tools
                cd .terraform-tools
                curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
                cd ..
                echo 'export PATH="$PWD/.terraform-tools:$PATH"' >> .envrc
            fi
            
            log "Terraform tools installed locally in .terraform-tools/"
            ;;
            
        "pulumi")
            log "Installing Pulumi dependencies..."
            
            # Install Pulumi CLI locally if not available
            if ! command -v pulumi >/dev/null 2>&1; then
                log "Installing Pulumi CLI locally..."
                mkdir -p .pulumi-tools
                cd .pulumi-tools
                curl -fsSL https://get.pulumi.com | sh
                cd ..
                echo 'export PATH="$PWD/.pulumi-tools/.pulumi/bin:$PATH"' >> .envrc
            fi
            
            # Create Pulumi project structure
            mkdir -p {src,infrastructure,scripts}
            
            log "Pulumi tools installed locally in .pulumi-tools/"
            ;;
            
        "bash")
            log "Installing Bash dependencies..."
            
            # Install shellcheck locally if not available
            if ! command -v shellcheck >/dev/null 2>&1; then
                log "Installing shellcheck locally..."
                mkdir -p .bash-tools
                cd .bash-tools
                curl -s https://raw.githubusercontent.com/koalaman/shellcheck/master/shellcheck.install | sh
                cd ..
                echo 'export PATH="$PWD/.bash-tools:$PATH"' >> .envrc
            fi
            
            # Install shfmt locally if not available
            if ! command -v shfmt >/dev/null 2>&1; then
                log "Installing shfmt locally..."
                mkdir -p .bash-tools
                cd .bash-tools
                curl -s https://raw.githubusercontent.com/mvdan/sh/master/cmd/shfmt/install.sh | bash
                cd ..
                echo 'export PATH="$PWD/.bash-tools:$PATH"' >> .envrc
            fi
            
            log "Bash tools installed locally in .bash-tools/"
            ;;
    esac
    
    success "Dependencies installed for $profile profile"
}

# Function to initialize project
init_project() {
    local profile="$1"
    
    log "Initializing project with profile: $profile"
    
    # Set profile
    set_profile "$profile"
    
    # Always include common profile + the specified profile
    local profiles=("common" "$profile")
    
    # Install profile (this will include common automatically)
    install_profile "$profile" "${profiles[@]}"
    
    # Create basic project structure
    create_project_structure "$profile"
    
    success "Project initialized with $profile profile (includes common profile)"
}

# Function to create project structure
create_project_structure() {
    local profile="$1"
    
    case "$profile" in
        "python")
            [[ ! -f "requirements.txt" ]] && echo "# Python dependencies" > requirements.txt
            [[ ! -f "setup.py" ]] && echo "# Python setup" > setup.py
            ;;
        "js")
            [[ ! -f "package.json" ]] && npm init -y
            ;;
        "go")
            [[ ! -f "go.mod" ]] && go mod init $(basename $(pwd))
            ;;
        "terraform")
            [[ ! -f "main.tf" ]] && echo "# Terraform configuration" > main.tf
            ;;
        "pulumi")
            [[ ! -f "Pulumi.yaml" ]] && echo "# Pulumi configuration" > Pulumi.yaml
            ;;
    esac
}

# Main script logic
case "${1:-}" in
    "init")
        if [[ -z "${2:-}" ]]; then
            error "Profile not specified"
            show_usage
            exit 1
        fi
        init_project "$2"
        ;;
    "set")
        if [[ -z "${2:-}" ]]; then
            error "Profile not specified"
            show_usage
            exit 1
        fi
        set_profile "$2"
        ;;
    "install")
        local current_profile=$(get_current_profile)
        local detected_types=$(detect_project_type)
        local profiles=("common" "$current_profile")
        
        # Add detected types if not already included
        for detected in $detected_types; do
            if [[ ! " ${profiles[*]} " =~ " ${detected} " ]]; then
                profiles+=("$detected")
            fi
        done
        
        install_profile "${profiles[@]}"
        ;;
    "list")
        echo "Available profiles:"
        for profile in "${AVAILABLE_PROFILES[@]}"; do
            echo "  - $profile"
        done
        ;;
    "show")
        local current_profile=$(get_current_profile)
        echo "Current profile: $current_profile"
        ;;
    "detect")
        local detected_types=$(detect_project_type)
        if [[ -n "$detected_types" ]]; then
            echo "Detected project types: $detected_types"
            echo "Suggested profiles: common, $detected_types"
        else
            echo "No specific project type detected. Using common profile."
        fi
        ;;
    "update")
        local current_profile=$(get_current_profile)
        local detected_types=$(detect_project_type)
        local profiles=("common" "$current_profile")
        
        for detected in $detected_types; do
            if [[ ! " ${profiles[*]} " =~ " ${detected} " ]]; then
                profiles+=("$detected")
            fi
        done
        
        merge_pre_commit_configs "${profiles[@]}"
        ;;
    "cleanup-configs")
        cleanup_profile_configs
        ;;
    *)
        show_usage
        exit 1
        ;;
esac 