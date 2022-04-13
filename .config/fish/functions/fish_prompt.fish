function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l timestamp (date '+%H:%M:%S')

    # 直前のコマンドのステータスで色を分ける
    set -l smallfish '><((・>'
    set -l smallfish_color $fish_color_status_ok
    if test $last_status -ne 0
        set smallfish '><((ｘ>'
        set smallfish_color $fish_color_status_ng
    end

    # 通常ユーザー/rootユーザーで色を分ける
    set -l color_cwd $fish_color_cwd
    set -l suffix '$'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # ローカル/リモートで色を分ける
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    printf "\n%s%s%s@%s%s%s:%s%s%s%s %s[%s]\n%s%s%s %s " \
        (set_color $fish_color_user) $USER $normal \
        (set_color $color_host) (prompt_hostname) $normal \
        (set_color $color_cwd) (prompt_pwd) \
        (set_color $fish_color_vcs) (fish_vcs_prompt) \
        (set_color $fish_color_time) $timestamp \
        (set_color $smallfish_color) $smallfish $normal \
        $suffix
end
