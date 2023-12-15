#!/bin/sh

BR=$(brightnessctl g)
if [ "$1" = "up" ]; then
    brightnessctl s $(($BR + 1))
else
    brightnessctl s $(($BR - 1))
fi
