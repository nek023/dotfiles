#!/bin/bash

set -eu

if command -v vim >/dev/null 2>&1; then
  vim +PlugUpgrade +PlugUpdate +qa
fi
