function __git_switch_local_branch
    set -l buffer (commandline)
    set -l branch (__git_select_branch -q "$buffer")
    if test -n "$branch"
        commandline "git switch $branch"
        commandline -f execute
    end
    commandline -f repaint
end
