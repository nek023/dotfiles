#!/usr/bin/env bash

# Install Command Line Tools
if [ "$(uname)" == 'Darwin' ]; then
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
  # Install Homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Install packages
  brew tap homebrew/bundle
  brew bundle --file=$HOME/dotfiles/Brewfile
fi
