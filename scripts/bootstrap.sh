#!/bin/bash

set -eu

# Set up a machine from scratch, or re-apply the latest dotfiles.
# Every step is idempotent; anything already satisfied is skipped.
#
# On a machine without the repositories:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/nek023/dotfiles/main/scripts/bootstrap.sh)"
#
# stow and the packages arrive with nix, so neither is installed here.
# The order is bootstrap -> nix-install -> switch -> link.

BREW_INSTALLER="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

DOTFILES_REPO_URL="https://github.com/nek023/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# host/owner/repo; on a work machine, point at the GHES repository via
# DOTFILES_PRIVATE_REPO or the interactive prompt.
DEFAULT_PRIVATE_REPO="github.com/nek023/dotfiles-private"
PRIVATE_DIR="$HOME/dotfiles-private"

# Upper bound for waiting on the CLT installer (5s x 360 = 30 min)
CLT_WAIT_INTERVAL=5
CLT_WAIT_RETRIES=360

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

# Use the enclosing checkout when run from one; fall back to
# $DOTFILES_DIR when run via curl.
resolve_repo_root() {
  local source=${BASH_SOURCE[0]:-}
  local root

  if [ -n "$source" ] && [ -f "$source" ]; then
    root=$(cd "$(dirname "$source")/.." && pwd)
    if [ -f "$root/Makefile" ]; then
      printf '%s\n' "$root"
      return
    fi
  fi

  printf '%s\n' "$DOTFILES_DIR"
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools: already installed"
    return
  fi

  log "Xcode Command Line Tools: installing"

  # Exits non-zero if an install was already requested.
  xcode-select --install >/dev/null 2>&1 || true

  echo "    waiting for the installer to finish (a dialog may be shown)"

  local i=0
  while ! xcode-select -p >/dev/null 2>&1; do
    i=$((i + 1))
    [ "$i" -lt "$CLT_WAIT_RETRIES" ] || abort "timed out waiting for Xcode Command Line Tools"
    sleep "$CLT_WAIT_INTERVAL"
  done
}

