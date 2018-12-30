function __vscode
    if count $argv > /dev/null
        code $argv
    else
        code $PWD
    end
end
