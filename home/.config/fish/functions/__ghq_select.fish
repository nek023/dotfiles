function __ghq_select
    argparse -n __ghq_select 'q/query=' -- $argv || return

    set -l dir (ghq list -p | sed -e "s|$HOME/||" | fzf +m -q "$_flag_query")

    if test -n "$dir"
        echo "$HOME/$dir"
    end
end
