#!/bin/sh
SCR="$(sh ./scripts/screencount.sh)"
eww open left-$SCR
eww open left-closer-$SCR
eww update left_visible=true
