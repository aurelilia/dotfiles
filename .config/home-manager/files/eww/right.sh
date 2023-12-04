#!/bin/sh
sh ./scripts/right/app_search.sh
eww open right && eww open right-closer && eww update right_visible=true && sleep 0.15 && ydotool key 108:1 108:0
