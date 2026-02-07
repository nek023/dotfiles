# ------------------------------------------------------------------------------
# Zsh configurations
# ------------------------------------------------------------------------------
# Set editor default keymap to emacs (`-e`) or vi (`-v`).
bindkey -e

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# ------------------------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------------------------
# Shell
export LANG=en_US.UTF-8

if (( ${+commands[nvim]} )); then
  export EDITOR=nvim
elif (( ${+commands[vim]} )); then
  export EDITOR=vim
fi

if (( ${+commands[less]} )); then
  export PAGER=less
fi

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# GPG
export GPG_TTY="$(tty)"

# Go
export GOPATH="${HOME}/.go"

# Homebrew
export HOMEBREW_NO_ANALYTICS=1

# ------------------------------------------------------------------------------
# Homebrew
# https://brew.sh/
# ------------------------------------------------------------------------------
# macOS
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# Linux
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------
setopt prompt_subst

PROMPT='
%(3L.%F{yellow}(%L)%f .)%(!.%F{red}%n%f.${SSH_TTY:+"%F{yellow}%n%f"})${SSH_TTY:+"@%F{green}%m%f:"}%F{cyan}%~%f%F{red}$(git-info)%f${duration_info}
%(1j.%F{blue}*%f .)%(?.%F{green}.%F{red}%? )%(!.#.$)%f '

# ------------------------------------------------------------------------------
# Git
# ------------------------------------------------------------------------------
if [ -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh" ]; then
  # macOS
  source "${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh"
elif [ -f /etc/bash_completion.d/git-prompt ]; then
  # Linux
  source /etc/bash_completion.d/git-prompt
fi

# ------------------------------------------------------------------------------
# Go
# ------------------------------------------------------------------------------
export PATH="${GOPATH}/bin:${PATH}"

# ------------------------------------------------------------------------------
# Ruby
# ------------------------------------------------------------------------------
export PATH="${HOMEBREW_PREFIX}/opt/ruby/bin:${PATH}"

# ------------------------------------------------------------------------------
# Java
# ------------------------------------------------------------------------------
export PATH="${HOMEBREW_PREFIX}/opt/openjdk/bin:${PATH}"

# ------------------------------------------------------------------------------
# asdf
# https://github.com/asdf-vm/asdf
# ------------------------------------------------------------------------------
export ASDF_DATA_DIR="${HOME}/.asdf"
export PATH="${ASDF_DATA_DIR}/shims:${PATH}"

# ------------------------------------------------------------------------------
# asdf-java
# https://github.com/halcyon/asdf-java
# ------------------------------------------------------------------------------
if (( ! ${+commands[mise]} )) && [[ -e "${HOME}/.asdf/plugins/java" ]]; then
  source "${HOME}/.asdf/plugins/java/set-java-home.zsh"
fi

# ------------------------------------------------------------------------------
# mise
# https://mise.jdx.dev/
# ------------------------------------------------------------------------------
if (( ${+commands[mise]} )); then
  eval "$(mise activate zsh)"
fi

# ------------------------------------------------------------------------------
# miniconda
# ------------------------------------------------------------------------------
__conda_setup="$("${HOMEBREW_PREFIX}/Caskroom/miniconda/base/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "${HOMEBREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
    . "${HOMEBREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
  else
    export PATH="${HOMEBREW_PREFIX}/Caskroom/miniconda/base/bin:${PATH}"
  fi
fi
unset __conda_setup

# ------------------------------------------------------------------------------
# fvm
# ------------------------------------------------------------------------------
# Add path for Flutter installed by `fvm global`
export PATH="${HOME}/fvm/default/bin:${PATH}"

# Add path for Dart bins, especially for protoc_plugin
# https://pub.dev/packages/protoc_plugin
export PATH="${HOME}/.pub-cache/bin:${PATH}"

# ------------------------------------------------------------------------------
# PostgreSQL
# ------------------------------------------------------------------------------
export PATH="${HOMEBREW_PREFIX}/opt/postgresql@18/bin:${PATH}"

# ------------------------------------------------------------------------------
# User-specific executable files
# ------------------------------------------------------------------------------
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/dotfiles/bin:${PATH}"

# ------------------------------------------------------------------------------
# Module configurations
# ------------------------------------------------------------------------------
# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# Specifies how suggestions should be generated.
# At first chooses the most recent match from history, then cxhooses a suggestion.
typeset -ga ZSH_AUTOSUGGEST_STRATEGY
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ------------------------------------------------------------------------------
# Zim
# ------------------------------------------------------------------------------
export ZIM_HOME="${ZDOTDIR:-${HOME}}/.zim"

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source "${HOMEBREW_PREFIX}/opt/zimfw/share/zimfw.zsh" init
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"

# ------------------------------------------------------------------------------
# Post-init module configurations
# ------------------------------------------------------------------------------
# Allow redirection to overwrite existing files.
unsetopt NO_CLOBBER

# Exact match takes precedence.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init.
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# ------------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------------
# Buildpacks
if (( ${+commands[pack]} )); then
  source $(pack completion --shell zsh)
fi

# fvm
if [ -f "${XDG_CONFIG_HOME}/.dart-cli-completion/zsh-config.zsh" ]; then
  . "${XDG_CONFIG_HOME}/.dart-cli-completion/zsh-config.zsh"
fi

# kubectl
if (( ${+commands[kubectl]} )); then
  source <(kubectl completion zsh)
fi

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
alias la='ls -lAh'
alias ll='ls -lh'
alias diff='diff -u'
alias grep='command grep -v grep | command grep --color=auto'

alias gc!='git commit --amend'
alias gac!='git add -A && git commit --amend'
alias gl='git log --graph --all --color --pretty=format:"%h %cn %s%Cred%d%Creset"'
alias gpull='git pull origin $(git-current-branch)'
alias gpush='git push origin $(git-current-branch)'
alias gpush!='git push --force-with-lease --force-if-includes origin $(git-current-branch)'

alias printpath='echo $PATH | tr ":" "\n"'
alias timestamp='date +%Y%m%d-%H%M%S | tr -d "\n"'

if (( ${+commands[bat]} )); then
  alias cat='bat -p'
elif (( ${+commands[batcat]} )); then
  alias cat='batcat -p'
fi

if (( ${+commands[eza]} )); then
  alias ls='eza -g --group-directories-first --time-style=long-iso'
  alias la='ls -la'
  alias ll='ls -l'
  alias tree='eza -T'
fi

if (( ${+commands[safe-rm]} )); then
  alias rm='safe-rm'
fi

# ------------------------------------------------------------------------------
# direnv
# https://github.com/direnv/direnv
# ------------------------------------------------------------------------------
if (( ${+commands[direnv]} )); then
  eval "$(direnv hook zsh)"
fi

# ------------------------------------------------------------------------------
# bat
# https://github.com/sharkdp/bat
# ------------------------------------------------------------------------------
if (( ${+commands[bat]} )); then
  export BAT_THEME=base16
  export MANPAGER='sh -c "col -bx | bat -l man -p --theme=\"Monokai Extended\""'
fi

# ------------------------------------------------------------------------------
# fzf
# https://github.com/junegunn/fzf
# ------------------------------------------------------------------------------
export FZF_DEFAULT_OPTS='
  --ansi --cycle --reverse
  --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:103
  --color info:150,prompt:110,spinner:150,pointer:167,marker:174
'

# ------------------------------------------------------------------------------
# base16-shell
# https://github.com/chriskempson/base16-shell
# ------------------------------------------------------------------------------
export BASE16_SHELL="${XDG_CONFIG_HOME}/base16-shell"

if [[ -n "${PS1}" && -s "${BASE16_SHELL}/profile_helper.sh" ]]; then
  source "${BASE16_SHELL}/profile_helper.sh"
fi

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------
export FPATH="${ZDOTDIR}/functions:${FPATH}"

for file in "${ZDOTDIR}"/functions/*; do
  autoload $(basename "${file}")
done

# ------------------------------------------------------------------------------
# Hooks
# ------------------------------------------------------------------------------
autoload -Uz add-zsh-hook

# duration-info
if (( ${+functions[duration-info-preexec]} && ${+functions[duration-info-precmd]} )); then
  zstyle ':zim:duration-info' format ' %F{yellow}(%d)%f'
  zstyle ':zim:duration-info' threshold 0.5
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi

add-zsh-hook precmd tmux-rename-window

# ------------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------------
zle -N select-history
bindkey '^r' select-history

zle -N ghq-cd
bindkey '^gc' ghq-cd

zle -N ghq-code
bindkey '^g^v' ghq-code

zle -N git-add-files
bindkey '^g^a' git-add-files

zle -N git-switch-local
bindkey '^g^b' git-switch-local

zle -N git-switch-remote
bindkey '^g^g^b' git-switch-remote

zle -N git-insert-commit
bindkey '^g^h' git-insert-commit

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line

zle -N replace-command-line
bindkey '^[r' replace-command-line

# ------------------------------------------------------------------------------
# Local configurations
# ------------------------------------------------------------------------------
if [[ -f "${HOME}/.config.local/zsh/.zshrc" ]]; then
  source "${HOME}/.config.local/zsh/.zshrc"
fi
