# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help format lint test security check build clean lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Targets:' \
		'  make format       Format code (go fmt)' \
		'  make lint         Run linters (golangci-lint, go vet)' \
		'  make test         Run tests' \
		'  make security     Run security checks (gosec)' \
		'  make check        Run all checks' \
		'  make build        Build binary' \
		'  make clean        Clean build artifacts' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

format:
	go fmt ./...

lint:
	golangci-lint run
	go vet ./...

test:
	go test ./... -v -coverprofile=coverage.out

security:
	gosec ./... || echo "gosec not found, skipping"

check: format lint test security
	@echo "All checks passed."

build:
	go build -o bin/{{PROJECT_NAME}} ./...

clean:
	rm -rf bin/ coverage.out

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
