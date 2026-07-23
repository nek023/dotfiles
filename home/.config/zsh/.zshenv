skip_global_compinit=1

# Point at the socket-activated agent here (not .zlogin) so non-login shells
# reach it too. Skip if SSH_AUTH_SOCK is already set (e.g. a forwarded agent).
if [[ -z $SSH_AUTH_SOCK && -n $XDG_RUNTIME_DIR ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi
