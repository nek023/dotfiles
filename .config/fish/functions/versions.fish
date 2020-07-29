function versions -a cmd lang
    switch $cmd
    case installed
        if test -n "$lang"
            asdf list "$lang" | string trim
        else
            asdf list
        end

    case used
        if test -z "$lang"
            echo 'Usage: versions used LANG'
            return 1
        end

        set -l files (find (ghq root) -name ".$lang-version" -type f -maxdepth 4)
        paste (cat $files | psub) (string replace -r '^(.*)$' '($1)' $files | psub) | sort

    case '*'
        echo 'Usage: versions <command> [args]'
        echo ''
        echo 'Commands:'
        echo '    installed          List installed versions'
        echo '    used               List used versions'
    end
end
