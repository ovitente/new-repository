# Tests

See also [[architecture]], [[delivery]], [[environments]], [[status]].

Verification strategy for the scaffold generator.

## Required checks

Automated checks that must pass before changes are committed.

- `shellcheck scaffold lib/*.sh` — all generator scripts must pass.
- `lat check` — generator's own knowledge graph must be valid.
- Scaffold dry run: `./scaffold /tmp/test-project code-go` must produce a valid project.

## Smoke expectations

Health checks after scaffolding a project.

- `lat check` passes in the generated project.
- `make lat-check` works in the generated project.
- `.githooks/pre-commit` is executable.
- `scripts/check-lat-sync.sh` is executable.
- `.pre-commit-config.yaml` exists and contains common + profile hooks.
- `Makefile` contains `lat-install`, `lat-check`, `lat-policy` targets.

## Failure signals

Conditions that indicate a broken generator.

- shellcheck errors in scaffold or lib/*.sh.
- `lat check` failure in generator or generated project.
- Missing files in generated output (Makefile, .githooks, lat.md/, etc.).
