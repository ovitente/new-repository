# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help format lint test security check clean lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Targets:' \
		'  make format       Format scripts (shfmt)' \
		'  make lint         Run linters (shellcheck)' \
		'  make test         Run tests' \
		'  make security     Run security checks' \
		'  make check        Run all checks' \
		'  make clean        Clean artifacts' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

format:
	shfmt -w -i 2 -ci . || echo "shfmt not found"

lint:
	find . -name '*.sh' -not -path './.git/*' -exec shellcheck {} +

test:
	@if ls tests/*.sh 1>/dev/null 2>&1; then \
		for t in tests/*.sh; do echo "Running $$t..."; bash "$$t"; done; \
	else echo "No tests found in tests/"; fi

security:
	find . -name '*.sh' -not -path './.git/*' -exec shellcheck --severity=error {} +

check: format lint test
	@echo "All checks passed."

clean:
	find . -name '*.log' -delete

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
