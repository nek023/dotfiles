# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# proxy
test -r $HOME/.proxy && source $HOME/.proxy

# anyenv
if type -a anyenv > /dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# dotfiles/bin
export PATH=$HOME/dotfiles/bin:$PATH
