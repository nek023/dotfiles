function __workdir
    if test (git rev-parse --is-inside-work-tree 2>/dev/null) = 'true'
        echo (__short_dirname (git rev-parse --show-toplevel))
    else
        echo (__short_dirname (pwd))
    end
end
