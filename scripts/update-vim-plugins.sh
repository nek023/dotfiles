#!/bin/bash

set -eu

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v vim >/dev/null 2>&1; then
  vim +PlugUpgrade +PlugUpdate +qa
fi
