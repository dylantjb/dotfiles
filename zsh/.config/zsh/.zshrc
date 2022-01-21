#!/bin/zsh
# vim:fileencoding=utf-8:ft=conf:foldmethod=marker
#          __
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#
#

# Options {{{
autoload -Uz compinit colors && colors
[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/zinit/instant-zsh.zsh" ] && source "${XDG_CACHE_HOME:-$HOME/.cache}/zinit/instant-zsh.zsh"
instant-zsh-pre "%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%}] %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%}➜ )%{$fg[cyan]%}%c%{$reset_color%} "

setopt auto_cd extendedglob nomatch menucomplete interactive_comments
unsetopt BEEP
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zinit/zcompcache"
zle_highlight=('paste:none')
fpath=(${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions $(brew --prefix)/share/zsh/site-functions $fpath)
stty stop undef
zmodload zsh/complist
_comp_options+=(globdots)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zinit/zcompdump-$ZSH_VERSION"
# }}}

# History {{{
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

HISTSIZE=50000
SAVEHIST=10000

bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
# }}}

# Plugins {{{
declare -A ZINIT
ZINIT[HOME_DIR]=${XDG_DATA_HOME:-$HOME/.local/share}/zinit
ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME:-$HOME/.cache}/zinit/zcompdump-$ZSH_VERSION
ZINIT[BIN_DIR]=${ZINIT[HOME_DIR]}/bin
ZINIT[PLUGINS_DIR]=${ZINIT[HOME_DIR]}/plugins
ZINIT[COMPLETIONS_DIR]=${ZINIT[HOME_DIR]}/completions
ZINIT[SNIPPETS_DIR]=${ZINIT[HOME_DIR]}/snippets
ZINIT[SERVICES_DIR]=${ZINIT[HOME_DIR]}/services

[ -f "$HOME/.config/zsh/prompt.zsh" ] && source "$HOME/.config/zsh/prompt.zsh"

if [ ! -d "${ZINIT[HOME_DIR]}" ]; then
    mkdir -p "${ZINIT[HOME_DIR]}" 
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${ZINIT[HOME_DIR]}" && command chmod g-rwX "${ZINIT[HOME_DIR]}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT[BIN_DIR]}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
else
    source "${ZINIT[BIN_DIR]}/zinit.zsh"
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
       zdharma-continuum/fast-syntax-highlighting \
    blockf \
       zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
       zsh-users/zsh-autosuggestions

# zinit ice silent wait'!'
zinit light zsh-users/zsh-history-substring-search

zinit ice sijent wait"0"
zinit light Aloxaf/fzf-tab

zinit ice wait"0" lucid pick"zsh-system-clipboard.zsh"
zinit light kutsan/zsh-system-clipboard

zinit ice wait"2" silent
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
#: }}}

# Aliases {{{
alias nb='newsboat'
alias playlist-dl='youtube-dl --extract-audio --audio-format mp3 -w4 -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias stowit='stow -vt ~'
alias unstow='stow -Dvt ~'
alias abook='abook --datafile "${XDG_DATA_HOME:-$HOME/.local/share}/abook/addressbook"'
alias monerod='monerod --config-file "${XDG_CONFIG_HOME:-$HOME/.config}"/bitmonero/bitmonero.conf'
alias transmission-cli='transmission-cli -w "${XDG_DATA_HOME:-$HOME/.local/share}/transmission"'
alias wget='wget --hsts-file="${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"'

alias zrc='${EDITOR:-nvim} "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"'
alias zfc='find "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions/" -type f | fzf | xargs -r ${EDITOR:-nvim}'

alias q=exit
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias ls='LC_COLLATE=C ls --group-directories-first --color'
alias ll='ls -l'
alias la='ls -A'
alias grep='grep --color'
alias lg=lazygit
alias degit='rm -rf .git*'
alias tempmail='ssh -t dylan@dylantjb.com "~/.local/bin/tempmail"'
#: }}}

# Functions {{{
autoload -Uz ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/autoload/*
for i in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions/*; do
  source "$i"
done

# Change cursor shape for different vi modes.
zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
#: }}}

# Exports {{{
export CASE_SENSITIVE='true'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
export AUTOSWITCH_VIRTUAL_ENV_DIR="${WORKON_HOME:-$HOME/.local/share/virtualenvs}"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export KEYTIMEOUT=1
export MANPAGER='nvim +Man!'
export MANWIDTH=999
# }}}

instant-zsh-post

