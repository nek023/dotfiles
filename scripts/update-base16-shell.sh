#!/bin/bash

set -eu

BASE16_DIR="${XDG_CONFIG_HOME}/base16-shell"

if [ -d $BASE16_DIR ]; then
  cd $BASE16_DIR
  git pull origin master
else
  git clone https://github.com/chriskempson/base16-shell.git $BASE16_DIR
fi
