eww update left_visible=false
if [ $(sh ./scripts/screencount.sh) -gt 1 ]; then
    eww close left-closer-1 && sleep 0.09 && eww close left-1
else 
    eww close left-closer-0 && sleep 0.09 && eww close left-0
fi
