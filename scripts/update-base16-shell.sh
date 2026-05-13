#!/bin/bash

set -eu

BASE16_DIR="${XDG_CONFIG_HOME}/base16-shell"
BASE16_REPO="https://github.com/chriskempson/base16-shell.git"

if git -C "$BASE16_DIR" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$BASE16_DIR" pull origin master
else
  if [ -e "$BASE16_DIR" ]; then
    echo "Removing invalid base16-shell directory: $BASE16_DIR"
    rm -rf "$BASE16_DIR"
  fi
  git clone "$BASE16_REPO" "$BASE16_DIR"
fi
