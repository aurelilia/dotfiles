#!/bin/sh

eww daemon
eww update config="$(cat ~/.config/eww/config/$(hostname).json)"
eww update apps="$(./scripts/right/appa search 10 2)"
eww open bgbox
eww open clock

