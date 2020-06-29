#!/bin/bash

set -eu

readonly BASE16_DIR=$XDG_CONFIG_HOME/base16-shell

if [ -d $BASE16_DIR ]; then
  cd $BASE16_DIR
  git pull origin master
fi
