#!/bin/zsh
# vim:fileencoding=utf-8:ft=conf:foldmethod=marker
#          __
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#
#

#: Urgent {{{
autoload -Uz compinit colors
compinit && colors

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

#: Options {{{
# History
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

setopt auto_cd extendedglob nomatch menucomplete
# }}}

#: Plugins {{{
declare -A ZINIT
ZINIT[HOME_DIR]=${XDG_DATA_HOME:-$HOME/.local/share}/zinit
ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME:-$HOME/.cache}/zinit/zcompdump
ZINIT[BIN_DIR]=${ZINIT[HOME_DIR]}/bin
ZINIT[PLUGINS_DIR]=${ZINIT[HOME_DIR]}/plugins
ZINIT[COMPLETIONS_DIR]=${ZINIT[HOME_DIR]}/completions
ZINIT[SNIPPETS_DIR]=${ZINIT[HOME_DIR]}/snippets
ZINIT[SERVICES_DIR]=${ZINIT[HOME_DIR]}/services

if [ ! -d "${ZINIT[HOME_DIR]}" ]; then
    mkdir -p "${ZINIT[HOME_DIR]}" 
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${ZINIT[HOME_DIR]}" && command chmod g-rwX "${ZINIT[HOME_DIR]}"
    command git clone https://github.com/zdharma/zinit "${ZINIT[BIN_DIR]}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
else
    source "${ZINIT[BIN_DIR]}/zinit.zsh"
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/p10k/config.zsh ]] && source $HOME/.config/p10k/config.zsh

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
       zdharma/fast-syntax-highlighting \
    blockf \
       zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
       zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-history-substring-search

zinit ice silent wait"0"
zinit light Aloxaf/fzf-tab

zinit ice wait"0" lucid pick"zsh-system-clipboard.zsh"
zinit light kutsan/zsh-system-clipboard

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit light zdharma/zsh-diff-so-fancy

zinit ice wait"2" silent
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
#: }}}

#: COLORS {{{
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps xo pid,user:10,cmd | ack-grep -v "sshd:|-zsh$"'
# }}}

#: Aliases {{{
alias upgrade="yay -Syyu"
alias debloat="sudo pacman -Rns $(pacman -Qdtq | tr '\r\n' ' ')"
alias degit="rm -rf .git*"
alias vimdiff="$EDITOR -d"
alias nvim="lvim"
alias stowit="stow -vt ~"
alias unstow="stow -Dvt ~"
alias darkmode="xrdb "$XDG_CONFIG_HOME/x11/xresources" && xdotool key Shift_L+Super_L+Delete"
alias wget="wget --hsts-file="$XDG_CACHE_HOME/wget-hsts""
alias y="yay -Sy"
alias abook="abook --datafile "$XDG_DATA_HOME/abook/addressbook""
alias yr="yay -Rns"
alias p="sudo pacman -Sy"

alias zrc="$EDITOR "$XDG_CONFIG_HOME/zsh/.zshrc""
alias zfc="find "$XDG_CONFIG_HOME/zsh/functions/" -type f | fzf | xargs -r $EDITOR"
alias slockrc="$EDITOR ~/repos/slock/config.h"
alias blockrc="$EDITOR ~/repos/dwmblocks/config.h"
alias dwlrc="$EDITOR ~/repos/dwl/config.h"
alias dwmrc="$EDITOR ~/repos/dwm/config.h"
alias dmenurc="$EDITOR ~/repos/dmenu/config.h"
alias strc="$EDITOR ~/repos/st/config.h"

alias lg='lazygit'
alias ls="exa -a --group-directories-first"
alias mkdir="mkdir -p"
alias ll="ls -l"
alias grep="rg"
#: }}}

#: Exports {{{
export CASE_SENSITIVE='true'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
export POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
export AUTOSWITCH_VIRTUAL_ENV_DIR="$WORKON_HOME"
export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
export ZVM_KEYTIMEOUT=0.005
export ZVM_ESCAPE_KEYTIMEOUT=0.005
# }}}

#: Functions {{{
for i in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions/*; do
    source "$i"
done
#: }}}

#: History {{{
HISTSIZE=50000
SAVEHIST=10000

bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
#: }}}

