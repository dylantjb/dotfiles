texedit() {
  st -e zathura "${1%.*}.pdf" &
  nvim $1
}
