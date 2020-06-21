#!/bin/bash

set -eu

if [ ! -d $XDG_CONFIG_HOME/anyenv/anyenv-install ]; then
  anyenv install --init
fi

if [ ! -d $(anyenv root)/plugins/anyenv-update ]; then
  mkdir -p $(anyenv root)/plugins
  git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
fi

if [ ! -d $(rbenv root)/plugins/rbenv-default-gems ]; then
  mkdir -p $(rbenv root)/plugins
  git clone https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
  ln -sfnv ~/dotfiles/.config/rbenv/default-gems $(rbenv root)/default-gems
fi
