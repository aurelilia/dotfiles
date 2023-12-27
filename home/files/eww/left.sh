#!/bin/sh
if [ $(sh ./scripts/screencount.sh) -gt 1 ]; then
    eww open left-1 && eww open left-closer-1
else 
    eww open left-0 && eww open left-closer-0
fi

eww update left_visible=true
