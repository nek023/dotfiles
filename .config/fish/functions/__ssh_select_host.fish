function __ssh_select_host
    argparse -n __ssh_select_host 'q/query=' -- $argv || return

    set -l config_paths /etc/ssh/ssh_config ~/.ssh/config
    for config_path in $config_paths
        set -l include_paths (command grep -ri Include $config_path | command grep -v '#' | \
            string replace -ri -- '.*\s*Include\s+(.*)' '$1')

        for include_path in $include_paths
            if string match -qri -- '^~/' $include_path || string match -qri -- '^\$HOME/' $include_path
                for file_path in (string split ' ' (eval echo $include_path))
                    test -f $file_path && set -a config_paths $file_path
                end
            else
                for file_path in (string split ' ' (eval echo (dirname $config_path)/$include_path))
                    test -f $file_path && set -a config_paths $file_path
                end
            end
        end
    end

    command egrep -i '^Host\s+.+' $config_paths | string replace -ri '[^\s]+\s+(.*)' '$1' | \
        string replace -ra '\s' ' ' | string split ' ' | command egrep -v '[*?]' | sort -u | \
        fzf +m -q "$_flag_query" | tr '\n' ' '
end
