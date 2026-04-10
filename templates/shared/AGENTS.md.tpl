# Project agent workflow

This repository uses `lat.md/` as the project knowledge graph.

## Read order for a new session

1. `./lat.md/status.md` — current focus, in-progress work, blockers.
2. `./lat.md/architecture.md` — system shape, components, boundaries.
3. `./lat.md/delivery.md` — make targets, CI, build gates.
4. `./lat.md/environments.md` — toolchain, paths, runtime assumptions.
5. `./lat.md/tests.md` — required checks, invariants, failure signals.
6. This file (`AGENTS.md`) — working protocol.

## Mandatory workflow

Before making substantial changes:
- Read the relevant `lat.md/` files first.
- Use `lat locate`, `lat section`, `lat refs`, or `lat search` when helpful.
- Do not change architecture, delivery flow, environments, or test expectations without first reading the matching lat docs.

## Routing rules

- Architecture / component interaction / boundaries / important flows:
  - update `lat.md/architecture.md`

- CI/CD / build / deploy / release / rollback / migrations:
  - update `lat.md/delivery.md`

- Environments / config / runtime behavior / secrets ownership / deployment targets:
  - update `lat.md/environments.md`

- Required checks / smoke tests / policy checks / integration or e2e expectations:
  - update `lat.md/tests.md`

- Current focus / progress / blockers / what works / known gaps:
  - update `lat.md/status.md`

## Completion criteria

A task is not complete until all of the following are true:
- Relevant `lat.md/` files were updated for any substantial behavior/config/workflow change.
- Relevant `@lat:` backlinks were added or updated where appropriate.
- `lat check` passes.
- Repository policy checks for lat sync pass.

## Review policy

When a change affects behavior but `lat.md/` was not updated, explain why explicitly.
Review semantic changes in `lat.md/` first, then review the code/config diff.
