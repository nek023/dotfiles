#!/bin/bash

set -eu

# Turn Touch ID for sudo on or off.
#
#   sudo ./scripts/touchid-sudo.sh enable
#   sudo ./scripts/touchid-sudo.sh disable
#
# /etc/pam.d/sudo includes sudo_local, and macOS keeps that file across system
# updates, so this only has to run once per machine. pam_reattach is what lets
# Touch ID reach tmux (and screen) sessions, which are detached from the GUI
# login session; without it the prompt never appears there.
#
# Both subcommands are idempotent: the file is only rewritten when it differs.

PAM_FILE="/etc/pam.d/sudo_local"
PAM_TEMPLATE="/etc/pam.d/sudo_local.template"
PAM_TID="/usr/lib/pam/pam_tid.so.2"

# Marks the file as ours, so it can be rewritten without keeping a backup.
MARKER="Managed by dotfiles (scripts/touchid-sudo.sh)"

usage() {
  cat <<'EOF'
usage: sudo touchid-sudo.sh <enable|disable>

  enable   Authenticate sudo with Touch ID, installing pam-reattach so that it
           works inside tmux as well.
  disable  Restore the stock sudo_local, which leaves sudo asking for the
           password. pam-reattach is left installed.
EOF
}

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf '    warning: %s\n' "$*" >&2
}

abort() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

# brew refuses to run as root, so anything it touches goes through the user who
# invoked sudo. -H resets HOME to that user's, which sudo -i and sudo -H would
# otherwise leave at /var/root and brew cannot write there.
as_user() {
  /usr/bin/sudo -H -u "$TARGET_USER" "$@"
}

find_brew() {
  local candidate

  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

# Print the pam_reattach path, or return 1 to configure Touch ID without it.
# Logging goes to stderr; stdout carries the path.
resolve_pam_reattach() {
  local brew prefix module

  TARGET_USER=${SUDO_USER:-}
  if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
    warn "cannot tell who invoked sudo, so brew cannot run; configuring Touch ID without tmux support"
    return 1
  fi

  if ! brew=$(find_brew); then
    warn "Homebrew not found; configuring Touch ID without tmux support"
    return 1
  fi

  prefix=$(as_user "$brew" --prefix)
  module="$prefix/lib/pam/pam_reattach.so"

  if [ ! -e "$module" ]; then
    log "pam-reattach: installing" >&2

    # sudo -u drops the caller's environment, so opt out of the auto-update here.
    if ! as_user env HOMEBREW_NO_AUTO_UPDATE=1 "$brew" install pam-reattach >&2; then
      warn "brew install pam-reattach failed; configuring Touch ID without tmux support"
      return 1
    fi
  fi

  if [ ! -e "$module" ]; then
    warn "$module is missing after the install; configuring Touch ID without tmux support"
    return 1
  fi

  printf '%s\n' "$module"
}

# Keep whatever the machine already had, unless it is the stock template with
# every line commented out, or a copy this script wrote.
backup_pam_file() {
  local backup

  [ -e "$PAM_FILE" ] || return 0
  grep -Eqv '^[[:space:]]*(#|$)' "$PAM_FILE" || return 0
  grep -qF "$MARKER" "$PAM_FILE" && return 0

  backup="$PAM_FILE.bak-$(date +%Y%m%d%H%M%S)"
  cp -p "$PAM_FILE" "$backup"
  log "backed up the previous configuration to $backup"
}

# Replace $PAM_FILE with what main staged in $TMP_FILE.
write_pam_file() {
  if [ -e "$PAM_FILE" ] && cmp -s "$TMP_FILE" "$PAM_FILE"; then
    log "$PAM_FILE: already up to date"
    return 0
  fi

  backup_pam_file

  # 0444 matches the permissions macOS ships sudo_local.template with.
  install -m 0444 -o root -g wheel "$TMP_FILE" "$PAM_FILE"
  log "$PAM_FILE: written"
}

enable_touchid() {
  local module

  [ -e "$PAM_TID" ] || abort "$PAM_TID not found; this macOS has no Touch ID PAM module"

  module=$(resolve_pam_reattach) || module=""

  {
    echo "# sudo_local: local config file which survives system update and is included for sudo"
    echo "# $MARKER; edit scripts/touchid-sudo.sh in the dotfiles repo instead."

    # pam_reattach has to come first: it reattaches the process to the GUI
    # session that pam_tid then authenticates against. ignore_ssh keeps a
    # sudo over ssh, e.g. inside tmux where pam_tid cannot tell, from raising
    # the Touch ID prompt on the local Mac.
    if [ -n "$module" ]; then
      printf 'auth       optional       %s ignore_ssh\n' "$module"
    fi

    echo "auth       sufficient     pam_tid.so"
  } >"$TMP_FILE"

  write_pam_file

  log "Touch ID for sudo: enabled"

  if [ -n "$module" ]; then
    log "tmux and screen: enabled via $module"
  else
    warn "tmux and screen will keep asking for the password (pam_reattach is not configured)"
  fi

  echo
  echo "Notes:"
  echo "  - Verify in a new terminal: sudo -k && sudo true"
  echo "  - sudo over ssh still falls back to the password; Touch ID is local only"
}

disable_touchid() {
  if [ ! -e "$PAM_FILE" ]; then
    log "$PAM_FILE: not present; sudo already asks for the password"
    return 0
  fi

  if [ -e "$PAM_TEMPLATE" ]; then
    cat "$PAM_TEMPLATE" >"$TMP_FILE"
    write_pam_file
  else
    # Older macOS ships no template, and sudo skips the include when the file
    # is gone.
    backup_pam_file
    rm -f "$PAM_FILE"
    log "$PAM_FILE: removed"
  fi

  log "Touch ID for sudo: disabled"

  echo
  echo "Notes:"
  echo "  - Drop the cached credentials to see it take effect: sudo -k"
  echo "  - pam-reattach is still installed; remove it with: brew uninstall pam-reattach"
}

main() {
  local command=${1:-}

  case "$command" in
    enable | disable) ;;
    -h | --help | help)
      usage
      exit 0
      ;;
    "")
      usage >&2
      exit 1
      ;;
    *)
      printf 'error: unknown command: %s\n\n' "$command" >&2
      usage >&2
      exit 1
      ;;
  esac

  [ "$(uname -s)" = "Darwin" ] || abort "macOS only"
  [ "$(id -u)" -eq 0 ] || abort "run this through sudo: sudo $0 $command"

  grep -Eq '^auth[[:space:]]+include[[:space:]]+sudo_local' /etc/pam.d/sudo \
    || warn "/etc/pam.d/sudo does not include sudo_local; the change may have no effect"

  TMP_FILE=$(mktemp)
  trap 'rm -f "$TMP_FILE"' EXIT

  if [ "$command" = "enable" ]; then
    enable_touchid
  else
    disable_touchid
  fi
}

main "$@"
