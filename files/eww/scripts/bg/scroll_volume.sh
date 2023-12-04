#!/bin/sh

VOL=$(sh ./scripts/left/get_volume.sh)
if [ "$1" = "up" ]; then
    amixer -D pulse sset Master $(($VOL + 1))%
else
    amixer -D pulse sset Master $(($VOL - 1))%
fi
