function versions
    argparse -n versions 'h/help' 'i/installed' 'n/not-installed' 'u/used' -- $argv || return

    if set -q _flag_help
        echo 'usage: versions [--installed] [--not-installed] [--used] <lang>'
    else if set -q _flag_installed
        if test -n "$argv"
            asdf list "$argv" | string trim
        else
            asdf list
        end
    else if set -q _flag_not_installed
        sort (versions -u $argv | psub) (versions -i $argv | psub) (versions -i $argv | psub) | \
            uniq -u
    else if set -q _flag_used
        set -l files (find (ghq root) -name ".$argv-version" -type f -maxdepth 4)
        test (count $files) -eq 0 && return
        cat $files | sort -u
    else
        versions -h
    end
end
