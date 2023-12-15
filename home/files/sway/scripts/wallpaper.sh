#!/bin/sh
RES=$(swaymsg -t get_outputs -p | rg -o '[0-9]{4}x[0-9]+' | head -n1)

while :
do
	img=$(shuf -e -n1 ~/personal/images/wallpapers/*)
	convert $img -resize $RES^ -gravity center -extent $RES ~/.config/wallpaper.png

	eww update wallpaper_visible=false
	sleep 0.5	
	eww update wallpaper="/home/leela/.config/wallpaper.png"
	eww update wallpaper_visible=true
	
    sleep 600
done
