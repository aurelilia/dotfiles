swaymsg -t get_outputs -r | jq "to_entries | .[] | select(.value.focused) | .key"
