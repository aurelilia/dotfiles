#!/usr/bin/env nu

source ~/.config/eww/scripts/screen.nu

def main [workspace: string] {
    try { pkill switch_workspace_sleep.sh }
    swaymsg workspace $workspace
    update-eww

    eww open --arg $"monitor=(current-screen-index)" workspace-popup
    try { ~/.config/sway/scripts/switch_workspace_sleep.sh }
    eww close workspace-popup
}
