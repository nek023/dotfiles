function git-rename-branch
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "not a git repository"
        return 1
    end

    set -l current_branch (git symbolic-ref --short HEAD 2>/dev/null)
    set -l tmp_file (mktemp)
    echo "$current_branch" > "$tmp_file"

    if set -q EDITOR
        command $EDITOR "$tmp_file"
    else
        command vim "$tmp_file"
    end

    set -l new_branch (cat "$tmp_file" | tr -d "[:space:]")
    rm -f "$tmp_file"

    if test -z "$new_branch"; or test "$new_branch" = "$current_branch"
        return 0
    end

    git branch -m "$new_branch"
end
