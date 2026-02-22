# ------------------------------------------------------------------------------
# Fish configurations
# ------------------------------------------------------------------------------
# 挨拶メッセージを非表示にする
set -g fish_greeting

# パスの短縮表示を無効にする (prompt_pwd)
set -g fish_prompt_pwd_dir_length 0

# fish_prompt
set -g fish_color_user        brgreen
set -g fish_color_cwd         blue
set -g fish_color_cwd_root    red
set -g fish_color_host        normal
set -g fish_color_host_remote yellow
set -g fish_color_vcs         red
set -g fish_color_time        555
set -g fish_color_status_ok   blue
set -g fish_color_status_ng   red

# fish_git_prompt
set -g __fish_git_prompt_showdirtystate     yes
set -g __fish_git_prompt_showstashstate     yes
set -g __fish_git_prompt_showuntrackedfiles yes
set -g __fish_git_prompt_showupstream       yes

# ------------------------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------------------------
# Shell
set -gx LANG en_US.UTF-8

if type -q nvim
  set -gx EDITOR nvim
else if type -q vim
  set -gx EDITOR vim
end

type -q less && set -gx PAGER less

# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# GPG
set -gx GPG_TTY (tty)

# Go
set -gx GOPATH "$HOME/.go"

# Homebrew
set -gx HOMEBREW_NO_ANALYTICS 1

# ------------------------------------------------------------------------------
# Homebrew
# https://brew.sh/
# ------------------------------------------------------------------------------
# macOS (Apple Silicon)
if test -f /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

# macOS (Intel)
if test -f /usr/local/bin/brew
  eval (/usr/local/bin/brew shellenv)
end

# Linux
if test -f /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# ------------------------------------------------------------------------------
# asdf
# https://github.com/asdf-vm/asdf
# ------------------------------------------------------------------------------
set -gx ASDF_DATA_DIR "$HOME/.asdf"
fish_add_path -m "$ASDF_DATA_DIR/shims"

# ------------------------------------------------------------------------------
# asdf-java
# https://github.com/halcyon/asdf-java
# ------------------------------------------------------------------------------
if not type -q mise; and test -e "$HOME/.asdf/plugins/java/set-java-home.fish"
  source "$HOME/.asdf/plugins/java/set-java-home.fish"
end

# ------------------------------------------------------------------------------
# mise
# https://mise.jdx.dev/
# ------------------------------------------------------------------------------
if type -q mise
  mise activate fish | source
end

# ------------------------------------------------------------------------------
# miniconda
# ------------------------------------------------------------------------------
if set -q HOMEBREW_PREFIX; and test -f "$HOMEBREW_PREFIX/Caskroom/miniconda/base/bin/conda"
  if set -l conda_setup ("$HOMEBREW_PREFIX/Caskroom/miniconda/base/bin/conda" 'shell.fish' 'hook' 2>/dev/null)
    eval $conda_setup
  else if test -f "$HOMEBREW_PREFIX/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    source "$HOMEBREW_PREFIX/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
  else
    fish_add_path -m "$HOMEBREW_PREFIX/Caskroom/miniconda/base/bin"
  end
end

# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------
# Go
fish_add_path -m "$GOPATH/bin"

# Ruby
if set -q HOMEBREW_PREFIX
  fish_add_path -m "$HOMEBREW_PREFIX/opt/ruby/bin"
end

# Java
if set -q HOMEBREW_PREFIX
  fish_add_path -m "$HOMEBREW_PREFIX/opt/openjdk/bin"
end

# PostgreSQL
if set -q HOMEBREW_PREFIX
  fish_add_path -m "$HOMEBREW_PREFIX/opt/postgresql@18/bin"
end

# fvm (Flutter)
fish_add_path -m "$HOME/fvm/default/bin"

# Dart (protoc_plugin etc.)
fish_add_path -m "$HOME/.pub-cache/bin"

# User-specific executable files
fish_add_path -m "$HOME/.local/bin"

# dotfiles
fish_add_path -m "$HOME/dotfiles/bin"

# ------------------------------------------------------------------------------
# Fisher
# https://github.com/jorgebucaran/fisher
# ------------------------------------------------------------------------------
# プラグインのインストール先を変更する
# https://github.com/jorgebucaran/fisher/issues/640
set -g fisher_path ~/dotfiles/.config/fish/fisher

set -g fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set -g fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end

# ------------------------------------------------------------------------------
# direnv
# https://github.com/direnv/direnv
# ------------------------------------------------------------------------------
type -q direnv && direnv hook fish | source

# ------------------------------------------------------------------------------
# bat
# https://github.com/sharkdp/bat
# ------------------------------------------------------------------------------
if type -q bat
  set -gx BAT_THEME base16
  set -gx MANPAGER "sh -c \"col -bx | bat -l man -p --theme='Monokai Extended'\""
end

# ------------------------------------------------------------------------------
# fzf
# https://github.com/junegunn/fzf
# ------------------------------------------------------------------------------
set -gx FZF_DEFAULT_OPTS '
  --ansi --cycle --reverse
  --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:103
  --color info:150,prompt:110,spinner:150,pointer:167,marker:174
'

# ------------------------------------------------------------------------------
# Local configurations
# ------------------------------------------------------------------------------
status is-interactive && source "$__fish_config_dir/interactive.fish"
status is-login && source "$__fish_config_dir/login.fish"
test -r "$HOME/.config.local/fish/config.fish" && source "$HOME/.config.local/fish/config.fish"
