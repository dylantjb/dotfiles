flashall() { for i in {boot,system,product,vbmeta}; do fastboot flash "$i" "$i.img"; done; }
