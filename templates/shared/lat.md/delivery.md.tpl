# Delivery

See also [[architecture]], [[tests]], [[environments]], [[status]].

How code moves from source to validated state.

## Make targets

Profile-specific build and quality commands.

{{PROFILE_SECTION}}

## lat.md targets

Knowledge graph management commands.

- `make lat-install` — install lat.md CLI globally.
- `make lat-check` — validate knowledge graph.
- `make lat-policy` — run sync policy check.

## CI pipeline

CI runs on push to main and on PRs. Includes `lat-check` job and profile-specific quality/test jobs. See `.github/workflows/ci.yml`.

## Failure handling

What blocks commits and merges.

- Pre-commit blocks the commit on failures.
- CI blocks merge on failures.
- See [[tests#Failure signals]] for the concrete list.
