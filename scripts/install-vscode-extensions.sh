#!/bin/bash

set -eu

INPUT_FILE="${1:-}"

if [ -z "$INPUT_FILE" ]; then
  echo "usage: $0 INPUT_FILE"
  exit 1
fi

while read EXT; do
  code --install-extension $EXT
done < <(cat $INPUT_FILE)
