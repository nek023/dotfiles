function tmux-renumber-sessions
    if test -z "$TMUX"
        return 0
    end

    set -l sessions (tmux ls -F "#{session_name}" | sort)
    set -l num 0

    for session in $sessions
        tmux rename -t "$session" "$num"
        set num (math $num + 1)
    end

    return 0
end
