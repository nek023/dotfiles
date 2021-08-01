function __ghq_cd
    set -l buffer (commandline)
    set -l repo (__ghq_select_repo -q "$buffer" | string escape -n)
    if test -n "$repo"
        commandline "cd $repo"
        commandline -f execute
    end
    commandline -f repaint
end
