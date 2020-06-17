#!/bin/bash

set -eu

if [ ! -e $HOME/.config/base16-shell ]; then
  git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
fi
