#!/usr/bin/env nu

source scripts/screen.nu

let hostname = sys | get host.hostname
let config = open --raw $"~/.config/eww/config/(sys | get host.hostname).json"

try {
    pkill eww
    sleep 2sec
}
eww daemon
eww update $"config=($config)"

let clock_screen = screens | where scale == 1 | first | get model
eww open --arg $"monitor=($clock_screen)" clock

screens | enumerate | each { |sc| 
    eww open --id $sc.index --arg $"monitor=($sc.index)" bgbox
}
