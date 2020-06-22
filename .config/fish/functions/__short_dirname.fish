function __short_dirname
    set -l dir $argv[1]
    set -l delim /
    set -q $argv[2] || set delim $argv[2]

    set -l left (basename (dirname $dir))
    set -l right (basename $dir)

    echo $left$delim$right
end
