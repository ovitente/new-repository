# @lat: [[delivery]]
# Scaffold generator — creates/upgrades project repositories.
.DEFAULT_GOAL := help
.PHONY: help scaffold list lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Scaffold generator' \
		'' \
		'  make scaffold PATH=<dir> PROFILE=<profile>' \
		'  make list                List available profiles' \
		'' \
		'  make lat-install         Install lat.md CLI (for this repo)' \
		'  make lat-check           Validate knowledge graph' \
		'  make lat-policy          Check lat.md sync policy'

scaffold:
	@if [ -z "$(PATH)" ] || [ -z "$(PROFILE)" ]; then \
		echo "Usage: make scaffold PATH=<dir> PROFILE=<profile>"; \
		echo "Run 'make list' to see available profiles."; \
		exit 1; \
	fi
	./scaffold "$(PATH)" "$(PROFILE)"

list:
	@./scaffold --list

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
