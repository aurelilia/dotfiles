#!/bin/sh
swww init

while :
do
    swww img $(shuf -e -n1 ~/wallpapers/*) --transition-fps 60 --transition-type random
    sleep 600
done
