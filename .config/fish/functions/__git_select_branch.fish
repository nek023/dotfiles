function __git_select_branch
    argparse -n __git_select_branch 'q/query=' 'r/remotes' -- $argv || return
    set -l options
    set -q _flag_remotes && set -a options -r
    eval "git branch --format='%(refname:short)' --sort=-committerdate $options" | \
        fzf +m +s -q "$_flag_query"
end
