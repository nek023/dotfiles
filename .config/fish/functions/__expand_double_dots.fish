function __expand_double_dots
    set -l token (string match '*..' -- (commandline -tc))
    if test -d "$token"
        commandline -i '/..'
    else
        commandline -i '.'
    end
end
