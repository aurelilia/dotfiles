def screens [] {
    swaymsg -t get_outputs -r | from json
}

def current-screen [] {
    screens | where focused | first
}

def current-screen-index [] {
    screens | enumerate | where item.focused | first | get index
}

def current-workspaces [] {
    let screen = current-screen | get name
    swaymsg -t get_workspaces -r | from json | where output == $screen
}

def update-eww [] {
    eww update $"workspaces=(current-workspaces | to json)"
}
