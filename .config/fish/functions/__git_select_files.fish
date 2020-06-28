function __git_select_files
    argparse -n __git_select_files 'q/query=' -- $argv || return
    git status --porcelain | fzf -m -q "$_flag_query" | string sub -s 4
end
