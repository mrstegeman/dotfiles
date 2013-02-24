#!/bin/sh

# test for an existing bus daemon, just to be safe
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    # if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi

export DE=xfce
[ -f ~/.Xresources ] && xrdb -load ~/.Xresources &
[ -f ~/.xbindkeysrc ] && xbindkeys &
[ -d ~/.mpd ] && mpd &
systemctl status bluetooth.service | grep -q 'Active: active' && blueman-applet &
nm-applet --sm-disable &
start-pulseaudio-x11 &
gmixer -d &
exec awesome
