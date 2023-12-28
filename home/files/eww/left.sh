#!/bin/sh
SCR="$(sh ./scripts/screen.sh)"
eww open --arg monitor=$SCR left
eww open --arg monitor=$SCR left-closer
eww update left_visible=true
