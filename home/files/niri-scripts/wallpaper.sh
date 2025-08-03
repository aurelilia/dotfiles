#!/bin/sh

swww-daemon
while :
do
	for name in $(niri msg -j outputs | jq -r ".[] | .name")
	do
		img=$(shuf -e -n1 ~/personal/images/wallpapers/*)
		swww img -o $name -t wipe --transition-duration 0.5 $img
	done
    sleep 600
done
