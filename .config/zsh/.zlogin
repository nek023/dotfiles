# ------------------------------------------------------------------------------
# ssh-agent
# ------------------------------------------------------------------------------
if [[ "$(uname)" == 'Linux' ]]; then
  if [[ -z $SSH_AUTH_SOCK && -n $XDG_RUNTIME_DIR ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
  fi

  if [[ -z $(pgrep -U "${USER}" ssh-agent) ]]; then
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
if (( ${+commands[tmux]} )) && [[ -z "${TMUX}" && -z "${SSH_CONNECTION}" && "${TERM_PROGRAM}" != "vscode" ]]; then
  tmux
fi
