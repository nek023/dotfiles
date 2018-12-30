# config.fish

# ------------------------------------------------------------------------------
# Suppress greeting message
# ------------------------------------------------------------------------------
set fish_greeting
set fish_prompt_pwd_dir_length 0

# ------------------------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------------------------
# SHELL
set -gx SHELL (which fish)

# $HOME/bin
set -gx fish_user_paths $fish_user_paths $HOME/bin

# LANG
set -gx LANG ja_jp.UTF-8

# EDITOR
if type -qa nvim
  set -gx EDITOR nvim
else if type -qa vim
  set -gx EDITOR vim
end

# PAGER
if type -qa less
  set -gx PAGER less
end

# Go
set -gx GOPATH $HOME/.go
if test -d $GOPATH/bin
  set -gx fish_user_paths $fish_user_paths $GOPATH/bin
end

# anyenv
if test -d $HOME/.anyenv/bin
  set -gx fish_user_paths $fish_user_paths $HOME/.anyenv/bin
  status --is-interactive; and source (anyenv init - | psub)
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

# heroku
if test -d /usr/local/heroku/bin
  set -gx fish_user_paths $fish_user_paths /usr/local/heroku/bin
end

# __fish_git_prompt
set __fish_git_prompt_showdirtystate     'yes'
set __fish_git_prompt_showstashstate     'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream       'yes'

# fish-global-abbreviation
set -gx gabbr_config $HOME/.config/fish/gabbr.conf

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
abbr -a ll 'ls -lh'
abbr -a la 'ls -lAh'

abbr -a md 'mkdir'
abbr -a rd 'rmdir'
abbr -a rf 'rm -rf'

abbr -a diff  'diff -u'
abbr -a grep  'command grep -v grep | command grep --color=auto'

abbr -a ff    'fzf'
abbr -a gg    'ghq get'
abbr -a v     'vagrant'
abbr -a cop   'rubocop'
abbr -a copa  'rubocop -a'
abbr -a watch 'watch -n 0.5'
abbr -a clone 'git clone --recursive'
abbr -a rt    'cd ./(git rev-parse --show-cdup)'
abbr -a a     '__atom'
abbr -a co    '__vscode'
abbr -a o     '__open'

abbr -a brewup      'brew update; brew upgrade --outdated'
abbr -a ssh-config  'vim ~/.ssh/config'

abbr -a g      'git'

abbr -a ga     'git add'
abbr -a gaa    'git add --all'
abbr -a gap    'git add -p'

abbr -a gc     'git commit'
abbr -a gc!    'git commit --amend'
abbr -a gca    'git commit -a'
abbr -a gca!   'git commit -a --amend'

abbr -a gac    'git add -A; and git commit'
abbr -a gac!   'git add -A; and git commit --amend'

abbr -a gb     'git branch'
abbr -a gba    'git branch -a'

abbr -a gco    'git checkout'
abbr -a gcb    'git checkout -b'
abbr -a gcm    'git checkout master'

abbr -a gd     'git diff'
abbr -a gds    'git diff --staged'

abbr -a gm     'git merge --no-ff'
abbr -a gmff   'git merge'

abbr -a gr     'git rebase'
abbr -a grc    'git rebase --continue'
abbr -a gri    'git rebase -i'
abbr -a grm    'git rebase master'

abbr -a gre    'git reset'
abbr -a greh   'git reset HEAD'

abbr -a gs     'git status'
abbr -a gl     'git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
abbr -a gf     'git fetch'
abbr -a gcp    'git cherry-pick'
abbr -a gbl    'git blame -b -w'
abbr -a gclean 'git clean -fd'
abbr -a gpush  'git push origin (__git_current_branch)'
abbr -a gpush! 'git push --force-with-lease origin (__git_current_branch)'
abbr -a gpull  'git pull origin (__git_current_branch)'
abbr -a gre    'git review'
abbr -a gff    'git fzf'

abbr -a s  'rails s'
abbr -a sb 'rails s -b 0.0.0.0'
abbr -a c  'rails c'
abbr -a t  'rspec'
abbr -a b  'bundle'
abbr -a be 'bundle exec'
abbr -a bi 'bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=4'
abbr -a ss 'spring stop'

abbr -a kz  'knife zero'
abbr -a kzb 'knife zero bootstrap'
abbr -a kzc 'knife zero converge'

# ------------------------------------------------------------------------------
# Load local config
# ------------------------------------------------------------------------------
__load_file $HOME/.proxy
__load_file $HOME/.local-config/fish/config.fish

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
