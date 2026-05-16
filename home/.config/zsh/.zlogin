# ------------------------------------------------------------------------------
# ssh-agent
# ------------------------------------------------------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  if [[ -z $SSH_AUTH_SOCK && -n $XDG_RUNTIME_DIR ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
  fi

  # ssh-add -l exits 2 only when no agent is reachable; 0/1 means a live
  # agent (systemd socket-activated or SSH-forwarded) is already available.
  ssh-add -l >/dev/null 2>&1
  if (( $? == 2 )); then
    if [[ -n $SSH_AUTH_SOCK ]]; then
      eval "$(ssh-agent -a $SSH_AUTH_SOCK)" > /dev/null
    else
      eval "$(ssh-agent)" > /dev/null
    fi
  fi
fi

# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------
if (( ${+commands[tmux]} )) && [[ -z "${TMUX}" && -z "${SSH_CONNECTION}" && -z "${CMUX_BUNDLE_ID}" && "${TERM_PROGRAM}" != "vscode" ]]; then
  tmux
fi
