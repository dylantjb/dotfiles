emacs() {
  [ "$1" ] && opt=$1 || opt="-t"
  emacsclient -a "$EDITOR" "$opt"
}
