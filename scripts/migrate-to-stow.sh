#!/usr/bin/env bash
# migrate-to-stow.sh
#
# Migrate a machine from the old custom-Makefile layout (top-level $HOME
# symlinks pointing into ~/dotfiles/.<file>) to the new GNU Stow layout
# (deep symlinks under ~/dotfiles/home/).
#
# Prerequisites (do these by hand first):
#   1. Quit Claude Code and any other tool that holds open files in
#      ~/dotfiles or ~/dotfiles-local.
#   2. For each repo, commit or stash local changes:
#        cd ~/dotfiles        && git status   # must be clean
#        cd ~/dotfiles-local  && git status   # must be clean (if present)
#   3. Pull the latest stow layout (this also pulls this script):
#        cd ~/dotfiles        && git pull
#        cd ~/dotfiles-local  && git pull     # if present
#
# Then run:
#   bash ~/dotfiles/scripts/migrate-to-stow.sh
#
# What this script does:
#   1. Scans $HOME for top-level symlinks pointing into either repo and
#      removes them (the old layout's symlinks).
#   2. Per-file moves untracked data left at the OLD top-level repo paths
#      (.config/, .ssh/, .claude/, .gemini/, etc.) into $HOME. It NEVER
#      overwrites a pre-existing $HOME file.
#   3. Ensures GNU Stow is installed.
#   4. Runs `make link` for each repo to create the new stow-managed
#      symlinks.
#
# Safe to re-run if interrupted — every step skips work already done.

set -euo pipefail

DOTFILES="${HOME}/dotfiles"
DLOCAL="${HOME}/dotfiles-local"

# ---- preflight ----
[ -d "$DOTFILES" ] || { echo "ERROR: $DOTFILES not found"; exit 1; }

if pgrep -fl "Claude.app\|claude --" >/dev/null 2>&1; then
  echo "WARNING: Claude Code appears to be running."
  echo "Quit it (cmd-Q) — this script moves ~/.claude/* paths."
  read -r -p "Continue anyway? [y/N] " ans
  [ "$ans" = "y" ] || exit 1
fi

for repo in "$DOTFILES" "$DLOCAL"; do
  [ -d "$repo" ] || continue
  if [ ! -d "$repo/home" ]; then
    echo "ERROR: $repo is not on the stow layout (no home/ package)."
    echo "Run: cd $repo && git pull"
    exit 1
  fi
  if ! git -C "$repo" diff --quiet || ! git -C "$repo" diff --cached --quiet; then
    echo "ERROR: $repo has uncommitted changes. Commit or stash, then re-run."
    exit 1
  fi
done

# ---- 1) remove old top-level $HOME symlinks pointing into the repos ----
echo "==> [1/5] Removing old top-level symlinks in \$HOME"
removed=0
shopt -s dotglob nullglob
for entry in "$HOME"/*; do
  [ -L "$entry" ] || continue
  # readlink without -f to inspect the literal target
  target=$(readlink "$entry")
  case "$target" in
    "$DOTFILES"/*|"$DLOCAL"/*)
      rm -v "$entry"
      removed=$((removed+1))
      ;;
  esac
done
shopt -u dotglob nullglob
echo "    removed $removed old symlinks"

# ---- 2) per-file rescue from OLD top-level repo paths into $HOME ----
# Walks every regular file under $src and moves it to the matching path
# under $dst. Never overwrites: if the destination exists, the source
# file stays where it is so you can resolve it later.
rescue_tree() {
  local src=$1 dst=$2
  [ -d "$src" ] || return 0
  echo "    rescue: $src/ -> $dst/"
  mkdir -p "$dst"
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    local target="$dst/$rel"
    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "      skip (exists): $target"
      continue
    fi
    mkdir -p "$(dirname "$target")"
    mv "$file" "$target"
  done < <(find "$src" \( -type f -o -type l \) -print0)
}

echo "==> [2/5] Rescuing untracked data from OLD top-level repo paths"
# Top-level items that the old Makefile used to symlink into $HOME.
OLD_PATHS=(.bash_profile .bashrc .config .config.local .vim .zshenv .ssh .claude .gemini)
for path in "${OLD_PATHS[@]}"; do
  for repo in "$DOTFILES" "$DLOCAL"; do
    [ -d "$repo" ] || continue
    src="$repo/$path"
    dst="$HOME/$path"
    if [ -d "$src" ]; then
      rescue_tree "$src" "$dst"
    elif [ -f "$src" ]; then
      if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "    skip (exists): $dst"
      else
        echo "    mv: $src -> $dst"
        mv "$src" "$dst"
      fi
    fi
  done
done

# Restore expected perms on ~/.ssh (mkdir -p uses umask, not 0700).
if [ -d "$HOME/.ssh" ]; then
  chmod 700 "$HOME/.ssh"
  find "$HOME/.ssh" -type f -name 'id_*' ! -name '*.pub' -exec chmod 600 {} \;
fi

# ---- 3) ensure stow is installed ----
echo "==> [3/5] Ensuring GNU Stow is installed"
if ! command -v stow >/dev/null 2>&1; then
  echo "    installing via Homebrew..."
  brew install stow
else
  echo "    already installed: $(stow --version | head -n1)"
fi

# ---- 4) link both repos with the new stow Makefile ----
echo "==> [4/5] Linking both repos with stow"
(cd "$DOTFILES" && make link)
if [ -d "$DLOCAL" ]; then
  (cd "$DLOCAL" && make link)
fi

# ---- 5) remove empty leftover directories inside the repos ----
# After rescue, the OLD top-level paths (.config/, .vim/, ...) usually
# leave a husk of empty subdirectories behind. `-empty` only matches
# truly empty dirs, so anything that still holds a conflicting file
# (skipped by rescue) is preserved for manual inspection. `.git/` is
# excluded to be safe — some refs subdirs can legitimately be empty.
echo "==> [5/5] Removing empty leftover directories in the repos"
for repo in "$DOTFILES" "$DLOCAL"; do
  [ -d "$repo" ] || continue
  find "$repo" -depth -type d -empty -not -path '*/.git/*' -delete 2>/dev/null || true
done

cat <<'EOF'

Migration done. Suggested verifications:
  ls -l ~/.config/zsh/.zshrc        # symlink -> ~/dotfiles/home/...
  ls -la ~/.ssh/id_ed25519          # real file (-rw-------), NOT a symlink
  ssh -G github.com | grep identity # should reference your real key
  cd ~/dotfiles && git status       # clean working tree

If something looks off, the old top-level repo paths may still hold
files that conflicted with $HOME (rescue skipped them). Inspect with:
  find ~/dotfiles ~/dotfiles-local \
    -maxdepth 2 \( -name .config -o -name .ssh -o -name .claude \
                 -o -name .gemini -o -name .vim \) -type d 2>/dev/null
EOF
