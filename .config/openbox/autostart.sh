. $GLOBALAUTOSTART &

nitrogen --restore &
(sleep 2 && stalonetray) &
sh /home/michael/bin/start_conky.sh &
#nm-applet --sm-disable &
blueman-applet &
mpd &
