#!/bin/bash

set -eu

# Lint all tracked files. Files are discovered by extension, shebang, or
# well-known file name -- never by repository-specific paths -- so this
# script keeps working as files are added, moved, or removed.

cd "$(dirname "$0")/.."

fail=0

check() {
  local label="$1" file="$2"
  shift 2
  if ! "$@"; then
    echo "FAIL [${label}] ${file}" >&2
    fail=1
  fi
}

# By extension
while IFS= read -r f; do
  check json "$f" jq empty "$f"
done < <(git ls-files '*.json')

while IFS= read -r f; do
  check toml "$f" python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$f"
done < <(git ls-files '*.toml')

while IFS= read -r f; do
  check lua "$f" luajit -b "$f" /dev/null
done < <(git ls-files '*.lua')

# SC1090/SC1091: sourced files only exist at runtime, so shellcheck cannot
# follow them in a dotfiles repository.
SHELLCHECK_OPTS="--severity=warning --exclude=SC1090,SC1091"

# By shebang
while IFS= read -r f; do
  check zsh "$f" zsh -n "$f"
done < <(git grep -lE '^#!(/usr)?/bin/(env )?zsh')

while IFS= read -r f; do
  # shellcheck disable=SC2086
  check bash "$f" shellcheck ${SHELLCHECK_OPTS} "$f"
done < <(git grep -lE '^#!(/usr)?/bin/(env )?bash')

# By well-known file name
while IFS= read -r f; do
  check zsh "$f" zsh -n "$f"
done < <(git ls-files '*/.zshrc' '*/.zshenv' '*/.zimrc' '*/.zprofile' '*/.zlogin')

while IFS= read -r f; do
  # shellcheck disable=SC2086
  check bash "$f" shellcheck ${SHELLCHECK_OPTS} --shell=bash "$f"
done < <(git ls-files '*/.bashrc' '*/.bash_profile')

exit "${fail}"
