# .bashrc

# Load system-wide config
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Homebrew (Intel)
if [ -f /usr/local/bin/brew ]; then
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

# Homebrew (Apple Silicon)
if [ -f /opt/homebrew/bin/brew ]; then
  export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
fi

# Load local config
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi
