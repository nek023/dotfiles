# https://github.com/junegunn/fzf/wiki/Examples#git
function __git_select_commit
    argparse -n __git_select_commit 'q/query=' -- $argv || return

    git log --color --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' \
        | fzf +m +s -q "$_flag_query" | grep -o '[a-f0-9]\{7\}' | head -1
end
