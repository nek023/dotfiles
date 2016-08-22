# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Run fish if startup command is not specified
if [ -z "$BASH_EXECUTION_STRING" ]; then
  SHELL=`which fish`
  test -x "$SHELL" && exec -l "$SHELL"
fi
