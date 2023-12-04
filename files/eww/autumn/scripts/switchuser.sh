echo $1
if [ "$1" = "autumn" ]; then
    eww --config ~/.config/eww/autumn/ update user="leela"
    swaymsg "input * xkb_layout us"
    swaymsg "input * xkb_variant minimak-8"
else
    eww --config ~/.config/eww/autumn/ update user="autumn"
    swaymsg "input * xkb_variant colemak"
fi
