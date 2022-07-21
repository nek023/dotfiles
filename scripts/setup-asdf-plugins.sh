#!/bin/bash

set -eu

if [ ! -f "${HOME}/.tool-versions" ]; then
  exit
fi

PLUGINS=$(cat "${HOME}/.tool-versions" | cut -d' ' -f1)

for PLUGIN in $PLUGINS; do
  asdf plugin add "${PLUGIN}" || :
done
