# .zshrc

# Source local definitions
if [ -f $HOME/.zshrc.local ]; then
  . $HOME/.zshrc.local
fi

# anyenv
if type -a anyenv > /dev/null 2>&1; then
  eval "$(anyenv init - zsh)"
fi

# dotfiles/bin
export PATH=$HOME/dotfiles/bin:$PATH
