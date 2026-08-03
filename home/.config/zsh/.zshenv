setopt no_global_rcs

# Point at the ssh-agent.service socket (provisioned via systemd --user) so both
# login and non-login shells reach the always-on agent. Skip if SSH_AUTH_SOCK is
# already set (e.g. a forwarded agent) or on macOS, where launchd injects it and
# XDG_RUNTIME_DIR is unset.
if [[ -z $SSH_AUTH_SOCK && -n $XDG_RUNTIME_DIR ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

# .zshrc is interactive-only, so shells like `ssh host -- cmd` would see just the
# system PATH. Repeat the static entries here; .zshrc lays them down again in its
# own order and `typeset -U` drops the duplicates. The hooks that would otherwise
# provide these (mise activate, brew shellenv) are interactive-only too.
typeset -U path PATH
path=(
  "${HOME}/.local/bin"(N-/)
  "${HOME}/.go/bin"(N-/)
  "${HOME}/.local/share/mise/shims"(N-/)
  /opt/homebrew/{bin,sbin}(N-/)
  /home/linuxbrew/.linuxbrew/{bin,sbin}(N-/)
  $path
)
