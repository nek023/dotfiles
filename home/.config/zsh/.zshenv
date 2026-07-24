skip_global_compinit=1

# Point at the ssh-agent.service socket (provisioned via systemd --user) so both
# login and non-login shells reach the always-on agent. Skip if SSH_AUTH_SOCK is
# already set (e.g. a forwarded agent) or on macOS, where launchd injects it and
# XDG_RUNTIME_DIR is unset.
if [[ -z $SSH_AUTH_SOCK && -n $XDG_RUNTIME_DIR ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi
