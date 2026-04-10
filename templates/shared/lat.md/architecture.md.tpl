# Architecture

See also [[delivery]], [[environments]], [[tests]], [[status]].

## System shape

Project components, their responsibilities, and how they connect.

{{PROFILE_SECTION}}

## Knowledge graph

This project uses `lat.md/` as a self-describing knowledge graph with 2-tier sync policy enforced by `scripts/check-lat-sync.sh` and `.githooks/pre-commit`.

## Important constraints

Hard rules that must not be violated.

- `.githooks/pre-commit` is the single hook entrypoint.
- `core.hooksPath` must be set to `.githooks` to activate hooks.
- lat.md must be updated when infra/config files change (tier 1).
- `lat.md/status.md` must be updated when source code changes (tier 2).

## Ownership boundaries

Which lat.md files are authoritative for which concerns.

- Architecture decisions: this file
- Build/CI pipeline: [[delivery]]
- Config and runtime: [[environments]]
- Test strategy: [[tests]]
- Living project state: [[status]]
