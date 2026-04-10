# Generator agent workflow

This repository is a scaffold generator tool. It uses `lat.md/` as its own knowledge graph.

## Read order for a new session

1. `./lat.md/status.md` — current focus, in-progress work, blockers.
2. `./lat.md/architecture.md` — generator components, template structure.
3. `./lat.md/delivery.md` — scaffold command, profiles, make targets.
4. `./lat.md/environments.md` — runtime requirements, paths.
5. `./lat.md/tests.md` — verification, shellcheck, smoke tests.
6. This file (`AGENTS.md`) — working protocol.

## Key distinction

This repo has two levels of lat.md:
- **Generator level:** `lat.md/` in this repo — describes the generator itself.
- **Template level:** `templates/shared/lat.md/` — skeleton files copied to generated projects.

When modifying generator logic, update the generator's lat.md files.
When modifying what gets generated, update the template lat.md files.

## Routing rules

- Generator architecture / rendering flow / template structure:
  - update `lat.md/architecture.md`

- Scaffold command / profiles / make targets:
  - update `lat.md/delivery.md`

- Runtime requirements / paths / dependencies:
  - update `lat.md/environments.md`

- Verification / shellcheck / smoke tests:
  - update `lat.md/tests.md`

- Current focus / progress / blockers:
  - update `lat.md/status.md`

## Completion criteria

A task is not complete until:
- Generator's lat.md files updated for behavioral changes.
- `shellcheck scaffold lib/*.sh` passes.
- `lat check` passes.
- Scaffold dry run produces valid output.
