function tmux_create_new_session
  if begin; type -aq tmux; and not tmux_is_running; and not ssh_is_running; end
    tmux new
  end
end
