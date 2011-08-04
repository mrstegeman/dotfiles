#!/bin/sh

xscreensaver -no-splash &
export DE=xfce
exec ck-launch-session dbus-launch wmfs
