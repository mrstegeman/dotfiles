#!/bin/bash

xmodmap ~/.Xmodmap &
xbindkeys &
/home/michael/git/nullfs/nul1fs /home/michael/.Skype/Logs &
#sh /home/michael/bin/start_conky.sh &
nm-applet --sm-disable &
blueman-applet &
mpd &
feh --bg-tile /home/michael/wallpapers/current.jpg
conky | while read -r conky_out; do wmfs -s "$conky_out"; done
