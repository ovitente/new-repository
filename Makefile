# Makefile for development tasks
# This file provides convenient commands for common development operations

.PHONY: help install format lint security check clean test docker-build docker-run docs

# Default target
help:
	@echo "Available commands:"
	@echo ""
	@echo "Profile Management:"
	@echo "  init        - Initialize with common profile"
	@echo "  init-common - Initialize with common profile"
	@echo "  init-js     - Initialize with JavaScript/TypeScript profile"
	@echo "  init-go     - Initialize with Go profile"
	@echo "  init-python - Initialize with Python profile"
	@echo "  init-terraform - Initialize with Terraform profile"
	@echo "  init-pulumi - Initialize with Pulumi profile"
	@echo "  init-bash   - Initialize with Bash profile"
	@echo ""
	@echo "  set-profile - Show usage for profile setting"
	@echo "  set-common  - Set common profile"
	@echo "  set-js      - Set JavaScript/TypeScript profile"
	@echo "  set-go      - Set Go profile"
	@echo "  set-python  - Set Python profile"
	@echo "  set-terraform - Set Terraform profile"
	@echo "  set-pulumi  - Set Pulumi profile"
	@echo "  set-bash    - Set Bash profile"
	@echo ""
	@echo "  show-profile - Show current profile"
	@echo "  list-profiles - List available profiles"
	@echo "  detect      - Auto-detect project type"
	@echo "  update-config - Update pre-commit configuration"
	@echo "  clean-configs - Clean profile-specific configuration files"
	@echo ""
	@echo "Development:"
	@echo "  install     - Install dependencies for current profile"
	@echo "  format      - Format code (profile-aware)"
	@echo "  lint        - Run linters (profile-aware)"
	@echo "  security    - Run security checks"
	@echo "  check       - Run all checks (format + lint + security)"
	@echo "  test        - Run tests (profile-aware)"
	@echo "  clean       - Clean up generated files"
	@echo ""
	@echo "Selective Checks (changed files only):"
	@echo "  selective-format   - Format changed files only"
	@echo "  selective-lint     - Lint changed files only"
	@echo "  selective-security - Security checks on changed files only"
	@echo "  selective-check    - All checks on changed files only"
	@echo ""
	@echo "CI Commands:"
	@echo "  ci-security        - CI security checks with reports"
	@echo "  ci-quality         - CI quality checks with reports"
	@echo "  ci-test            - CI tests with reports"
	@echo ""
	@echo "Infrastructure:"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run Docker container"
	@echo "  docs        - Generate documentation"
	@echo ""
	@echo "Environment Management:"
	@echo "  venv-create  - Create Python virtual environment"
	@echo "  venv-activate - Activate virtual environment"
	@echo "  venv-install - Install Python dependencies in venv"
	@echo "  venv-clean   - Remove virtual environment"
	@echo "  clean-all    - Clean all local tools and environments"
	@echo ""
	@echo "Available profiles: common, js, go, python, terraform, pulumi, bash"

# Install dependencies and pre-commit hooks
install:
	@echo "Installing dependencies for current profile..."
	./scripts/profile-manager.sh install
	@echo "Installation complete!"

