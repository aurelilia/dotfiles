if [ $(swaymsg -t get_outputs -r | jq ".[0] | .focused") = "true" ]; then 
    echo 0 
else
    echo 1
fi;
