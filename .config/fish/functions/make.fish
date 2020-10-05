function make
    if test ! -f Makefile -o "$argv" != 'help'
        command make $argv
        return
    end

    set -l targets (command grep -E '^[A-Za-z0-9_-]+:.*$' Makefile)

    if string match -q -r '^help:.*$' $targets
        command make help
        return
    end

    echo 'Targets:'
    for target in $targets
        set -l matches (string match -r '^([A-Za-z0-9_-]+):.*?(?:## (.*))?$' $target)
        set_color cyan; printf '  %-18s %s' $matches[2]
        test -n $matches[3] && set_color normal && echo $matches[3]
    end
end
