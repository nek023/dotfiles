#!/usr/bin/env bash

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

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install homebrew-bundle
brew tap Homebrew/bundle

# Install packages
brew bundle

# Install anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv
exec $SHELL -l

# Install anyenv-update
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

# Install ruby
anyenv install rbenv
rbenv install 2.3.1
rbenv global 2.3.1

# Install python
anyenv install pyenv
pyenv install 2.7.11
pyenv global 2.7.11

# Install vim plugins
vim +PlugInstall +qa
