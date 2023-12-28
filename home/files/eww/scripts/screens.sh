swaymsg -t get_outputs -r | jq -r ".[] | .model"
