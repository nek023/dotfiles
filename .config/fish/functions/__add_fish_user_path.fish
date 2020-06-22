function __add_fish_user_path -a dir
    test -d "$dir" || return
    contains "$dir" $fish_user_paths || set -gp fish_user_paths $dir
end
