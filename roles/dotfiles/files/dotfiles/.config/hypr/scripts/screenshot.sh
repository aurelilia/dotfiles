#!/bin/sh
slurp | grim -g - -t jpeg -q 95 ~/screenshots/$(date +%F_%T).jpg
