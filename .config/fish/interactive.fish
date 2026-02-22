# ------------------------------------------------------------------------------
# Abbreviations
# ------------------------------------------------------------------------------
abbr -ag m    'make'
abbr -ag o    'open'
abbr -ag rf   'rm -rf'

abbr -ag g    'git'
abbr -ag ga   'git add'
abbr -ag gaa  'git add -A'
abbr -ag gac  'git add -A && git commit'
abbr -ag gaca 'git add -A && git commit --amend'
abbr -ag gap  'git add -p'
abbr -ag gb   'git branch'
abbr -ag gbm  'git-rename-branch'
abbr -ag gc   'git commit'
abbr -ag gca  'git commit --amend'
abbr -ag gco  'git checkout'
abbr -ag gcp  'git cherry-pick'
abbr -ag gd   'git diff'
abbr -ag gds  'git diff --staged'
abbr -ag gf   'git fetch'
abbr -ag gm   'git merge'
abbr -ag gr   'git rebase'
abbr -ag gre  'git restore'
abbr -ag greh 'git reset HEAD'
abbr -ag gres 'git restore -S'
abbr -ag gri  'git rebase -i'
abbr -ag grm  'git rebase (__git_default_branch)'
abbr -ag gs   'git status'
abbr -ag gsc  'git switch -c'
abbr -ag gsm  'git switch (__git_default_branch)'
abbr -ag gsw  'git switch'

abbr -ag be   'bundle exec'
abbr -ag bi   'bundle install'
abbr -ag c    'rails c'
abbr -ag cop  'rubocop'
abbr -ag copa 'rubocop -a'
abbr -ag s    'rails s'
abbr -ag t    'rspec'

abbr -ag n    'npm'
abbr -ag nr   'npm run'
abbr -ag y    'yarn'
abbr -ag yr   'yarn run'

abbr -ag a    'aws-login'
abbr -ag co   'code'
abbr -ag d    'docker'
abbr -ag dc   'docker compose'
abbr -ag gg   'ghq get'
abbr -ag k    'kubectl'
abbr -ag tf   'terraform'
abbr -ag tfd  'terraform-docs'
abbr -ag cc   'claude'
abbr -ag ccc  'claude --continue'
abbr -ag ccr  'claude --resume'

abbr -ag brewup 'brew update; brew upgrade; brew cleanup'

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
alias la='ls -lAh'
alias ll='ls -lh'
alias diff='diff -u'
alias grep='command grep --color=auto'

alias gc!='git commit --amend'
alias gac!='git add -A && git commit --amend'
alias gl='git log --graph --all --color --pretty=format:'"'"'%h %cn %s%Cred%d%Creset'"'"''
alias gpull='git pull origin (__git_current_branch)'
alias gpush='git push origin (__git_current_branch)'
alias gpush!='git push --force-with-lease --force-if-includes origin (__git_current_branch)'

alias printpath='echo $PATH | tr " " "\n"'
alias timestamp='date +%Y%m%d-%H%M%S | tr -d "\n"'

if type -q bat
  alias cat='bat -p'
else if type -q batcat
  alias cat='batcat -p'
end

if type -q eza
  alias ls='eza -g --group-directories-first --time-style=long-iso'
  alias la='ls -la'
  alias ll='ls -l'
  alias tree='eza -T'
end

if type -q safe-rm
  alias rm='safe-rm'
end

# Temporary remove ~/.asdf/shims from path to avoid conflicting with
# python*-config scripts provided by Homebrew.
alias brew='env PATH=(string join : (string match -e "$HOME/.asdf/shims" -v "$PATH")) brew'

# ------------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------------
bind . __expand_double_dots
bind \cr __select_history
bind \cgc __ghq_cd
bind \cg\cv __ghq_code
bind \cg\ca __git_add_files
bind \cg\cb __git_switch_local
bind \cg\cg\cb __git_switch_remote
bind \cg\ch __git_insert_commit
bind \cgs __ssh_connect
bind \ee edit_command_buffer

# ------------------------------------------------------------------------------
# base16-shell
# https://github.com/chriskempson/base16-shell
# ------------------------------------------------------------------------------
set -gx BASE16_SHELL "$HOME/.config/base16-shell/"
source "$BASE16_SHELL/profile_helper.fish"
