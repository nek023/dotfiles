function __shortdir -a dir
    test -n "$dir" || set dir "$PWD"
    echo (basename (dirname "$dir"))/(basename "$dir")
end
