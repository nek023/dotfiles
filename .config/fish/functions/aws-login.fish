function aws-login
    argparse -n aws-login 'h/help' 'i/inprivate' -- $argv || return

    if set -q _flag_help
        echo 'usage: aws-login [--inprivate] [profile]'
        return
    end

    set -l profile $argv
    if test -z "$profile"
        set profile (aws-vault list --profiles | egrep "^aws-vault" | string sub -s 11 | fzf +m)
    end

    if test -z "$profile"
        aws-login -h
        return
    end

    set -l login_url (aws-vault login aws-vault.$profile --no-session --stdout)
    if set -q _flag_inprivate
        open -na 'Microsoft Edge' --args --inprivate \
            --user-data-dir="$HOME/Library/Application Support/Microsoft Edge/aws-vault/$profile" \
            "$login_url"
    else
        open -na 'Microsoft Edge' "$login_url"
    end
end
