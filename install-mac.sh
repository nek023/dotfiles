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
source ~/.bashrc

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

# Install apps
mas install 950145466  # Letterspace
mas install 409789998  # Twitter
mas install 449589707  # Dash
mas install 896624060  # Kobito
mas install 406056744  # Evernote
mas install 414030210  # LimeChat
mas install 1024640650 # CotEditor
mas install 425424353  # The Unarchiver
mas install 955848755  # Theine
mas install 682658836  # GarageBand
mas install 409203825  # Numbers
mas install 409201541  # Pages
mas install 409183694  # Keynote
mas install 408981434  # iMovie
mas install 497799835  # Xcode
