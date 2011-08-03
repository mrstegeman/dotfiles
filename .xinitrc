#!/bin/sh

xscreensaver -no-splash &
export DE=xfce
#exec ck-launch-session dbus-launch openbox-session
exec ck-launch-session dbus-launch wmfs
