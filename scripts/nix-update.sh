#!/bin/bash

set -eu

MIN_RELEASE_DAYS="${MIN_RELEASE_DAYS:-7}"
BRANCH="nixpkgs-unstable"

command -v jq >/dev/null 2>&1 || { echo "error: jq not found" >&2; exit 1; }

if date -u -v-1d >/dev/null 2>&1; then
  until_date=$(date -u -v-"${MIN_RELEASE_DAYS}"d +%Y-%m-%dT00:00:00Z)
else
  until_date=$(date -u -d "${MIN_RELEASE_DAYS} days ago" +%Y-%m-%dT00:00:00Z)
fi

auth=()
if command -v gh >/dev/null 2>&1; then
  if token=$(gh auth token 2>/dev/null) && [ -n "$token" ]; then
    auth=(-H "Authorization: token $token")
  fi
fi

commit=$(curl -sf "${auth[@]}" \
  "https://api.github.com/repos/NixOS/nixpkgs/commits?sha=${BRANCH}&until=${until_date}&per_page=1" \
  | jq -re '.[0].sha') || { echo "error: failed to resolve a nixpkgs commit" >&2; exit 1; }

echo "Updating nixpkgs to ${commit} (older than ${MIN_RELEASE_DAYS} days)"
nix flake update nixpkgs --override-input nixpkgs "github:NixOS/nixpkgs/${commit}"

nix flake update nix-darwin
