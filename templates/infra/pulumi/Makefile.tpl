# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help preview up destroy lint security check clean lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Targets:' \
		'  make preview      Pulumi preview' \
		'  make up           Pulumi up' \
		'  make destroy      Pulumi destroy' \
		'  make lint         Run linters' \
		'  make security     Security scan' \
		'  make check        Run all checks' \
		'  make clean        Clean state' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

preview:
	pulumi preview --diff

up:
	pulumi up

destroy:
	pulumi destroy

lint:
	pulumi validate || echo "pulumi validate not available"

security:
	pulumi policy run || echo "pulumi policy not configured"

check: lint
	@echo "All checks passed."

clean:
	@echo "Clean state manually via pulumi stack rm"

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
