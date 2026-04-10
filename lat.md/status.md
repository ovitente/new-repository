# Status

See also [[architecture]], [[delivery]], [[tests]], [[environments]].

Living status file for the scaffold generator project.

## Current focus

Active work area and immediate next step.

- **Area:** initial generator implementation
- **State:** local, refactored from cloneable template to scaffold tool
- **Next step:** verify scaffold dry run, shellcheck, lat check

## In-progress

Open work streams.

- Generator scaffolding complete, needs verification.

## Blockers

Things preventing forward progress.

- **None.**

## What works

Capabilities verified as functional.

- scaffold script with 6 profiles (code-go/js/python/bash, infra-terraform/pulumi)
- Template rendering with `{{KEY}}` substitution and marker injection
- 2-tier lat sync policy per profile
- Pre-commit hook chain (lat check, sync policy, pre-commit run)
- CI generation with lat-check + profile-specific jobs
- Interactive overwrite prompt for existing directories

## Known gaps

Missing functionality.

- No Dockerfile templates for code profiles yet.
- No automated test suite for the generator itself.

## Do not regress

Invariants that must hold.

- Generated repos must be self-contained.
- Scaffold must not modify files outside the target directory.
- Profile patterns in check-lat-sync.sh must match the profile's actual source layout.
