# ------------------------------------------------------------------------------
# Zsh configurations
# ------------------------------------------------------------------------------
# Set editor default keymap to emacs (`-e`) or vi (`-v`).
bindkey -e

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# ------------------------------------------------------------------------------
# Environment variables
# ------------------------------------------------------------------------------
# Shell
export LANG=en_US.UTF-8

if (( ${+commands[vim]} )); then
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

# Zim
export ZIM_HOME="${ZDOTDIR:-${HOME}}/.zim"

# GPG
export GPG_TTY="$(tty)"

# Go
export GOPATH="${HOME}/.go"

# ------------------------------------------------------------------------------
# Homebrew
# https://brew.sh/
# ------------------------------------------------------------------------------
# Apple Silicon
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# Intel
if [[ -f /usr/local/bin/brew ]]; then
  eval $(/usr/local/bin/brew shellenv)
fi

# ------------------------------------------------------------------------------
# asdf
# https://github.com/asdf-vm/asdf
# ------------------------------------------------------------------------------
if (( ${+commands[asdf]} )); then
  source "$(brew --prefix asdf)/asdf.sh"
fi

# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------
# Go
export PATH="${GOPATH}/bin:${PATH}"

# dotfiles
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
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# Specifies how suggestions should be generated.
# At first chooses the most recent match from history, then cxhooses a suggestion.
typeset -ga ZSH_AUTOSUGGEST_STRATEGY
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ------------------------------------------------------------------------------
# Initialize modules
# ------------------------------------------------------------------------------
# Download zimfw plugin manager if missing.
if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-${HOME}}/.zimrc" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"

# ------------------------------------------------------------------------------
# Post-init module configurations
# ------------------------------------------------------------------------------
# Unset NO_CLOBBER set by environment module.
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
alias gpush!='git push --force-with-lease origin $(git-current-branch)'

alias printpath='echo $PATH | tr ":" "\n"'
alias timestamp='date +%Y%m%d-%H%M%S | tr -d "\n"'

if (( ${+commands[bat]} )); then
  alias cat='bat -p'
fi

if (( ${+commands[exa]} )); then
  alias ls='exa -g --group-directories-first --time-style=long-iso'
  alias la='ls -la'
  alias ll='ls -l'
  alias tree='exa -T'
fi

if (( ${+commands[safe-rm]} )); then
  alias rm='safe-rm'
fi

# Temporary remove ~/.asdf/shims from path to avoid conflicting with
# python*-config scripts provided by Homebrew.
alias brew='PATH=$(echo $PATH | sed -e "s|${HOME}/.asdf/shims:||g") brew'

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
  eval "$("${BASE16_SHELL}/profile_helper.sh")"
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
add-zsh-hook precmd tmux-rename-window

# ------------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------------
zle -N select-history
bindkey '^r' select-history

zle -N ghq-cd
bindkey '^gc' ghq-cd

zle -N git-add-files
bindkey '^g^a' git-add-files

zle -N git-switch-local
bindkey '^g^b' git-switch-local

zle -N git-switch-remote
bindkey '^g^g^b' git-switch-remote

zle -N git-insert-commit
bindkey '^g^h' git-insert-commit

# ------------------------------------------------------------------------------
# Local configurations
# ------------------------------------------------------------------------------
if [[ -f "${HOME}/.config.local/zsh/.zshrc" ]]; then
  source "${HOME}/.config.local/zsh/.zshrc"
fi
