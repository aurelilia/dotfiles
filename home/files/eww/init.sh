#!/bin/sh

pkill eww || true
eww daemon
eww update config="$(cat ~/.config/eww/config/$(hostname).json)"
eww open bgbox-0
eww open clock

if [ $(sh ./scripts/screencount.sh) -gt 1 ]; then
    eww open bgbox-1
fi
