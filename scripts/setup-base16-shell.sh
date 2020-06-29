#!/bin/bash

set -eu

readonly BASE16_DIR=$XDG_CONFIG_HOME/base16-shell

if [ ! -d $BASE16_DIR ]; then
  git clone https://github.com/chriskempson/base16-shell.git $BASE16_DIR
fi
