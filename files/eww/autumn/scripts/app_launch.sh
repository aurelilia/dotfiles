./scripts/appa inc "$1"
gtk-launch "$2" 2> /dev/null
eww --config ~/.config/eww/autumn/ update apps="$(./scripts/appa search 3 4)"
