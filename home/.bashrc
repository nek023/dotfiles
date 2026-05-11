# .bashrc

# Load system-wide config
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Homebrew (macOS)
if [ -f /opt/homebrew/bin/brew ]; then
  export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
fi

# Homebrew (Linux)
if [ -f /opt/homebrew/bin/brew ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH
fi

# Load local config
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi
