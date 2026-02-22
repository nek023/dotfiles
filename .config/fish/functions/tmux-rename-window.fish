function tmux-rename-window
    test -n "$TMUX" || return 0

    set -l pane_path (tmux display-message -p '#{pane_current_path}')
    set -l window_id (tmux display-message -p '#{window_id}')

    if test -z "$pane_path"; or test -z "$window_id"
        return 0
    end

    set -l dir
    if git -C "$pane_path" rev-parse --is-inside-work-tree >/dev/null 2>&1
        set dir (git -C "$pane_path" rev-parse --show-toplevel)
    else
        set dir "$pane_path"
    end

    tmux rename-window -t "$window_id" (basename (dirname "$dir"))"/"(basename "$dir")
end
