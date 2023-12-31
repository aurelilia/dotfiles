#!/bin/sh

pkill eww || true
eww daemon
eww update config="$(cat ~/.config/eww/config/$(hostname).json)"

CLOCKS=$(swaymsg -t get_outputs -r | jq -r ".[] | select(.scale == 1.0) | .model")
eww open --arg monitor="$CLOCKS" clock

IFS=$'\n'
for scr in $(sh ~/.config/eww/scripts/screens.sh)
do
    eww open --id $scr --arg monitor=$scr bgbox
done
