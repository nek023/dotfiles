#!/bin/bash

set -eu

if command -v asdf >/dev/null 2>&1; then
  asdf plugin update --all
fi
