#!/bin/bash

# Check if the directory argument is provided
if [ -z "$1" ]; then
	directory="$HOME/.images"
else
	directory="$1"
fi

# List all jpg and png files that do not end with _blur
images=$(find "$directory" -type f \( -name "*.jpg" -o -name "*.png" \) ! -name "*_blur.*")

# Check if any images were found
if [ -z "$images" ]; then
	swaymsg output "*" bg color "#282c34"
fi

images_array=($images)
num_images=${#images_array[@]}
random_index=$((RANDOM % num_images))

# Return the random image
#echo "${images_array[$random_index]}"
random_image="${images_array[$random_index]}"
swaymsg output "*" bg "$random_image" fill

random_image_blur="${random_image%.*}_blur.jpg"
if [ ! -f "$random_image_blur" ]; then
	convert "$random_image" -filter Gaussian -blur 0x8 "$random_image_blur"
fi
ln -sf "$random_image_blur" "$directory/lockscreen.jpg"


