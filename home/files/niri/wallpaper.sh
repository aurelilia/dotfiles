#!/bin/sh

swww-daemon
while :
do
	for name in $(niri msg -j outputs | jq -r ".[] | .name")
	do
		img=$(shuf -e -n1 ~/personal/images/wallpapers/*)
		swww img -o -t wipe --transition-duration 0.5 $name $img
	done
    sleep 600
done
