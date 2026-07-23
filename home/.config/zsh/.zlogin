# ------------------------------------------------------------------------------
# ssh-agent
# ------------------------------------------------------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  # SSH_AUTH_SOCK is set in .zshenv; start an agent as a login-time fallback
  # only when none is reachable (ssh-add -l exits 2 = no agent).
  ssh-add -l >/dev/null 2>&1
  if (( $? == 2 )); then
    if [[ -n $SSH_AUTH_SOCK ]]; then
      # Remove a stale socket left by a dead agent; otherwise ssh-agent -a
      # fails to bind and every new shell keeps hitting the same error.
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
