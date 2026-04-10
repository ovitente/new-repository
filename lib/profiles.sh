#!/usr/bin/env bash
# Generator library: profile registry and validation.
# Sourced by scaffold — not executed directly.

# All valid profiles
VALID_PROFILES=(
  code-go
  code-js
  code-python
  code-bash
  infra-terraform
  infra-pulumi
)

# Validate profile string. Exits with error if invalid.
validate_profile() {
  local profile="$1"
  for p in "${VALID_PROFILES[@]}"; do
    [[ "$p" = "$profile" ]] && return 0
  done
  error "Unknown profile: ${profile}. Valid profiles: ${VALID_PROFILES[*]}"
}

# Split profile into category and language.
# Sets global CATEGORY and LANG variables.
split_profile() {
  local profile="$1"
  CATEGORY="${profile%%-*}"
  LANG="${profile#*-}"
}

# Print available profiles grouped by category.
print_profiles() {
  printf '%b\n' "${BOLD}Code profiles:${RESET}"
  printf "  code-go        Go project (golangci-lint, go test)\n"
  printf "  code-js        JavaScript/TypeScript (eslint, prettier, jest)\n"
  printf "  code-python    Python (black, flake8, pytest)\n"
  printf "  code-bash      Bash scripts (shellcheck, shfmt)\n"
  printf "\n"
  printf '%b\n' "${BOLD}Infra profiles:${RESET}"
  printf "  infra-terraform  Terraform (tflint, tfsec)\n"
  printf "  infra-pulumi     Pulumi (pulumi validate)\n"
}
