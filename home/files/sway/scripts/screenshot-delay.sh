#!/bin/sh
slurp > /tmp/region
sleep 5
cat /tmp/region | grim -g - -t jpeg -q 95 ~/personal/images/screenshots/$(date +%F_%T).jpg
sleep 0.1
notify-send "Screenshot taken"