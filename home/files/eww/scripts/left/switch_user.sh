echo $1
if [ "$1" = "autumn" ]; then
    eww update user="leela"
    swaymsg "input * xkb_layout us"
    swaymsg "input * xkb_variant minimak-8"
else
    eww update user="autumn"
    swaymsg "input * xkb_variant colemak"
fi
