#!/bin/bash

# Development Tools Installation Script
# This script installs all necessary development and security tools

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Python package
install_python_package() {
    local package="$1"
    if ! command_exists "$package"; then
        log "Installing $package..."
        pip install "$package"
        success "$package installed successfully"
    else
        log "$package already installed"
    fi
}

# Function to install Go package
install_go_package() {
    local package="$1"
    local binary_name="$2"
    if ! command_exists "$binary_name"; then
        log "Installing $package..."
        go install "$package@latest"
        success "$package installed successfully"
    else
        log "$package already installed"
    fi
}

# Function to install Node.js package
install_node_package() {
    local package="$1"
    if ! command_exists "$package"; then
        log "Installing $package..."
        npm install -g "$package"
        success "$package installed successfully"
    else
        log "$package already installed"
    fi
}

log "Starting development tools installation..."

# Check if we're on a supported platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
else
    error "Unsupported platform: $OSTYPE"
    exit 1
fi

# Install system dependencies
log "Installing system dependencies..."

if command_exists apt-get; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install -y \
        curl \
        wget \
        git \
        build-essential \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        golang-go
elif command_exists yum; then
    # CentOS/RHEL
    sudo yum update -y
    sudo yum install -y \
        curl \
        wget \
        git \
        gcc \
        gcc-c++ \
        python3-pip \
        nodejs \
        npm \
        golang
elif command_exists brew; then
    # macOS with Homebrew
    brew update
    brew install \
        curl \
        wget \
        git \
        python3 \
        node \
        go
else
    warning "No supported package manager found. Please install dependencies manually."
fi

# Install Python tools
log "Installing Python development tools..."

# Upgrade pip
python3 -m pip install --upgrade pip

# Install Python packages
PYTHON_PACKAGES=(
    "pre-commit"
    "black"
    "isort"
    "flake8"
    "bandit"
    "safety"
    "pytest"
    "pytest-cov"
    "mypy"
    "pylint"
    "radon"
    "coverage"
    "tox"
    "trufflehog"
    "semgrep"
    "pip-audit"
    "autopep8"
    "pydocstyle"
    "mccabe"
    "pytest-mock"
    "pytest-xdist"
    "pytest-html"
    "sphinx"
    "sphinx-rtd-theme"
    "myst-parser"
)

for package in "${PYTHON_PACKAGES[@]}"; do
    install_python_package "$package"
done

# Install Go tools
log "Installing Go development tools..."

GO_PACKAGES=(
    "github.com/zricethezav/gitleaks/v8/cmd/gitleaks@latest"
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
    "github.com/securecodewarrior/git-secrets@latest"
)

for package in "${GO_PACKAGES[@]}"; do
    binary_name=$(basename "$package" | cut -d'@' -f1)
    install_go_package "$package" "$binary_name"
done

# Install Node.js tools
log "Installing Node.js development tools..."

NODE_PACKAGES=(
    "eslint"
    "prettier"
    "typescript"
    "ts-node"
    "jest"
    "nodemon"
    "snyk"
    "npm-check-updates"
    "license-checker"
)

for package in "${NODE_PACKAGES[@]}"; do
    install_node_package "$package"
done

# Install additional security tools
log "Installing additional security tools..."

# Install Trivy
if ! command_exists trivy; then
    log "Installing Trivy..."
    if [[ "$PLATFORM" == "linux" ]]; then
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install -y trivy
    elif [[ "$PLATFORM" == "macos" ]]; then
        brew install trivy
    fi
    success "Trivy installed successfully"
else
    log "Trivy already installed"
fi

# Install Hadolint (Dockerfile linter)
if ! command_exists hadolint; then
    log "Installing Hadolint..."
    if [[ "$PLATFORM" == "linux" ]]; then
        wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
        sudo mv /tmp/hadolint /usr/local/bin/hadolint
        sudo chmod +x /usr/local/bin/hadolint
    elif [[ "$PLATFORM" == "macos" ]]; then
        brew install hadolint
    fi
    success "Hadolint installed successfully"
else
    log "Hadolint already installed"
fi

# Install ShellCheck
if ! command_exists shellcheck; then
    log "Installing ShellCheck..."
    if command_exists apt-get; then
        sudo apt-get install -y shellcheck
    elif command_exists yum; then
        sudo yum install -y epel-release
        sudo yum install -y ShellCheck
    elif command_exists brew; then
        brew install shellcheck
    fi
    success "ShellCheck installed successfully"
else
    log "ShellCheck already installed"
fi

# Install yamllint
if ! command_exists yamllint; then
    log "Installing yamllint..."
    if command_exists apt-get; then
        sudo apt-get install -y yamllint
    elif command_exists yum; then
        sudo yum install -y yamllint
    elif command_exists brew; then
        brew install yamllint
    else
        pip install yamllint
    fi
    success "yamllint installed successfully"
else
    log "yamllint already installed"
fi

# Install Terraform tools
if ! command_exists terraform; then
    log "Installing Terraform..."
    if command_exists apt-get; then
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt-get update
        sudo apt-get install -y terraform
    elif command_exists yum; then
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
        sudo yum install -y terraform
    elif command_exists brew; then
        brew install terraform
    fi
    success "Terraform installed successfully"
else
    log "Terraform already installed"
fi

# Install tflint
if ! command_exists tflint; then
    log "Installing tflint..."
    if [[ "$PLATFORM" == "linux" ]]; then
        wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip
        unzip /tmp/tflint.zip -d /tmp
        sudo mv /tmp/tflint /usr/local/bin/
        rm /tmp/tflint.zip
    elif [[ "$PLATFORM" == "macos" ]]; then
        brew install tflint
    fi
    success "tflint installed successfully"
else
    log "tflint already installed"
fi

# Install pre-commit hooks
log "Installing pre-commit hooks..."
if command_exists pre-commit; then
    pre-commit install
    pre-commit install --hook-type commit-msg
    success "Pre-commit hooks installed successfully"
else
    error "Pre-commit not found. Please install it first."
fi

# Install project dependencies
log "Installing project dependencies..."

# Python dependencies
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    success "Python dependencies installed"
fi

# Node.js dependencies
if [ -f "package.json" ]; then
    npm install
    success "Node.js dependencies installed"
fi

# Create necessary directories
log "Creating necessary directories..."
mkdir -p {security-reports,quality-reports,test-reports,docs,monitoring}

# Set up Git hooks
log "Setting up Git hooks..."
if [ -d ".git" ]; then
    # Create .git/hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Make sure hooks are executable
    chmod +x .git/hooks/*
    
    success "Git hooks configured"
else
    warning "Not a Git repository. Please initialize Git first."
fi

# Final summary
log "Installation completed successfully!"
echo ""
echo "Installed tools:"
echo "================"
echo "Python: black, isort, flake8, bandit, safety, pytest, mypy, pylint, radon, coverage, tox, trufflehog, semgrep"
echo "Go: gitleaks, golangci-lint, git-secrets"
echo "Node.js: eslint, prettier, typescript, jest, snyk"
echo "Security: trivy, hadolint, shellcheck, yamllint"
echo "Infrastructure: terraform, tflint"
echo ""
echo "Next steps:"
echo "1. Run 'make install' to install project-specific dependencies"
echo "2. Run 'make check' to verify everything is working"
echo "3. Run 'make security' to perform initial security scan"
echo "4. Configure your IDE to use the installed tools"
echo ""
success "All development tools have been installed successfully!" 