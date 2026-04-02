#!/usr/bin/env bash
# @lat: [[tests#Failure signals]]
#
# Policy check: if infrastructure/config/delivery files changed,
# lat.md/ must also be updated in the same commit/PR.
#
# Usage:
#   scripts/check-lat-sync.sh                  # compare HEAD~1..HEAD
#   scripts/check-lat-sync.sh origin/main HEAD # compare branches (CI)
set -euo pipefail

BASE_REF="${1:-HEAD~1}"
HEAD_REF="${2:-HEAD}"

CHANGED="$(git diff --name-only "$BASE_REF" "$HEAD_REF" || true)"

if [ -z "$CHANGED" ]; then
  echo "No changed files detected."
  exit 0
fi

NEEDS_LAT=0
HAS_LAT=0

# Patterns that trigger lat.md sync requirement.
# Adapt these to your project structure.
echo "$CHANGED" | grep -E '(^\.github/workflows/|^infra/|^scripts/|^deploy/|^k8s/|^terraform/|Makefile|Dockerfile|docker-compose\.ya?ml|\.tf$|\.tfvars$|flake\.nix|shell\.nix)' >/dev/null && NEEDS_LAT=1 || true
echo "$CHANGED" | grep -E '^lat\.md/' >/dev/null && HAS_LAT=1 || true

if [ "$NEEDS_LAT" -eq 1 ] && [ "$HAS_LAT" -eq 0 ]; then
  echo "Detected infra/delivery/config changes, but no changes under lat.md/."
  echo "Update the relevant lat.md files:"
  echo "  - architecture.md"
  echo "  - delivery.md"
  echo "  - environments.md"
  echo "  - tests.md"
  exit 1
fi

echo "lat sync policy check passed."
