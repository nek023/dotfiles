#!/bin/bash

set -eu

STOW_DIR="${STOW_DIR:-home}"
STOW_TARGET="${STOW_TARGET:-$HOME}"

ignore=$(grep -v '^[[:space:]]*$' "$STOW_DIR/.stow-local-ignore" 2>/dev/null | paste -sd '|' -)

find "$STOW_DIR" \( -type f -o -type l \) | sort | while read -r src; do
  rel="${src#"$STOW_DIR"/}"
  base="${rel##*/}"

  [ "$base" = ".stow-local-ignore" ] && continue
  if [ -n "$ignore" ] && printf '%s\n' "$base" | grep -Eq "^($ignore)$"; then
    continue
  fi

  tgt="$STOW_TARGET/$rel"
  if [ -L "$tgt" ]; then
    dest=$(readlink "$tgt")
    if [ "$(readlink -f "$tgt")" = "$(readlink -f "$src")" ]; then
      printf '\033[32m  linked\033[0m %s\n' "$tgt"
    else
      printf '\033[33m foreign\033[0m %s -> %s (points outside this repo)\n' "$tgt" "$dest"
    fi
  elif [ -e "$tgt" ]; then
    printf '\033[31mconflict\033[0m %s (a non-symlink file exists)\n' "$tgt"
  else
    printf '\033[90munlinked\033[0m %s\n' "$tgt"
  fi
done
