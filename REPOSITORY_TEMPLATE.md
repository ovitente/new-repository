# Repository Template

A comprehensive template for new Git repositories with security best practices, code quality tools, and CI/CD pipeline configurations.

## 🛡️ Security Tools

### Pre-commit Security Checks
- **TruffleHog**: Detects secrets and credentials in code
- **GitLeaks**: Scans for hardcoded secrets and API keys
- **Bandit**: Python security linter for common vulnerabilities
- **Safety**: Checks Python dependencies for known security vulnerabilities

### Code Quality Tools
- **Pre-commit hooks**: Automated checks before commits
- **Black**: Python code formatter
- **isort**: Import sorting for Python
- **flake8**: Python linter
- **ESLint**: JavaScript/TypeScript linter
- **Prettier**: Code formatter for multiple languages
- **yamllint**: YAML file validation
- **jsonlint**: JSON file validation

## 🚀 Quick Start

1. **Clone this template**:
   ```bash
   git clone <this-repo-url> your-new-project
   cd your-new-project
   ```

2. **Initialize with your project profile**:
   ```bash
   # Auto-detect project type
   make detect
   
   # Initialize with specific profile
   make init go      # For Go projects
   make init python  # For Python projects
   make init js      # For JavaScript/TypeScript projects
   make init         # For common profile only
   ```

3. **Install dependencies for your profile**:
   ```bash
   make install
   ```

