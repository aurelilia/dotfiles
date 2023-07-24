#!/bin/sh

eww daemon
eww update config="$(cat ~/.config/eww/config/$(hostname).json)"
eww open bgbox
eww open clock

