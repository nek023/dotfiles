function a
    if count $argv > /dev/null
        atom $argv
    else
        atom $PWD
    end
end
