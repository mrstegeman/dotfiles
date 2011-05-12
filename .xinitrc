#!/bin/sh

xmodmap ~/.Xmodmap &
xbindkeys &
xscreensaver -no-splash &
export DE=xfce
exec ck-launch-session dbus-launch openbox-session
