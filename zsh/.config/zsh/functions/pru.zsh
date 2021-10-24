pru() {
  while getopts "apz" opt; do
    case "$opt" in
      a) paru -Sua ;;
      p) sudo pacman -Syu ;;
      z) 
        INST_LINVAR=$(sed 's|.*linux|linux|' /proc/cmdline | sed 's|.img||g' | awk '{ print $1 }')
        sudo pacman -Sy --needed --noconfirm "$INST_LINVAR" "$INST_LINVAR"-headers zfs-"$INST_LINVAR" zfs-utils ;;
      *) echo "Try 'yap --help' for more information." && break ;;
    esac
  done
}

