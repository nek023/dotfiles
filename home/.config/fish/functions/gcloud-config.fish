function gcloud-config
    set -l config_name (gcloud config configurations list \
        --format='table[no-heading](is_active.yesno(yes="*",no="-"), name, properties.core.account, properties.core.project.yesno(no="(unset)"))' \
        | grep --color=always -E '^(\*)|$' \
        | fzf +m -q "$argv[1]" \
        | awk '{print $2}')

    if test -n "$config_name"
        gcloud config configurations activate "$config_name"
    end
end
