# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# PATH
export PATH=$PATH:$HOME/bin

# proxy
test -r $HOME/.proxy && source $HOME/.proxy

# anyenv
export PATH=$HOME/.anyenv/bin:$PATH
if type -a anyenv > /dev/null 2>&1; then
  eval "$(anyenv init -)"
fi
