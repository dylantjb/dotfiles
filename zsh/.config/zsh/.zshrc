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
[ -f "$XDG_CACHE_HOME/zinit/instant-zsh.zsh" ] && source "$XDG_CACHE_HOME/zinit/instant-zsh.zsh"
instant-zsh-pre "%B%{$fg[blue]%}[%{$fg[white]%}%n%{$fg[red]%}@%{$fg[white]%}%m%{$fg[blue]%}] %(?:%{$fg_bold[green]%} :%{$fg_bold[red]%}➜ )%{$fg[cyan]%}%c%{$reset_color%} "

setopt auto_cd extendedglob nomatch menucomplete interactive_comments
unsetopt BEEP
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zinit/zcompcache"
zle_highlight=('paste:none')
fpath=($XDG_CONFIG_HOME/zsh/functions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
stty stop undef
zmodload zsh/complist
_comp_options+=(globdots)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
compinit -d "$XDG_CACHE_HOME/zinit/zcompdump-$ZSH_VERSION"
# }}}

# History {{{
export HISTFILE="$XDG_STATE_HOME/zsh/history"
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
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zinit/zcompdump-$ZSH_VERSION
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
alias ng='[ -d ".git" ] && nvim +Neogit || echo "fatal: not a git repository (or any of the parent directories): .git"'
alias nn='nncli -c ~/Library/Preferences/nncli'
alias sbt='sbt -ivy "$XDG_DATA_HOME"/ivy2 -sbt-dir "$XDG_DATA_HOME"/sbt'
alias python=python3
alias playlist-dl='youtube-dl --extract-audio --audio-format mp3 -w4 -o "%(playlist_index)s - %(title)s.%(ext)s"'
alias stowit='stow -vt ~'
alias sudoedit='sudo -e'
alias unstow='stow -Dvt ~'
alias abook='abook --datafile "$XDG_DATA_HOME/abook/addressbook"'
alias ykoath='ykman oath accounts'
alias monerod='monerod --config-file "$XDG_CONFIG_HOME"/bitmonero/bitmonero.conf'
alias transmission-cli='transmission-cli -w $HOME/Downloads'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

alias zrc='$EDITOR "$XDG_CONFIG_HOME/zsh/.zshrc"'
alias zpc='$EDITOR "$XDG_CONFIG_HOME/zsh/zprofile"'
alias zfc='find "$XDG_CONFIG_HOME/zsh/functions/" -type f | fzf | xargs -r $EDITOR'

alias q=exit
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias ls='LC_COLLATE=C ls --group-directories-first --color -I ".DS_Store" -I "\$RECYCLE.BIN" -I "desktop.ini" -I ".localized" -I ".userchain"'
alias ll='ls -l'
alias la='ls -A'
alias grep='grep --color'
alias lg=lazygit
alias degit='rm -rf .git*'
alias rmmail='ssh -p 64 -t dylan@dylantjb.com "~/.local/bin/rmmail"'
alias mkmail='ssh -p 64 -t dylan@dylantjb.com "~/.local/bin/mkmail"'
alias lsmail='ssh -p 64 -t dylan@dylantjb.com "~/.local/bin/catmail"'
alias newmail='ssh -p 64 -t dylan@dylantjb.com "sudoedit /etc/aliases; sudo newaliases"'
#: }}}

# Functions {{{
autoload -Uz $XDG_CONFIG_HOME/zsh/functions/*
for i in $XDG_CONFIG_HOME/zsh/functions/*; do
  source "$i"
done

compdef mkcd=mkdir
compdef rcp=rsync
alias rcpd='rcp --delete --delete-after'
alias rcpu='rcp --chmod=go='
alias rcpdu='rcpd --chmod=go='
bindkey -s '^o' 'rr\n'

# Change cursor shape for different vi modes.
zle-keymap-select () {
  case $KEYMAP in
    vicmd) echo -ne '\e[2 q';;      # block
    viins|main) echo -ne '\e[6 q';; # beam
  esac
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins
  echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}
#: }}}

# Exports {{{
export CASE_SENSITIVE='true'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
export AUTOSWITCH_VIRTUAL_ENV_DIR="$WORKON_HOME"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export KEYTIMEOUT=1
export MANPAGER='nvim +Man!'
export MANWIDTH=999
# }}}

! pgrep -qx gpg-agent && gpg-agent --daemon > /dev/null
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

instant-zsh-post


