function pr
    set -l prs (gh pr list \
        --limit 100 \
        --json number,title,headRefName,updatedAt,statusCheckRollup \
        --template '{{range .}}
    {{- $concl := (join "" (pluck "conclusion" .statusCheckRollup)) -}}
    {{- $status := "🟡" -}}
    {{- if regexMatch "^(SUCCESS|SKIPPED)+$" $concl -}}{{ $status = "✅" }}
    {{- else if contains "FAILURE" $concl -}}{{ $status = "❌" }}{{- end -}}
    {{- tablerow (printf "#%v" .number) .title $status .headRefName (timeago .updatedAt) -}}{{end}}')

    if test -z "$prs"
        echo "no open pull requests found"
        return
    end

    set -l number (echo "$prs" | fzf +m +s | sed 's/^#\([0-9]*\).*/\1/')

    if test -n "$number"
        gh pr checkout "$number"
    end
end
