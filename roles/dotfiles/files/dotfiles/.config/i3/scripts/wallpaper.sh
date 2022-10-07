#!/bin/bash
wal -i $(shuf -n1 -e ~/wallpapers/ )
sleep 0.2
rm ~/.fehbg
