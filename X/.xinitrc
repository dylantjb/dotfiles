#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#: Sourcing {{{
. ~/.xprofile
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
#: }}}

#: Exports {{{
export DISPLAY=:0
export BROWSER=qutebrowser
export TERMINAL=/usr/local/bin/st
export QT_QPA_PLATFORMTHEME=qt5ct
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_SCREENSHOTS_DIR=~/Pictures/screenshots/
#: }}}

while true; do
    ssh-agent dwm 2> ~/.dwm.log
done
