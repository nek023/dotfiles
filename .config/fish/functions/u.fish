function u
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "not a git repository" >&2
        return 1
    end

    cd ./(git rev-parse --show-cdup)

    if count $argv >/dev/null
        cd $argv
    end
end
