# login.fish
# ログインシェルでのみ実行されます

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
# /usr/local/binのあとに/usr/local/sbinを追加する
# fish_user_pathsではなくPATHに追加しないと、anyenv init実行時に順番がおかしくなる
set -x PATH /usr/local/bin /usr/local/sbin (string match -v /usr/local/bin $PATH)

# anyenv
if test -d $HOME/.anyenv
    status --is-interactive && source (anyenv init - | psub)
end

# go
if test -d $GOPATH/bin
    set -x PATH $GOPATH/bin $PATH
end

# rust
if test -d $HOME/.cargo/bin
    set -x PATH $HOME/.cargo/bin $PATH
end

# Google Cloud SDK
if test -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
end

# dotfiles/bin
set -x PATH $HOME/dotfiles/bin $PATH

# ------------------------------------------------------------------------------
# startup
# ------------------------------------------------------------------------------
__tmux_create_session
