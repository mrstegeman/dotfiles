#!/bin/sh

export DE=xfce
[ -f ~/.Xresources ] && xrdb -load ~/.Xresources &
[ -f ~/.xbindkeysrc ] && xbindkeys &
[ -d ~/.mpd ] && mpd &
systemctl status bluetooth.service | grep -q 'Active: active' && blueman-applet &
start-pulseaudio-x11 &
exec dbus-launch --exit-with-session awesome
