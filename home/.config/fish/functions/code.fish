function code
    set -l args $argv
    if not count $args >/dev/null
        set args $PWD
    end

    set -l args_str (string join " " -- $argv)
    if test "$VSCODE_INJECTION" = 1; and not string match -qr '(^| )-n( |$)' -- "$args_str"; and not string match -qr '(^| )-r( |$)' -- "$args_str"
        command code -r $args
    else
        command code $args
    end
end
