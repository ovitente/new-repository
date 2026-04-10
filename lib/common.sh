#!/usr/bin/env bash
# Generator library: colors, logging, error handling.
# Sourced by scaffold — not executed directly.

set -euo pipefail

# Colors (disabled when not a terminal)
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' BOLD='' RESET='' # exported via source
fi

log()   { printf '%b %s\n' "${GREEN}>>>${RESET}" "$*"; }
warn()  { printf '%b %s\n' "${YELLOW}WARNING:${RESET}" "$*" >&2; }
error() { printf '%b %s\n' "${RED}ERROR:${RESET}" "$*" >&2; exit 1; }
info()  { printf '%b %s\n' "${BLUE}---${RESET}" "$*"; }

# Resolve path to absolute
resolve_path() {
  local p="$1"
  if [[ "$p" = /* ]]; then
    printf '%s' "$p"
  else
    printf '%s' "$(cd "$(dirname "$p")" 2>/dev/null && pwd)/$(basename "$p")"
  fi
}
