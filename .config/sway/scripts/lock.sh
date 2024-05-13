#!/bin/bash
/home/braho/.config/sway/scripts/cliphist_clear.sh
if ! pgrep -x swaylock; then swaylock -e -F -l -i /home/braho/.images/wallpaper_blur.jpg; fi
