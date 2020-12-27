function aws-login
    argparse -n aws-login 'd/duration=' 'h/help' 'i/incognito' -- $argv || return

    if set -q _flag_help
        echo 'usage: aws-login [options] [profile]'
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

    set -l login_url
    if set -q _flag_duration
        set login_url (aws-vault login aws-vault.$profile --stdout --duration $_flag_duration)
    else
        set login_url (aws-vault login aws-vault.$profile --stdout)
    end

    if set -q _flag_incognito
        open -na 'Google Chrome' --args --incognito \
            --user-data-dir="$HOME/Library/Application Support/Google/Chrome/aws-vault/$profile" \
            "$login_url"
    else
        open -na 'Google Chrome' "$login_url"
    end
end
