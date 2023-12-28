eww update left_visible=false
SCR="$(sh ./scripts/screencount.sh)"
eww close left-closer-$SCR && sleep 0.09 && eww close left-$SCR
