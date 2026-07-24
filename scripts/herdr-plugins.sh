#!/bin/bash

set -eu

STOW_DIR="${STOW_DIR:-home}"

# herdr が無い環境 (未導入・非対応 OS) では何もしない。
if ! command -v herdr >/dev/null 2>&1; then
  echo "herdr not found; skipping plugin registration"
  exit 0
fi

plugins_dir="$STOW_DIR/.config/herdr/plugins"
found=0

# 各プラグイン (herdr-plugin.toml を持つディレクトリ) を herdr に登録する。
# herdr plugin link は冪等なので、登録済みでも安全に再実行できる。
for manifest in "$plugins_dir"/*/herdr-plugin.toml; do
  [ -e "$manifest" ] || continue
  found=1

  dir=$(cd "$(dirname "$manifest")" && pwd)
  herdr plugin link "$dir" --enabled >/dev/null
done

if [ "$found" -eq 0 ]; then
  echo "no herdr plugins under $plugins_dir"
fi
