#!/bin/bash

set -eu

command -v brew >/dev/null 2>&1 || { echo "error: brew not found" >&2; exit 1; }
command -v nix >/dev/null 2>&1 || { echo "error: nix not found" >&2; exit 1; }

user="${SUDO_USER:-$USER}"
attr=".#darwinConfigurations.default.config.home-manager.users.${user}.home.activation.homebrew.data"

declared=$(nix eval --impure --raw "$attr" 2>/dev/null \
  | grep -oE '/nix/store/[a-z0-9]+-Brewfile' | head -1)

[ -n "$declared" ] || { echo "error: could not locate the generated Brewfile" >&2; exit 1; }

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

normalize() {
  sed -E \
    -e 's/^(mas "[^"]+", id: [0-9]+).*/\1/' \
    -e 's/^([a-z]+ "[^"]+").*/\1/' \
    | grep -E '^(tap|brew|cask|mas|vscode) ' | sort
}

normalize < "$declared" > "$tmpdir/declared"
brew bundle dump --file=- --no-describe 2>/dev/null | normalize > "$tmpdir/installed"

if cmp -s "$tmpdir/declared" "$tmpdir/installed"; then
  echo "no difference"
  exit 0
fi

git -C "$tmpdir" diff --no-index -- declared installed || true
