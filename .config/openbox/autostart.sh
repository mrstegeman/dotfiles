. $GLOBALAUTOSTART &

nitrogen --restore &
(sleep 2 && stalonetray) &
sh /home/michael/Programs/scripts/start_conky.sh &
#nm-applet --sm-disable &
blueman-applet &
if [ $? -eq 0 ]; then
    mpd
fi
