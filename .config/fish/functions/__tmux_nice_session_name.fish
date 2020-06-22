function __tmux_nice_session_name
    set -l num 0
    for name in (tmux ls -F "#{session_name}" | string join0 | sort -z | string split0)
        if string match -qr '^\d+$' -- $name
            test $num -lt (math $name) && break
            set num (math $num + 1)
        end
    end
    echo $num
end
