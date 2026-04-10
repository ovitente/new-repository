# Environments

See also [[architecture]], [[delivery]], [[tests]], [[status]].

Runtime requirements and paths for the generator.

## Runtime requirements

The generator itself needs minimal tooling.

- Bash 4+ (for `mapfile` in prompt.sh, `${var//pat/rep}` in render.sh).
- git (for `git init`, `git config` in scaffold).
- npm (only if running `make lat-install` on the generator repo).

Generated projects additionally need profile-specific tools (Go, Node, Python, etc.).

## Paths

Key directories in the generator and generated output.

- Generator root: wherever this repo is cloned.
- Template resources: `templates/shared/`, `templates/code/`, `templates/infra/`.
- Library: `lib/`.
- Generated project: user-specified `<path>` argument.

## lat.md in generated projects

How lat.md is set up in scaffolded projects.

- lat.md CLI installed to `$HOME/.npm-global/bin/lat`.
- `LAT_LLM_KEY` set to `unused` (placeholder, not needed for `lat check`).
- `core.hooksPath` set to `.githooks` by scaffold automatically.
