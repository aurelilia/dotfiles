./scripts/appa inc "$1"
gtk-launch "$2" 2> /dev/null
eww update apps="$(./scripts/right/appa search 10 2)"
