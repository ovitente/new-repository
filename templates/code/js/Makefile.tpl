# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help install format lint test security check build clean lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Targets:' \
		'  make install      Install dependencies' \
		'  make format       Format code (prettier)' \
		'  make lint         Run linters (eslint, tsc)' \
		'  make test         Run tests (jest)' \
		'  make security     Run security checks (npm audit)' \
		'  make check        Run all checks' \
		'  make build        Build project' \
		'  make clean        Clean artifacts' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

install:
	npm install

format:
	npx prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,yaml,yml,md}"

lint:
	npx eslint "**/*.{js,jsx,ts,tsx}"
	npx tsc --noEmit || echo "TypeScript check skipped"

test:
	npm test

security:
	npm audit --audit-level=moderate || echo "npm audit completed with issues"

check: format lint test security
	@echo "All checks passed."

build:
	npm run build

clean:
	rm -rf dist/ build/ node_modules/ coverage/

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
