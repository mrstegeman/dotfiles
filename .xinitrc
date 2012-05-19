#!/bin/sh

[ -f ~/.Xresources ] && xrdb -load ~/.Xresources &
[ -f ~/.xbindkeysrc ] && xbindkeys &
[ -d ~/.Skype/Logs ] && /home/michael/git/nullfs/nul1fs /home/michael/.Skype/Logs &
[ -d ~/.mpd ] && mpd &
rc.d list bluetooth | grep -q STARTED && blueman-applet &
export DE=xfce
exec dbus-launch --exit-with-session awesome
