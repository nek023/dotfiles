function code
    if count $argv > /dev/null
        command code $argv
    else
        command code $PWD
    end
end
