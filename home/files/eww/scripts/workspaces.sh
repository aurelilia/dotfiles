FOCUS=$(swaymsg -t get_outputs -r | jq '.[] | select(.focused == true) | .name')
OUTS=$(swaymsg -t get_workspaces -r | jq --compact-output "[ .[] | select(.output == $FOCUS) ]")
echo $OUTS
eww update workspaces="$OUTS"
