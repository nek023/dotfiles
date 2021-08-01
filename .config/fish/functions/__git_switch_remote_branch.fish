function __git_switch_remote_branch
    set -l buffer (commandline)
    set -l branch (__git_select_branch -q "$buffer" -r)
    if test -n "$branch"
        commandline "git switch -t $branch"
        commandline -f execute
    end
    commandline -f repaint
end
