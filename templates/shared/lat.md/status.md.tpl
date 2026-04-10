# Status

See also [[architecture]], [[delivery]], [[tests]], [[environments]].

Living status file. Must be updated when product source code changes.

## Current focus

Active work area and immediate next step.

- **Area:** initial setup
- **State:** local
- **Next step:** fill in project-specific details in lat.md/ files

## In-progress

Open work streams.

- (none yet)

## Blockers

Things preventing forward progress.

- **None.**

## What works

Capabilities verified as functional.

- lat.md knowledge graph with pre-commit enforcement
- 2-tier sync policy (infra changes and source code changes)
- CI pipeline with lat-check job

## Known gaps

Missing functionality.

- (fill in as the project grows)

## Do not regress

Invariants that must hold.

- Pre-commit hook must block commits that violate lat sync policy.
