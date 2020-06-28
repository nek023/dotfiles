function __ssh_connect
    set -l buffer (commandline)
    set -l host (__ssh_select_host -q "$buffer")
    if test -n "$host"
        commandline "ssh $host"
        commandline -f execute
    end
    commandline -f repaint
end
