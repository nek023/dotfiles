#!/bin/bash

set -eu

STOW_DIR="${STOW_DIR:-home}"
STOW_TARGET="${STOW_TARGET:-$HOME}"

if [ -t 1 ]; then
  c_linked=$'\033[32m'; c_foreign=$'\033[33m'; c_conflict=$'\033[31m'; c_unlinked=$'\033[90m'; c_reset=$'\033[0m'
else
  c_linked=''; c_foreign=''; c_conflict=''; c_unlinked=''; c_reset=''
fi

ignore=$(grep -v '^[[:space:]]*$' "$STOW_DIR/.stow-local-ignore" 2>/dev/null | paste -sd '|' -)

find -L "$STOW_DIR" \( -type f -o -type l \) | sort | while read -r src; do
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
      printf '%s  linked%s %s\n' "$c_linked" "$c_reset" "$tgt"
    else
      printf '%s foreign%s %s -> %s (points outside this repo)\n' "$c_foreign" "$c_reset" "$tgt" "$dest"
    fi
  elif [ -e "$tgt" ]; then
    printf '%sconflict%s %s (a non-symlink file exists)\n' "$c_conflict" "$c_reset" "$tgt"
  else
    printf '%sunlinked%s %s\n' "$c_unlinked" "$c_reset" "$tgt"
  fi
done
