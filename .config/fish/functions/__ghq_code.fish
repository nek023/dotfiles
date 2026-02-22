function __ghq_code
    set -l buffer (commandline)
    set -l dir (__ghq_select -q "$buffer")
    if test -n "$dir"
        commandline "code -n $dir"
        commandline -f execute
    end
    commandline -f repaint
end