find_brew() {
  local candidate

  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi

  for candidate in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew \
    "$HOME/.linuxbrew/bin/brew"; do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

# Homebrew on Linux does not provide its own build dependencies,
# so install them with the distribution's package manager first.
install_homebrew_deps_linux() {
  local sudo_cmd=""

  if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || abort "sudo not found; run this script as root instead"
    sudo_cmd="sudo"
  fi

  # sudo_cmd is intentionally unquoted; it expands to nothing for root.
  # shellcheck disable=SC2086
  if command -v apt-get >/dev/null 2>&1; then
    $sudo_cmd apt-get update
    $sudo_cmd apt-get install -y build-essential procps curl file git
  elif command -v dnf >/dev/null 2>&1; then
    # dnf5 renamed groupinstall to "group install"; try both.
    $sudo_cmd dnf group install -y development-tools \
      || $sudo_cmd dnf groupinstall -y "Development Tools"
    $sudo_cmd dnf install -y procps-ng curl file git
  elif command -v pacman >/dev/null 2>&1; then
    $sudo_cmd pacman -S --noconfirm base-devel procps-ng curl file git
  elif command -v zypper >/dev/null 2>&1; then
    $sudo_cmd zypper install -y -t pattern devel_basis
    $sudo_cmd zypper install -y procps curl file git
  else
    warn "unknown package manager; assuming build dependencies are present"
  fi
}

ensure_homebrew() {
  local brew

  if brew=$(find_brew); then
    log "Homebrew: already installed ($brew)"
  else
    if [ "$(uname -s)" = "Linux" ]; then
      log "Homebrew: installing build dependencies"
      install_homebrew_deps_linux
    fi

    log "Homebrew: installing"
    /bin/bash -c "$(curl -fsSL "$BREW_INSTALLER")"

    brew=$(find_brew) || abort "Homebrew installation did not produce a usable brew"
  fi

  # brew may not be on PATH right after installation.
  eval "$("$brew" shellenv)"
}

ensure_brew_formula() {
  local formula=$1

  if command -v "$formula" >/dev/null 2>&1; then
    log "$formula: already installed ($(command -v "$formula"))"
    return
  fi

  log "$formula: installing"
  brew install "$formula"
}

# gh auth login is interactive, so give up without a terminal.
ensure_gh_auth() {
  local host=$1

  if gh auth status --hostname "$host" >/dev/null 2>&1; then
    log "gh auth ($host): already logged in"
    return 0
  fi

  if [ ! -t 0 ]; then
    warn "stdin is not a terminal; cannot run gh auth login for $host"
    return 1
  fi

  log "gh auth ($host): logging in"
  gh auth login --hostname "$host"
}

# Fast-forward an existing clone; skip with a warning rather than
# touch local changes.
update_repo() {
  local dir=$1

  if [ ! -d "$dir/.git" ]; then
    return
  fi

  if [ -n "$(git -C "$dir" status --porcelain --untracked-files=no)" ]; then
    warn "$dir has local changes; skipping pull"
    return
  fi

  log "Updating $(basename "$dir")"
  git -C "$dir" pull --ff-only \
    || warn "failed to pull $dir; continuing with the current checkout"
}

ensure_dotfiles() {
  if [ -f "$REPO_ROOT/Makefile" ]; then
    log "dotfiles: already cloned ($REPO_ROOT)"
    # Pulling may rewrite this very script; safe because the whole
    # file is parsed before main runs.
    update_repo "$REPO_ROOT"
    return
  fi

  log "dotfiles: cloning"
  git clone "$DOTFILES_REPO_URL" "$REPO_ROOT"
}

# Print the repository to clone, or return 1 to skip.
select_private_repo() {
  local input

  if [ -n "${DOTFILES_PRIVATE_REPO:-}" ]; then
    printf '%s\n' "$DOTFILES_PRIVATE_REPO"
    return 0
  fi

  if [ ! -t 0 ]; then
    return 1
  fi

  printf 'dotfiles-private repository (host/owner/repo) [%s] (type "skip" to skip): ' \
    "$DEFAULT_PRIVATE_REPO" >&2
  read -r input || true
  input=${input:-$DEFAULT_PRIVATE_REPO}

  if [ "$input" = "skip" ]; then
    return 1
  fi

  printf '%s\n' "$input"
}

setup_private() {
  local repo host owner_repo

  if [ -d "$PRIVATE_DIR" ]; then
    log "dotfiles-private: already cloned ($PRIVATE_DIR)"
    update_repo "$PRIVATE_DIR"
  else
    if ! repo=$(select_private_repo); then
      log "dotfiles-private: skipped"
      return
    fi

    repo=${repo#https://}
    repo=${repo%.git}

    case "$repo" in
      */*/*)
        host=${repo%%/*}
        owner_repo=${repo#*/}
        ;;
      */*)
        host="github.com"
        owner_repo=$repo
        ;;
      *)
        abort "invalid repository: $repo (expected host/owner/repo)"
        ;;
    esac

    if ! ensure_gh_auth "$host"; then
      log "dotfiles-private: skipped (gh auth required)"
      return
    fi

    log "dotfiles-private: cloning ($host/$owner_repo)"
    GH_HOST="$host" gh repo clone "$owner_repo" "$PRIVATE_DIR"
  fi
}

install_mise_tools() {
  local config="$HOME/.config/mise/config.toml"

  # mise comes from nix, so it is absent until the first switch.
  if ! command -v mise >/dev/null 2>&1; then
    log "mise: not installed yet; skipping tool installation"
    return
  fi

  if [ ! -e "$config" ]; then
    log "mise: no global config; skipping tool installation"
    return
  fi

  # mise resolves GitHub credentials via "gh auth token".
  if ! ensure_gh_auth "github.com"; then
    log "mise: skipped (run 'gh auth login' and 'mise install' later)"
    return
  fi

  log "mise: installing tools"

  # paranoid = true requires trusting the config before installing.
  mise trust "$config"
  (cd "$HOME" && mise install --yes) \
    || warn "mise install failed; rerun 'mise install' later"
}

main() {
  local os
  os=$(uname -s)

  case "$os" in
    Darwin | Linux) ;;
    *) abort "unsupported platform: $os" ;;
  esac

  if [ "$os" = "Darwin" ]; then
    ensure_xcode_clt
  fi

  ensure_homebrew

  # gh clones dotfiles-private, and nix does not exist yet at that point.
  # Everything else this machine carries arrives with the first switch.
  ensure_brew_formula gh

  ensure_dotfiles
  setup_private
  install_mise_tools

  log "Done"
  echo
  echo "Next steps:"
  echo "  make nix-install"
  echo "  make switch      # installs stow, among everything else"
  echo "  make link"
  if [ -d "$PRIVATE_DIR" ]; then
    echo "  make -C $PRIVATE_DIR relink"
    echo "  - Set up MCP servers: make -C $PRIVATE_DIR mcp"
  fi
}

REPO_ROOT=$(resolve_repo_root)

main "$@"
