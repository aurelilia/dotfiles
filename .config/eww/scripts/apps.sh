ALL=$(ls /usr/share/applications/ | grep -m 10 -i "$1")
OUT=""

for e in $ALL; do
  desktop="/usr/share/applications/$e"
  content="cat $desktop"
  name="$(grep "^Name=" $desktop | tail -c+6 | head -n1)"
  icon_name="$(grep "^Icon=" $desktop | tail -c+6 | head -n1)"
  icon="/usr/share/icons/Papirus-Dark/64x64/apps/$icon_name.svg"
  if [ ! -f $icon ]; then
    icon="/usr/share/icons/hicolor/scalable/apps/$icon_name.svg"
  fi
  OUT="$OUT { \"name\": \"$name\", \"icon\": \"$icon\", \"exec\": \"$e\" }"
done

ALL=$(ls /usr/share/applications/ | grep -m 20 -i "$1" | tail -n+11)
OUTB=""

for e in $ALL; do
  desktop="/usr/share/applications/$e"
  content="cat $desktop"
  name="$(grep "^Name=" $desktop | tail -c+6 | head -n1)"
  icon_name="$(grep "^Icon=" $desktop | tail -c+6 | head -n1)"
  icon="/usr/share/icons/Papirus-Dark/64x64/apps/$icon_name.svg"
  if [ ! -f $icon ]; then
    icon="/usr/share/icons/hicolor/scalable/apps/$icon_name.svg"
  fi
  OUTB="$OUTB { \"name\": \"$name\", \"icon\": \"$icon\", \"exec\": \"$e\" }"
done

eww update appsa="$(echo "$OUT" | jq -n '[inputs]')"
eww update appsb="$(echo "$OUTB" | jq -n '[inputs]')"
