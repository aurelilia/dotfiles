#!/bin/sh
slurp | grim -g - -t jpeg -q 95 ~/personal/images/screenshots/$(date +%F_%T).jpg
