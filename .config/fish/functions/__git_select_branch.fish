function __git_select_branch
    argparse -n __git_select_branch 'q/query=' 'r/remotes' -- $argv || return
    set -l git_opts
    set -q _flag_remotes && set -a git_opts -r
    eval "git branch --format='%(refname:short)' --sort=-committerdate $git_opts" \
        | fzf +m +s -q "$_flag_query"
end
