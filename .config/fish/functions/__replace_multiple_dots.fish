function __replace_multiple_dots
    set -l token (string match '*..' -- (commandline -tc))
    if test -d "$token"
        commandline -i '/..'
    else
        commandline -i '.'
    end
end
