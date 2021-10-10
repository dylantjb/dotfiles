ideapad-cm() {
  case "$1" in
    "on") sudo battmngr -sc 3 ;;
    "off") sudo battmngr -sc 4 ;;
  esac
}
