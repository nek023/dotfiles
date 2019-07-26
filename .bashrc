# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source local definitions
if [ -f $HOME/.bashrc.local ]; then
  . $HOME/.bashrc.local
fi

# anyenv
if type -a anyenv > /dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# dotfiles/bin
export PATH=$HOME/dotfiles/bin:$PATH
