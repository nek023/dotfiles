# interactive.fish
# インタラクティブシェルでのみ実行されます

# ------------------------------------------------------------------------------
# abbreviations
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
abbr -a gbm  'git branch -m'
abbr -a gco  'git checkout'
abbr -a gcp  'git cherry-pick'
abbr -a gc   'git commit'
abbr -a gc!  'git commit --amend'
abbr -a gd   'git diff'
abbr -a gds  'git diff --staged'
abbr -a gf   'git fetch'
abbr -a gm   'git merge'
abbr -a gr   'git rebase'
abbr -a gri  'git rebase -i'
abbr -a grm  'git rebase master'
abbr -a greh 'git reset HEAD'
abbr -a gre  'git restore'
abbr -a gres 'git restore -S'
abbr -a gs   'git status'
abbr -a gsw  'git switch'
abbr -a gsc  'git switch -c'
abbr -a gsm  'git switch master'

abbr -a be   'bundle exec'
abbr -a bi   'bundle install --jobs=4'
abbr -a c    'rails c'
abbr -a s    'rails s'
abbr -a cop  'rubocop'
abbr -a copa 'rubocop -a'
abbr -a t    'rspec'

abbr -a co   'code'
abbr -a gg   'ghq get'
abbr -a d    'docker'
abbr -a dc   'docker-compose'
abbr -a tf   'terraform'
abbr -a tfw  'terraform workspace'

abbr -a brewup 'brew update; brew upgrade; brew cleanup'

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
if test -d $HOME/.config/base16-shell
    set BASE16_SHELL $HOME/.config/base16-shell
    source "$BASE16_SHELL/profile_helper.fish"
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
    if __tmux_is_running
        set -l fish_ppid (ps -o ppid= -p $fish_pid | tr -d ' ')
        set -l window_id (tmux list-panes -a -F "#{pane_pid} #{window_id}" | grep $fish_ppid | cut -d ' ' -f 2)
        test -n "$window_id" && tmux rename-window -t $window_id (__workdir)
    end
end
