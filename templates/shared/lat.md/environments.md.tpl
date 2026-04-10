# Environments

See also [[architecture]], [[delivery]], [[tests]], [[status]].

Execution environments and their differences.

## Environment inventory

Where this project runs.

- **Local dev:** user machine, Makefile + scripts.
- **CI:** GitHub Actions runner.

{{PROFILE_SECTION}}

## lat.md toolchain

Installation and runtime details for the lat.md CLI.

- **Install:** `npm install -g --prefix $HOME/.npm-global lat.md`
- **Path:** `$HOME/.npm-global/bin/lat`
- **Graceful degradation:** pre-commit hook warns and exits 0 if lat is missing.

## Runtime assumptions

Prerequisites for the workflow to function.

- npm available for lat.md installation.
- `git config core.hooksPath .githooks` set after clone.
- Bash 4+ for pre-commit hook.
