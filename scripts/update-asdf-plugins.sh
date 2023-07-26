#!/bin/bash

set -eu

if command -v asdf >/dev/null 2>&1; then
  PLUGINS=$(cat "${HOME}/.tool-versions" | cut -d' ' -f1)
  for PLUGIN in $PLUGINS; do
    asdf plugin add "${PLUGIN}" || :
  done

  asdf plugin update --all
fi
