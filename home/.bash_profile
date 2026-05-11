# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

ZSH_CMD=$(command -v zsh)
if [ -t 1 ] && [ -x "$ZSH_CMD" ] && [ "$SHELL" != "$ZSH_CMD" ]; then
  export SHELL="$ZSH_CMD"
  exec -l "$SHELL"
fi
