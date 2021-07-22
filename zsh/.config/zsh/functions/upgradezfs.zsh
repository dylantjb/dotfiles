upgradezfs() {
  yay -R --noconfirm zfs-linux zfs-linux-headers
  yay -Sy --noconfirm linux linux-headers
  yay -Sy --noconfirm zfs-linux zfs-linux-headers
  sudo mkinitcpio -P
}
