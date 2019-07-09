# config.fish

# ------------------------------------------------------------------------------
# Fish
# ------------------------------------------------------------------------------
# 挨拶メッセージを非表示にする
set fish_greeting

# パスの短縮表示を無効にする
set fish_prompt_pwd_dir_length 0

# ------------------------------------------------------------------------------
# Fisher
# ------------------------------------------------------------------------------
# Fisherのインストール
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# インストール先のパスを変更する
set -g fisher_path $HOME/dotfiles/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

# ------------------------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------------------------
# shell
set -gx SHELL (which fish)

# lang
set -gx LANG ja_JP.UTF-8

# editor
if type -qa nvim
    set -gx EDITOR nvim
else if type -qa vim
    set -gx EDITOR vim
end

# pager
if type -qa less
    set -gx PAGER less
end

# gpg
set -gx GPG_TTY (tty)

# __fish_git_prompt
set __fish_git_prompt_showdirtystate     'yes'
set __fish_git_prompt_showstashstate     'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream       'yes'

# ryotako/fish-global-abbreviation
set -gx gabbr_config $HOME/.config/fish/gabbr.conf

# anyenv
if test -d $HOME/.anyenv
    status --is-interactive && source (anyenv init - | psub)
end

# go
set -gx GOPATH $HOME/.go
if test -d $GOPATH/bin
    set -gx fish_user_paths $GOPATH/bin $fish_user_paths
end

# heroku
if test -d /usr/local/heroku/bin
    set -gx fish_user_paths /usr/local/heroku/bin $fish_user_paths
end

# direnv
if type -qa direnv
    eval (direnv hook fish)
end

# fzf
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

# dotfiles/bin
set -gx fish_user_paths $HOME/dotfiles/bin $fish_user_paths

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
alias gl='git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias grep='command grep -v grep | command grep --color=auto'
alias gpull='git pull origin (__git_current_branch)'
alias gpush='git push origin (__git_current_branch)'
alias gpush!='git push --force-with-lease origin (__git_current_branch)'
alias la='ls -lAh'
alias ll='ls -lh'

# ------------------------------------------------------------------------------
# Abbreviations
# ------------------------------------------------------------------------------
abbr -a diff 'diff -u'
abbr -a md   'mkdir'
abbr -a o    'open'
abbr -a rf   'rm -rf'
abbr -a rd   'rmdir'

abbr -a g    'git'
abbr -a ga   'git add'
abbr -a gaa  'git add -A'
abbr -a gac  'git add -A && git commit'
abbr -a gac! 'git add -A && git commit --amend'
abbr -a gap  'git add -p'
abbr -a gb   'git branch'
abbr -a gco  'git checkout'
abbr -a gcb  'git checkout -b'
abbr -a gcm  'git checkout master'
abbr -a gcp  'git cherry-pick'
abbr -a gc   'git commit'
abbr -a gc!  'git commit --amend'
abbr -a gd   'git diff'
abbr -a gds  'git diff --staged'
abbr -a gf   'git fetch'
abbr -a gm   'git merge --no-ff'
abbr -a gr   'git rebase'
abbr -a grc  'git rebase --continue'
abbr -a gri  'git rebase -i'
abbr -a grm  'git rebase master'
abbr -a gre  'git reset'
abbr -a greh 'git reset HEAD'
abbr -a gs   'git status'

abbr -a co   'code'
abbr -a gg   'ghq get'
abbr -a d    'docker'
abbr -a dc   'docker-compose'
abbr -a tf   'terraform'
abbr -a tfw  'terraform workspace'

abbr -a b    'bundle'
abbr -a be   'bundle exec'
abbr -a bi   'bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=4'
abbr -a c    'rails c'
abbr -a s    'rails s'
abbr -a cop  'rubocop'
abbr -a copa 'rubocop -a'
abbr -a t    'rspec'

abbr -a brewup     'brew update; brew upgrade; brew cleanup'
abbr -a ssh-config 'vim ~/.ssh/config'

# ------------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------------
bind \c{ backward-word
bind \c} forward-word

if functions -q __gabbr_expand
    bind ' ' '__gabbr_expand; commandline -i " "'
    bind ';' '__gabbr_expand; commandline -i "; "'
    bind \cj '__gabbr_expand; commandline -f execute'
    bind \cm '__gabbr_expand; commandline -f execute'
    bind \r  '__gabbr_expand; commandline -f execute'
end

# ------------------------------------------------------------------------------
# Load local config
# ------------------------------------------------------------------------------
__source_if_exists $HOME/.proxy
__source_if_exists $HOME/.config.local/fish/config.fish

# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------
function __tmux_rename_window --on-event fish_prompt
    if __tmux_is_running
        set -l git_dir (__git_dir_path)
        set -l window_name

        if test -n "$git_dir"
          set window_name (basename (dirname $PWD))/(basename $PWD)
        else
          set window_name (basename $PWD)
        end

        tmux rename-window "$window_name"
    end
end

__tmux_create_new_session
