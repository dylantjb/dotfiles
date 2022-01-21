rcp() {
    rsync -azPJ \
    --include=.git/ \
    --filter=':- .gitignore' \
    --filter=":- $XDG_CONFIG_HOME/git/ignore" \
    "$@"
}; compdef rcp=rsync

alias rcpd='rcp --delete --delete-after'
alias rcpu='rcp --chmod=go='
alias rcpdu='rcpd --chmod=go='
