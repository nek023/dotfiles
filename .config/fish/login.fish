# login.fish
# ログインシェルでのみ実行されます

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
# /usr/local/binのあとに/usr/local/sbinを追加する
if contains /usr/local/bin $PATH && not contains /usr/local/sbin $PATH
    set -l bin_index (contains -i /usr/local/bin $PATH)
    set -x PATH $PATH[1..$bin_index] /usr/local/sbin $PATH[(math $bin_index+1)..-1]
end

# anyenv
if not string match -e anyenv -q $PATH && type -aq anyenv
    source (anyenv init - | psub)
end

# go
if not contains $GOPATH/bin $PATH && test -d $GOPATH/bin
    set -x PATH $GOPATH/bin $PATH
end

# rust
if not contains ~/.cargo/bin $PATH && test -d ~/.cargo/bin
    set -x PATH ~/.cargo/bin $PATH
end

# Google Cloud SDK
if test -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
end

# dotfiles/bin
if not contains ~/dotfiles/bin $PATH && test -d ~/dotfiles/bin
    set -x PATH ~/dotfiles/bin $PATH
end

# ------------------------------------------------------------------------------
# startup
# ------------------------------------------------------------------------------
__tmux_create_session
