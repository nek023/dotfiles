function __tmux_create_session
    if begin; type -aq tmux && not __tmux_is_running && not __ssh_is_running; end
        tmux new -s (__tmux_nice_session_name)
    end
end
