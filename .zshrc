# .zshrc

# Homebrew (Intel)
if [ -f /usr/local/bin/brew ]; then
  eval $(/usr/local/bin/brew shellenv)
fi

# Homebrew (Apple Silicon)
if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# Load local config
if [ -f ~/.zshrc.local ]; then
  . ~/.zshrc.local
fi
