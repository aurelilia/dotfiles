#!/bin/sh

VOL=$(sh ./scripts/left/get_volume.sh)
if [ "$1" = "up" ]; then
    amixer sset Master $(($VOL + 1))%
else
    amixer sset Master $(($VOL - 1))%
fi
