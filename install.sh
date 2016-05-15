#!/usr/bin/env bash

# Check whether git is installed or not
if ! command -v git > /dev/null; then
    echo "Error: git is required."
fi

# Move to home directory
pushd $HOME > /dev/null

# Clone dotfiles
if [ ! -e dotfiles ]; then
    git clone https://github.com/questbeat/dotfiles.git dotfiles
fi
cd dotfiles

# Create symbolic links for dotfiles
for DOTFILE in `ls -a dotfiles`; do
    if [ $DOTFILE = '.' -o $DOTFILE = '..' ]; then
        continue
    fi

    SRC=$HOME/dotfiles/dotfiles/$DOTFILE
    DST=$HOME/$DOTFILE

    echo -n "$DOTFILE: "

    if [ -e $DST ]; then
        echo "Already installed."
    else
        echo -n "Installing... "
        ln -s $SRC $DST
        echo "Done!"
    fi
done

# Create symbolic links for bin
if [ ! -e $HOME/bin ]; then
    ln -s $HOME/dotfiles/bin $HOME/bin
fi

# Install vim plug-ins
vim +PlugInstall +qa

# Back to last directory
popd > /dev/null

