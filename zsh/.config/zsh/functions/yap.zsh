yap() {
  while getopts "apz" opt; do
    case "$opt" in
      a)
        yay -Sua ;;
      p)
        sudo pacman -Syu ;;
      z)
        yay -R --noconfirm zfs-linux-lts zfs-linux-lts-headers
        yay -Sy --noconfirm linux-lts linux-lts-headers
        yay -Sy --noconfirm zfs-linux-lts zfs-linux-lts-headers
        sudo mkinitcpio -P
        ;;
    esac
  done
}

