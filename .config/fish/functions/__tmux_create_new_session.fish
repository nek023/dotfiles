function __tmux_create_new_session
    if begin; type -aq tmux && not __tmux_is_running && not __ssh_is_running; end
        tmux new
    end
end
