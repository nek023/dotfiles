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
alias ll 'ls -lh'
alias la 'ls -lAh'

alias md 'mkdir'
alias rd 'rmdir'
alias rf 'rm -rf'

alias diff  'diff -u'
alias grep  'command grep -v grep | command grep --color=auto'

alias ff    'fzf'
alias gg    'ghq get'
alias a     'atom .'
alias v     'vagrant'
alias watch 'watch -n 0.5'
alias clone 'git clone --recursive'
alias rt    'cd ./(git rev-parse --show-cdup)'

alias ssh-config  'vim ~/.ssh/config'
alias direnv-init 'echo \'export PATH=$PWD/bin:$PWD/vendor/bin:$PATH\' > .envrc; and direnv allow'

alias ...    'cd ../..'
alias ....   'cd ../../..'
alias .....  'cd ../../../..'
alias ...... 'cd ../../../../..'

alias g      'git'

alias ga     'git add'
alias gaa    'git add --all'

alias gc     'git commit'
alias gc!    'git commit --amend'
alias gca    'git commit -a'
alias gca!   'git commit -a --amend'

alias gac    'git add -A; and git commit'
alias gac!   'git add -A; and git commit --amend'

alias gb     'git branch'
alias gba    'git branch -a'

alias gco    'git checkout'
alias gcb    'git checkout -b'
alias gcm    'git checkout master'

alias gm     'git merge --no-ff'
alias gmff   'git merge'

alias gs     'git status'
alias gd     'git diff'
alias gl     'git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias gf     'git fetch'
alias gcp    'git cherry-pick'
alias gr     'git rebase'
alias gbl    'blame -b -w'
alias gclean 'git clean -fd'
alias gpush  'git push origin (git_current_branch)'
alias gpush! 'git push --force-with-lease origin (git_current_branch)'
alias gi     'git ignore'
alias gre    'git review'
alias gff    'git fzf'

alias s  'rails s'
alias c  'rails c'
alias db 'rails db'
alias t  'rspec'
alias be 'bundle exec'
alias bi 'bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=4'

alias krepare 'knife solo prepare'
alias kook    'knife solo cook'

# ------------------------------------------------------------------------------
# Load external files
# ------------------------------------------------------------------------------
load_file $HOME/.proxy

# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------
tmux_create_new_session
