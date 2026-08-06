#!/bin/bash

set -eu

# 素の環境から make nix-install を実行できる状態までを整える。
# Xcode Command Line Tools (macOS のみ) -> Homebrew の順に、
# 不足しているものだけを導入する。何度実行しても安全。
#
# stow は nix が入れるため、ここでは扱わない。make link は make switch の後。

BREW_INSTALLER="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Xcode Command Line Tools のインストール完了を待つ上限 (5 秒 x 360 = 30 分)
CLT_WAIT_INTERVAL=5
CLT_WAIT_RETRIES=360

log() {
  printf '==> %s\n' "$*"
}

abort() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools: already installed"
    return
  fi

  log "Xcode Command Line Tools: installing"

  # 既にインストール要求が出ている場合は非ゼロで終了するため、失敗は無視する。
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

# Linux 版 Homebrew はビルド用の依存を自前で用意しないため、
# ディストリビューションのパッケージマネージャから先に導入する。
install_homebrew_deps_linux() {
  local sudo_cmd=""

  if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || abort "sudo not found; run this script as root instead"
    sudo_cmd="sudo"
  fi

  # sudo_cmd は root では空文字になるため、意図的にクォートしない。
  # shellcheck disable=SC2086
  if command -v apt-get >/dev/null 2>&1; then
    $sudo_cmd apt-get update
    $sudo_cmd apt-get install -y build-essential procps curl file git
  elif command -v dnf >/dev/null 2>&1; then
    # dnf5 で groupinstall が group install に変わったため、両方の書式を試す。
    $sudo_cmd dnf group install -y development-tools \
      || $sudo_cmd dnf groupinstall -y "Development Tools"
    $sudo_cmd dnf install -y procps-ng curl file git
  elif command -v pacman >/dev/null 2>&1; then
    $sudo_cmd pacman -S --noconfirm base-devel procps-ng curl file git
  elif command -v zypper >/dev/null 2>&1; then
    $sudo_cmd zypper install -y -t pattern devel_basis
    $sudo_cmd zypper install -y procps curl file git
  else
    echo "    warning: unknown package manager; assuming build dependencies are present"
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

  # インストール直後は PATH に載っていないため、このシェルに読み込む。
  eval "$("$brew" shellenv)"
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

  log "Done"
  echo
  echo "Next steps:"
  echo "  make nix-install"
  echo "  make switch      # installs stow, among everything else"
  echo "  make link"
}

main "$@"
