# https://github.com/junegunn/fzf/wiki/Examples#git
function __git_select_commit
    argparse -n __git_select_branch 'q/query=' -- $argv || return
    git log --graph --color --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $argv | \
        fzf --ansi +m +s -q "$_flag_query" | grep -o '[a-f0-9]\{7\}' | head -1
end