4. **Available profiles**:
   - [`common`](#common-profile) - Basic security and quality checks
   - [`python`](#python-profile) - Python-specific tools (Black, isort, flake8, bandit, mypy)
   - [`js`](#javascripttypescript-profile) - JavaScript/TypeScript tools (ESLint, Prettier, TypeScript)
   - [`go`](#go-profile) - Go tools (gofmt, golangci-lint, go vet)
   - [`terraform`](#terraform-profile) - Terraform tools (terraform fmt, tflint, tfsec)
   - [`pulumi`](#pulumi-profile) - Pulumi tools (pulumi fmt, pulumi validate)
   - [`bash`](#bash-profile) - Bash tools (shellcheck, shfmt)

## ⚡ **Quick Start by Profile**

### **Python Project**
```bash
make init python   # Initialize with Python profile
make install       # Creates venv and installs dependencies
make check         # Run all checks
```

### **JavaScript/TypeScript Project**
```bash
make init js       # Initialize with JS profile
make install       # Installs npm dependencies
make check         # Run all checks
```

### **Go Project**
```bash
make init go       # Initialize with Go profile
make install       # Installs Go tools
make check         # Run all checks
```

### **Terraform Project**
```bash
make init terraform # Initialize with Terraform profile
make install       # Installs Terraform tools
make check         # Run all checks
```

### **Pulumi Project**
```bash
make init pulumi   # Initialize with Pulumi profile
make install       # Installs Pulumi tools
make check         # Run all checks
```

### **Bash Project**
```bash
make init bash     # Initialize with Bash profile
make install       # Installs shell tools
make check         # Run all checks
```

## 📁 Project Structure

```
.
├── .github/                    # GitHub Actions workflows
├── .project-profile           # Project profile configuration
├── .pre-commit-config.yaml    # Auto-generated pre-commit hooks
├── .gitignore                 # Git ignore patterns
├── .editorconfig             # Editor configuration
├── LICENSE                    # Project license
├── SECURITY.md               # Security guidelines
├── docker-compose.yml        # Development environment
├── Dockerfile                # Container configuration
├── Makefile                  # Common development commands
├── scripts/                  # Utility scripts
│   ├── profile-manager.sh    # Profile management script
│   ├── selective-checks.sh   # Selective checks script
│   ├── security-scan.sh      # Security scanning script
│   └── install-tools.sh      # Tools installation script
├── repo-checks/              # Profile-specific configurations
│   ├── common/               # Common checks and configs
│   │   ├── pre-commit-config.yaml
│   │   └── configs/
│   │       ├── .semgrep.yml
│   │       └── .yamllint
│   ├── python/              # Python-specific checks and configs
│   │   ├── pre-commit-config.yaml
│   │   └── configs/
│   │       ├── pyproject.toml
│   │       └── requirements.txt
│   ├── js/                  # JavaScript/TypeScript checks and configs
│   │   ├── pre-commit-config.yaml
│   │   └── configs/
│   │       ├── package.json
│   │       ├── .eslintrc.js
│   │       ├── .prettierrc
│   │       ├── jest.config.js
│   │       └── tsconfig.json
│   ├── go/                  # Go-specific checks and configs
│   │   ├── pre-commit-config.yaml
│   │   └── configs/
│   │       └── .golangci.yml
│   ├── terraform/           # Terraform-specific checks and configs
│   │   ├── pre-commit-config.yaml
│   │   └── configs/
│   │       ├── .tflint.hcl
│   │       └── .terraform-version
│   ├── pulumi/              # Pulumi-specific checks
│   │   └── pre-commit-config.yaml
│   └── bash/                # Bash-specific checks
│       └── pre-commit-config.yaml
└── src/                     # Example source code
```

## 🔧 Configuration Files

### **General Configuration**
- **`.project-profile`**: Defines the project profile and which checks to run
- **`.pre-commit-config.yaml`**: Auto-generated pre-commit hooks based on profile
- **`.editorconfig`**: Editor settings for consistent coding style
- **`.gitignore`**: Git ignore patterns
- **`Makefile`**: Common development commands

### **Profile-Specific Configurations**
Profile-specific configuration files are stored in `repo-checks/{profile}/configs/` and are automatically copied to the project root when a profile is initialized:

- **Python**: `pyproject.toml`, `requirements.txt`
- **JavaScript/TypeScript**: `package.json`, `.eslintrc.js`, `.prettierrc`, `jest.config.js`, `tsconfig.json`
- **Go**: `.golangci.yml`
- **Terraform**: `.tflint.hcl`, `.terraform-version`
- **Common**: `.semgrep.yml`, `.yamllint`

## 📋 Project Profiles

This template supports multiple project profiles that automatically configure the appropriate tools:

### **Common Profile** {#common-profile}
- Basic security checks (TruffleHog, GitLeaks)
- YAML/JSON validation
- Markdown linting
- Commit message formatting

### **Python Profile** {#python-profile}
- All universal checks
- Black code formatting
- isort import sorting
- flake8 linting
- bandit security linting
- MyPy type checking
- Safety dependency scanning

### **JavaScript/TypeScript Profile** {#javascripttypescript-profile}
- All universal checks
- ESLint with security rules
- Prettier code formatting
- TypeScript compilation check
- npm audit for dependencies

### **Go Profile** {#go-profile}
- All universal checks
- gofmt formatting
- golangci-lint
- go vet
- go test
- gosec security scanning

### **Terraform Profile** {#terraform-profile}
- All universal checks
- terraform fmt
- terraform validate
- tflint
- tfsec security scanning
- Checkov security scanning

### **Pulumi Profile** {#pulumi-profile}
- All universal checks
- pulumi fmt
- pulumi validate
- Language-specific checks (TypeScript/Python/Go)

### **Bash Profile** {#bash-profile}
- All universal checks
- shellcheck
- shfmt formatting
- bash syntax validation

## 🛠️ Development Commands

### **Profile Management**
```bash
# Initialize project with profile
make init

# Set project profile
make set-profile

# Show current profile
make show-profile

# List available profiles
make list-profiles

# Auto-detect project type
make detect

# Update pre-commit configuration
make update-config

# Clean profile-specific configuration files
make clean-configs
```

### **Development Commands**
```bash
# Install dependencies for current profile
make install

# Format code (profile-aware)
make format

# Lint code (profile-aware)
make lint

# Security checks
make security

# Run all checks
make check

# Run tests (profile-aware)
make test

# Clean up
make clean
```

### **Environment Management**
```bash
# Python virtual environment
make venv-create    # Create virtual environment
make venv-install   # Install Python dependencies in venv
make venv-clean     # Remove virtual environment

# Clean all local tools
make clean-all      # Remove all local tools and environments
```

### **CI/CD Commands**
```bash
# CI-specific commands (with reports)
make ci-security    # Security checks with JSON reports
make ci-quality     # Quality checks with text reports
make ci-test        # Tests with coverage and JUnit reports
```

### **Selective Checks (changed files only)**
```bash
# Format changed files only
make selective-format

# Lint changed files only
make selective-lint

# Security checks on changed files only
make selective-security

# All checks on changed files only
make selective-check
```

## 🔒 Security Features

- **Secret Detection**: Automated scanning for hardcoded secrets
- **Dependency Scanning**: Vulnerability checks for dependencies
- **Code Quality**: Automated formatting and linting
- **Git Hooks**: Pre-commit validation
- **CI/CD Integration**: GitHub Actions workflows
- **Profile-Based Checks**: Language-specific security and quality tools
- **Selective Validation**: Checks only on changed files for faster feedback
- **Local Installation**: All tools installed locally, no system pollution
- **CI Compatibility**: All CI commands go through Makefile for cross-platform compatibility

## 📝 Usage Examples

### **Python Project**
```bash
# Initialize Python project
make init
# Select: python

# Install dependencies
make install

# Run checks
make check

# Development workflow
make format
make lint
make test
```

### **JavaScript/TypeScript Project**
```bash
# Initialize JS project
make init
# Select: js

# Install dependencies
make install

# Development workflow
make format
make lint
make test
```

### **Go Project**
```bash
# Initialize Go project
make init
# Select: go

# Install dependencies
make install

# Development workflow
make format
make lint
make test
```

### **Terraform Project**
```bash
# Initialize Terraform project
make init
# Select: terraform

# Install dependencies
make install

# Development workflow
make format
make lint
make test
```

### **Pulumi Project**
```bash
# Initialize Pulumi project
make init-pulumi

# Install dependencies
make install

# Development workflow
make format
make lint
make test
```

### **Bash Project**
```bash
# Initialize Bash project
make init-bash

# Install dependencies
make install

# Development workflow
make format
make lint
make test
```

### **Mixed Project (Python + JS)**
```bash
# Set profile to common (will auto-detect)
make set-common

# Install dependencies
make install

# Run selective checks on changed files
make selective-check
```

## 🏠 **Local Installation (No System Pollution)**

All tools are installed locally in the project directory to avoid system pollution. See [LOCAL_INSTALLATION.md](LOCAL_INSTALLATION.md) for detailed information.

### **Python Projects**
- **Virtual Environment**: `venv/` directory
- **Activation**: `source venv/bin/activate`
- **Management**: `make venv-create`, `make venv-install`, `make venv-clean`

### **JavaScript/TypeScript Projects**
- **Dependencies**: `node_modules/` directory
- **Local Tools**: ESLint, Prettier, TypeScript installed locally
- **Scripts**: Added to `package.json` for convenience

### **Go Projects**
- **Tools**: Installed in `$GOPATH/bin` (user-specific)
- **Configuration**: `.golangci.yml` created automatically

### **Terraform Projects**
- **Local Tools**: `.terraform-tools/` directory
- **Tools**: tflint, tfsec installed locally
- **Environment**: PATH updated via `.envrc`

### **Pulumi Projects**
- **Local Tools**: `.pulumi-tools/` directory
- **CLI**: Pulumi CLI installed locally
- **Environment**: PATH updated via `.envrc`

### **Bash Projects**
- **Local Tools**: `.bash-tools/` directory
- **Tools**: shellcheck, shfmt installed locally
- **Environment**: PATH updated via `.envrc`

## 🔄 **CI/CD Compatibility**

This template is designed to work with any CI/CD system by using only Makefile commands:

### **Supported CI Systems**
- **GitHub Actions** (included)
- **GitLab CI**
- **Jenkins**
- **CircleCI**
- **Travis CI**
- **Azure DevOps**
- **Any other CI system**

### **CI Commands**
All CI operations use standardized Makefile commands:

```bash
# Security checks (with reports)
make ci-security

# Quality checks (with reports)
make ci-quality

# Tests (with coverage and JUnit reports)
make ci-test

# All checks combined
make check
```

### **CI Integration Example**
```yaml
# Example for any CI system
- name: Setup project
  run: |
    make init-python  # or init-js, init-go, etc.
    make install

- name: Run security checks
  run: make ci-security

- name: Run quality checks
  run: make ci-quality

- name: Run tests
  run: make ci-test
```

### **Generated Reports**
CI commands generate standardized reports:
- **Security**: JSON reports (bandit, safety, npm audit)
- **Quality**: Text reports (flake8, eslint, golangci-lint)
- **Tests**: JUnit XML and coverage reports

## 🛠️ **Detailed Usage Examples**

### **Complete Python Project Workflow**
```bash
# 1. Initialize Python project
make init-python

# 2. Install dependencies (creates venv automatically)
make install

# 3. Activate virtual environment
source venv/bin/activate

# 4. Development workflow
make format          # Format code with Black and isort
make lint            # Run flake8, bandit, mypy
make test            # Run pytest with coverage
make security        # Run security checks
make check           # Run all checks (format + lint + security)

# 5. Selective checks (only changed files)
make selective-format
make selective-lint
make selective-check

# 6. Clean up when done
make venv-clean
make clean-configs
```

### **Complete JavaScript/TypeScript Project Workflow**
```bash
# 1. Initialize JS project
make init-js

# 2. Install dependencies
make install

# 3. Development workflow
make format          # Format with Prettier
make lint            # Run ESLint and TypeScript checks
make test            # Run Jest tests
make security        # Run npm audit and security checks
make check           # Run all checks

# 4. Using npm scripts (automatically added)
npm run format       # Same as make format
npm run lint         # Same as make lint
npm run lint:fix     # Fix linting issues

# 5. Clean up
make clean-all
```

### **Complete Go Project Workflow**
```bash
# 1. Initialize Go project
make init-go

# 2. Install dependencies
make install

# 3. Development workflow
make format          # Format with gofmt
make lint            # Run golangci-lint
make test            # Run go tests
make security        # Run gosec security checks
make check           # Run all checks

# 4. Go-specific commands
go mod tidy          # Clean up dependencies
go vet ./...         # Additional static analysis
```

### **Complete Terraform Project Workflow**
```bash
# 1. Initialize Terraform project
make init-terraform

# 2. Install dependencies
make install

# 3. Development workflow
make format          # Format with terraform fmt
make lint            # Run tflint and tfsec
make test            # Run terraform validate and plan
make security        # Run security checks
make check           # Run all checks

# 4. Terraform-specific commands
terraform init       # Initialize Terraform
terraform plan       # Preview changes
terraform apply      # Apply changes
```

### **Profile Management Examples**
```bash
# Check current profile
make show-profile

# List available profiles
make list-profiles

# Auto-detect project type
make detect

# Change profile (cleans old configs automatically)
make set-profile
# Enter: js

# Update pre-commit configuration
make update-config

# Clean profile-specific configs
make clean-configs
```

### **Environment Management Examples**
```bash
# Python virtual environment
make venv-create     # Create virtual environment
make venv-install    # Install Python dependencies
make venv-clean      # Remove virtual environment

# Clean all local tools and environments
make clean-all       # Remove venv, node_modules, local tools

# Show help
make help            # List all available commands
```

### **Daily Development Commands**
```bash
# Before starting work
make install         # Install dependencies
source venv/bin/activate  # Activate Python venv (if applicable)

# During development
make format          # Format code
make lint            # Check code quality
make test            # Run tests
make security        # Security checks

# Before committing
make check           # Run all checks
make selective-check # Check only changed files

# After work
make clean           # Clean temporary files
make venv-clean      # Clean virtual environment (if needed)
```

### **Troubleshooting Commands**
```bash
# Reset project configuration
make clean-configs   # Remove profile configs
make init            # Reinitialize profile

# Reset everything
make clean-all       # Remove all local tools
make install         # Reinstall everything

# Check what's wrong
make show-profile    # Show current profile
make detect          # Auto-detect project type
make help            # Show all commands
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make check` to ensure all tests pass
5. Commit your changes (pre-commit hooks will run automatically)
6. Push to your branch
7. Create a Pull Request

## 📄 License

This template is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 