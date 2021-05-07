syncbin() {
    local dir="${1:-$HOME/scripts}"
    [ -z $1 ] && { rm -r ~/bin; mkdir bin }

    for i in $dir/*; do
        ! [ -d "$i" ] && {
            chmod +x $i
            ln -s $i ~/bin
        } || syncbin "$i"
    done
}
