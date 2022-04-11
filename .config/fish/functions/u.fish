function u
    cd ./"$(git rev-parse --show-cdup)"

    if count $argv > /dev/null
        cd $argv
    end
end
