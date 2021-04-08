m() {
    /usr/bin/man $1 | nvim -c "set ft=man" -
}
