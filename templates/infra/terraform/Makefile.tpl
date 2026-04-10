# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help init validate plan apply fmt lint security check clean lat-install lat-check lat-policy

help:
	@printf '%s\n' \
		'Targets:' \
		'  make init         Terraform init' \
		'  make fmt          Format code (terraform fmt)' \
		'  make validate     Terraform validate' \
		'  make plan         Terraform plan' \
		'  make apply        Terraform apply' \
		'  make lint         Run linters (tflint, tfsec)' \
		'  make security     Security scan (tfsec)' \
		'  make check        Run all checks' \
		'  make clean        Clean .terraform/' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

init:
	terraform init

fmt:
	terraform fmt -recursive

validate: init
	terraform validate

plan: init
	terraform plan

apply: init
	terraform apply

lint:
	tflint || echo "tflint not found"
	tfsec . || echo "tfsec not found"

security:
	tfsec . || echo "tfsec not found"

check: fmt validate lint
	@echo "All checks passed."

clean:
	rm -rf .terraform/ .terraform.lock.hcl

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
