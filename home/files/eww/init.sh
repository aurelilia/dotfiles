#!/bin/sh

eww daemon
eww update config="$(cat ~/.config/eww/config/$(hostname).json)"
eww open bgbox-0

if [ $(sh ./scripts/screencount.sh) -gt 1 ]; then
    eww open bgbox-1
    eww open clock-1
else 
    eww open clock-0
fi
