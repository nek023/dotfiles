#!/usr/bin/env bash

if [ "$(uname)" == 'Darwin' ]; then
  # Install Xcode command line tools
  xcode-select --install
  while :
  do
    xcode-select -p
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 5
  done
fi

# Install dotfiles
git clone https://github.com/questbeat/dotfiles.git $HOME/dotfiles
pushd $HOME/dotfiles > /dev/null
make link
popd > /dev/null

if [ "$(uname)" == 'Darwin' ]; then
  # Install homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Install homebrew/bundle
  brew tap homebrew/bundle

  # Install from Brewfile
  brew bundle --file=$HOME/dotfiles/Brewfile
fi

# Install anyenv
git clone https://github.com/anyenv/anyenv $HOME/.anyenv
source $HOME/.bashrc

# Install anyenv-update
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# Install envs
anyenv install rbenv
anyenv install pyenv

# Install vim plugins
vim +PlugInstall +qa
