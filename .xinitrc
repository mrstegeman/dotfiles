#!/bin/sh

[ -f ~/.Xresources ] && xrdb -load ~/.Xresources &
[ -f ~/.xbindkeysrc ] && xbindkeys &
[ -d ~/.mpd ] && mpd &
systemctl status bluetooth.service | grep -q 'Active: active' && blueman-applet &
export DE=xfce
exec dbus-launch --exit-with-session awesome
