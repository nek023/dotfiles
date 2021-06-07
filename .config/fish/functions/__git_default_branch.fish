function __git_default_branch
    if git for-each-ref --format="%(refname:short)" refs/heads/ | grep -q main
        echo main
    else
        echo master
    end
end
