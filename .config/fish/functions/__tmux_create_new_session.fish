function __tmux_create_new_session
  if begin; type -aq tmux; and not __tmux_is_running; and not __ssh_is_running; end
    tmux new
  end
end
