function brew
    set -l tmp_path $PATH

    # pyenv
    while true
        set -l i (contains -i $HOME/.anyenv/envs/pyenv/shims $tmp_path)
        if test -z "$i"
            break
        end
        set -e tmp_path[$i]
    end

    set -lx PATH $tmp_path
    command brew $argv
end
