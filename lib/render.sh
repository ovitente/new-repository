#!/usr/bin/env bash
# Generator library: template rendering engine.
# Sourced by scaffold — not executed directly.

# Render a .tpl file by substituting {{KEY}} markers.
# Arguments: src_file dst_file KEY=VALUE ...
render_template() {
  local src="$1" dst="$2"
  shift 2

  local content
  content="$(cat "$src")"

  while [[ $# -gt 0 ]]; do
    local key="${1%%=*}" val="${1#*=}"
    content="${content//\{\{${key}\}\}/${val}}"
    shift
  done

  mkdir -p "$(dirname "$dst")"
  printf '%s\n' "$content" > "$dst"
}

# Copy a file preserving directory structure.
# Arguments: src_file dst_file
copy_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

# Inject content from a file at a {{MARKER}} line in the target file.
# Arguments: target_file marker_name content_file
inject_at_marker() {
  local target="$1" marker="$2" content_file="$3"

  if [[ ! -f "$content_file" ]]; then
    # No snippet — remove the marker line
    sed -i "/{{${marker}}}/d" "$target"
    return
  fi

  local tmpfile="${target}.tmp"
  local marker_pattern="{{${marker}}}"

  awk -v marker="$marker_pattern" -v cfile="$content_file" '
    $0 ~ marker { while ((getline line < cfile) > 0) print line; close(cfile); next }
    { print }
  ' "$target" > "$tmpfile" && mv "$tmpfile" "$target"
}

# Build the output manifest: list of relative paths that will be written.
# Arguments: generator_root category lang
# Prints one path per line.
build_manifest() {
  local root="$1" category="$2" lang="$3"
  local shared_dir="${root}/templates/shared"
  local profile_dir="${root}/templates/${category}/${lang}"

  # Shared files
  if [[ -d "$shared_dir" ]]; then
    find "$shared_dir" -type f | while IFS= read -r f; do
      local rel="${f#"${shared_dir}"/}"
      # Strip .tpl suffix for output path
      rel="${rel%.tpl}"
      # Remap directory names
      rel="${rel/githooks\//.githooks/}"
      rel="${rel/github\//.github/}"
      printf '%s\n' "$rel"
    done
  fi

  # Profile files (exclude snippets and patterns — they're injected, not copied)
  if [[ -d "$profile_dir" ]]; then
    find "$profile_dir" -type f \
      ! -path "*/lat-snippets/*" \
      ! -name "lat-sync-patterns.sh" \
      ! -name "ci-steps.yml" \
      | while IFS= read -r f; do
      local rel="${f#"${profile_dir}"/}"
      rel="${rel%.tpl}"
      printf '%s\n' "$rel"
    done
  fi
}
