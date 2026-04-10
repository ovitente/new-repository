#!/usr/bin/env bash
# @lat: [[tests#Failure signals]]
#
# Single source of truth for the lat sync policy.
# Two-tier enforcement:
#   Tier 1: infra/config/delivery changes require any lat.md/ update.
#   Tier 2: product source code changes require lat.md/status.md update.
#
# Used by .githooks/pre-commit (--staged) and CI / manual runs (--range).
set -euo pipefail

MODE="range"
BASE_REF="HEAD~1"
HEAD_REF="HEAD"

usage() {
  echo "usage: $0 [--staged | --range BASE HEAD | BASE [HEAD]]" >&2
  exit 2
}

if [ $# -gt 0 ]; then
  case "$1" in
    --staged)
      MODE="staged"
      ;;
    --range)
      shift
      [ $# -ge 2 ] || usage
      BASE_REF="$1"
      HEAD_REF="$2"
      ;;
    -h|--help)
      usage
      ;;
    *)
      BASE_REF="$1"
      HEAD_REF="${2:-HEAD}"
      ;;
  esac
fi

if [ "$MODE" = "staged" ]; then
  CHANGED="$(git diff --cached --name-only || true)"
else
  CHANGED="$(git diff --name-only "$BASE_REF" "$HEAD_REF" || true)"
fi

if [ -z "$CHANGED" ]; then
  echo "No changed files detected."
  exit 0
fi

NEEDS_LAT=0
NEEDS_STATUS=0
HAS_LAT=0
HAS_STATUS=0

# Tier 1: infra / config / delivery surfaces — require any lat.md/ update.
if printf '%s\n' "$CHANGED" | grep -qE '{{TIER1_PATTERNS}}'; then
  NEEDS_LAT=1
fi

# Tier 2: product source code surfaces — require lat.md/status.md update.
if printf '%s\n' "$CHANGED" | grep -qE '{{TIER2_PATTERNS}}'; then
  NEEDS_STATUS=1
fi

if printf '%s\n' "$CHANGED" | grep -qE '^lat\.md/'; then
  HAS_LAT=1
fi
if printf '%s\n' "$CHANGED" | grep -qE '^lat\.md/status\.md$'; then
  HAS_STATUS=1
fi

FAIL=0

if [ "$NEEDS_LAT" -eq 1 ] && [ "$HAS_LAT" -eq 0 ]; then
  echo "BLOCKED: infra/config/delivery surfaces changed, but no changes under lat.md/."
  echo "Update the relevant lat.md file (architecture / delivery / environments / tests / status)."
  FAIL=1
fi

if [ "$NEEDS_STATUS" -eq 1 ] && [ "$HAS_STATUS" -eq 0 ]; then
  echo "BLOCKED: product source code changed, but lat.md/status.md not updated."
  echo "Update lat.md/status.md to reflect current focus / in-progress / blockers."
  FAIL=1
fi

if [ "$FAIL" -eq 1 ]; then
  exit 1
fi

echo "lat sync policy check passed."
