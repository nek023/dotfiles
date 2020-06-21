# config.fish

# ------------------------------------------------------------------------------
# fish variables
# ------------------------------------------------------------------------------
# 挨拶メッセージを非表示にする
set -g fish_greeting

# パスの短縮表示を無効にする
set -g fish_prompt_pwd_dir_length 0

# fish_git_prompt
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_git_prompt.fish
set -g __fish_git_prompt_showdirtystate     'yes'
set -g __fish_git_prompt_showstashstate     'yes'
set -g __fish_git_prompt_showuntrackedfiles 'yes'
set -g __fish_git_prompt_showupstream       'yes'

# ------------------------------------------------------------------------------
# environment variables
# ------------------------------------------------------------------------------
# shell
set -gx SHELL (which fish)

# lang
set -gx LANG ja_JP.UTF-8

# XDG Base Directory Specification
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share

# editor
if type -aq nvim
    set -gx EDITOR nvim
else if type -aq vim
    set -gx EDITOR vim
end

# pager
if type -aq less
    set -gx PAGER less
end

# gpg
set -gx GPG_TTY (tty)

# go
set -gx GOPATH ~/.go

# bat
# https://github.com/sharkdp/bat
if type -aq bat
    set -gx BAT_THEME base16
    set -gx MANPAGER 'sh -c "col -bx | bat -l man -p --theme=\'Monokai Extended\'"'
end

# fzf
# https://github.com/junegunn/fzf
set -gx FZF_DEFAULT_OPTS '
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

type -aq bat && alias cat='bat -p'

# ------------------------------------------------------------------------------
# fisher
# https://github.com/jorgebucaran/fisher
# ------------------------------------------------------------------------------
# fisherの自動インストール
# https://github.com/jorgebucaran/fisher#bootstrap-installation
if not functions -q fisher
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# インストール先のパスを変更する
# https://github.com/jorgebucaran/fisher#changing-the-installation-prefix
set -g fisher_path ~/dotfiles/.config/fish/fisher

set -g fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set -g fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

# ------------------------------------------------------------------------------
# fish-global-abbreviation
# https://github.com/ryotako/fish-global-abbreviation
# ------------------------------------------------------------------------------
set -g gabbr_config $XDG_CONFIG_HOME/fish/gabbr.conf

# ------------------------------------------------------------------------------
# local config
# ------------------------------------------------------------------------------
status --is-interactive && __source_if_exists $__fish_config_dir/interactive.fish
status --is-login && __source_if_exists $__fish_config_dir/login.fish
__source_if_exists ~/.config.local/fish/config.fish
