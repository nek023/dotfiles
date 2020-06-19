# config.fish

# ------------------------------------------------------------------------------
# fish variables
# ------------------------------------------------------------------------------
# 挨拶メッセージを非表示にする
set fish_greeting

# パスの短縮表示を無効にする
set fish_prompt_pwd_dir_length 0

# __fish_git_prompt
set __fish_git_prompt_showdirtystate     'yes'
set __fish_git_prompt_showstashstate     'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream       'yes'

# ------------------------------------------------------------------------------
# environment variables
# ------------------------------------------------------------------------------
# shell
set -x SHELL (which fish)

# lang
set -x LANG ja_JP.UTF-8

# XDG Base Directory Specification
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share

# editor
if type -aq nvim
    set -x EDITOR nvim
else if type -aq vim
    set -x EDITOR vim
end

# pager
if type -aq less
    set -x PAGER less
end

# gpg
set -x GPG_TTY (tty)

# go
set -x GOPATH $HOME/.go

# bat
# https://github.com/sharkdp/bat
if type -aq bat
    set -x BAT_THEME base16
    set -x MANPAGER 'sh -c "col -bx | bat -l man -p --theme=\'Monokai Extended\'"'
    alias cat='bat -p'
end

# fzf
# https://github.com/junegunn/fzf
set -x FZF_DEFAULT_OPTS '
--reverse
--extended
--ansi
--multi
--cycle
--no-sort
--color fg:-1,bg:-1,hl:229,fg+:3,bg+:233,hl+:103
--color info:150,prompt:110,spinner:150,pointer:167,marker:174
'

# ------------------------------------------------------------------------------
# aliases
# ------------------------------------------------------------------------------
alias gl='git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias gpull='git pull origin (__git_current_branch)'
alias gpush='git push origin (__git_current_branch)'
alias gpush!='git push --force-with-lease origin (__git_current_branch)'
alias grep='command grep -v grep | command grep --color=auto'
alias la='ls -lAh'
alias ll='ls -lh'
alias timestamp='date +%Y%m%d-%H%M%S | tr -d \'\\n\''
alias printpath='echo $PATH | string split \' \''

# ------------------------------------------------------------------------------
# fisher
# https://github.com/jorgebucaran/fisher
# ------------------------------------------------------------------------------
# fisherの自動インストール
# https://github.com/jorgebucaran/fisher#bootstrap-installation
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# インストール先のパスを変更する
# https://github.com/jorgebucaran/fisher#changing-the-installation-prefix
set fisher_path $HOME/dotfiles/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

# ------------------------------------------------------------------------------
# fish-global-abbreviation
# https://github.com/ryotako/fish-global-abbreviation
# ------------------------------------------------------------------------------
set gabbr_config $HOME/.config/fish/gabbr.conf

# ------------------------------------------------------------------------------
# local config
# ------------------------------------------------------------------------------
status --is-interactive && __source_if_exists $HOME/.config/fish/interactive.fish
status --is-login && __source_if_exists $HOME/.config/fish/login.fish
__source_if_exists $HOME/.config.local/fish/config.fish
