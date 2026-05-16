# .bashrc

# Load system-wide config
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Homebrew (macOS first, then Linux as fallback)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Load local config
if [ -f ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi
