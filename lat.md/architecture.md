# Architecture

See also [[delivery]], [[environments]], [[tests]], [[status]].

Scaffold generator that creates/upgrades project repositories with lat.md integration, pre-commit hooks, CI, and profile-specific tooling.

## System shape

Components and their responsibilities.

- `scaffold` — main entry point (bash). Parses args, checks conflicts, renders templates, assembles output.
- `lib/common.sh` — colors, logging, error handling.
- `lib/profiles.sh` — profile registry and validation.
- `lib/prompt.sh` — interactive overwrite prompt.
- `lib/render.sh` — template rendering engine (`{{KEY}}` substitution + marker injection).
- `templates/shared/` — files common to all profiles (hooks, lat.md skeleton, CI base, .editorconfig).
- `templates/code/<lang>/` — code profile resources (go, js, python, bash).
- `templates/infra/<tool>/` — infra profile resources (terraform, pulumi).
- `Makefile` — thin wrapper around scaffold.

## Template structure

Each profile directory contains a standard set of resources.

- `Makefile.tpl` — profile-specific Makefile (rendered with `{{PROJECT_NAME}}`).
- `pre-commit-config.yaml` — profile-specific hooks (merged with common hooks).
- `ci-steps.yml` — CI job fragment (injected into ci.yml at `{{CI_PROFILE_JOBS}}`).
- `lat-sync-patterns.sh` — Tier 1/2 regex patterns (sourced, injected into check-lat-sync.sh).
- `lat-snippets/*.snippet` — content fragments injected into lat.md files at `{{PROFILE_SECTION}}`.
- `gitignore-extra` — profile-specific .gitignore lines (injected at `{{PROFILE_GITIGNORE}}`).

## Rendering flow

How scaffold transforms templates into a project.

1. Validate profile, resolve target path.
2. If target exists: build manifest, show conflicts, prompt.
3. Source `lat-sync-patterns.sh` for Tier 1/2 patterns.
4. Copy/render shared files (static + `.tpl` substitution).
5. Render lat.md skeleton, inject profile snippets at markers.
6. Render profile Makefile.
7. Merge pre-commit configs (common + profile).
8. Render CI (base + profile ci-steps.yml).
9. Git init + set hooksPath.

## Important constraints

Hard rules that must not be violated.

- Generator is bash-only, no external dependencies.
- Generated repos are self-contained — no dependency back on the generator.
- `.tpl` files use `{{KEY}}` markers, processed by `lib/render.sh`.
- Snippets use `inject_at_marker` for multi-line insertion.
