function __short_dirname
    set path $argv[1]
    set delim /
    set -q $argv[2] || set delim $argv[2]

    set left (basename (dirname $path))
    set right (basename $path)

    echo $left$delim$right
end
