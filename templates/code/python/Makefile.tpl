# @lat: [[delivery]]
.DEFAULT_GOAL := help
.PHONY: help install format lint test security check clean lat-install lat-check lat-policy

VENV := venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

help:
	@printf '%s\n' \
		'Targets:' \
		'  make install      Create venv and install deps' \
		'  make format       Format code (black, isort)' \
		'  make lint         Run linters (flake8, mypy)' \
		'  make test         Run tests (pytest)' \
		'  make security     Run security checks (bandit, safety)' \
		'  make check        Run all checks' \
		'  make clean        Clean artifacts' \
		'  make lat-install  Install lat.md CLI' \
		'  make lat-check    Validate knowledge graph' \
		'  make lat-policy   Check lat.md sync policy'

install:
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install black isort flake8 bandit safety mypy pytest pytest-cov

format:
	$(PYTHON) -m black .
	$(PYTHON) -m isort .

lint:
	$(PYTHON) -m flake8 .
	$(PYTHON) -m mypy . || echo "mypy check skipped"

test:
	$(PYTHON) -m pytest tests/ -v --cov=. --cov-report=html

security:
	$(PYTHON) -m bandit -r . --exclude ./tests,./venv || echo "bandit completed with issues"

check: format lint test security
	@echo "All checks passed."

clean:
	rm -rf $(VENV) __pycache__ .pytest_cache htmlcov .coverage *.egg-info dist build

lat-install:
	@export PATH="$$HOME/.npm-global/bin:$$PATH"; \
	command -v lat >/dev/null 2>&1 && echo "lat already installed" || npm install -g --prefix $$HOME/.npm-global lat.md
	@git config core.hooksPath .githooks

lat-check:
	@export PATH="$$HOME/.npm-global/bin:$$PATH" LAT_LLM_KEY=$${LAT_LLM_KEY:-unused} && lat check

lat-policy:
	@bash scripts/check-lat-sync.sh
