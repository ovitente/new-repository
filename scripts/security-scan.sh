#!/bin/bash

# Comprehensive Security Scanning Script
# This script runs multiple security tools to scan the codebase

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPORTS_DIR="security-reports"
LOG_FILE="security-scan.log"
FAIL_ON_ERRORS=${FAIL_ON_ERRORS:-false}

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

# Initialize log file
echo "Security Scan Started: $(date)" > "$LOG_FILE"

log "Starting comprehensive security scan..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run security tool with error handling
run_security_tool() {
    local tool_name="$1"
    local command="$2"
    local output_file="$3"
    
    log "Running $tool_name..."
    
    if eval "$command" > "$output_file" 2>&1; then
        success "$tool_name completed successfully"
        return 0
    else
        error "$tool_name failed with exit code $?"
        if [ "$FAIL_ON_ERRORS" = "true" ]; then
            return 1
        fi
        return 0
    fi
}

# 1. TruffleHog - Secret Detection
if command_exists trufflehog; then
    run_security_tool "TruffleHog" \
        "trufflehog --fail ." \
        "$REPORTS_DIR/trufflehog-report.txt"
else
    warning "TruffleHog not found, skipping secret detection"
fi

# 2. GitLeaks - Git History Secret Detection
if command_exists gitleaks; then
    run_security_tool "GitLeaks" \
        "gitleaks detect --verbose" \
        "$REPORTS_DIR/gitleaks-report.txt"
else
    warning "GitLeaks not found, skipping git history secret detection"
fi

# 3. Bandit - Python Security Linting
if command_exists bandit; then
    run_security_tool "Bandit" \
        "bandit -r . -f json -o $REPORTS_DIR/bandit-report.json" \
        "$REPORTS_DIR/bandit-output.txt"
else
    warning "Bandit not found, skipping Python security linting"
fi

# 4. Safety - Python Dependency Security
if command_exists safety; then
    run_security_tool "Safety" \
        "safety check --json --output $REPORTS_DIR/safety-report.json" \
        "$REPORTS_DIR/safety-output.txt"
else
    warning "Safety not found, skipping Python dependency security check"
fi

# 5. npm audit - Node.js Dependency Security
if command_exists npm && [ -f "package.json" ]; then
    run_security_tool "npm audit" \
        "npm audit --audit-level=moderate" \
        "$REPORTS_DIR/npm-audit-report.txt"
else
    warning "npm not found or no package.json, skipping Node.js dependency audit"
fi

# 6. Snyk - Advanced Security Scanning
if command_exists snyk; then
    run_security_tool "Snyk" \
        "snyk test --severity-threshold=high" \
        "$REPORTS_DIR/snyk-report.txt"
else
    warning "Snyk not found, skipping advanced security scanning"
fi

# 7. Semgrep - Static Analysis
if command_exists semgrep; then
    run_security_tool "Semgrep" \
        "semgrep scan --config auto --json --output $REPORTS_DIR/semgrep-report.json" \
        "$REPORTS_DIR/semgrep-output.txt"
else
    warning "Semgrep not found, skipping static analysis"
fi

# 8. Trivy - Container Vulnerability Scanning
if command_exists trivy && [ -f "Dockerfile" ]; then
    run_security_tool "Trivy" \
        "trivy fs --format json --output $REPORTS_DIR/trivy-report.json ." \
        "$REPORTS_DIR/trivy-output.txt"
else
    warning "Trivy not found or no Dockerfile, skipping container vulnerability scanning"
fi

# 9. Check for hardcoded secrets using grep
log "Checking for hardcoded secrets patterns..."
grep -r -i -n --exclude-dir={node_modules,.git,venv,__pycache__} \
    -E "(password|secret|key|token|api_key|private_key)" . \
    > "$REPORTS_DIR/hardcoded-secrets.txt" 2>/dev/null || true

# 10. Check for exposed ports in Docker
if [ -f "Dockerfile" ]; then
    log "Checking Dockerfile for security issues..."
    grep -n "EXPOSE" Dockerfile > "$REPORTS_DIR/docker-exposed-ports.txt" 2>/dev/null || true
fi

# 11. Check for environment variables
log "Checking for environment variable usage..."
grep -r -n --exclude-dir={node_modules,.git,venv,__pycache__} \
    -E "process\.env|os\.environ|getenv" . \
    > "$REPORTS_DIR/env-usage.txt" 2>/dev/null || true

# Generate summary report
log "Generating security scan summary..."
{
    echo "Security Scan Summary"
    echo "===================="
    echo "Scan completed: $(date)"
    echo ""
    echo "Reports generated:"
    ls -la "$REPORTS_DIR/"
    echo ""
    echo "Recommendations:"
    echo "1. Review all generated reports"
    echo "2. Address high and critical vulnerabilities first"
    echo "3. Update dependencies with known vulnerabilities"
    echo "4. Remove any hardcoded secrets found"
    echo "5. Review exposed ports and services"
} > "$REPORTS_DIR/security-summary.txt"

# Check for critical issues
critical_issues=0

# Check if any reports contain critical findings
if [ -f "$REPORTS_DIR/bandit-report.json" ]; then
    if grep -q '"severity": "HIGH"' "$REPORTS_DIR/bandit-report.json"; then
        ((critical_issues++))
        error "High severity issues found in Bandit report"
    fi
fi

if [ -f "$REPORTS_DIR/safety-report.json" ]; then
    if grep -q '"severity": "HIGH"' "$REPORTS_DIR/safety-report.json"; then
        ((critical_issues++))
        error "High severity issues found in Safety report"
    fi
fi

if [ -f "$REPORTS_DIR/npm-audit-report.txt" ]; then
    if grep -q "high\|critical" "$REPORTS_DIR/npm-audit-report.txt"; then
        ((critical_issues++))
        error "High/Critical severity issues found in npm audit"
    fi
fi

# Final summary
if [ $critical_issues -eq 0 ]; then
    success "Security scan completed. No critical issues found."
    log "All security reports saved to $REPORTS_DIR/"
else
    error "Security scan completed with $critical_issues critical issue(s) found."
    log "Please review the reports in $REPORTS_DIR/"
    if [ "$FAIL_ON_ERRORS" = "true" ]; then
        exit 1
    fi
fi

log "Security scan completed successfully" 