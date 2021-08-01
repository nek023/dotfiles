function __ghq_select_repo
    argparse -n __ghq_select_repo 'q/query=' -- $argv || return
    set -l repo (ghq list -p | sed -e "s|$HOME/||g" | fzf +m -q "$_flag_query")
    test -n "$repo" && echo $HOME/$repo
end
