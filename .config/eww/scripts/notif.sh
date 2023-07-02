DATA="$(dunstctl history | jq '.data[0] | .[] | {body: .body.data, title: .summary.data}' | jq -n '[inputs]')"
LEN="$(echo $DATA | jq 'length - 1')"

echo "(box :orientation \"vertical\" :space-evenly false :class \"notif-box-inner\""
for i in `seq 0 $LEN`
do
    echo "(notif :title $(echo $DATA | jq ".[$i][\"title\"]") :text $(echo $DATA | jq ".[$i][\"body\"]"))"
done
echo ")"
