yap() {
  while getopts "apz" opt; do
    case "$opt" in
      a)
        yay -Sua ;;
      p)
        sudo pacman -Syu ;;
      z)
        yay -R --noconfirm zfs-linux-hardened zfs-linux-hardened-headers
        yay -Sy --noconfirm linux-hardened linux-hardened-headers
        yay -Sy --noconfirm zfs-linux-hardened zfs-linux-hardened-headers
        sudo mkinitcpio -P
        ;;
    esac
  done
}

