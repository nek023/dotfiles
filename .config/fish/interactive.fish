# interactive.fish
# インタラクティブシェルでのみ実行されます

# ------------------------------------------------------------------------------
# abbreviations
# ------------------------------------------------------------------------------
abbr -a -g diff 'diff -u'
abbr -a -g md   'mkdir'
abbr -a -g o    'open'
abbr -a -g rf   'rm -rf'
abbr -a -g rd   'rmdir'

abbr -a -g g    'git'
abbr -a -g ga   'git add'
abbr -a -g gaa  'git add -A'
abbr -a -g gac  'git add -A && git commit'
abbr -a -g gac! 'git add -A && git commit --amend'
abbr -a -g gap  'git add -p'
abbr -a -g gb   'git branch'
abbr -a -g gbm  'git branch -m'
abbr -a -g gco  'git checkout'
abbr -a -g gcp  'git cherry-pick'
abbr -a -g gc   'git commit'
abbr -a -g gc!  'git commit --amend'
abbr -a -g gd   'git diff'
abbr -a -g gds  'git diff --staged'
abbr -a -g gf   'git fetch'
abbr -a -g gm   'git merge'
abbr -a -g gr   'git rebase'
abbr -a -g gri  'git rebase -i'
abbr -a -g grm  'git rebase master'
abbr -a -g greh 'git reset HEAD'
abbr -a -g gre  'git restore'
abbr -a -g gres 'git restore -S'
abbr -a -g gs   'git status'
abbr -a -g gsw  'git switch'
abbr -a -g gsc  'git switch -c'
abbr -a -g gsm  'git switch master'

abbr -a -g be   'bundle exec'
abbr -a -g bi   'bundle install --jobs=4'
abbr -a -g c    'rails c'
abbr -a -g s    'rails s'
abbr -a -g cop  'rubocop'
abbr -a -g copa 'rubocop -a'
abbr -a -g t    'rspec'

abbr -a -g co   'code'
abbr -a -g gg   'ghq get'
abbr -a -g d    'docker'
abbr -a -g dc   'docker-compose'
abbr -a -g tf   'terraform'
abbr -a -g tfw  'terraform workspace'

abbr -a -g brewup 'brew update; brew upgrade; brew cleanup'

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
