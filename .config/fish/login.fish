# login.fish
# ログインシェルでのみ実行されます

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
# /usr/local/binのあとに/usr/local/sbinを追加する
# fish_user_pathsではなくPATHに追加しないと、anyenv init実行時に順番がおかしくなる
set -gx PATH /usr/local/bin /usr/local/sbin (string match -v /usr/local/bin $PATH)

# Google Cloud SDK
if test -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
end

# anyenv
if test -d $HOME/.anyenv
    status --is-interactive && source (anyenv init - | psub)
end

# go
if test -d $GOPATH/bin
    set -gx fish_user_paths $GOPATH/bin $fish_user_paths
end

# heroku
if test -d /usr/local/heroku/bin
    set -gx fish_user_paths /usr/local/heroku/bin $fish_user_paths
end

# rust
if test -d $HOME/.cargo/bin
    set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

# dotfiles/bin
set -gx fish_user_paths $HOME/dotfiles/bin $fish_user_paths

# ------------------------------------------------------------------------------
# startup
# ------------------------------------------------------------------------------
__tmux_create_session
