# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

# Editor
export EDITOR=vim

# bin
export PATH=$PATH:$HOME/bin

# Ghostscript
export PATH=$PATH:/usr/local/Cellar/ghostscript/9.15/share/ghostscript/Resource/Init

# Go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# Android Platform Tools
export PATH=$PATH:/Applications/adt-bundle-mac/sdk/platform-tools

# Heroku Toolbelt
export PATH=$PATH:/usr/local/heroku/bin

# Aliases
alias ls='CLICOLOR_FORCE=1 ls -G'
alias ll='ls -l'
alias la='ls -la'
alias less='less -R'
alias gl='git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias vi='vim'

# Colors
export CLICOLOR=1
export LSCOLORS=ExGxcxdxBxegedabagacad

# git-completion
source ~/.git-completion.bash

# git-prompt
source ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto
export PS1='\[\e[32m\]\u@\h\[\e[00m\]:\[\e[34m\]\w\[\e[31m\]$(__git_ps1)\[\e[00m\]\$ '

# anyenv
export PATH=$PATH:$HOME/.anyenv/bin
eval "$(anyenv init -)"

# direnv
eval "$(direnv hook bash)"

# Go to top-level directory of the current git repository
function u() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}
