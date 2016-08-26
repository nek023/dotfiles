function ssh_is_running
  test -n "$SSH_CONNECTION"
end
