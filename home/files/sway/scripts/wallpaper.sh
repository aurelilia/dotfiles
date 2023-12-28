#!/bin/sh

swww init
while :
do
	for name in $(swaymsg -t get_outputs -r | jq -r ".[] | .name")
	do
		img=$(shuf -e -n1 ~/personal/images/wallpapers/*)
		swww img -o $name $img
	done
    sleep 600
done
