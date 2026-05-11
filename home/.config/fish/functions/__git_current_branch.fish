function __git_current_branch
    git symbolic-ref --short HEAD
end
