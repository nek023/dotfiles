# config.fish

# ------------------------------------------------------------------------------
# Fish
# ------------------------------------------------------------------------------
set fish_greeting
set fish_prompt_pwd_dir_length 0

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
# Locale and encoding
set -x LANG ja_jp.UTF-8

# Editor
if type -qa nvim
  set -x EDITOR nvim
else if type -qa vim
  set -x EDITOR vim
end

# PAGER
if type -qa less
  set -x PAGER less
end

# vim
if type -a vim >/dev/null ^/dev/null
  alias vim 'vi'
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

alias fz    'fzf'
alias watch 'watch -n 0.5'
alias direnv-init 'echo \'export PATH=$PWD/bin:$PWD/vendor/bin:$PATH\' > .envrc; and direnv allow'

alias ssh-config 'vim ~/.ssh/config'

alias ...    'cd ../..'
alias ....   'cd ../../..'
alias .....  'cd ../../../..'
alias ...... 'cd ../../../../..'

alias g      'git'

alias ga     'git add'
alias gaa    'git add --all'

alias gb     'git branch'
alias gba    'git branch -a'

alias gbl    'git blame -b -w'

alias gc     'git commit -v'
alias gc!    'git commit -v --amend'
alias gca    'git commit -v -a'
alias gca!   'git commit -v -a --amend'

alias gco    'git checkout'
alias gcb    'git checkout -b'
alias gcm    'git checkout master'

alias gm     'git merge --no-ff'
alias gmff   'git merge'

alias gst    'git stash'
alias gpop   'git stash pop'
alias gdrop  'git stash drop'

alias gl     'git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias gd     'git diff'
alias gf     'git fetch'
alias gcl    'git clone --recursive'
alias gs     'git status'
alias gcp    'git cherry-pick'
alias gr     'git rebase'
alias gf     'git fzf'
alias gi     'git ignore'
alias gclean 'git clean -fd'
alias gpush  'git push origin (git_current_branch)'
alias gpush! 'git push --force-with-lease origin (git_current_branch)'
alias gpr    'git_project_root_cd'

alias s  'rails s'
alias c  'rails c'
alias db 'rails db'
alias t  'rspec'
alias be 'bundle exec'
alias bi 'bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=4'

alias krepare 'knife solo prepare'
alias kook    'knife solo cook'

eval (thefuck --alias | tr '\n' ';')

# ------------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------------
load_file $HOME/.proxy

# tmux_create_new_session
