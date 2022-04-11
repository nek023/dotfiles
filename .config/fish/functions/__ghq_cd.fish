function __ghq_cd
    set -l buffer (commandline)
    set -l dir (__ghq_select -q "$buffer")
    if test -n "$dir"
        commandline "cd $dir"
        commandline -f execute
    end
    commandline -f repaint
end
