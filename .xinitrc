#!/bin/sh

[ -f ~/.Xresources ] && xrdb -load ~/.Xresources &
[ -f ~/.xbindkeysrc ] && xbindkeys &
[ -d ~/.mpd ] && mpd &
rc.d list bluetooth | grep -q STARTED && blueman-applet &
export DE=xfce
exec dbus-launch --exit-with-session awesome
