# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source local definitions
if [ -f $HOME/.bashrc.local ]; then
  . $HOME/.bashrc.local
fi
