#!/usr/bin/env bash
# Generator library: interactive overwrite prompt.
# Sourced by scaffold — not executed directly.

# Check which files from manifest already exist in target_dir.
# Prints conflicts and prompts for confirmation.
# Arguments: target_dir manifest_file
check_conflicts() {
  local target_dir="$1"
  local manifest_file="$2"
  local conflicts=()

  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    [[ -f "${target_dir}/${f}" ]] && conflicts+=("$f")
  done < "$manifest_file"

  if [[ ${#conflicts[@]} -eq 0 ]]; then
    return 0
  fi

  printf "\n${YELLOW}The following %d files already exist and will be overwritten:${RESET}\n" "${#conflicts[@]}"
  printf '  %s\n' "${conflicts[@]}"
  printf "\n"
  read -rp "Continue? [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
}
