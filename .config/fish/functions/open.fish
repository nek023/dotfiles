function open
    if count $argv > /dev/null
        command open $argv
    else
        command open $PWD
    end
end
