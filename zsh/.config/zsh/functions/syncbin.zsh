syncbin() {
    local dir="${1:-$HOME/scripts}"
    [ -z $1 ] && find ~/.local/bin -type l -delete

    for i in $dir/*; do
        ! [ -d "$i" ] && {
            chmod +x $i
            ln -s $i ~/.local/bin
        } || syncbin "$i"
    done
}
