#!/bin/bash

xbindkeys &
/home/michael/git/nullfs/nul1fs /home/michael/.Skype/Logs &
blueman-applet &
mpd &
feh --bg-tile /home/michael/wallpapers/current.jpg
twmnd &
conky | while read -r conky_out; do wmfs -s "$conky_out"; done
