#!/usr/bin/env bash
set -eo pipefail

package_dir=${1%/}
target_dir=${2%/}
shift 2

for arg in "$@"; do
  case "$arg" in
    -n|--no|--simulate) exec stow "$@" ;;
  esac
done
if [[ ! -d /etc/skel ]]; then
  exec stow "$@"
fi

has_symlink_parent() {
  local directory=${1%/*}
  while [[ "$directory" != "$target_dir" ]]; do
    if [[ -L "$directory" ]]; then
      return 0
    fi
    directory=${directory%/*}
  done
  return 1
}

backed_up=()
restore_unlinked_files() {
  local file
  for file in "${backed_up[@]}"; do
    if [[ ! -e "$file" && ! -L "$file" ]]; then
      mv -n -- "$file.bak" "$file"
    fi
  done
}

# A Stow conflict can abort the whole link, leaving moved files unlinked.
trap restore_unlinked_files EXIT
while IFS= read -r -d '' source_file; do
  relative_path=${source_file#"$package_dir"/}
  target_file="$target_dir/$relative_path"
  skeleton_file="/etc/skel/$relative_path"
  if [[ ! -f "$target_file" || -L "$target_file" || ! -f "$skeleton_file" ]]; then
    continue
  fi
  if has_symlink_parent "$target_file" || ! cmp -s -- "$skeleton_file" "$target_file"; then
    continue
  fi
  if [[ -e "$target_file.bak" || -L "$target_file.bak" ]]; then
    printf 'Keeping %s because %s already exists\n' "$target_file" "$target_file.bak" >&2
    continue
  fi
  mv -n -- "$target_file" "$target_file.bak"
  if [[ ! -e "$target_file" && ! -L "$target_file" ]]; then
    backed_up+=("$target_file")
  fi
done < <(find "$package_dir" \( -type f -o -type l \) -print0)

stow "$@"
