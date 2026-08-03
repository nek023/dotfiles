#!/bin/bash

set -eu

NIX_INSTALLER_URL="https://install.determinate.systems/nix"
NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

if command -v nix >/dev/null 2>&1; then
  echo "nix already installed ($(command -v nix))"
  exit 0
fi

if [ -e "$NIX_PROFILE" ]; then
  echo "nix already installed (source $NIX_PROFILE to use it in this shell)"
  exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER_URL" | sh -s -- install

echo
echo "Start a new shell, or run this to use nix right away:"
echo "  . $NIX_PROFILE"
