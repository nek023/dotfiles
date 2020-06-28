# interactive.fish
# インタラクティブシェルでのみ実行されます

# ------------------------------------------------------------------------------
# paths
# ------------------------------------------------------------------------------
# /usr/local/sbin (homebrew)
__add_fish_user_path /usr/local/sbin

# go
__add_fish_user_path $GOPATH/bin

# rust
__add_fish_user_path ~/.cargo/bin

# Google Cloud SDK
__add_fish_user_path /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

# dotfiles/bin
__add_fish_user_path ~/dotfiles/bin

# ------------------------------------------------------------------------------
# abbreviations
# ------------------------------------------------------------------------------
abbr -ag diff 'diff -u'
abbr -ag md   'mkdir'
abbr -ag o    'open'
abbr -ag rf   'rm -rf'
abbr -ag rd   'rmdir'

abbr -ag g    'git'
abbr -ag ga   'git add'
abbr -ag gaa  'git add -A'
abbr -ag gac  'git add -A && git commit'
abbr -ag gac! 'git add -A && git commit --amend'
abbr -ag gap  'git add -p'
abbr -ag gb   'git branch'
abbr -ag gbm  'git branch -m'
abbr -ag gco  'git checkout'
abbr -ag gcp  'git cherry-pick'
abbr -ag gc   'git commit'
abbr -ag gc!  'git commit --amend'
abbr -ag gd   'git diff'
abbr -ag gds  'git diff --staged'
abbr -ag gf   'git fetch'
abbr -ag gm   'git merge'
abbr -ag gr   'git rebase'
abbr -ag gri  'git rebase -i'
abbr -ag grm  'git rebase master'
abbr -ag greh 'git reset HEAD'
abbr -ag gre  'git restore'
abbr -ag gres 'git restore -S'
abbr -ag gs   'git status'
abbr -ag gsw  'git switch'
abbr -ag gsc  'git switch -c'
abbr -ag gsm  'git switch master'

abbr -ag be   'bundle exec'
abbr -ag bi   'bundle install'
abbr -ag c    'rails c'
abbr -ag s    'rails s'
abbr -ag cop  'rubocop'
abbr -ag copa 'rubocop -a'
abbr -ag t    'rspec'

abbr -ag co   'code'
abbr -ag gg   'ghq get'
abbr -ag d    'docker'
abbr -ag dc   'docker-compose'
abbr -ag tf   'terraform'
abbr -ag tfw  'terraform workspace'

abbr -ag brewup 'brew update; brew upgrade; brew cleanup'

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

if type -aq exa
    alias ls='exa -g --time-style long-iso'
    alias la='ls -la'
    alias ll='ls -l'
    alias tree='exa -T'
end

# ------------------------------------------------------------------------------
# key bindings
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

bind \cg\ca __git_add_files

# ------------------------------------------------------------------------------
# base16-shell
# https://github.com/chriskempson/base16-shell
# ------------------------------------------------------------------------------
# https://github.com/chriskempson/base16-shell/blob/master/profile_helper.fish
if test -e ~/.base16_theme
  set -l SCRIPT_NAME (basename (realpath ~/.base16_theme) .sh)
  set -gx BASE16_THEME (string match 'base16-*' $SCRIPT_NAME | string sub -s (string length 'base16-*'))
  eval sh '"'(realpath ~/.base16_theme)'"'
end

# ------------------------------------------------------------------------------
# direnv
# https://github.com/direnv/direnv
# ------------------------------------------------------------------------------
type -aq direnv && eval (direnv hook fish)

# workaround for https://github.com/direnv/direnv/issues/583
function __direnv_export_eval_on_prompt --on-event fish_prompt
    type -aq direnv && eval (direnv export fish)
end

# ------------------------------------------------------------------------------
# tmux
# https://github.com/tmux/tmux
# ------------------------------------------------------------------------------
function __tmux_rename_window --on-event fish_prompt
    __tmux_is_running || return
    set -l window_id (tmux list-panes -a -F "#{pane_pid} #{window_id}" | grep $fish_pid | cut -d ' ' -f 2)
    test -n "$window_id" && tmux rename-window -t "$window_id" (__workdir)
end
