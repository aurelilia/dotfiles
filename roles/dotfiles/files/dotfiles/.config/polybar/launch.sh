#!/bin/bash

(
   killall -q polybar

   while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

   outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)
   tray_output=HDMI-A-1

   for m in $outputs; do
     export MONITOR=$m
     export TRAY_POSITION=none
     if [[ $m == $tray_output ]]; then
       TRAY_POSITION=right
     fi

     polybar --reload main -c "~/.config/polybar/shapes/config.ini" &
     disown
   done
) 200>/var/tmp/polybar-launch.lock
