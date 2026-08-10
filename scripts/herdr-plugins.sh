#!/bin/bash

set -eu

STOW_DIR="${STOW_DIR:-home}"

if ! command -v herdr >/dev/null 2>&1; then
  echo "herdr not found; skipping plugin registration"
  exit 0
fi

plugins_dir="$STOW_DIR/.config/herdr/plugins"
found=0

for manifest in "$plugins_dir"/*/herdr-plugin.toml; do
  [ -e "$manifest" ] || continue
  found=1

  dir=$(cd "$(dirname "$manifest")" && pwd)
  herdr plugin link "$dir" --enabled >/dev/null
done

if [ "$found" -eq 0 ]; then
  echo "no herdr plugins under $plugins_dir"
fi
