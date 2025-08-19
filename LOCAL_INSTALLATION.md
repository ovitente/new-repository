# Local Installation Guide

This guide explains how the repository template installs all tools locally to avoid system pollution.

## 🎯 **Why Local Installation?**

- **No System Pollution**: Tools don't interfere with system packages
- **Project Isolation**: Each project has its own tool versions
- **Easy Cleanup**: Remove all tools with one command
- **Version Control**: Different projects can use different tool versions
- **Portability**: Project can be moved without reinstalling tools

## 📁 **Local Installation Structure**

```
project/
├── venv/                    # Python virtual environment
├── node_modules/            # Node.js dependencies
├── .terraform-tools/        # Terraform tools (tflint, tfsec)
├── .pulumi-tools/          # Pulumi CLI
├── .bash-tools/            # Bash tools (shellcheck, shfmt)
├── .envrc                  # Environment variables for local tools
├── activate-venv.sh        # Python virtual environment activation script
└── go.mod                  # Go module (tools in $GOPATH/bin)
```

## 🐍 **Python Projects**

### **Virtual Environment**
- **Location**: `venv/` directory
- **Activation**: `source venv/bin/activate`
- **Deactivation**: `deactivate`

### **Tools Installed**
- `black` - Code formatting
- `isort` - Import sorting
- `flake8` - Linting
- `bandit` - Security linting
- `safety` - Dependency security
- `mypy` - Type checking
- `pylint` - Additional linting
- `pytest` - Testing
- `pytest-cov` - Coverage

### **Management Commands**
```bash
# Create virtual environment
make venv-create

# Install dependencies
make venv-install

# Activate (manual)
source venv/bin/activate

# Clean up
make venv-clean
```

## 🟨 **JavaScript/TypeScript Projects**

### **Local Dependencies**
- **Location**: `node_modules/` directory
- **Package Manager**: npm (local installation)
- **Scripts**: Added to `package.json`

### **Tools Installed**
- `eslint` - Linting
- `prettier` - Code formatting
- `typescript` - Type checking
- `@typescript-eslint/eslint-plugin` - TypeScript ESLint rules
- `eslint-plugin-security` - Security rules
- `eslint-plugin-import` - Import rules

### **NPM Scripts Added**
```json
{
  "scripts": {
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}\"",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix"
  }
}
```

## 🔵 **Go Projects**

### **Tools Location**
- **Tools**: Installed in `$GOPATH/bin` (user-specific)
- **Configuration**: `.golangci.yml` created automatically

### **Tools Installed**
- `golangci-lint` - Comprehensive linting
- `git-secrets` - Secret detection
- `gocyclo` - Cyclomatic complexity
- `ineffassign` - Ineffective assignments

### **Configuration**
The `.golangci.yml` file is created with comprehensive linting rules including:
- Code formatting (gofmt, goimports)
- Static analysis (govet, errcheck, staticcheck)
- Security (gosec)
- Complexity (gocyclo)
- And many more...

## 🟫 **Terraform Projects**

### **Local Tools**
- **Location**: `.terraform-tools/` directory
- **Environment**: PATH updated via `.envrc`

### **Tools Installed**
- `tflint` - Terraform linting
- `tfsec` - Security scanning
- `terraform` - Infrastructure as Code

### **Directory Structure**
```
terraform/
├── modules/                 # Reusable modules
├── environments/           # Environment-specific configs
│   ├── dev/
│   ├── staging/
│   └── prod/
└── .terraform-tools/       # Local tools
```

## 🟪 **Pulumi Projects**

### **Local Tools**
- **Location**: `.pulumi-tools/` directory
- **CLI**: Pulumi CLI installed locally

### **Directory Structure**
```
pulumi/
├── src/                    # Source code
├── infrastructure/         # Infrastructure definitions
├── scripts/               # Utility scripts
└── .pulumi-tools/         # Local tools
```

## 🟢 **Bash Projects**

### **Local Tools**
- **Location**: `.bash-tools/` directory
- **Environment**: PATH updated via `.envrc`

### **Tools Installed**
- `shellcheck` - Shell script linting
- `shfmt` - Shell script formatting

## 🔧 **Environment Management**

### **Automatic PATH Updates**
The `.envrc` file is created to update PATH for local tools:

```bash
# Terraform tools
export PATH="$PWD/.terraform-tools:$PATH"

# Pulumi tools
export PATH="$PWD/.pulumi-tools/.pulumi/bin:$PATH"

# Bash tools
export PATH="$PWD/.bash-tools:$PATH"
```

### **Manual Activation**
```bash
# Load environment variables
source .envrc

# Or use direnv (if installed)
direnv allow
```

## 🧹 **Cleanup Commands**

### **Individual Cleanup**
```bash
# Python
make venv-clean

# Node.js
rm -rf node_modules/

# Terraform
rm -rf .terraform-tools/

# Pulumi
rm -rf .pulumi-tools/

# Bash
rm -rf .bash-tools/
```

### **Complete Cleanup**
```bash
# Remove all local tools and environments
make clean-all
```

This removes:
- `venv/` - Python virtual environment
- `node_modules/` - Node.js dependencies
- `.terraform-tools/` - Terraform tools
- `.pulumi-tools/` - Pulumi tools
- `.bash-tools/` - Bash tools
- `.envrc` - Environment variables
- `activate-venv.sh` - Activation script

## 🔄 **Reinstallation**

After cleanup, you can reinstall everything:

```bash
# Reinstall for current profile
make install

# Or initialize with specific profile
./scripts/profile-manager.sh init python
```

## 📋 **Benefits Summary**

✅ **No System Pollution**: Tools don't affect system packages
✅ **Project Isolation**: Each project has independent tool versions
✅ **Easy Cleanup**: Remove everything with one command
✅ **Version Control**: Different projects can use different versions
✅ **Portability**: Move projects without reinstalling tools
✅ **Reproducibility**: Same environment across different machines
✅ **Security**: No need for system-wide installations
✅ **Flexibility**: Easy to switch between tool versions

## 🚀 **Best Practices**

1. **Always use local installations** for project-specific tools
2. **Commit `.envrc`** to version control for team consistency
3. **Use `make clean-all`** before sharing or archiving projects
4. **Document tool versions** in project documentation
5. **Use virtual environments** for Python projects
6. **Keep `node_modules/`** in `.gitignore`
7. **Use `direnv`** for automatic environment loading (optional) 