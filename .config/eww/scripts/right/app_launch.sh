./scripts/right/appa inc "$1"
eww update apps="$(./scripts/right/appa search 10 2)"
sh ./scripts/right/close.sh

cd ~
gtk-launch "$2" & 2> /dev/null
