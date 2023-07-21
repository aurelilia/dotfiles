#!/bin/sh
RES=$(swaymsg -t get_outputs -p | rg -o '[0-9]*x[0-9]*' | head -n1)

while :
do
	img=$(shuf -e -n1 ~/images/wallpapers/*)
	convert $img -resize $RES^ -gravity center -extent $RES ~/.config/eww/assets/wallpaper.png

	eww update wallpaper_visible=false
	sleep 0.5	
	eww update wallpaper="./assets/wallpaper.png"
	eww update wallpaper_visible=true
	
    sleep 600
done
