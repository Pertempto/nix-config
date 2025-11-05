#!/usr/bin/env bash
# Clone repos based on a given file
# Each line of the file should be of the format
# <remote-url> <local-path>
# Comments are supported with # prefix
set -euo pipefail

# Check that a config file was provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <repos.conf>"
  exit 1
fi

CONFIG_FILE="$1"

# Ensure the CONFIG file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: file '$CONFIG_FILE' not found"
  exit 1
fi

# Read the config file; skip blank lines and lines starting with #
while read -r url target || [ -n "$url" ]; do
  # skip comments / empty lines
  [[ -z "${url// }" ]] && continue
  [[ "$url" =~ ^# ]] && continue

  # expand ~ and env vars, then convert to absolute path
  eval expanded_target="$target"
  target_path="$(realpath -m "$expanded_target" 2>/dev/null || echo "$expanded_target")"

  if [ -d "$target_path" ]; then
    printf 'SKIP: %s already exists at %s\n' "$url" "$target_path"
    continue
  fi

  # ensure parent directory exists
  parent=$(dirname -- "$target_path")
  mkdir -p -- "$parent"

  # run git clone
  printf 'CLONING: %s -> %s\n' "$url" "$target_path"
  if git clone "$url" "$target_path"; then
    printf 'OK: %s\n' "$target_path"
  else
    printf 'ERROR cloning %s\n' "$url" >&2
  fi

done < "$CONFIG_FILE"

