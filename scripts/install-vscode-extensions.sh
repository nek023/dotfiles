#!/bin/bash

set -eu

while read $ext; do
  echo $(code --install-extension $ext)
done < $HOME/dotfiles/.config/vscode/extensions
