function __git_insert_commit
    set -l buffer (commandline)
    set -l commit (__git_select_commit)
    test -n "$commit" && commandline -i "$commit"
    commandline -f repaint
end
