[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx -- vt1 -ardelay 300 -arinterval 20 &> /dev/null
