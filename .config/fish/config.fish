# config.fish

# ------------------------------------------------------------------------------
# fish variables
# ------------------------------------------------------------------------------
# 挨拶メッセージを非表示にする
set -g fish_greeting

# パスの短縮表示を無効にする (prompt_pwd)
set -g fish_prompt_pwd_dir_length 0

# fish_prompt
set -g fish_color_user        brgreen
set -g fish_color_cwd         blue
set -g fish_color_cwd_root    red
set -g fish_color_host        normal
set -g fish_color_host_remote yellow
set -g fish_color_vcs         red
set -g fish_color_time        555
set -g fish_color_status_ok   blue
set -g fish_color_status_ng   red

# fish_git_prompt
set -g __fish_git_prompt_showdirtystate     yes
set -g __fish_git_prompt_showstashstate     yes
set -g __fish_git_prompt_showuntrackedfiles yes
set -g __fish_git_prompt_showupstream       yes

# ------------------------------------------------------------------------------
# environment variables
# ------------------------------------------------------------------------------
# shell
set -gx SHELL (which fish)

# lang
set -gx LANG en_US.UTF-8

# XDG Base Directory Specification
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share

# editor
if type -q nvim
    set -gx EDITOR nvim
else if type -q vim
    set -gx EDITOR vim
end

# pager
if type -q less
    set -gx PAGER less
end

# gpg
set -gx GPG_TTY (tty)

# go
set -gx GOPATH ~/.go

# ------------------------------------------------------------------------------
# user paths
# ------------------------------------------------------------------------------
# Homebrew
fish_add_path -m (brew --prefix)/sbin
fish_add_path -m (brew --prefix)/bin

# go
fish_add_path -m $GOPATH/bin

# rust
fish_add_path -m ~/.cargo/bin

# Google Cloud SDK
fish_add_path -m /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

# krew
fish_add_path -m ~/.krew/bin

# dotfiles/bin
fish_add_path -m ~/dotfiles/bin

# ------------------------------------------------------------------------------
# asdf
# https://github.com/asdf-vm/asdf
# ------------------------------------------------------------------------------
if type -q asdf
    source (brew --prefix asdf)"/libexec/asdf.fish"
end

# ------------------------------------------------------------------------------
# bat
# https://github.com/sharkdp/bat
# ------------------------------------------------------------------------------
if type -q bat
    set -gx BAT_THEME base16
    set -gx MANPAGER 'sh -c "col -bx | bat -l man -p --theme=\'Monokai Extended\'"'
end

# ------------------------------------------------------------------------------
# fzf
# https://github.com/junegunn/fzf
# ------------------------------------------------------------------------------
set -gx FZF_DEFAULT_OPTS '
    --ansi --cycle --reverse
    --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:103
    --color info:150,prompt:110,spinner:150,pointer:167,marker:174
'

# ------------------------------------------------------------------------------
# fisher
# https://github.com/jorgebucaran/fisher
# ------------------------------------------------------------------------------
# プラグインのインストール先を変更する
# https://github.com/jorgebucaran/fisher/issues/640
set -g fisher_path ~/dotfiles/.config/fish/fisher

set -g fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set -g fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end

# ------------------------------------------------------------------------------
# direnv
# https://github.com/direnv/direnv
# ------------------------------------------------------------------------------
type -q direnv && direnv hook fish | source

# workaround for https://github.com/direnv/direnv/issues/583
function __direnv_export_eval_on_prompt --on-event fish_prompt
    type -q direnv && eval (direnv export fish)
end

# ------------------------------------------------------------------------------
# local config
# ------------------------------------------------------------------------------
status is-interactive && __source_script $__fish_config_dir/interactive.fish
status is-login && __source_script $__fish_config_dir/login.fish
__source_script ~/.config.local/fish/config.fish
