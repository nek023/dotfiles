#!/usr/bin/env bash
# migrate-to-dotfiles-private.sh
#
# Rename ~/dotfiles-local to ~/dotfiles-private on a machine that has
# already been migrated to GNU Stow. All existing symlinks contain the
# string "dotfiles-local" in their relative target paths, so a plain
# `mv` would leave them dangling. This script unstows first, renames
# the directory, updates the git remote URL, and re-stows from the new
# location.
#
# Prerequisites (do these by hand first):
#   1. Rename the repo on GitHub (dotfiles-local -> dotfiles-private).
#   2. Quit Claude Code and any other tool holding files in the repo.
#   3. cd ~/dotfiles-local && git status   # must be clean
#
# Run: bash ~/dotfiles/scripts/migrate-to-dotfiles-private.sh

set -euo pipefail

OLD="${HOME}/dotfiles-local"
NEW="${HOME}/dotfiles-private"
OLD_SLUG="dotfiles-local"
NEW_SLUG="dotfiles-private"

# ---- preflight ----
if [ ! -d "$OLD" ]; then
  echo "ERROR: $OLD not found — nothing to rename"
  exit 1
fi

if [ -e "$NEW" ] || [ -L "$NEW" ]; then
  echo "ERROR: $NEW already exists — refusing to overwrite"
  exit 1
fi

if [ ! -d "$OLD/home" ]; then
  echo "ERROR: $OLD is not on the stow layout (no home/ package)."
  echo "Run the regular migrate-to-stow.sh first."
  exit 1
fi

if ! git -C "$OLD" diff --quiet || ! git -C "$OLD" diff --cached --quiet; then
  echo "ERROR: $OLD has uncommitted changes — commit or stash first"
  exit 1
fi

if pgrep -fl "Claude.app\|claude --" >/dev/null 2>&1; then
  echo "WARNING: Claude Code appears to be running."
  echo "Quit it (cmd-Q) before continuing — this script touches \$HOME symlinks."
  read -r -p "Continue anyway? [y/N] " ans
  [ "$ans" = "y" ] || exit 1
fi

# ---- 1) unstow current symlinks from the OLD location ----
echo "==> [1/4] Unstowing symlinks from $OLD"
(cd "$OLD" && make unlink)

# ---- 2) rename the directory ----
echo "==> [2/4] Renaming $OLD -> $NEW"
mv "$OLD" "$NEW"

# ---- 3) update git remote URL if it still points at the old slug ----
echo "==> [3/4] Updating git remote URL"
current_url=$(git -C "$NEW" remote get-url origin 2>/dev/null || true)
if [ -z "$current_url" ]; then
  echo "    no origin remote configured — skipping"
elif [[ "$current_url" == *"$OLD_SLUG"* ]]; then
  new_url="${current_url//$OLD_SLUG/$NEW_SLUG}"
  echo "    $current_url"
  echo "      -> $new_url"
  git -C "$NEW" remote set-url origin "$new_url"
else
  echo "    origin URL has no '$OLD_SLUG' substring — leaving as-is"
  echo "    current: $current_url"
fi

# ---- 4) re-stow from the NEW location ----
echo "==> [4/4] Linking from $NEW with stow"
(cd "$NEW" && make link)

cat <<EOF

Rename complete. Verify with:
  ls -l ~/.config/zsh/.zshrc.local   # should resolve via $NEW_SLUG/...
  git -C $NEW remote -v              # should show $NEW_SLUG URL
EOF