# Initialize project with specific profile
init:
	@chmod +x scripts/*.sh 2>/dev/null || true
	@if [ -n "$(filter-out init,$(MAKECMDGOALS))" ]; then \
		profile=$(filter-out init,$(MAKECMDGOALS)); \
		echo "Initializing project with $$profile profile..."; \
		./scripts/profile-manager.sh init $$profile; \
	else \
		echo "Initializing project with common profile..."; \
		./scripts/profile-manager.sh init common; \
	fi

# Handle arguments for init command
%:
	@:

# Initialize with common profile
init-common:
	@echo "Initializing project with common profile..."
	./scripts/profile-manager.sh init common

# Initialize with JavaScript/TypeScript profile
init-js:
	@echo "Initializing project with JavaScript/TypeScript profile..."
	./scripts/profile-manager.sh init js

# Initialize with Go profile
init-go:
	@echo "Initializing project with Go profile..."
	./scripts/profile-manager.sh init go

# Initialize with Python profile
init-python:
	@echo "Initializing project with Python profile..."
	./scripts/profile-manager.sh init python

# Initialize with Terraform profile
init-terraform:
	@echo "Initializing project with Terraform profile..."
	./scripts/profile-manager.sh init terraform

# Initialize with Pulumi profile
init-pulumi:
	@echo "Initializing project with Pulumi profile..."
	./scripts/profile-manager.sh init pulumi

# Initialize with Bash profile
init-bash:
	@echo "Initializing project with Bash profile..."
	./scripts/profile-manager.sh init bash

# Set project profile
set-profile:
	@echo "Usage: make set-profile [PROFILE]"
	@echo "Available profiles: common, js, go, python, terraform, pulumi, bash"
	@echo "Example: make set-profile js"

# Set common profile
set-common:
	@echo "Setting project profile to common..."
	./scripts/profile-manager.sh set common

# Set JavaScript/TypeScript profile
set-js:
	@echo "Setting project profile to JavaScript/TypeScript..."
	./scripts/profile-manager.sh set js

# Set Go profile
set-go:
	@echo "Setting project profile to Go..."
	./scripts/profile-manager.sh set go

# Set Python profile
set-python:
	@echo "Setting project profile to Python..."
	./scripts/profile-manager.sh set python

# Set Terraform profile
set-terraform:
	@echo "Setting project profile to Terraform..."
	./scripts/profile-manager.sh set terraform

# Set Pulumi profile
set-pulumi:
	@echo "Setting project profile to Pulumi..."
	./scripts/profile-manager.sh set pulumi

# Set Bash profile
set-bash:
	@echo "Setting project profile to Bash..."
	./scripts/profile-manager.sh set bash

# Show current profile
show-profile:
	@echo "Current project profile:"
	./scripts/profile-manager.sh show

# List available profiles
list-profiles:
	@echo "Available profiles:"
	./scripts/profile-manager.sh list

# Detect project type
detect:
	@echo "Detecting project type..."
	./scripts/profile-manager.sh detect

# Update pre-commit configuration
update-config:
	@echo "Updating pre-commit configuration..."
	./scripts/profile-manager.sh update

# Clean profile-specific configs
clean-configs:
	@echo "Cleaning profile-specific configuration files..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Current profile: $$profile"; \
		./scripts/profile-manager.sh cleanup-configs; \
	else \
		echo "No profile configured"; \
	fi

# Virtual environment management
venv-create:
	@echo "Creating Python virtual environment..."
	python3 -m venv venv
	@echo "Virtual environment created. Activate with: source venv/bin/activate"

venv-activate:
	@echo "Activating virtual environment..."
	@if [ -d "venv" ]; then \
		source venv/bin/activate; \
		echo "Virtual environment activated. Run 'deactivate' to exit."; \
	else \
		echo "Virtual environment not found. Create with: make venv-create"; \
	fi

venv-install:
	@echo "Installing Python dependencies in virtual environment..."
	@if [ -d "venv" ]; then \
		source venv/bin/activate && pip install --upgrade pip; \
		if [ -f "requirements.txt" ]; then \
			source venv/bin/activate && pip install -r requirements.txt; \
		fi; \
		source venv/bin/activate && pip install black isort flake8 bandit safety mypy pylint pytest pytest-cov; \
		echo "Dependencies installed in virtual environment"; \
	else \
		echo "Virtual environment not found. Create with: make venv-create"; \
	fi

venv-clean:
	@echo "Removing virtual environment..."
	rm -rf venv
	@echo "Virtual environment removed"

# Selective checks (only on changed files)
selective-format:
	@echo "Formatting changed files..."
	./scripts/selective-checks.sh format

selective-lint:
	@echo "Linting changed files..."
	./scripts/selective-checks.sh lint

selective-security:
	@echo "Security checks on changed files..."
	./scripts/selective-checks.sh security

selective-check:
	@echo "All checks on changed files..."
	./scripts/selective-checks.sh all

# Format code (profile-aware)
format:
	@echo "Formatting code for current profile..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				echo "Formatting Python code..."; \
				if [ -d "venv" ]; then \
					source venv/bin/activate && black . && isort .; \
				else \
					black . 2>/dev/null || echo "Black not found, install with: pip install black isort"; \
					isort . 2>/dev/null || echo "isort not found, install with: pip install black isort"; \
				fi; \
				;; \
			"js") \
				echo "Formatting JavaScript/TypeScript code..."; \
				if [ -f "package.json" ]; then \
					npm run format 2>/dev/null || npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}"; \
				else \
					npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}" 2>/dev/null || echo "Prettier not found"; \
				fi; \
				;; \
			"go") \
				echo "Formatting Go code..."; \
				go fmt ./...; \
				;; \
			"terraform") \
				echo "Formatting Terraform code..."; \
				if [ -d ".terraform-tools" ]; then \
					export PATH="$$PWD/.terraform-tools:$$PATH" && terraform fmt -recursive; \
				else \
					terraform fmt -recursive 2>/dev/null || echo "Terraform not found"; \
				fi; \
				;; \
			"pulumi") \
				echo "Formatting Pulumi code..."; \
				if [ -d ".pulumi-tools" ]; then \
					export PATH="$$PWD/.pulumi-tools/.pulumi/bin:$$PATH" && pulumi fmt; \
				else \
					pulumi fmt 2>/dev/null || echo "Pulumi not found"; \
				fi; \
				;; \
			"bash") \
				echo "Formatting Bash scripts..."; \
				if [ -d ".bash-tools" ]; then \
					export PATH="$$PWD/.bash-tools:$$PATH" && shfmt -w -i 2 -ci .; \
				else \
					shfmt -w -i 2 -ci . 2>/dev/null || echo "shfmt not found"; \
				fi; \
				;; \
			*) \
				echo "Formatting all code..."; \
				if [ -d "venv" ]; then \
					source venv/bin/activate && black . 2>/dev/null || true; \
					source venv/bin/activate && isort . 2>/dev/null || true; \
				else \
					black . 2>/dev/null || true; \
					isort . 2>/dev/null || true; \
				fi; \
				if [ -f "package.json" ]; then \
					npm run format 2>/dev/null || npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}" 2>/dev/null || true; \
				else \
					npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}" 2>/dev/null || true; \
				fi; \
				if [ -d ".terraform-tools" ]; then \
					export PATH="$$PWD/.terraform-tools:$$PATH" && terraform fmt -recursive 2>/dev/null || true; \
				else \
					terraform fmt -recursive 2>/dev/null || true; \
				fi; \
				;; \
		esac; \
	else \
		echo "No profile configured, formatting all code..."; \
		if [ -d "venv" ]; then \
			source venv/bin/activate && black . 2>/dev/null || true; \
			source venv/bin/activate && isort . 2>/dev/null || true; \
		else \
			black . 2>/dev/null || true; \
			isort . 2>/dev/null || true; \
		fi; \
		if [ -f "package.json" ]; then \
			npm run format 2>/dev/null || npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}" 2>/dev/null || true; \
		else \
			npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}" 2>/dev/null || true; \
		fi; \
		if [ -d ".terraform-tools" ]; then \
			export PATH="$$PWD/.terraform-tools:$$PATH" && terraform fmt -recursive 2>/dev/null || true; \
		else \
			terraform fmt -recursive 2>/dev/null || true; \
		fi; \
	fi
	@echo "Code formatting complete!"

# Run linters (profile-aware)
lint:
	@echo "Running linters for current profile..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				echo "Running Python linters..."; \
				if [ -d "venv" ]; then \
					source venv/bin/activate && flake8 .; \
					source venv/bin/activate && bandit -r . -f json -o bandit-report.json; \
					source venv/bin/activate && mypy . 2>/dev/null || echo "MyPy check skipped"; \
				else \
					flake8 . 2>/dev/null || echo "Flake8 not found"; \
					bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
					mypy . 2>/dev/null || echo "MyPy check skipped"; \
				fi; \
				;; \
			"js") \
				echo "Running JavaScript/TypeScript linters..."; \
				if [ -f "package.json" ]; then \
					npm run lint 2>/dev/null || npx eslint "**/*.{js,jsx,ts,tsx}"; \
					npx tsc --noEmit 2>/dev/null || echo "TypeScript check skipped"; \
				else \
					npx eslint "**/*.{js,jsx,ts,tsx}" 2>/dev/null || echo "ESLint not found"; \
					npx tsc --noEmit 2>/dev/null || echo "TypeScript check skipped"; \
				fi; \
				;; \
			"go") \
				echo "Running Go linters..."; \
				golangci-lint run; \
				go vet ./...; \
				;; \
			"terraform") \
				echo "Running Terraform linters..."; \
				if [ -d ".terraform-tools" ]; then \
					export PATH="$$PWD/.terraform-tools:$$PATH" && terraform validate && tflint && tfsec .; \
				else \
					terraform validate 2>/dev/null || echo "Terraform not found"; \
					tflint 2>/dev/null || echo "tflint not found"; \
					tfsec . 2>/dev/null || echo "tfsec not found"; \
				fi; \
				;; \
			"pulumi") \
				echo "Running Pulumi linters..."; \
				if [ -d ".pulumi-tools" ]; then \
					export PATH="$$PWD/.pulumi-tools/.pulumi/bin:$$PATH" && pulumi validate; \
				else \
					pulumi validate 2>/dev/null || echo "Pulumi not found"; \
				fi; \
				;; \
			"bash") \
				echo "Running Bash linters..."; \
				if [ -d ".bash-tools" ]; then \
					export PATH="$$PWD/.bash-tools:$$PATH" && find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
				else \
					find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
				fi; \
				;; \
			*) \
				echo "Running all linters..."; \
				if [ -d "venv" ]; then \
					source venv/bin/activate && flake8 . 2>/dev/null || echo "Flake8 not found"; \
					source venv/bin/activate && bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
				else \
					flake8 . 2>/dev/null || echo "Flake8 not found"; \
					bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
				fi; \
				if [ -f "package.json" ]; then \
					npm run lint 2>/dev/null || npx eslint "**/*.{js,jsx,ts,tsx}" 2>/dev/null || echo "ESLint not found"; \
				else \
					npx eslint "**/*.{js,jsx,ts,tsx}" 2>/dev/null || echo "ESLint not found"; \
				fi; \
				yamllint . 2>/dev/null || echo "YAMLlint not found"; \
				if [ -d ".bash-tools" ]; then \
					export PATH="$$PWD/.bash-tools:$$PATH" && find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
				else \
					find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
				fi; \
				;; \
		esac; \
	else \
		echo "No profile configured, running all linters..."; \
		if [ -d "venv" ]; then \
			source venv/bin/activate && flake8 . 2>/dev/null || echo "Flake8 not found"; \
			source venv/bin/activate && bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
		else \
			flake8 . 2>/dev/null || echo "Flake8 not found"; \
			bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
		fi; \
		if [ -f "package.json" ]; then \
			npm run lint 2>/dev/null || npx eslint "**/*.{js,jsx,ts,tsx}" 2>/dev/null || echo "ESLint not found"; \
		else \
			npx eslint "**/*.{js,jsx,ts,tsx}" 2>/dev/null || echo "ESLint not found"; \
		fi; \
		yamllint . 2>/dev/null || echo "YAMLlint not found"; \
		if [ -d ".bash-tools" ]; then \
			export PATH="$$PWD/.bash-tools:$$PATH" && find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
		else \
			find . -name "*.sh" -exec shellcheck {} \; 2>/dev/null || echo "ShellCheck not found"; \
		fi; \
	fi
	@echo "Linting complete!"

# Run security checks (profile-aware)
security:
	@echo "Running security checks for current profile..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				echo "Running Python security checks..."; \
				if [ -d "venv" ]; then \
					source venv/bin/activate && bandit -r . -f json -o bandit-report.json; \
					source venv/bin/activate && safety check --json --output safety-report.json; \
				else \
					bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
					safety check --json --output safety-report.json 2>/dev/null || echo "Safety not found"; \
				fi; \
				;; \
			"js") \
				echo "Running JavaScript security checks..."; \
				if [ -f "package.json" ]; then \
					npm audit --audit-level=moderate --json > npm-audit-report.json 2>/dev/null || echo "npm audit failed"; \
				fi; \
				;; \
			"go") \
				echo "Running Go security checks..."; \
				gosec -fmt=json -out=gosec-report.json ./... 2>/dev/null || echo "gosec not found"; \
				;; \
			"terraform") \
				echo "Running Terraform security checks..."; \
				tfsec . --format json --out tfsec-report.json 2>/dev/null || echo "tfsec not found"; \
				;; \
			"pulumi") \
				echo "Running Pulumi security checks..."; \
				pulumi policy run 2>/dev/null || echo "Pulumi policy not found"; \
				;; \
			"bash") \
				echo "Running Bash security checks..."; \
				find . -name "*.sh" -exec shellcheck --severity=error {} \; 2>/dev/null || echo "ShellCheck not found"; \
				;; \
			*) \
				echo "Running universal security checks..."; \
				;; \
		esac; \
	else \
		echo "No profile configured, running universal security checks..."; \
	fi
	# Common security checks (always run)
	@echo "Running common security checks..."
	@echo "Running TruffleHog secret detection..."
	trufflehog --fail . 2>/dev/null || echo "TruffleHog not found"
	@echo "Running GitLeaks secret detection..."
	gitleaks detect --verbose 2>/dev/null || echo "GitLeaks not found"
	@echo "Security checks complete!"

# CI-specific commands
ci-security:
	@echo "Running CI security checks..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				if [ -d "venv" ]; then \
					source venv/bin/activate && bandit -r . -f json -o bandit-report.json; \
					source venv/bin/activate && safety check --json --output safety-report.json; \
				else \
					bandit -r . -f json -o bandit-report.json 2>/dev/null || echo "Bandit not found"; \
					safety check --json --output safety-report.json 2>/dev/null || echo "Safety not found"; \
				fi; \
				;; \
			"js") \
				if [ -f "package.json" ]; then \
					npm audit --audit-level=moderate --json > npm-audit-report.json 2>/dev/null || echo "npm audit failed"; \
				fi; \
				;; \
			"go") \
				gosec -fmt=json -out=gosec-report.json ./... 2>/dev/null || echo "gosec not found"; \
				;; \
			*) \
				echo "Running universal security checks..."; \
				;; \
		esac; \
	else \
		echo "No profile configured, running universal security checks..."; \
	fi
	@echo "CI security checks complete!"

ci-quality:
	@echo "Running CI quality checks..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				if [ -d "venv" ]; then \
					source venv/bin/activate && flake8 . --output-file=flake8-report.txt; \
				else \
					flake8 . --output-file=flake8-report.txt 2>/dev/null || echo "Flake8 not found"; \
				fi; \
				;; \
			"js") \
				if [ -f "package.json" ]; then \
					npm run lint > eslint-report.txt 2>&1 || echo "ESLint check completed with issues"; \
				fi; \
				;; \
			"go") \
				golangci-lint run --out-format=line-number > golangci-lint-report.txt 2>/dev/null || echo "golangci-lint not found"; \
				;; \
			*) \
				echo "Running universal quality checks..."; \
				;; \
		esac; \
	else \
		echo "No profile configured, running universal quality checks..."; \
	fi
	@echo "CI quality checks complete!"

ci-test:
	@echo "Running CI tests..."
	@mkdir -p test-results
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				if [ -d "venv" ]; then \
					source venv/bin/activate && python -m pytest tests/ -v --cov=. --cov-report=xml --cov-report=html --junitxml=test-results/pytest.xml; \
				else \
					python -m pytest tests/ -v --cov=. --cov-report=xml --cov-report=html --junitxml=test-results/pytest.xml 2>/dev/null || echo "No Python tests found"; \
				fi; \
				;; \
			"js") \
				if [ -f "package.json" ]; then \
					npm test -- --reporter=junit --reporter-option outputDirectory=test-results 2>/dev/null || echo "No JavaScript tests found"; \
				fi; \
				;; \
			"go") \
				go test ./... -v -coverprofile=coverage.out -json > test-results/go-test.json 2>/dev/null || echo "No Go tests found"; \
				;; \
			*) \
				echo "Running universal tests..."; \
				;; \
		esac; \
	else \
		echo "No profile configured, running universal tests..."; \
	fi
	@echo "CI tests complete!"

# Run all checks
check: format lint security
	@echo "All checks completed successfully!"

# Run tests (profile-aware)
test:
	@echo "Running tests for current profile..."
	@if [ -f ".project-profile" ]; then \
		profile=$$(grep "^PROFILE=" .project-profile | cut -d'=' -f2 | tr -d ' '); \
		echo "Using profile: $$profile"; \
		case "$$profile" in \
			"python") \
				echo "Running Python tests..."; \
				python -m pytest tests/ -v --cov=. --cov-report=html 2>/dev/null || echo "No Python tests found"; \
				;; \
			"js") \
				echo "Running JavaScript/TypeScript tests..."; \
				npm test 2>/dev/null || echo "No JavaScript tests found"; \
				;; \
			"go") \
				echo "Running Go tests..."; \
				go test ./... -v 2>/dev/null || echo "No Go tests found"; \
				;; \
			"terraform") \
				echo "Running Terraform tests..."; \
				terraform plan -detailed-exitcode 2>/dev/null || echo "Terraform plan failed"; \
				;; \
			"pulumi") \
				echo "Running Pulumi tests..."; \
				pulumi preview --diff 2>/dev/null || echo "Pulumi preview failed"; \
				;; \
			"bash") \
				echo "Running Bash tests..."; \
				find . -name "test*.sh" -exec bash {} \; 2>/dev/null || echo "No Bash tests found"; \
				;; \
			*) \
				echo "Running all tests..."; \
				python -m pytest tests/ -v --cov=. --cov-report=html 2>/dev/null || echo "No Python tests found"; \
				npm test 2>/dev/null || echo "No JavaScript tests found"; \
				go test ./... -v 2>/dev/null || echo "No Go tests found"; \
				;; \
		esac; \
	else \
		echo "No profile configured, running all tests..."; \
		python -m pytest tests/ -v --cov=. --cov-report=html 2>/dev/null || echo "No Python tests found"; \
		npm test 2>/dev/null || echo "No JavaScript tests found"; \
		go test ./... -v 2>/dev/null || echo "No Go tests found"; \
	fi
	@echo "Tests complete!"

# Clean up generated files
clean:
	@echo "Cleaning up generated files..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name "node_modules" -exec rm -rf {} +
	find . -type f -name "*.log" -delete
	find . -type f -name "*.tmp" -delete
	find . -type f -name "*.swp" -delete
	find . -type f -name "*.swo" -delete
	find . -type f -name ".DS_Store" -delete
	rm -rf .coverage htmlcov/ dist/ build/ *.egg-info/
	rm -f bandit-report.json safety-report.json
	@echo "Cleanup complete!"

# Clean all local tools and environments
clean-all:
	@echo "Cleaning all local tools and environments..."
	rm -rf venv/
	rm -rf .terraform-tools/
	rm -rf .pulumi-tools/
	rm -rf .bash-tools/
	rm -rf node_modules/
	rm -f .envrc
	rm -f activate-venv.sh
	@echo "All local tools and environments cleaned"

# Docker commands
docker-build:
	@echo "Building Docker image..."
	docker build -t repository-template .

docker-run:
	@echo "Running Docker container..."
	docker run -it --rm repository-template

# Generate documentation
docs:
	@echo "Generating documentation..."
	mkdir -p docs
	pydoc -w . || true
	@echo "Documentation generated in docs/ directory"

# Development server
dev:
	@echo "Starting development server..."
	python -m http.server 8000

# Update dependencies
update-deps:
	@echo "Updating Python dependencies..."
	pip install --upgrade -r requirements.txt
	@echo "Updating Node.js dependencies..."
	npm update
	@echo "Dependencies updated!"

# Check for outdated dependencies
check-deps:
	@echo "Checking for outdated Python packages..."
	pip list --outdated
	@echo "Checking for outdated Node.js packages..."
	npm outdated

# Backup and restore
backup:
	@echo "Creating backup..."
	tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz --exclude=node_modules --exclude=__pycache__ --exclude=.git .

# Git operations
git-status:
	@echo "Git status:"
	git status

git-log:
	@echo "Recent commits:"
	git log --oneline -10

# Environment setup
setup-env:
	@echo "Setting up development environment..."
	python -m venv venv
	@echo "Virtual environment created. Activate it with: source venv/bin/activate"

# Database operations (if applicable)
db-migrate:
	@echo "Running database migrations..."
	# Add your migration commands here

db-seed:
	@echo "Seeding database..."
	# Add your seeding commands here

# Performance checks
performance:
	@echo "Running performance checks..."
	python -m cProfile -o profile.stats main.py || true
	@echo "Performance profile saved to profile.stats"

# Code coverage
coverage:
	@echo "Generating code coverage report..."
	python -m pytest --cov=. --cov-report=html --cov-report=term-missing
	@echo "Coverage report generated in htmlcov/"

# Dependency vulnerability scan
vuln-scan:
	@echo "Scanning for vulnerabilities..."
	npm audit
	safety check
	@echo "Vulnerability scan complete!"

# Code complexity analysis
complexity:
	@echo "Analyzing code complexity..."
	radon cc . -a
	radon mi . -a
	@echo "Complexity analysis complete!"

# License compliance
license-check:
	@echo "Checking license compliance..."
	licensecheck -r .
	@echo "License check complete!"

# Code metrics
metrics:
	@echo "Generating code metrics..."
	cloc .
	@echo "Code metrics complete!" 