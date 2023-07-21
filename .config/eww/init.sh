#!/bin/sh

eww daemon
eww update config="$(cat config/$(hostname).json)"
eww open bgbox
eww open clock

