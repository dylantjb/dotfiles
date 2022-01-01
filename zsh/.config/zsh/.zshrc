#!/bin/zsh
# vim:fileencoding=utf-8:ft=conf:foldmethod=marker
#          __
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#
#

# Urgent {{{
autoload -Uz +X compinit colors
colors && compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/instant-zsh.zsh" ] && source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/instant-zsh.zsh"
instant-zsh-pre "%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%}] %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%}➜ )%{$fg[cyan]%}%c%{$reset_color%} "
# }}}

# Options {{{
setopt auto_cd extendedglob nomatch menucomplete

# History
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
# }}}

# Plugins {{{
declare -A ZINIT
ZINIT[HOME_DIR]=${XDG_DATA_HOME:-$HOME/.local/share}/zinit
ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
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
alias syncorg='syncfiles ~/documents/gtd nextcloud:Org'
alias playlist-dl='youtube-dl --extract-audio --audio-format mp3 -w4 -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias stowit='stow -vt ~'
alias unstow='stow -Dvt ~'
alias abook='abook --datafile "${XDG_DATA_HOME:-$HOME/.local/share}/abook/addressbook"'
alias smake='rm -f "config.h" && make'
alias monerod='monerod --config-file "${XDG_CONFIG_HOME:-$HOME/.config}"/bitmonero/bitmonero.conf'
alias transmission-cli='transmission-cli -w ~/.local/share/transmission'
alias mg='em -s "term" -cte "(progn (magit-status) (delete-other-windows))"'
alias em='~/.local/bin/scripts/em -s "term" -t -a ""'
alias wget='wget --hsts-file="${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"'
[ "$(uname -n)" = "arch" ] && {
  alias y='yay -Sy'
  alias yr='yay -Rns'
  alias snapshots='zfs list -t snapshot -S creation $(df --output=source ~ | tail -n +2)'
  alias debloat="sudo pacman -Rns $(pacman -Qdtq | tr '\r\n' ' ') 2>/dev/null || echo 'No packages to debloat'"
}

alias zrc='${EDITOR:-nvim} "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"'
alias zfc='find "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions/" -type f | fzf | xargs -0 ${EDITOR:-nvim}'

alias q=exit
alias rm='rm -i'
alias cp='cp -i'
alias jc='journalctl -xe'
alias sc=systemctl
alias ssc='sudo systemctl'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias c='xclip -selection clipboard -in'
alias ls='LC_COLLATE=C ls --group-directories-first --color'
alias ll='ls -l'
alias la='ls -A'
alias grep='grep --color'
alias lg=lazygit
alias degit='rm -rf .git*'
alias tempmail='ssh -t dylan@dylantjb.com "~/.local/bin/tempmail"'
#: }}}

# Functions {{{
for i in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions/*; do
    source "$i"
done
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

# History {{{
HISTSIZE=50000
SAVEHIST=10000

bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up

instant-zsh-post
#: }}}

