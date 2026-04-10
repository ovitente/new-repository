# Delivery

See also [[architecture]], [[tests]], [[environments]], [[status]].

How the generator is used and maintained.

## Commands

Entry points for scaffolding projects.

- `./scaffold <path> <profile>` — generate/upgrade a project.
- `./scaffold --list` — list available profiles.
- `make scaffold PATH=<dir> PROFILE=<profile>` — Makefile wrapper.
- `make list` — list profiles via Makefile.

## Profiles

Six profiles in two categories: code and infra.

- `code-go` — Go (golangci-lint, go test)
- `code-js` — JavaScript/TypeScript (eslint, prettier, jest)
- `code-python` — Python (black, flake8, pytest)
- `code-bash` — Bash (shellcheck, shfmt)
- `infra-terraform` — Terraform (tflint, tfsec)
- `infra-pulumi` — Pulumi (pulumi validate)

## lat.md targets (generator repo)

Knowledge graph management for the generator itself.

- `make lat-install` — install lat.md CLI.
- `make lat-check` — validate generator's knowledge graph.
- `make lat-policy` — check generator's sync policy.

## Failure handling

What blocks scaffold execution.

- Scaffold exits 1 on invalid profile or user abort.
- See [[tests#Failure signals]] for verification.
