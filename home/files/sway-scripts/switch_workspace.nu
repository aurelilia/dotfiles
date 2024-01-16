#!/usr/bin/env nu

source ~/.config/eww/scripts/screen.nu

def main [workspace: string] {
    try { pkill switch_workspace_sleep.sh }
    swaymsg workspace $workspace
    update-eww

    # Work around Electron being broken
    # TODO: Remove once Electron supports Wayland properly
    # https://github.com/electron/electron/issues/39449
    let ws = current-workspaces | where focused | first | get num
    if $ws == 3 {
        swaymsg output DP-3 scale 1.0
    } else {
        swaymsg output DP-3 scale 1.5
    }

    eww open --arg $"monitor=(current-screen-index)" workspace-popup
    try { ~/.config/sway/scripts/switch_workspace_sleep.sh }
    eww close workspace-popup
}
