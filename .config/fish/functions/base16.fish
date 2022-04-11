# https://github.com/chriskempson/base16-shell/blob/ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1/profile_helper.fish
function base16
    set -l theme (find "$BASE16_SHELL/scripts" -type f -exec basename {} .sh \; \
        | cut -c8- | sort | fzf +m +s)
    test -n "$theme" || return

    eval "base16-$theme"
end
