# ------------------------------------------------------------------------------
# ssh-agent
# ------------------------------------------------------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  # Reuse a live agent via pgrep (not `ssh-add -l`: the fixed socket has no listener).
  if [[ -z $(pgrep -U "${USER}" -x ssh-agent) ]]; then
    if [[ -n $SSH_AUTH_SOCK ]]; then
      rm -f "$SSH_AUTH_SOCK"
      eval "$(ssh-agent -a $SSH_AUTH_SOCK)" > /dev/null
    else
      eval "$(ssh-agent)" > /dev/null
    fi
  fi
fi

# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------
if (( ${+commands[tmux]} )) && [[ -z "${TMUX}" && -z "${SSH_CONNECTION}" && -z "${CMUX_BUNDLE_ID}" && "${TERM_PROGRAM}" != "vscode" && "${HERDR_ENV}" != "1" ]]; then
  tmux
fi
