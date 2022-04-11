function __workdir
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo (__shortdir (git rev-parse --show-toplevel))
    else
        echo (__shortdir "$PWD")
    end
end
