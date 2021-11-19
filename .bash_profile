# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Launch fish shell if startup command is not specified
if [ -z "$BASH_EXECUTION_STRING" ]; then
  FISH_PATH=$(which fish)
  test -x "$FISH_PATH" && exec -l "$FISH_PATH"
fi
