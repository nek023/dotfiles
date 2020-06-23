function __short_dirname -a dir delim
    test -z "$delim" && set delim /
    echo (basename (dirname $dir))$delim(basename $dir)
end
