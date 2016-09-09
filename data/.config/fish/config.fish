# config.fish

# ------------------------------------------------------------------------------
# Fish
# ------------------------------------------------------------------------------
set fish_greeting
set fish_prompt_pwd_dir_length 0

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
# PATH
set -x PATH /usr/local/bin /bin /usr/bin /sbin /usr/sbin
if test -d /usr/local/sbin
  set PATH $PATH /usr/local/sbin
end

# $HOME/bin
set PATH $PATH $HOME/bin

# LANG
set -x LANG ja_jp.UTF-8

# EDITOR
if type -qa nvim
  set -x EDITOR nvim
else if type -qa vim
  set -x EDITOR vim
end

# PAGER
if type -qa less
  set -x PAGER less
end

# go
set -x GOPATH $HOME/.go
if test -d $GOPATH/bin
  set -x PATH $PATH $GOPATH/bin
end

# anyenv
if test -d $HOME/.anyenv/bin
  set PATH $HOME/.anyenv/bin $PATH
  status --is-interactive; and source (anyenv init - | psub)
end

# direnv
if type -qa direnv
  eval (direnv hook fish)
end

# fzf
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

# heroku
if test -d /usr/local/heroku/bin
  set -x PATH $PATH /usr/local/heroku/bin
end

# __fish_git_prompt
set __fish_git_prompt_showdirtystate     'yes'
set __fish_git_prompt_showstashstate     'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream       'yes'

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

abbr -a ssh-config  'vim ~/.ssh/config'
abbr -a direnv-init 'echo \'export PATH=$PWD/bin:$PWD/vendor/bin:$PATH\' > .envrc; and direnv allow'

abbr -a ...    'cd ../..'
abbr -a ....   'cd ../../..'
abbr -a .....  'cd ../../../..'
abbr -a ...... 'cd ../../../../..'

abbr -a g      'git'

abbr -a ga     'git add'
abbr -a gaa    'git add --all'

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
abbr -a grm    'git rebase master'

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
abbr -a c  'rails c'
abbr -a db 'rails db'
abbr -a t  'rspec'
abbr -a b  'bundle'
abbr -a be 'bundle exec'
abbr -a bi 'bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=4'

abbr -a krepare 'knife solo prepare'
abbr -a kook    'knife solo cook'

# ------------------------------------------------------------------------------
# Load external files
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
