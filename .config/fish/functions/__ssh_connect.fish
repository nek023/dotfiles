function __ssh_connect
    set -l buffer (commandline)
    set -l host (__ssh_select_host)
    if test -n "$host"
        if test -n "$buffer"
            commandline -i "$host"
        else
            commandline "ssh $host"
            commandline -f execute
        end
    end
    commandline -f repaint
end
