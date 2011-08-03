#!/bin/bash

feh --bg-tile /home/michael/wallpapers/current.jpg
conky | while read -r conky_out; do wmfs -s "$conky_out"; done
