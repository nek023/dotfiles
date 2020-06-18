#!/bin/bash

set -eu

readonly INPUT_FILE="${1:-}"

if [ "$INPUT_FILE" == "" ]; then
  echo "usage: $0 INPUT_FILE"
  exit 1
fi

while read ext; do
  echo $(code --install-extension $ext)
done < <(cat "$INPUT_FILE")
