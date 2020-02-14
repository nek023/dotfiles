function __workdir
    set -l inside_work_tree (git rev-parse --is-inside-work-tree 2>/dev/null)

    if test "$inside_work_tree" = 'true'
        echo (__short_dirname (git rev-parse --show-toplevel))
    else
        echo (__short_dirname (pwd))
    end
end
