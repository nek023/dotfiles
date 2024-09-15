#!/bin/bash

set -eu

if command -v nvim >/dev/null 2>&1; then
  nvim --headless "+Lazy! sync" +qa
fi
