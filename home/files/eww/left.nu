#!/usr/bin/env nu
source scripts/screen.nu

let screen = current-screen-index
eww open --arg $"monitor=($screen)" left
eww open --arg $"monitor=($screen)" left-closer
eww update left_visible=true
