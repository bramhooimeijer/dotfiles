#!/bin/bash
/home/braho/.config/sway/scripts/cliphist_clear.sh
if [ ! -f /home/braho/.images/wallpaper_blur.jpg ]; then
	convert /home/braho/images/wallpaper.jpg -blur 0x8 /home/braho/.images/wallpaper_blur.jpg
fi
if ! pgrep -x swaylock; then swaylock -e -F -l -i /home/braho/.images/wallpaper_blur.jpg; fi
