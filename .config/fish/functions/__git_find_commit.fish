function __git_find_commit
    git log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $argv | \
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort | \
        grep -o '[a-f0-9]\{7\}' | \
        head -1
end
