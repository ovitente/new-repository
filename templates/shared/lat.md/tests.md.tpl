# Tests

See also [[architecture]], [[delivery]], [[environments]], [[status]].

Test strategy and critical invariants.

## Required checks

Automated checks that must pass before code is committed or merged.

- `lat check` must pass locally and in CI.
- `scripts/check-lat-sync.sh` enforces 2-tier sync policy.
- `.githooks/pre-commit` must exit cleanly.
- `make check` is the local quality gate.

{{PROFILE_SECTION}}

## Sync policy trigger patterns

Patterns matched by `scripts/check-lat-sync.sh`.

**Tier 1 (any lat.md/ update required):**
{{TIER1_DESCRIPTION}}

**Tier 2 (status.md update required):**
{{TIER2_DESCRIPTION}}

## Failure signals

Conditions that block commits, PRs, or deploys.

- `lat check` failure — broken wikilinks.
- Tier 1 sync policy failure — infra changed without lat.md update.
- Tier 2 sync policy failure — source code changed without status.md update.
- Profile-specific check failures (lint, test, security).
