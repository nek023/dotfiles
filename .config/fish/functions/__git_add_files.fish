function __git_add_files
    set -l buffer (commandline)
    # :/ means git root in pathspec: https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
    set -l files (__git_select_files -q "$buffer" | sed -e 's/^/:\//' | string unescape | string escape -n)
    if test -n "$files"
        commandline "git add $files"
        commandline -f execute
    end
    commandline -f repaint
end
